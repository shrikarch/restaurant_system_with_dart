library restaurant;

import 'package:objectory/objectory.dart';

const DefaultUri = '127.0.0.1:8080';

//All classes here represent models of a single document
//of respectively named collections

class RestaurantDetail extends PersistentObject{
  String get name => getProperty('name');
  void set name(String value) => setProperty('name', value);
  
  String get address => getProperty('address');
  void set address(String value) => setProperty('address', value);
  
  String get background => getProperty('background');
  void set background(String value) => setProperty('background',value);
  
  String get restaurantId => id.toHexString();
}

class MenuItem extends PersistentObject{
  
  String get uid => getProperty('uid');
  set uid(String value) => setProperty('uid', value);
  
  String get name => getProperty('name');
  set name(String value) => setProperty('name', value);
  
  String get price => getProperty('price');
  set price(String value) => setProperty('price', value);
  
  String get description => getProperty('description');
  set description(String value) => setProperty('description', value);

  String get category => getProperty('category');
  set category(String value) => setProperty('category', value);
  
  String get url => getProperty('url');
  set url(String value) => setProperty('url', value);
  
  String get menuItemId => id.toHexString();
  
  int get ratingCount => getProperty('ratingCount');
  set ratingCount(int value) => setProperty('ratingCount', value);
  
  int get rating => getProperty('rating');
  set rating(int value){
    int prevProp = getProperty('rating');
    int newProp = value;
    int ratCount = ratingCount;
    print(prevProp);
    print(newProp);
    if(prevProp != newProp){
      int actVal = 0;
      if(ratCount!=null){
        print("$prevProp * $ratCount + $newProp / ${ratCount +1}");
        actVal = ((prevProp * ratCount + newProp)/(ratCount+1)).round();
        setProperty('ratingCount', ratCount+1);
      }
      else{
        setProperty('ratingCount', 1);
        actVal = newProp;
      }
      print(actVal);
      setProperty('rating', actVal);
      if(id!=null)
        save();
    }
    print("===================");
  }

}

class Categories extends PersistentObject {
  List<String> get list => getProperty('list');
  set list(List<String> value) => setProperty('list', value); 
}

registerClasses(){
  objectory.registerClass(MenuItem,()=>new MenuItem(),()=>new List<MenuItem>());
  objectory.registerClass(Categories,()=>new Categories());
  objectory.registerClass(RestaurantDetail,()=>new RestaurantDetail());
}