import 'dart:core';
import 'package:powerup/entities/Session.dart';
import 'package:powerup/entities/Vendor.dart';
import 'package:powerup/entities/User.dart';
import 'package:powerup/entities/Course.dart';
import 'dart:async';
import 'package:powerup/DBHelper.dart';

import '../entities/Vendor.dart';

/// This class handles the adding of a new course, removing an existing course, view participants of a session
/// and retrieval of vacancy of an existing session.
class VendorController {

  /// Stores the current vendor
  static Vendor vendor;
  DBHelper dbHelper = DBHelper.getInstance();

  ///This is the constructor for the class.
  /// VendorController();


  //ui call constructor for courses and session first
  ///This function add a course created by the vendor
  Future<bool> addCourseToDB(Course course, List<Session> sessions) async {
    return  dbHelper.addCourse(course, sessions);
  }
  ///This function removes an existing course from the vendor
  Future<bool> removeCourseFromDB(int courseToRemoveID, String vendorEmail) async {
    return dbHelper.removeCourse(courseToRemoveID, vendorEmail);
  }

  ///This function retrieves the participants list of a session.
  Future<List<List<String>>> viewParticipants(int sessionID,int courseID) async {
    List<List<String>> ListOfParticipantsList;
    List<Session> sessionList = await dbHelper.getSessionsByCourse(courseID);
    for(int i =0;i<sessionList.length;i++){
      List<String> participantsList;
      //first element is the sessionID string
      participantsList.add(sessionID.toString());
      participantsList = await dbHelper.getRegisterBySession(sessionID);
      ListOfParticipantsList.add(participantsList);
      sessionList.remove(sessionList[i]);
    }
     return ListOfParticipantsList;
  }
  ///This function retrieves the vacancy of a session.
  Future<int> getVacancyOfSession(int courseID, int sessionID) async{
    int vacancy;
    List<Session> sessions = await dbHelper.getSessionsByCourse(courseID);
    for (int i = 0; i < sessions.length; i++) {
      if (sessionID == sessions[i].sessionID) {
        vacancy=sessions[i].vacancy;
      }
    }
    return vacancy;
  }
// need to get the vendor's courses from db.
 Future<List<Course>> getVendorCreatedCourses(Vendor vendor){
    return dbHelper.getVendorCourse(vendor);
 }

  /// Singleton
  static VendorController single_instance = null; 
    static VendorController getInstance() 
    { 
        if (single_instance == null) 
            single_instance = new VendorController(); 
  
        return single_instance; 
    }
}