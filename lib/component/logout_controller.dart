library logout_controller;

import 'package:angular/angular.dart';
import 'package:mongo_pro/service/common_service.dart';

@Component(
    selector: 'logout'
)
class RegisterTable{
  
  final Router _router;
  final CommonService _commonService;
  
  RegisterTable(this._router, this._commonService){
    _commonService.clearSession();
    _router.go('view', {});
  }
}