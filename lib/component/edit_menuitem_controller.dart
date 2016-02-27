library edit_menuitem_controller;

import 'package:angular/angular.dart';
import 'package:mongo_pro/service/query_service.dart';
import 'package:mongo_pro/service/common_service.dart';
import 'package:cargo/cargo_client.dart';
import 'package:mongo_pro/service/menu.dart';
import 'package:angular_ui/angular_ui.dart';
import 'dart:async';
import 'dart:html';

@Component(
  selector:'edit-menu-item',
  templateUrl: 'edit_menuitem_controller.html',
  useShadowDom: false,
  exportExpressions: const ["loginClose","doLogin","username","password"]
)

class EditMenuItemController implements ScopeAware{
  final Http _http;
  final QueryService _queryService;
  final CommonService _commonService;
  final Router _router;
  final RouteProvider _routeProvider;
  
  bool menuItemsLoaded = false;
  
  Map<String, MenuItem> _menuItemMap = {};
  Map<String, MenuItem> get menuItemMap => _menuItemMap;
  List<MenuItem> _allMenuItems = [];
  List<MenuItem> get allMenuItems => _allMenuItems;
  List<List<MenuItem>> _properMenuItems = [];
  List<List<MenuItem>> get properMenuItems => _properMenuItems;
  List<String> _categories = [];
  List<String> get categories => _categories;
  int get totalItems => _menuItemMap.length;
  
  //List<MenuItem> _categoryWiseItems = [];
  //List<MenuItem> get categoryWiseItems => _categoryWiseItems; 
  
  RestaurantDetail _restaurantDetail = null;
  RestaurantDetail get restaurantDetail => _restaurantDetail;
  void set restaurantDetail(RestaurantDetail detail){
    _restaurantDetail = detail;
  }
  
  //Login Modal Elements
  String _username = "";
  String _password = "";
  String get username => _username;
  String get password => _password;
  void set username(String value){
    _username = value;
  }
  void set password(String value){
    _password = value;
  }
  
  Modal modal;
  ModalInstance loginModalInstance;
  ModalInstance editModalInstance;
  Scope sc;
  
  String backdrop = 'true';
  
  EditMenuItemController(this._http,this._queryService, this._commonService,this._router, this._routeProvider, this.modal){    
    querySelector("#dbbody").classes.remove('view-body');
    querySelector("#dbhtml").classes.remove('view-html');
    querySelector("#dbbody").classes.add('dashboard-body');
    querySelector("#dbhtml").classes.add('dashboard-html');
    print(querySelector("#dbhtml").classes);
    print(querySelector("#dbbody").classes);
    
    _routeProvider.route.onPreLeave.listen((_){
      print("Pre leaving");
      loginModalInstance.close(true);
      querySelector('.loader').classes.remove('hide');
      querySelector("#dbbody").classes.add('view-body');
      querySelector("#dbhtml").classes.add('view-html');
      querySelector("#dbbody").classes.remove('dashboard-body');
      querySelector("#dbhtml").classes.remove('dashboard-html');
      });
  }
  
  void loginClose(){
    loginModalInstance.close(true);
    _router.go('view', {});
  }
  
  void doLogin(){
    if(username == 'sid' && password == 'sid'){
      //put the data in session
      _commonService.session['loggedIn'] = 'true';
      
      loginModalInstance.close(true);
      
      querySelector('.loader').classes.remove('hide');
      
      _loadData().then((_){
        querySelector('.loader').classes.add('hide');
        print("Total number of items: ${menuItemMap.values.length}");
      });
      
      _queryService.getCategories().then((categories){
        _categories = categories;
      });
      
      
    }
  }
  
  void set scope(Scope scope){
    print("Setting scope");
    sc = scope;
    querySelector('.loader').classes.add('hide');
    if(_commonService.session.getItemSync('loggedIn',defaultValue: null) == null){
      loginModalInstance = modal.open(new ModalOptions(templateUrl: 'view/login_modal.html', backdrop: 'static', keyboard: false), sc);
    }else{      
      _loadData().then((_){
        querySelector('.loader').classes.add('hide');
      });
      
      _queryService.getCategories().then((categories){
        _categories = categories;
      });
      
      print("Scope Total number of items: ${menuItemMap.length}");
    }
  }
  
  //Open Modal
  void open() {
     loginModalInstance = getModalInstance();
  }
  
  //Create a modal
  ModalInstance getModalInstance() {
    return modal.open(new ModalOptions(templateUrl:"template_2.html", backdrop: backdrop), sc);
  }
  
  Future _loadData(){
    String cat = "";
    String cat2 = "";
    _queryService.getAllRecipes().then((Map<String, MenuItem> allItems){
      _menuItemMap = allItems;
      _allMenuItems = _menuItemMap.values.toList();
      List<MenuItem> _tempList=[];
      cat = _allMenuItems.first.category;
      _allMenuItems.forEach((item){
        if(item.category == cat){
          //print("if clause");
          _tempList.add(item);
        }
        else{
          //print("else clause");
          cat = item.category;
          _properMenuItems.add(_tempList);
          _tempList = [];
          _tempList.add(item);
          
        }
      });
      if(_tempList.isNotEmpty){
        _properMenuItems.add(_tempList);
        _tempList = [];
      }
      _allMenuItems.forEach((item){
        if(cat2 != item.category){
          cat2 = item.category;
          categories.add(cat2);
        }
      });
      
      _queryService.getRestaurantDetails().then((details){
        _restaurantDetail = details;
      });
      
      menuItemsLoaded = true;
      return new Future.value(true);
    }).catchError((e) {
      print(e);
      menuItemsLoaded = false;
      print("Some stuff happened!");
    });
    
    return new Future.value(false);
  }
  
  //actions to do when a category is clicked
  void selectCategory(String category){
    _router.go('edit-mode', {'category':category}, startingFrom: _router.root.findRoute('admin'));
  
  }
  
  //when 'add an item' button is clicked
  void addButton(){
    _router.go('add-item', {}, startingFrom: _router.root.findRoute('admin'));
  }
  
  //when 'preview' button is clicked
  void previewMenu(){
    _router.go('preview', {}, startingFrom: _router.root.findRoute('admin'));
  }
}