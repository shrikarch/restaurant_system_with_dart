library preview_component;

import 'package:angular/angular.dart';
import '../service/query_service.dart';
import '../service/menu.dart';
import 'package:mongo_pro/service/common_service.dart';
//import '../../web/test.dart';
//import 'dart:async';
//import 'dart:html';

@Component(
  selector:'preview',
  templateUrl: 'preview_component.html',
  useShadowDom: false
)
class PreviewComponent implements AttachAware{
  final QueryService _queryService;
  final Router _router;
  final RouteProvider _routeProvider;
  final CommonService _commonService;
  
  @NgOneWay('menu-items-loaded')
  bool menuItemsLoaded;
  @NgOneWay('menu-item-map')
  Map<String, MenuItem> menuItemMap;
  @NgOneWay('proper-menu-items')
  List<List<MenuItem>> properMenuItems;
  @NgOneWay('categories')
  List<String> categories;
  @NgOneWay('restaurant-detail')
  RestaurantDetail restaurantDetail;
  
  String tableNumber = null;
  
  PreviewComponent(this._queryService,this._router, this._routeProvider, this._commonService){
    
    print(_commonService.session['table_num']);
    
  }
  
  void attach(){
    print("preview attached");
  }
}