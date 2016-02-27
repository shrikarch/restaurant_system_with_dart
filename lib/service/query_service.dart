library objectory_service;

import 'dart:async';
import 'package:objectory/objectory_browser.dart';
import 'package:mongo_pro/service/menu.dart';
import 'package:angular/angular.dart';
import 'dart:html';

//var port = Platform.environment.containsKey('PORT')?Platform.environment['PORT']:8881;
//var DefaultUri = 'restaurant-pp.herokuapp.com:16011';
const DefaultUri = 'localhost:8881';
//String DefaultUri = '120.60.60.133:8881';
//String DefaultUri = 'siddqwerty.ddns.net:8881';

@Injectable()
class QueryService {

  Window _window;
  //Future of queries being completed
  Future _loaded;
  Future _inited;

  //cache files for avoiding querying the server whenever possible
  Map<String, MenuItem> _menuItemsCache;
  List<String> _categories;
  RestaurantDetail _restaurantDetail;

  //constructor for calling the loadData function
  QueryService(this._window) {
    /*
    _inited.then((_){
      _loaded = loadData();
    });
    */
    
    //DefaultUri = window.location.origin.replaceAll('http://', '');
    //DefaultUri = DefaultUri.replaceAll(':43424', '');
    //DefaultUri = '$DefaultUri:8881';
    _loaded = loadData();
  }
  
  Future initData(){
    objectory = new ObjectoryWebsocketBrowserImpl(DefaultUri,registerClasses,false);
    return _inited = objectory.initDomainModel();
  }

  //queries and fetches the documents from database and puts them into cache
  Future loadData() {
    List<Future> allTasks = [];
    print("queryServiceLoadData");
    objectory = new ObjectoryWebsocketBrowserImpl(DefaultUri,registerClasses,false);
    return objectory.initDomainModel().then((_) {
      allTasks.add(objectory[MenuItem].find(where.sortBy("category")).then((items) {
        _menuItemsCache = new Map<String, MenuItem>();
        String cat = "";
        _categories = [];
        for (MenuItem item in items) {
          _menuItemsCache[item.menuItemId] = item;
          if(cat != item.category){
            cat = item.category;
            _categories.add(cat);
          }
        }
        return new Future.value(true);
      }));
      
      allTasks.add(objectory[RestaurantDetail].findOne().then((detail){
        _restaurantDetail = detail;
        return new Future.value(true);
      }));
      
      return Future.wait(allTasks);
    });
  }

  //Specific queries
  Future<MenuItem> getMenuItemById(String id) {
    return _menuItemsCache == null
        ? _loaded.then((_) => _menuItemsCache[id])
        : new Future.value(_menuItemsCache[id]);
  }

  Future<Map<String, MenuItem>> getAllRecipes() {
      return _menuItemsCache == null
        ? _loaded.then((_) => _menuItemsCache)
        :new Future.value(_menuItemsCache);
  }
  
  Future<List<String>> getCategories(){
    return _categories == null
        ? _loaded.then((_) => _categories)
        :new Future.value(_categories);
  }
  
  Future<RestaurantDetail> getRestaurantDetails() {
    return _restaurantDetail == null
        ? _loaded.then((_) => _restaurantDetail)
        : new Future.value(_restaurantDetail);
  }  
}
