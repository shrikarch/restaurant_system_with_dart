library register_table;

import 'package:angular/angular.dart';
import 'package:mongo_pro/service/common_service.dart';

@Component(
    selector: 'register-table'
)
class RegisterTable{
  
  final Router _router;
  final CommonService _commonService;
  final RouteProvider _routerProvider;
  
  RegisterTable(this._router, this._commonService, this._routerProvider){
    String table_num = _routerProvider.parameters['table_num'];
    _commonService.session['table_num'] = table_num;
    _router.go('view', {});
  }
}