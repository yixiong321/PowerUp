import 'package:flutter/cupertino.dart';
import 'package:powerup/entities/User.dart';
import 'package:powerup/entities/Course.dart';
import 'dart:async';
import 'package:powerup/DBHelper.dart';
import 'package:powerup/entities/Session.dart';


/// This controller handles sending validation email and changing of password for user.


class UserController {

  /// Stores the current user object
  static User user;


  /// Default constructor for UserController
  UserController() {}
  DBHelper dbHelper = new DBHelper();

  /*
  //Deals with login stuff
  /// This function checks if user has verified his account
  bool checkVerifiedAccount(String userEmail){

  }
  */

  /// This function retrieves the user's registered courses and displays the list
  /// of registered courses of the user
  Future<List<Course>> getUserRegisteredCourse(String emailAddress) async {
    return dbHelper.getRegisterByUser(emailAddress);
  }

  /// This function registers the course to this controllers user's object
  void addCourseToList(int courseID, int sessionID,
      String emailAddress) async {
    dbHelper.saveRegister(courseID, sessionID, emailAddress);
  }

  /// This function withdraw the course from this controllers user's object
  Future<bool> withdrawCourseFromList(String emailAddress, int courseID) async {
    return dbHelper.deleteRegisterByUser(emailAddress, courseID);
  }

  /// This function checks if the course is registered in this controllers
  /// user's object
  Future<bool> containsRegisteredCourse(int courseID,
      String emailAddress) async {
    var dbClient = await dbHelper.db;
    List<Map> maps = await dbClient.rawQuery(
        "SELECT * from RegisterTABLE WHERE courseID = ? AND email = ?",
        [courseID, emailAddress]);
    if (maps.isEmpty) {
      return false;
    }
    return true;
  }

  /// This function retrieves the user's favorite courses and stores it in
  /// this controllers user's object
  Future<List<Course>> getUserFavoriteCourses(String emailAddress) async {
    return dbHelper.getFavForUser(emailAddress);
  }

  /// This function adds the course to the user's favorite courses and stores
  /// it in this controllers user's object
  Future<bool> addFavoriteCourseToList(String emailAddress,
      int courseID) async {
    return dbHelper.saveFavourite(emailAddress, courseID);
  }

  /// This function removes the course from favorite courses and this controllers
  /// user's object
  Future<bool> removeFavoriteCourseFromList(String emailAddress,
      int courseID) async {
    return dbHelper.deleteFavCourseByUser(emailAddress, courseID);
  }

  /// This function checks if the course is favorited in this controllers
  /// user's object
  Future<bool> containsFavoriteCourse(String emailAddress, int courseID) async {
    var dbClient = await dbHelper.db;
    List<Map> maps = await dbClient.rawQuery(
        "SELECT * from Favourite WHERE emailAddress = ? AND courseID = ?",
        [emailAddress, courseID]);
    if (maps.isEmpty) {
      return false;
    }
    return true;
  }

  Future<List<Session>> getAllSessionByCourse(int courseID) async{
    return await dbHelper.getSessionsByCourse(courseID);
  }

  Future<List<Session>> getAvailSessionByCourse(int courseID) async {
    List<Session> sessionList = await dbHelper.getSessionsByCourse(courseID);
    List<Session> vacancyList = [];
    for (int i = 0; i < sessionList.length; i++) {
      if (sessionList[i].vacancy > 0) {
        vacancyList.add(sessionList[i]);
      }
    }
    return vacancyList;
  }

  Future<bool> checkUserRegisteredForCourse(String emailAddress, int courseID) async {
    List<Course> courseList = await dbHelper.getRegisterByUser(emailAddress);
    for(int i = 0; i < courseList.length; i++){
      if(courseList[i].courseID == courseID){
        return true;
      }
    }
    return false;
  }
}





















