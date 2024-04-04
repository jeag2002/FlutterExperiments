import 'package:hackaton_project/model/story.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

//probar drift para web:
//https://medium.com/@mustafatahirhussein/using-drift-moor-database-in-flutter-web-8423698e41cb

class StoryDatabase {
  static final StoryDatabase _instance = StoryDatabase._internal();

  //https://github.com/tekartik/sqflite/issues/999
  //https://github.com/tekartik/sqflite/issues/1033

  Database? database;

  factory StoryDatabase() {
    return _instance;
  }

  StoryDatabase._internal();

  Future<StoryDatabase> createDatabaseSync() async {
    // ignore: prefer_conditional_assignment
    if (database == null) {
      database = await createDatabase();
      var sqliteVersion = (await database!.rawQuery('select sqlite_version()'))
          .first
          .values
          .first;
      // ignore: avoid_print
      print("[DATABASE] database created sqlite version $sqliteVersion");
    }

    return this;
  }

  Future<Database> createDatabase() async {
    String path = join(await dataBasePathLink(), 'story_database.db');

    // ignore: avoid_print
    print("[DATABASE] path $path");

    return openDatabase(path, onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE story(id INTEGER PRIMARY KEY, uuid TEXT, stepType TEXT, step TEXT, optionOne TEXT, optionTwo TEXT)',
      );
    }, version: 1)
        .catchError((err) {
      // ignore: avoid_print
      print('[DATABASE]: $err');
      return err;
    });
  }

  Future<String> dataBasePathLink() async {
    if (!kIsWeb) {
      return getDatabasesPath();
    } else {
      return databaseFactoryFfiWebNoWebWorker.getDatabasesPath();
    }
  }

  void insertStory(Story story) {
    if (database != null) {
      String uuid = story.uuid;
      String step = story.stepType;
      // ignore: avoid_print
      print("[DATABASE] insert story $uuid - $step");

      database?.insert(
        'story',
        story.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<String> storyList(String uuid) async {
    // ignore: unused_local_variable
    String storyToString = "";

    List<Map<String, dynamic>> storyList = await database!
        .rawQuery("select step from story where uuid = $uuid order by id asc");

    // ignore: unnecessary_null_comparison
    if (storyList != null) {
      // ignore: unnecessary_set_literal
      for (var element in storyList) {
        storyToString = "${storyToString + element["step"]}'\n'";
      }
    }

    // ignore: avoid_print
    print("[DATABASE] get story $uuid \n $storyToString");

    return storyToString;
  }

  void deleteStory(String uuid) {
    // ignore: avoid_print
    if (database != null) {
      // ignore: avoid_print
      print("[DATABASE] delete story ");
      database?.delete(
        'story',
        where: 'uuid = ?',
        whereArgs: [uuid],
      );
    }
  }
}
