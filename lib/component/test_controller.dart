import 'package:angular/angular.dart';
import 'package:angular_ui/angular_ui.dart';

@Component(
    selector: 'test',
    useShadowDom: false)
class TestController implements ScopeAware{
  
  Scope sc;
  Modal modal;
  
  void set scope(Scope scope){
    print("Setting scope");
    sc = scope;
    modal.open(new ModalOptions(templateUrl: 'view/sample_modal.html'), sc);
  }
  
  TestController(this.modal){
    
  }
}