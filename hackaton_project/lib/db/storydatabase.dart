import 'package:hackaton_project/model/story.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class StoryDatabase {
  static final StoryDatabase _instance = StoryDatabase._internal();

  Database? database;

  factory StoryDatabase() {
    return _instance;
  }

  StoryDatabase._internal();

  Future<StoryDatabase> createDatabaseSync() async {
    database ??= await createDatabase();
    // ignore: avoid_print
    print("[DATABASE] database created");
    return this;
  }

  Future<Database> createDatabase() async {
    return openDatabase(join(await getDatabasesPath(), 'story_database.db'),
        onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE story(id INTEGER PRIMARY KEY, uuid TEXT, stepType TEXT, step TEXT, optionOne TEXT, optionTwo TEXT)',
      );
    }, version: 1);
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
