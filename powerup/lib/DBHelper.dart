import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'entities/user.dart';
import 'entities/Session.dart';
import 'entities/Course.dart';

class DBHelper {
  static Database _db;
  static const String ID = 'id';
  static const String NAME = 'name';
  static const String TABLE = 'User';
  static const String DB_NAME1 = 'User.db';
  static const String DB_NAME2 = ''

  //if db empty(first time), initialize db else return current db-yx
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }
  //initialize a new db-yx
  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }
  //Create table query for SQL-yx
  _onCreate(Database db, int version) async {
    await db
        .execute("CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY, $NAME TEXT)");
  }
  //Adding a new user-yx
  Future<User> save(User user) async {
    var dbClient = await db;
    user.id = await dbClient.insert(TABLE, user.toMap());
    return user;
    /*
    await dbClient.transaction((txn) async {
      var query = "INSERT INTO $TABLE ($NAME) VALUES ('" + employee.name + "')";
      return await txn.rawInsert(query);
    });
    */
  }

  //return a list of users from db-yx
  Future<List<User>> getUsers() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(TABLE, columns: [ID, NAME]);
    //List<Map> maps = await dbClient.rawQuery("SELECT * FROM $TABLE");
    List<User> users = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        users.add(User.fromMap(maps[i]));
      }
    }
    return users;
  }

  //delete from table SQL -yx
  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete(TABLE, where: '$ID = ?', whereArgs: [id]);
  }
  //to change anything in the table -yx
  Future<int> update(User user) async {
    var dbClient = await db;
    return await dbClient.update(TABLE, user.toMap(),
        where: '$ID = ?', whereArgs: [user.id]);
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }

  //from ui create the list of sessions
  Future<int> addCourse(Course course,List<Session> sessions) async {
    var dbClient = await db;
    //need to add session into sessions db first
    int i=0;
    while (sessions.Count !=0) {
      await dbClient.insert(SessionDB, sessions[i].toMap());
      i++;
    }
    int course_id = await dbClient.insert(CourseDB, course.toMap());
    return course_id;

  }

  Future<int> deleteCourse(int CourseToRemoveID,String VendorEmail) async {
    var dbClient = await db;
    List<string> participantsToEmail = getParticipants(CourseToRemoveID);
    //***
    //email the participants with participants emails notifyParticipants
    return await dbClient.delete(CourseDB, where: '$ID = ?', whereArgs: [CourseToRemoveID]);
  }

  Future<List<string>> getParticipantsFromCourse(int CourseToRemoveID) {
    var dbClient = await db;
    List<Map> map = await dbClient.rawQuery(
        "SELECT Email FROM RegisterTABLE WHERE courseID = '" +
            CourseToRemoveID.toString() + "';";);
    List<string> emailList = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        emailList.add(maps[i]["Email"]);
      }
    }
    return emailList;
  }
  Future<List<string>> getParticipantsFromSession(int courseID,int sessionID) {
    var dbClient = await db;
    List<Map> map = await dbClient.rawQuery(
        "SELECT Email FROM RegisterTABLE WHERE courseID = '" +
            CourseID.toString()+" AND sessionID = '"+sessionID.toString()+ "';");
    List<string> emailList = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        emailList.add(maps[i]["Email"]);
      }
    }
    return emailList;
  }

  void Participants(){

  }

}