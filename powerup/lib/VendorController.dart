import 'dart:core';
import 'package:powerup/DBHelper.dart';


class VendorController{

   DBHelper db;

   VendorController(){
      DBHelper db = new DBHelper();
   }
   //ui call constructor for courses and session first
   public void addcourseToDB(Course course,List<Session> sessions){
      db.addCourse(course,sessions);
   }

   public void removeCourseFromDB(int CourseToRemoveID,String VendorEmail){
      db.deleteCourse(courseToRemoveID,VendorEmail);
   }


   public List<string> viewParticipants(int courseID,int sessionID){
      return List<string> participantsList=db.getParticipants(courseID,);
   }

   public int getVacancyOfCourse(int course){

   }

   public void notifyParticipants(List<string> ){

   }
}


