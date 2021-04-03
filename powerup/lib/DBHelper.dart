import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:powerup/entities/Course.dart';
import 'package:powerup/entities/User.dart';
import 'package:powerup/entities/Vendor.dart';
import 'package:powerup/entities/Session.dart';

class DBHelper {
  //DATABASE
  static Database _db;
  static const String DB_NAME = 'MainDB.db';

  //User Table
  static const String UserTABLE = 'User';
  static const String name = 'name';
  static const String dob = 'DOB';
  static const String email = 'emailAddress';
  static const String contactNum = 'contactNum';
  static const String passU='passwordU';
  static const String NOKname='NOKname';
  static const String NOKNum = 'NOKcontactNum';

  //Vendor Table
  static const String VendorTABLE = 'Vendor';
  static const String POCName = 'nameOfPOC';
  static const String POCNum = 'contactNumOfPOC';
  static const String passV='passwordV';
  static const String busRegNum='busRegNum';
  static const String compName = 'companyName';

  //Course Table
  static const String CourseTABLE = 'Course';
  static const String courseID = 'courseID';
  static const String courseTitle = 'courseTitle';
  static const String courseDesc = 'courseDesc';
  //static const String compName = 'companyName';
  static const String rating = 'rating';
  static const String price = 'price';
  static const String url = 'url';
  static const String location = 'location';
  static const String ageGroup = 'ageGroup';
  //static const String POCName = 'nameOfPOC';
  //static const String POCNum = 'contactNumOfPOC';
  static const String startDate = 'startDate';
  static const String regDeadline = 'regDeadline';

  //Fav Table
  static const String FavTABLE = 'Favourite';

  //Session Table
  static const String SessionTABLE = 'Session';
  static const String sessionID = 'sessionID';
  //static const String CID = 'courseID'; //check in Course
  static const String numberOfClasses = 'numberOfClasses';
  static const String startDateOfSession = 'startDate';
  static const String dateTime = 'dateTime';
  static const String vacancy = 'vacancy';
  static const String classSize = 'classSize';

  //Register
  static const String RegisterTABLE = 'Register';

