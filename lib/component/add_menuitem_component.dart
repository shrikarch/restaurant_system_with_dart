library add_menuitem_component;

import 'dart:html';
import 'package:angular/angular.dart';
import 'package:mongo_pro/service/menu.dart';
import 'package:mongo_pro/service/query_service.dart';

@Component(
  selector: 'add-item',
  templateUrl: 'add_menuitem_component.html',
  useShadowDom: false
)
class AddMenuItemComponent implements AttachAware{
  
  @NgOneWay('menu-item-map')
  Map<String, MenuItem> menuItemMap;
  @NgOneWay('proper-menu-items')
  List<List<MenuItem>> properMenuItems;
  @NgOneWay('categories')
  List<String> categories;
  
  final QueryService _queryService;
  final Router _router;
  final RouteProvider _routeProvider;
  
  MenuItem _menuItem = null;
  MenuItem get menuItem => _menuItem;
  
  AddMenuItemComponent(this._router,this._routeProvider, this._queryService){
    _menuItem = new MenuItem()..rating=0;
  }
  
  void attach(){
    print("attached");
  }
  
  void save(){
    bool catMatched = false;
    _menuItem.save().then((_) {
      menuItemMap[_menuItem.menuItemId] = _menuItem;
      
      properMenuItems.forEach((list){       
        if(list.last.category == _menuItem.category){
          list.add(_menuItem);
          catMatched = true;
        }
      });
      if(!catMatched){
        properMenuItems.add([_menuItem]);
        categories.add(_menuItem.category);
      }
      
      _queryService.loadData().then((_){
        _router.go('admin', {});
      });
    });
  }
}