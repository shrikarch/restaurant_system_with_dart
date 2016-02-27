library editor_controller;

import 'package:angular/angular.dart';
import 'package:angular_ui/angular_ui.dart';
import 'package:mongo_pro/service/menu.dart';
import 'package:mongo_pro/service/query_service.dart';

@Component(
    selector: 'editor',
    templateUrl: 'editor_controller.html',
    useShadowDom: false,
    exportExpressions: const ["selectedMenuItem","editorClose","editorSave"]
)
class EditorController implements AttachAware,ScopeAware{
  
  final Router _router;
  final RouteProvider _routeProvider;
  final QueryService _queryService;
  
  @NgOneWay('menu-item-map')
  Map<String, MenuItem> menuItemMap;
  @NgOneWay('proper-menu-items')
  List<List<MenuItem>> properMenuItems;
  @NgOneWay('categories')
  List<String> categories;
  
  Scope sc;
  Modal modal;
  ModalInstance editModalInstance;
  
  MenuItem _selectedMenuItem = null;
  MenuItem get selectedMenuItem => _selectedMenuItem;
  
  
  String _selectedCategory;
  List<MenuItem> _categoryWiseItems = [];
  List<MenuItem> get categoryWiseItems => _categoryWiseItems;
  
  EditorController(this._router,this._routeProvider,this._queryService,this.modal){
    //_menuItemId = _routeProvider.parameters['menuItemId'];
    _selectedCategory = _routeProvider.parameters['category'];
  }
  
  void attach(){
    if(properMenuItems != null){
      properMenuItems.forEach((list){
        if(_selectedCategory == list.first.category){
          _categoryWiseItems = list;
        }
      });
    }
    else{
      print("properMenuItems is null");
    }

  }
  
  void set scope(Scope scope){
    sc = scope;
  }
  
  void editItem(String id){
    //_router.go('edit-mode', {'menuItemId':id}, startingFrom: _router.root.findRoute('edit'));
    _selectedMenuItem = menuItemMap[id];
    editModalInstance = modal.open(new ModalOptions(templateUrl: 'view/editor_modal.html', backdrop: 'static', keyboard: false), sc);
    
    editModalInstance.close = (value){
      print("Closer called");
      _selectedMenuItem.reRead();
      modal.hide();
    };
  }
  
  void editorClose(){
    editModalInstance.close(true);
  }
  
  void editorSave(){
    bool catMatched = false;
    selectedMenuItem.save().then((_){
      menuItemMap[selectedMenuItem.menuItemId] = selectedMenuItem;
      
      List<MenuItem> removalList;
      properMenuItems.forEach((list){
        //first remove from list and then add
        MenuItem removalItem;
        //bool removeList = false;
        list.forEach((item){
          if(item.name == selectedMenuItem.name){
            removalItem = item;
          }
          if((removalItem != null) && (list.length == 1) && (removalList == null)){
            removalList = list;
          }
        });
        if(removalItem != null){
          list.remove(removalItem);
          
        }
      });
      
      if(removalList != null){
        properMenuItems.remove(removalList);
      }
      
      properMenuItems.forEach((list){       
        if(list.last.category == selectedMenuItem.category){
          list.add(selectedMenuItem);
          catMatched = true;
        }
      });
      if(!catMatched){
        properMenuItems.add([selectedMenuItem]);
        categories.add(selectedMenuItem.category);
      }
      _queryService.loadData();
      modal.hide();
    });
  }

  void removeItem(String id){
    menuItemMap[id].remove().then((_){
      
      List removalList;
      properMenuItems.forEach((list){
        bool removeItem = false;
        list.forEach((item){
          if(item.name == menuItemMap[id].name){
            removeItem = true;
          }
          if((removeItem != null) && (list.length == 1) && (removalList == null)){
            removalList = list;
          }
        });
        if(removeItem){
          list.remove(menuItemMap[id]);
        }
      });
      
      if(removalList != null){
        properMenuItems.remove(removalList);
      }
      
      menuItemMap.remove(id);
      
      _queryService.loadData();
    });
  }
}