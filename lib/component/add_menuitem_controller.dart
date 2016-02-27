library add_menuitem_controller;

import 'dart:html';
import 'package:angular/angular.dart';
import 'package:mongo_pro/service/menu.dart';
import 'package:mongo_pro/service/query_service.dart';
//import 'package:mongo_pro/service/take_order_service.dart';

@Component(
  selector: 'add-menu-item',
  templateUrl: 'add_menuitem_controller.html',
  useShadowDom: false
)
class AddMenuItemController{
  
  final WEBSOCKET_URL = "ws://127.0.0.1:8000/sendorder";
  
  String name;
  String description;
  var category;
  String price;
  var type;
  
  //final TakeOrderService _takeOrderService;
  final QueryService _queryService;
  final Router _router;
  final RouteProvider _routeProvider;
  
  MenuItem _menuItem = null;
  MenuItem get menuItem => _menuItem;
  
  List<String> _categories;
  List<String> get categories => _categories;
  
  AddMenuItemController(this._router,this._routeProvider, this._queryService){
    _menuItem = new MenuItem()..rating=0;
    _queryService.getCategories().then((categories){
      _categories = categories;
    });
    
    querySelector('.loader').classes.add('hide');
    
    _routeProvider.route.onPreLeave.listen((_){
      //print("Page before unload");
      querySelector('.loader').classes.remove('hide');
    });
    
  }
  
  void save(){
    //print(category);
    //print(price);
    //print(type);
    //_menuItem.category = category;
    //_menuItem.price = price.toString();
    
    _menuItem.save().then((_) { 
      //_scope.emit('kitchen-add','emit');
      //_scope.broadcast('kitchen-add','broadcast');
      //_scope.parentScope.broadcast('kitchen-add','parent broadcast');
      //_scope.rootScope.broadcast('kitchen-add','root broadcast');
      
      //print(_takeOrderService.takeOrder(_menuItem.name));
      
      WebSocket _webSocket = new WebSocket(WEBSOCKET_URL);
      _webSocket.onOpen.listen((e){
        _webSocket.send(_menuItem.name);
        _webSocket.close();
      });
      
      _webSocket.onClose.listen((e){
        _queryService.loadData().then((_){
          _router.go('view', {});
        });
      });
    });
    
  }
}