library common_service;

import 'package:angular/angular.dart';
import 'package:cargo/cargo_client.dart';

@Injectable()
class CommonService{
  
  //serves the session object
  
  
  Cargo session = new Cargo(MODE: CargoMode.SESSION);
  /*
  Map<String, String> _session = {};
  Map<String, String> get session => _session;
  void set session(Map<String, String> s){
    _session = s;
  }
  */
  
  void clearSession(){
    session.clear();
  }
}