import 'dart:async';

import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:path/path.dart';
import 'package:sembast/sembast_io.dart';

class AppDatabase {
  //the only available instance of this AppDatabase class
  //is sorted in this private class
  static final AppDatabase _singleton = AppDatabase._();

  //this instance get only property is the only way for other classes to access
  //the single AppDatabase object.
  static AppDatabase get instance => _singleton;

  //completer is used fro transforming synchronus code into asynchronus code.
  Completer<Database>? _dbOpenCompleter;

  //A private constructor
  //If a class specifies its own constructor, it immediately loses the default one
  //This means that by providing a private construictor, we can create new instances
  //only from within this AppDatabase class itself
  AppDatabase._();

  Future<Database> get database async {
    if (_dbOpenCompleter == null) {
      _dbOpenCompleter = Completer();
      _openDatabase();
      //AppDatabase._();
    }
    return _dbOpenCompleter!.future;
  }

  Future _openDatabase() async {
    final appDocumentDir = await getApplicationCacheDirectory();
    final dbPath = join(appDocumentDir.path, 'contacts.db');
    final database = await databaseFactoryIo.openDatabase(dbPath);
    _dbOpenCompleter!.complete(database);
  }
}
