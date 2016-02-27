library kitchen_component;

import 'dart:html';
import 'dart:convert';
import 'package:angular/angular.dart';
//import 'package:mongo_pro/service/take_order_service.dart';

@Component(
    selector:'kitchen',
    templateUrl: 'kitchen_component.html',
    useShadowDom: false)
class KitchenComponent{ //implements ShadowRootAware{
  
  final WEBSOCKET_URL = "ws://127.0.0.1:8000/kitchen";
  //final WEBSOCKET_URL = "ws://siddqwerty.ddns.net:8000/kitchen";
  
  bool skippedOnce = false;
  WebSocket _webSocket;
  
  Element output;
  final RouteProvider _router;
  final Window window;
  
  //final TakeOrderService _takeOrderService;
  
  List<List<OrderedItem>> orders = [];
  
  String _orderSource = "";
  
  List<OrderedItem> _properOrderItems = [];
  List<OrderedItem> get properOrderItems => _properOrderItems;
  
  List<String> temp = [];
  KitchenComponent(this._router,this.output,this.window){
    print("Kitchen called");
    
    //doesnt work... use something else to monitor the trigger of close of tabs and close the socket

    
    _router.route.onPreLeave.listen((_){
      _webSocket.close();
      querySelector('.loader').classes.remove('hide');
      
    });
    
    querySelector('.loader').classes.add('hide');
    
    window.onBeforeUnload.listen((e){
      
      //in case window is closed... stop listening from socket
      print("onBeforeUnload");
      _webSocket.close();
      print("after");
    });
    
    //print(ngQuery(output, "#orders").length);
    _takeOrders();
  }
  
  void _takeOrders(){
    _webSocket = new WebSocket(WEBSOCKET_URL);
    _webSocket.onOpen.listen((e){
      print("opening kitchen");
      _webSocket.send("Send Now");
    });
    
    _webSocket.onMessage.listen((msg){
      print("received order of: ${msg.data}");
      if(msg.data.toString() == 'start'){
        //temp = new List<String>();
        skippedOnce = false;
        _properOrderItems = [];
        return;
      }
      if(msg.data.toString() == 'end'){
        //orderItems.add(temp);
        orders.add(properOrderItems);
        return;
      }
      //temp.add(msg.data);
      fromJson(msg.data);
    });
    
    _webSocket.onClose.listen((msg){
      print("server closing");
    });
  }
  
  bool isNumeric(String s) {
    if(s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }
  
  void fromJson(String jsonString){
    if(!skippedOnce){
      _orderSource = jsonString;
      skippedOnce = true;
      return;
    }
    
    List jsonList = JSON.decode(jsonString);
    jsonList.forEach((jsonElement){
      //print(jsonElement['item']);
      _properOrderItems.add(new OrderedItem(jsonElement['item'], jsonElement['quantity'], _orderSource));
    });
  }
  
  void orderReady(int listHashCode){
    List removalList;
    orders.forEach((list){
      if(list.hashCode == listHashCode){
        removalList = list;
      }
    });
    
    orders.remove(removalList);
  }
  
  /*
  void onShadowRoot(ShadowRoot root) {
      Element e = root.querySelector('#orders');
      print("Text is : ${e.text}");
  }
  */
}

class OrderedItem{
  String itemName;
  int quantity;
  String source;
  
  OrderedItem(this.itemName,this.quantity,this.source);
}