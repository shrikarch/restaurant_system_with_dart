import 'dart:html';
import 'dart:convert';
import 'dart:async';
//import 'package:mongo_pro/menu.dart';
import 'package:angular/application_factory.dart';
import 'package:di/annotations.dart';
import 'package:angular/angular.dart';
import 'package:mongo_pro/component/rating.dart';

final WEBSOCKET_URL = "ws://127.0.0.1:8000/websocket";
/*
@Injectable()
class LOL{
  String yolo = ".";
  Menu menu;
  
  LOL(){
    
    _createMenu().then((menu){
      this.menu = menu;
    });
  }
}

class MyAppModule extends Module{
  MyAppModule(){
    bind(RatingComponent);
  }
}

void main() {
  //print("hello");
  
  applicationFactory()
  .rootContextType(LOL).addModule(new MyAppModule()).run();
  
}

Future<Menu> _createMenu(){
  
  Completer com = new Completer();
  
  connectToWebsocket().then((m){

      List<Category> categories = [];
      
      String category_name;
      List<Item> items = [];
      
      m.forEach((key,val){
        Map all_categories = val;
        
        all_categories.forEach((k,v){
          if(v is String)
            category_name = v;
          else
            items.add(new Item(v['uid'], v['name'], double.parse(v['price']), v['description']));
        });
        
        categories.add(new Category(category_name, items));
        items = [];
      });
      
      com.complete(new Menu(categories));
  });
   return com.future;
}

outputMsg(String msg){
  var output = querySelector('#sample_text_id');
  var text = msg;
  if (!output.text.isEmpty) {
    text = "${output.text}"+"${text}";
  }
  output.text = text;
}

Future<Map> connectToWebsocket() {
  //print("What is wrong?");
  Completer com = new Completer();
  
  outputMsg(".");
  WebSocket _webSocket = new WebSocket(WEBSOCKET_URL);
  
  _webSocket.onOpen.listen((e){
    outputMsg(".");
    _webSocket.send("Send data now!");
  });
  
  _webSocket.onMessage.listen((e){
    com.complete(outputMapMsg('${e.data}'));
  });
  return com.future;
}

Map outputMapMsg(String s){
  Map m = JSON.decode(s);
  return m['menu'];
  /*
  Map drinks = menu['Drinks'];
  drinks.forEach((k,v){
    print(k);
    outputMsg(k);
  });
  */
}
*/