import 'dart:io';

WebSocket _sendOrderSocket, _kitchenSocket;
List<List<String>> items = [];
List<String> temp = [];

//starts listening on port:8000 for potential websocket protocol type requests
void main() {
  HttpServer
    .bind(InternetAddress.ANY_IP_V6, 8000)
    .then((server){
      print("Kitchen server is running on "
          "'http://${server.address.host}:8000/'");
      print('server listening...');
      server.listen((HttpRequest req){
        //if the httprequest requests to be upgraded to a websocket request
        if (WebSocketTransformer.isUpgradeRequest(req)){
          switch(req.uri.path){
            case '/sendorder':
              print("Send Order request");
              WebSocketTransformer.upgrade(req).then(sendOrderSocketHandler);
              break;
            case '/kitchen':
              print("Kitchen Request");
              WebSocketTransformer.upgrade(req).then(kitchenSocketHandler);
              break;
          }
        }
        else{
          print("Regular ${req.method} request for: ${req.uri.path}");
          req.response.statusCode = HttpStatus.FORBIDDEN;
          req.response.reasonPhrase = "WebSocket connections only";
          req.response.close();
        }
      });
    });
}

void sendOrderSocketHandler(WebSocket socket){
  _sendOrderSocket = socket;
  
  //listen for incoming messages from the socket
  _sendOrderSocket.listen(handleMsg);
}

//adds all order items either to a list if kitchen is closed
//or sends directly to kitchen
void handleMsg(msg){
  print('Message received: $msg');
  
  //read a flag instead
  if(_kitchenSocket == null){
    if(msg.toString() == 'online' || isNumeric(msg.toString())){
      if(temp.isEmpty){
        temp.add(msg.toString());
        return;
      }
      else{
        temp = new List<String>();
        temp.add(msg.toString());
        return;
      }
    }
    //buffer into the list
    print("Kitchen isn't open yet.");
    temp.add(msg.toString());
    items.add(temp);
  }else{
    print("Sending : $msg");
    if(msg.toString() == 'online' || isNumeric(msg.toString())){
      _kitchenSocket.add("start");
      _kitchenSocket.add(msg.toString());
    }else{
      _kitchenSocket.add(msg.toString());
      _kitchenSocket.add("end");
    }
    
  }
}

bool isNumeric(String s) {
  if(s == null) {
    return false;
  }
  return double.parse(s, (e) => null) != null;
}

//listens to incoming messages from kitchen itself
//and sends pending orders from the buffer to kitchen when connected
void kitchenSocketHandler(WebSocket socket){
  print("Kitchen opened now");
  _kitchenSocket = socket;
  
  _kitchenSocket.listen((msg){
    
    print("Kitchen Message: $msg");
    if(items.isNotEmpty){
      //flush the list
      print("Sending : $items");
      items.forEach((list){
        list.forEach((item){
          if(item.toString() == 'online' || isNumeric(item.toString())){
            _kitchenSocket.add("start");
            _kitchenSocket.add(item.toString());
          }
          else{
            _kitchenSocket.add(item.toString());
            _kitchenSocket.add("end");
          }
        });
      });
      items = [];
      
    }
    
  },
  onDone: (){ print("done"); _kitchenSocket = null; }
  );
}