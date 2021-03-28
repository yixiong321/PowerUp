import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:powerup/entities/Course.dart';
import 'package:powerup/entities/User.dart';
import 'package:powerup/entities/Vendor.dart';
import 'package:powerup/entities/Session.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';

class DBHelper {



  //DATABASE
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
    /*io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate, onConfigure: _onConfigure);
    return db;*/

    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "MainDB.db");

// Check if the database exists
    var exists = await databaseExists(path);

    if (!exists) {
      // Should happen only the first time you launch your application
      print("Creating new copy from asset");

      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      ByteData data = await rootBundle.load(join("assets", "MainDB.db"));
      List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);

    } else {
      print("Opening existing database");
    }
    // open the database
    var db = await openDatabase(path, readOnly: true);
    return db;
  }
  //Create table query for SQL-yx
  _onCreate(Database db, int version) async {
    await db
        .execute("CREATE TABLE $UserTABLE ($name TEXT,"
    await db.execute("CREATE TABLE $VendorTABLE ($email TEXT PRIMARY KEY,"
        "$POCName TEXT,"
        "$POCNum INTEGER,"
        "$passV TEXT,"
        "$busRegNum TEXT,"
        "$compName TEXT)");

    await db.execute(
        "CREATE TABLE $CourseTABLE ($courseID INTEGER PRIMARY KEY, $courseTitle TEXT, $courseDesc TEXT, $compName TEXT, $rating REAL, $price REAL, $url TEXT, $location TEXT, $ageGroup TEXT, $POCName TEXT, $POCNum INTEGER, $startDate TEXT, $regDeadline TEXT)");
    /*
    await db.execute(
        "CREATE TABLE $FavTABLE ($email TEXT PRIMARY KEY, $courseID INTEGER PRIMARY KEY, FOREIGN KEY ($email) REFERENCES $UserTABLE($email) ON DELETE CASCADE ON UPDATE CASCADE, FOREIGN KEY ($courseID) REFERENCES $CourseTABLE($courseID) ON DELETE CASCADE ON UPDATE CASCADE");*/
/*

// fav table sql,created in DBBrowser
//CREATE TABLE "Favourite" (
"emailAddress"	TEXT NOT NULL,
"courseID"	INTEGER NOT NULL,
FOREIGN KEY("emailAddress") REFERENCES "User"("emailAddress"),
PRIMARY KEY("emailAddress","courseID")
);

    await db //Session
        .execute("CREATE TABLE $SessionTABLE ($sessionID INTEGER PRIMARY KEY, "
        "$courseID INTEGER PRIMARY KEY, $startDateOfSession TEXT, $dateTime TEXT, "
        "$vacancy INTEGER, $classSize INTEGER, "
        "FOREIGN KEY($courseID) REFERENCES $CourseTABLE($courseID) ON UPDATE CASCADE ON DELETE CASCADE");*/
/*
    await db //Register
        .execute("CREATE TABLE $RegisterTABLE ($email TEXT PRIMARY KEY, $sessionID INTEGER PRIMARY KEY, $courseID INTEGER PRIMARY KEY,"
        "FOREIGN KEY($email) REFERENCES $UserTABLE($email) ON UPDATE CASCADE ON DELETE CASCADE,"
        "FOREIGN KEY($sessionID) REFERENCES $SessionTABLE($sessionID) ON UPDATE CASCADE ON DELETE CASCADE,"
        "FOREIGN KEY($courseID) REFERENCES $CourseTABLE($courseID) ON UPDATE CASCADE ON DELETE CASCADE");*/
  }
  /// This function saves a Course object into the CourseTABLE
  Future<Course> saveCourse(Course course) async {
    var dbClient = await db;
    await dbClient.insert(CourseTABLE, course.toMap());
    return course;


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

  /// This function updates the RegisterTABLE when a new User registers for a
  /// Course/Session
  Future<bool> updateRegister(int courseID, int sessionID, String userEmail) async {
    var dbClient = await db;
    await dbClient.rawUpdate('UPDATE registerTable SET email = ? '
        'WHERE sessionID = ? AND coursID = ?', [sessionID, courseID]); //IMPT: only updating usermail
    return true;
  }

  /// This function closes the database
  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
  /// This function adds sessions into the session database and adds a course into the course database
  Future<bool> addCourse(Course course,List<Session> sessions) async {
    for(int i=0;i<sessions.length;i++){
      await saveSession(sessions[i]);
    }
    await saveCourse(course);
    return true;
  }
  /// This function gets the email addresses of the participants of a course and sends them a notification.
  /// before removing the relevant data from respective tables.
  Future<bool> removeCourse(int courseID,String vendorEmail ) async{
    List<Session> sessions = await getSessionsByCourse(courseID);
    for(int j=0;j<sessions.length;j++){
      List<String> emails = await getRegisterBySession(sessions[j].sessionID);
      for (int k=0;k<emails.length;k++){
        //send email to notify participant
      }
    }
    for(int i=0;i<sessions.length;i++){
      deleteSession(sessions[i].sessionID,courseID);
    }
    await deleteRegisterByCourse(courseID);
    await deleteCourse(courseID);
    return true;
  }




}