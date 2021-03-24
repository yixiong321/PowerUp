import 'dart:core';
import 'package:powerup/entities/Course.dart';
import 'package:date_time_picker/date_time_picker.dart';

class SearchController {
  /// Searches through entire list of courses to return list of courses
  /// which contain the search term either within their course title or company
  /// name.

  List<Course> search(String search_term){}

  /// Searches through filtered results to return list of courses which contain
  /// the search term either within their course title or company name.
  List<Course> fSearch(String search_term, List<Course> listofCourses){}

  /// Filters through list of courses/search results to return list of courses which
  /// meet any filter value defined for each criteria (e.g. West OR North) and
  /// multiple filter criteria (e.g. Location = 'West' OR 'North' AND Start Month = 'January')
  List<Course> sFilterLocationAgeGroupStartMonth(List<String> locations,
      List<int> ageGroups, String startDate, List<Course> listOfCourses)
  { //assume HomePage/SearchPage will have a variable holding the lists of courses from database,
    // and is updated after every search and filter operations
    List<Course> courseList = listOfCourses;
    if (locations.isNotEmpty){
      List<Course> filterOne = filterLocation(locations, courseList);
      courseList = filterOne;
    }
    if (ageGroups.isNotEmpty){
      List<Course> filterTwo = filterAgeGroup(ageGroups, courseList);
      courseList = filterTwo;
    }
    if (startDate.isNotEmpty){
      List<Course> filterThree = filterStartDate(startDate, courseList);
      courseList = filterThree;
    }
    return courseList;
  }

  /// Filters through list of courses/search results to return list of courses which
  /// meet any filter value defined for location criteria (e.g. West OR North)
  List<Course> filterLocation (List<String> locations, List<Course> listOfCourses)
  {
    List<Course> courseList = []; //return variable
    for (var i = 0; i < listOfCourses.length; i++){
      for (var j = 0; j< locations.length ; j++){
        if(listOfCourses[i].location.toLowerCase().contains(locations[j].toLowerCase())){
          courseList.add(listOfCourses[i]);
          break;
        }
        else{continue;} //do we actually need the else
      }
      //break in the for loop comes here
    }
    return courseList;
  }

  /// Filters through list of courses/search results to return list of courses which
  /// meet any filter value defined for age group criteria (e.g. '13-18' OR '19-35')
  List<Course> filterAgeGroup (List<int> ageGroups, List<Course> listOfCourses)
  {
    List<Course> courseList = []; //return variable
    for(var i = 0; i<listOfCourses.length; i++){
      for(var j = 0; j<ageGroups.length; j++){
        if (listOfCourses[i].ageGroup == ageGroups[j]){
          courseList.add(listOfCourses[i]);
          break;
        }
        else{continue;}
      }
    }
    return courseList;
  }

  /// Filters through list of courses/search results to return list of courses which
  /// meet any filter value defined for start month criteria (e.g. 'January' OR 'February')
  List<Course> filterStartDate (String startDate, List<Course> listofCourses)
  {
    DateTime dateStart = DateTime.parse(startDate); //convert string to datetime format
    List<Course> courseList = []; //return variable
    for (var i = 0; i <listofCourses.length; i++){ //check if every course in the list is after startDate
      DateTime date = DateTime.parse(listofCourses[i].startDate);
      if(date.isAfter(dateStart)){   //if it is after startDate, add to courseList
        courseList.add(listofCourses[i]);
      }
    }
    return courseList;
  }

  /// Orders search and/or filtered results by the selected order criterion
  List<Course> orderBy (int order_choice, List<Course> listofCourses){}

}