  /// This function initializes a new database when the current database is null,
  /// and returns the current database when it is not null
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  /// This function enables foreign key support
  static Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  /// If the current database is not null, this function executes to retrieve the
  /// current database
  initDb() async {
    /*Directory documentsDirectory = await getApplicationDocumentsDirectory();
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

  /// This function creates all the tables for the database
  _onCreate(Database db, int version) async {
    await db
        .execute("CREATE TABLE $UserTABLE ($name TEXT,"
        "$dob TEXT,$email TEXT PRIMARY KEY,$contactNum INTEGER, $passU TEXT,"
        "$NOKname TEXT,$NOKNum INTEGER)");

    await db.execute("CREATE TABLE $VendorTABLE ($email TEXT PRIMARY KEY, $POCName TEXT, $POCNum INTEGER, $passV TEXT, $busRegNum TEXT, $compName TEXT)");

    await db.execute(
        "CREATE TABLE $CourseTABLE ($courseID INTEGER NOT NULL, $courseTitle TEXT NOT NULL, $courseDesc TEXT, $compName TEXT, $rating REAL, $price REAL, $url TEXT, $location TEXT, $ageGroup TEXT, $POCName TEXT, $POCNum INTEGER, $startDate TEXT, $regDeadline TEXT, PRIMARY KEY(\"courseID\" AUTOINCREMENT))");

    await db.execute(
        "CREATE TABLE $FavTABLE ($email TEXT NOT NULL, $courseID INTEGER NOT NULL, PRIMARY KEY(\"emailAddress\", \"courseID\"),FOREIGN KEY(\"emailAddress\") REFERENCES \"User\"(\"emailAddress\") ON DELETE CASCADE)");

    await db //Session
        .execute("CREATE TABLE $SessionTABLE ($sessionID INTEGER NOT NULL, "
        "$courseID INTEGER NOT NULL, $startDateOfSession TEXT NOT NULL, $dateTime TEXT NOT NULL, "
        "$vacancy INTEGER NOT NULL, $classSize INTEGER NOT NULL, "
        "PRIMARY KEY($sessionID AUTOINCREMENT),"
        "FOREIGN KEY($courseID) REFERENCES $CourseTABLE($courseID)"
        "ON DELETE CASCADE)");

    await db //Register
        .execute("CREATE TABLE $RegisterTABLE ($email TEXT NOT NULL, $sessionID INTEGER NOT NULL, $courseID INTEGER NOT NULL,"
        "PRIMARY KEY($email, $sessionID, $courseID),"
        "FOREIGN KEY($email) REFERENCES $UserTABLE($email)"
        "ON DELETE CASCADE,"
        "FOREIGN KEY($sessionID) REFERENCES $SessionTABLE($sessionID)"
        "ON DELETE CASCADE,"
        "FOREIGN KEY($courseID) REFERENCES $CourseTABLE($courseID)"
        "ON DELETE CASCADE)");

  }

  /// This function saves a Course object into the CourseTABLE
  Future<Course> saveCourse(Course course) async {
    var dbClient = await db;
    await dbClient.insert(CourseTABLE, course.toMap());
    return course;
  }

  /// This function saves a User object into the UserTABLE
  Future<User> saveUser(User user) async {
    var dbClient = await db;
    await dbClient.insert(UserTABLE, user.toMap());
    return user;
  }

  /// This function saves a Vendor object into the VendorTABLE
  Future<Vendor> saveVendor(Vendor vendor) async{
    var dbClient = await db;
    await dbClient.insert(VendorTABLE, vendor.toMap());
    return vendor;
  }

  /// This function saves a User's email address and the courseID of his favourite
  /// course into the FavTABLE
  Future<bool> saveFavourite(String email, int courseID) async{
    var dbClient = await db;
    await dbClient.execute("INSERT INTO $FavTABLE VALUES email, courseID");
    return true;
  }

  /// This function saves a Session object into the SessionTABLE
  Future<Session> saveSession(Session session) async {
    var dbClient = await db;
    await dbClient.insert(SessionTABLE, session.toMap());
    return session;
  }

  /// This function saves a User's email address, his registered sessionID and
  /// the courseID of the Session into the RegisterTABLE
  Future<bool> saveRegister(int courseID, int sessionID, String userEmail) async { //pass in three objects
    var dbClient = await db;
    await dbClient.rawInsert("INSERT INTO registerTable(email, sessionID, courseID) VALUES(?,?)', "
        "[userEmail, sessionID, courseID]");
    return true;
  }

  /// This function returns a list of all Courses from the CourseTABLE
  Future<List<Course>> getAllCourses() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.rawQuery("SELECT * FROM $CourseTABLE");
    List<Course> courses = [];
    if(maps.length > 0){
      for(int i = 0; i < maps.length; i++){
        courses.add(Course.fromMap(maps[i]));
      }
    }
    return courses;
  }

  /// This function returns a Course object given a courseID from the CourseTABLE
  Future<Course> getCourseById(int courseID) async {
    var dbClient = await db;
    List<Map> maps = await dbClient.rawQuery("SELECT * FROM $CourseTABLE WHERE courseID = ?", [courseID]);
    List<Course> courses = [];
    if(maps.length > 0){
      for(int i = 0; i < maps.length; i++){
        courses.add(Course.fromMap(maps[i]));
      }
    }
    return courses[0];
  }

  /// This function returns a list of all Users from the UserTABLE
  Future<List<User>> getAllUsers() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(UserTABLE, columns: [name,dob,email,contactNum,passU,NOKname,NOKNum]);
    //List<Map> maps = await dbClient.rawQuery("SELECT * FROM $TABLE");
    List<User> users = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        users.add(User.fromMap(maps[i]));
      }
    }
    return users;
  }

  /// This function returns a list of all Vendors from the VendorTABLE
  Future<List<Vendor>> getAllVendors() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(VendorTABLE, columns: [email,POCName,POCNum,passV,busRegNum,compName]);
    //List<Map> maps = await dbClient.rawQuery("SELECT * FROM $TABLE");
    List<Vendor> vendors = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        vendors.add(Vendor.fromMap(maps[i]));
      }
    }
    return vendors;
  }

  /// This function returns a list of favourite courses given a User's email address
  Future<List<Course>> getFavForUser(String email) async {
    var dbClient = await db;
    List<Map> maps = await dbClient.rawQuery("SELECT $courseID FROM $FavTABLE WHERE $courseID = ? ", [email]);
    List<Course> courses = [];
    if(maps.length > 0){
      for(int i = 0; i < maps.length; i++){
        courses.add(Course.fromMap(maps[i]));
      }
    }
    return courses;
  }

  /// This function returns a list of Sessions from the SessionTABLE
  Future<List<Session>> getAllSessions() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(SessionTABLE, columns: [sessionID, numberOfClasses, startDateOfSession, dateTime, vacancy, classSize ]);
    //List<Map> maps = await dbClient.rawQuery("SELECT * FROM $TABLE");
    List<Session> sessions = []; //to store entries into a list of <objects>
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        sessions.add(Session.fromMap(maps[i]));
      }
    }
    return sessions;
  }
  /// This function returns a list of Session objects given a courseID from the
  /// SessionTABLE
  Future<List<Session>> getSessionsByCourse(int courseID) async {
    var dbClient = await db;
    List<Map> maps = await dbClient.rawQuery(
        "SELECT * FROM $SessionTABLE WHERE courseID = ?", [courseID]);
    List<Session> sessions = []; //to store entries into a list of <objects>
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        sessions.add(Session.fromMap(maps[i]));
      }
    }
    return sessions;
  }

  /// This function returns a list of email addresses of Users registered in a
  /// Session from the RegisterTABLE
  Future<List<String>> getRegisterBySession(int sessionID) async {
    var dbClient = await db;
    List<Map> maps = await dbClient.rawQuery(
      "SELECT email FROM $RegisterTABLE WHERE sessionID = ?", [sessionID]);
    List<String> register = []; //users who have registered for a session
    if(maps.length > 0){
      for(int i = 0; i < maps.length; i++){
          register.add(maps[i]['email']);
      }
    }
    return register;
  }

  /// This function returns a list of Course objects that a User registered from
  /// the RegisterTABLE
  Future<List<Course>> getRegisterByUser(String userEmail) async {
    var dbClient = await db;
    List<Map> maps = await dbClient.rawQuery(
      "SELECT courseID from RegisterTABLE WHERE email = ?", [userEmail]);
    List<Course> courseList = [];
    if(maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        Course course = await getCourseById(maps[i]['courseID']);
        courseList.add(course);
      }
    }
    return courseList;
  }

  /// This function deletes a Course object given a courseID from the CourseTABLE
  Future<bool> deleteCourse(int courseID) async {
    var dbClient = await db;
    await dbClient.delete(CourseTABLE, where: '$courseID = ?', whereArgs: [courseID]);
    return true;
  }

  /// This function deletes a User object given a User's email address from the
  /// UserTABLE
  Future<bool> deleteUser(String emailAddress) async {
    var dbClient = await db;
    //delete will return the number of rows affected
    await dbClient.delete(UserTABLE, where: '$email = ?', whereArgs: [emailAddress]);
    return true;
  }

  /// This function deletes a Vendor object given a Vendor's email address from
  /// the VendorTABLE
  Future<bool> deleteVendor(String emailAddress) async {
    var dbClient = await db;
    //delete will return the number of rows affected
    await dbClient.delete(VendorTABLE, where: '$email = ?', whereArgs: [emailAddress]);
    return true;
  }

  /// This function deletes a Course object given a User's email address from
  /// the FavTABLE
  Future<bool> deleteFavCourseByUser(String emailAddress, int courseID) async {
    var dbClient = await db;
    await dbClient.rawDelete("SELECT * FROM FavTABLE WHERE email = ? AND courseID = ?", [emailAddress, courseID]);
    return true;
  }

  /// This function deletes a Session object given a sessionID and courseID
  /// from the SessionTABLE
  Future<bool> deleteSession(int sessionID, int courseID) async {
    var dbClient = await db;
    await dbClient.rawDelete("SELECT * FROM sessionTable WHERE sessionID = ? AND courseID = ?", [sessionID, courseID]);
    return true;
  }

  /// This function deletes all the courseID from the RegisterTABLE when the
  /// courseID is removed
  Future<bool> deleteRegisterByCourse(int courseID) async {
    var dbClient = await db;
    await dbClient.rawDelete("SELECT * FROM registerTable WHERE courseID = ?", [courseID]);
    return true;
  }

  /// This function deletes a User's email address from the RegisterTABLE when
  /// the User withdraws from a Course
  Future<bool> deleteRegisterByUser(String userEmail, int courseID) async {
    var dbClient = await db;
    await dbClient.rawDelete("SELECT * FROM registerTable WHERE email = ? AND courseID = ?", [userEmail, courseID]);
    return true;
  }

  /// This function deletes all the sessionID from the RegisterTABLE when the
  /// sessionID is removed
  Future<bool> deleteRegisterBySession(int sessionID) async {
    var dbClient = await db;
    await dbClient.rawDelete("SELECT * FROM registerTable WHERE sessionID = ?", [sessionID]);
    return true;
  }

  /// This function updates the Course object in the CourseTABLE
  Future<bool> updateCourse(Course course) async {
    var dbClient = await db;
    await dbClient.update(CourseTABLE, course.toMap(),
      where: '$courseID = ?', whereArgs: [course.courseID]);
    return true;
  }

  /// This function updates the User object in the UserTABLE
  Future<bool> updateUser(User user) async {
    var dbClient = await db;
    await dbClient.update(UserTABLE, user.toMap(),
        where: '$email = ?', whereArgs: [user.emailAddress]);
    return true;
  }

  /// This function updates the Vendor object in the VendorTABLE
  Future<bool> updateVendor(Vendor vendor) async {
    var dbClient = await db;
    await dbClient.update(VendorTABLE, vendor.toMap(),
        where: '$email = ?', whereArgs: [vendor.emailAddress]);
    return true;
  }

  /// This function updates the Session object in the SessionTABLE
  Future<bool> updateSession(Session session) async {
    var dbClient = await db;
    await dbClient.update(SessionTABLE, session.toMap(),
        where: 'SID = ?', whereArgs: [session.sessionID]);
    return true;
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

  /// This function deletes a User from a Session from the SessionTABLE
  Future<bool>deleteUserFromSession(String userEmail, int sessionID){
  }
}