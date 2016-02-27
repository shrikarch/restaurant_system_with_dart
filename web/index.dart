//import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular/application_factory.dart';
import 'package:logging/logging.dart';

import 'package:mongo_pro/service/query_service.dart';
import 'package:mongo_pro/component/menu_controller.dart';
import 'package:mongo_pro/component/rating.dart';
import 'package:mongo_pro/routing/restaurant_router.dart';
import 'package:mongo_pro/component/add_menuitem_controller.dart';
import 'package:mongo_pro/component/edit_menuitem_controller.dart';
import 'package:mongo_pro/component/editor_controller.dart';
import 'package:mongo_pro/component/kitchen_component.dart';
//import 'package:mongo_pro/service/take_order_service.dart';

class MyAppModule extends Module{
  MyAppModule(){
    
    bind(MenuController);
    bind(AddMenuItemController);
    bind(EditMenuItemController);
    bind(EditorController);
    bind(KitchenComponent);
    //bind(TakeOrderService);
    bind(QueryService);
    bind(RatingComponent);
    bind(RouteInitializerFn, toValue: restaurantRouteInitializer);
    bind(NgRoutingUsePushState, toValue: new NgRoutingUsePushState.value(false));
    
  }
  /*
  void hideLoader(){
    querySelector(".loader").
  }
  */
}

void main(){
  Logger.root..level = Level.FINEST
               ..onRecord.listen((LogRecord r) { print(r.message); });
  applicationFactory().addModule(new MyAppModule()).run();
}