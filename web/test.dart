import 'package:angular/angular.dart';
import 'package:angular_ui/angular_ui.dart';
import 'package:angular/application_factory.dart';
import 'package:logging/logging.dart';

import 'package:mongo_pro/service/query_service.dart';
import 'package:mongo_pro/service/common_service.dart';

import 'package:mongo_pro/component/rating.dart';
import 'package:mongo_pro/component/menu_controller.dart';
import 'package:mongo_pro/component/add_menuitem_component.dart';
import 'package:mongo_pro/component/edit_menuitem_controller.dart';
import 'package:mongo_pro/component/editor_controller.dart';
import 'package:mongo_pro/component/kitchen_component.dart';
import 'package:mongo_pro/component/register_table.dart';
import 'package:mongo_pro/component/test_controller.dart';
import 'package:mongo_pro/component/preview_component.dart';

import 'package:mongo_pro/routing/restaurant_router.dart';

class MyAppModule extends Module{
  MyAppModule(){
    
    //binding all the elements together for the dependency injector
    bind(MenuController);
    bind(AddMenuItemComponent);
    bind(EditMenuItemController);
    bind(EditorController);
    bind(KitchenComponent);
    bind(RegisterTable);
    bind(PreviewComponent);
    bind(TestController);
    bind(CommonService);
    bind(QueryService);
    bind(RatingComponent);
    bind(RouteInitializerFn, toValue: restaurantRouteInitializer);
    bind(NgRoutingUsePushState, toValue: new NgRoutingUsePushState.value(false));
    
  }  
}

void main(){
  //enables logging for route changes
  Logger.root..level = Level.FINEST
               ..onRecord.listen((LogRecord r) { print(r.message); });
  
  //start up configuration of the application
  applicationFactory().addModule(new AngularUIModule()).addModule(new MyAppModule()).run();
}