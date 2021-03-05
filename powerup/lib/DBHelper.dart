import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:powerup/Course.dart';
import 'package:powerup/User.dart';
import 'package:powerup/Vendor.dart';

class DBHelper {
  static Database _db;
  static const String DB_NAME = 'MainDB.db';

  //USER_TABLE
  static const String UserTABLE = 'User';
  static const String NAME = 'name';
  static const String DOB = 'DOB';
  static const String Email = 'emailAddress';
  static const String contactNum = 'contactNum';
  static const String passU='passwordU';
  static const String NOKname='NOKname';
  static const String NOKNum = 'NOKcontactNum';

  //VENDOR_TABLE
  static const String VendorTABLE = 'Vendor';
  static const String POCName = 'nameOfPOC';
  static const String POCNum = 'contactNumOfPOC';
  static const String passV='passwordV';
  static const String busRegNum='busRegNum';
  static const String compName = 'companyName';

  //COURSE_TABLE
  static const String COURSE_TABLE = 'Course';
  static const String COURSE_ID = 'courseID';
  static const String COURSE_TITLE = 'courseTitle';
  static const String COURSE_DESC = 'courseDesc';
  static const String COMPANY = 'company';
  static const String RATING = 'rating';
  static const String PRICE = 'price';
  static const String URL = 'url';
  static const String LOCATION = 'location';
  static const String AGE_GROUP = 'ageGroup';
  static const String POC_NAME = 'pocName';
  static const String POC_CONTACT_NUMBER = 'pocContactNumber';
  static const String START_DATE = 'startDate';
  static const String REG_DEADLINE = 'regDeadline';

  //FAV_TABLE
  static const String FAV_TABLE = 'Favourite';

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

  _onCreate(Database db, int version) async {
    await db
        .execute("CREATE TABLE $UserTABLE ($NAME TEXT,"
        "$DOB TEXT,$Email TEXT PRIMARY KEY,$contactNum INTEGER,$passU TEXT,"
        "$NOKname TEXT,$NOKNum INTEGER)");

    await db.execute("CREATE TABLE $VendorTABLE ($Email TEXT PRIMARY KEY,"
        "$POCName TEXT,"
        "$POCNum INTEGER,"
        "$passV TEXT,"
        "$busRegNum TEXT,"
        "$compName TEXT");

    await db.execute(
        "CREATE TABLE $COURSE_TABLE ($COURSE_ID INTEGER PRIMARY KEY AUTOINCREMENT, $COURSE_TITLE TEXT, $COURSE_DESC TEXT, $COMPANY TEXT, $RATING REAL, $PRICE REAL, $URL TEXT, $LOCATION TEXT, $AGE_GROUP TEXT, $POC_NAME TEXT, $POC_CONTACT_NUMBER INTEGER, $START_DATE TEXT, $REG_DEADLINE TEXT,)");

    await db.execute(
        "CREATE TABLE $FAV_TABLE (FOREIGN KEY ($Email) REFERENCES $UserTABLE($Email) ON DELETE CASCADE ON UPDATE CASCADE, FOREIGN KEY ($COURSE_ID) REFERENCES $COURSE_TABLE($COURSE_ID) ON DELETE CASCADE ON UPDATE CASCADE");
  }
  //SAVE
  Future<Course> saveCourse(Course course) async {
    var dbClient = await db;
    await dbClient.insert(COURSE_TABLE, course.toMap());
    return course;
  }

  Future<User> saveUser(User user) async {
    var dbClient = await db;
    await dbClient.insert(UserTABLE, user.toMap());
    return user;
  }

  Future<Vendor> saveVendor(Vendor vendor) async{
    var dbClient = await db;
    await dbClient.insert(VendorTABLE, vendor.toMap());
    return vendor;
  }

  Future<bool> saveFavourite(User user, Course course) async{
    var dbClient = await db;
    String email = user.emailAddress;
    int courseID = course.courseID;
    await dbClient.execute("INSERT INTO $FAV_TABLE VALUES email, courseID");
    return true;
  }

  //GET
  Future<List<Course>> getCourses() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.rawQuery("SELECT * FROM $COURSE_TABLE");
    List<Course> courses = [];
    if(maps.length > 0){
      for(int i = 0; i < maps.length; i++){
        courses.add(Course.fromMap(maps[i]));
      }
    }
    return courses;
  }

  Future<List<User>> getUsers() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(UserTABLE, columns: [NAME,DOB,Email,contactNum,passU,NOKname,NOKNum]);
    //List<Map> maps = await dbClient.rawQuery("SELECT * FROM $TABLE");
    List<User> users = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        users.add(User.fromMap(maps[i]));
      }
    }
    return users;
  }

  Future<List<Vendor>> getVendors() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(VendorTABLE, columns: [Email,POCName,POCNum,passV,busRegNum,compName]);
    //List<Map> maps = await dbClient.rawQuery("SELECT * FROM $TABLE");
    List<Vendor> vendors = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        vendors.add(Vendor.fromMap(maps[i]));
      }
    }
    return vendors;
  }

  Future<List<Course>> getFavourites(User user) async {
    var dbClient = await db;
    String email = user.emailAddress;
    List<Map> maps = await dbClient.rawQuery("SELECT $COURSE_ID FROM $FAV_TABLE WHERE $COURSE_ID = ? ", [email]);
    List<Course> courses = [];
    if(maps.length > 0){
      for(int i = 0; i < maps.length; i++){
        courses.add(Course.fromMap(maps[i]));
      }
    }
    return courses;
  }

  //DELETE
  Future<int> deleteCourse(int courseID) async {
    var dbClient = await db;
    return await dbClient.delete(COURSE_TABLE, where: '$COURSE_ID = ?', whereArgs: [courseID]);
  }

  Future<int> deleteUser(String emailAddress) async {
    var dbClient = await db;
    //delete will return the number of rows affected
    await dbClient.delete(UserTABLE, where: '$Email = ?', whereArgs: [emailAddress]);
    return 1;
  }

  Future<int> deleteVendor(String emailAddress) async {
    var dbClient = await db;
    //delete will return the number of rows affected
    await dbClient.delete(VendorTABLE, where: '$Email = ?', whereArgs: [emailAddress]);
    return 1;
  }

  //UPDATE
  Future<int> update(Course course) async {
    var dbClient = await db;
    return await dbClient.update(COURSE_TABLE, course.toMap(),
      where: '$COURSE_ID = ?', whereArgs: [course.courseID]);
  }

  Future<int> updateUser(User user) async {
    var dbClient = await db;
    return await dbClient.update(UserTABLE, user.toMap(),
        where: '$Email = ?', whereArgs: [user.emailAddress]);
  }
  Future<int> updateVendor(Vendor vendor) async {
    var dbClient = await db;
    return await dbClient.update(VendorTABLE, vendor.toMap(),
        where: '$Email = ?', whereArgs: [vendor.emailAddress]);
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}