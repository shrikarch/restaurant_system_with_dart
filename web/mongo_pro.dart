import 'dart:io';
import 'dart:convert';
import 'package:mongo_dart/mongo_dart.dart';

WebSocket _socket;
String msg = '';
String json = '';
Map cool = {};
void main() {
  HttpServer
    .bind(InternetAddress.ANY_IP_V6, 8500)
    .then((server){
      print("Search server is running on "
          "'http://${server.address.address}:8000/'");
      server.listen((HttpRequest req){
        print('server listening...');
        if(req.uri.path == '/websocket'){
          WebSocketTransformer.upgrade(req).then(socketHandler);
        }
      });
    });
}

void socketHandler(WebSocket socket){
  _socket = socket;
  _socket.listen(handleMsg);
}

void write(String message){
  _socket.add(message);
}

void handleMsg(msg){
  print('Message received: $msg');
  dbConnection();
}

void dbConnection() {
  var db = new Db('mongodb://127.0.0.1/mydb');
  db.open().then((_){
      var _bios = db.collection("menu");
      Cursor cur = _bios.find();
      cur.forEach((Map bio){
        cool = extractMap(bio);
        print(JSON.encode(cool));
      }).then((dummy){
        write(JSON.encode(cool));
      });
  });
}

Map extractMap(Map m){
  Map m1 = new Map.from(m);
  m.forEach((k,v){
    if(v is Map){
      extractMap(v);
    }
    else if(v is List){
      v.forEach((e){
        if(e is Map){
          extractMap(e);
        }   
      });
    }
    else{
      var strin = v.toString();
      m1.remove(k);
      m1[k] = strin;
    }
  });
  return m1;
}

List extractList(List l){
  List l1 = new List.from(l);
  int i = 0;
  l.forEach((v){
  if(v is Map){
    extractMap(v);
  }
  else if(v is List){
    extractList(v);
  }
  else{
    var strin = v.toString();
    l1.remove(i);
    l1[i] = strin;
  }
  ++i;
  });
  return l1;
}
