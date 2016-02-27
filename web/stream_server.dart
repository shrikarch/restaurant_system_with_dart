library stream_objectory;

import "dart:async";
import "dart:io";

import 'package:objectory/src/objectory_server_impl.dart';
import 'package:mongo_dart/mongo_dart.dart';
import "package:stream/stream.dart";


final String PATH_TO_WEB_CONTENT = "../web";
final _db = new Db('mongodb://sid:sunny777@ds055680.mongolab.com:55680/mydb');
//final _db = new Db('mongodb://127.0.0.1:27017/mydb');
//final _db = new Db(Platform.environment['PROD_MONGODB']);
//final _db = new Db('mongodb://120.60.60.133:42434/mydb');
//final _db = new Db('mongodb://siddqwerty.ddns.net:42434/mydb');
int _token = 1;

//A WebSocket handler
Future getObjectory(WebSocket socket) {
  new ObjectoryClient(_token, socket, _db);
  _token++;
  return socket.done;
}

var _mapping = {
  "ws:/ws": getObjectory
};

void main() {
  //get the root path of the server
  final String root = Platform.script.resolve(PATH_TO_WEB_CONTENT).toFilePath();
  print("Root is $root");
  var port = Platform.environment.containsKey('PORT') ? int.parse(Platform.environment['PORT']) : 8881;
  //start server when connection to db is successful
  _db.open().then((_) {
    new StreamServer(uriMapping: _mapping, homeDir: root).start(port:port);
  });
}
