import 'dart:core';
import 'package:powerup/entities/Course.dart';
import 'package:powerup/DBHelper.dart';
import 'package:date_time_picker/date_time_picker.dart';
class SearchController {

  Map<String, int> monthMap = {
    "January" : 1, "February" : 2, "March" : 3, "April" : 4, "May" : 5, "June" : 6, "July" : 7, "August" : 8, "September" : 9, "October" : 10, "November" : 11, "December" : 12
  };



  /// Searches through entire list of courses using the general use search function,
  /// to return a list of courses related to the search term.
Future<List<Course>> searchAllCourses(String search_term) async {
    List<Course> search_results;
    DBHelper db_helper = new DBHelper();
    db_helper.getAllCourses().then((List<Course> courses) {
      search_results = search(search_term, courses);
    });
    return search_results;
  }

  /// General use search function which searches through the list of courses
  /// passed to it as an argument (either full list of courses or filtered list)
  /// to return list of courses which contain the search term either within their
  /// course title, description or company name.
List<Course> search(String search_term, List<Course> listofCourses){
    List<Course> search_results = [];
    for(Course course in listofCourses){
      if(course.courseTitle.toLowerCase().contains(search_term.toLowerCase())||
          course.courseDesc.toLowerCase().contains(search_term.toLowerCase())||
          course.company.toLowerCase().contains(search_term.toLowerCase()))
        search_results.add(course);
    }
    return search_results;
  }
  /// Filters through list of courses/search results to return list of courses which
  /// meet any filter value defined for each criteria (e.g. West OR North) and
  /// multiple filter criteria (e.g. Location = 'West' OR 'North' AND Start Month = 'January')
  List<Course> sFilterLocationAgeGroupStartMonth(List<String> filters, List<Course> listOfCourses)
  { //assume HomePage/SearchPage will have a variable holding the lists of courses from database,
    // and is updated after every search and filter operations
    List<Course> courseList = listOfCourses;
    List<String> locations = [];
    List<String> ageGroups = [];
    List<String> startMonth = [];
    List<String> startYear = [];
    for (int i = 0; i < filters.length; i++) {
      if (filters[i] == 'North' || filters[i] == 'South' || filters[i] == 'East' || filters[i] == 'West') {
        locations.add(filters[i]);
      }
      print("locations");
      print(locations.length);
      if (filters[i] == "7-12" || filters[i] == "13-18" || filters[i] == '19-35' || filters[i] == '36-55' || filters[i] == '56-67') {
        ageGroups.add(filters[i]);
      }
      print("ageGroups");
      print(ageGroups.length);
      if (monthMap.containsKey(filters[i])) {
        startMonth.add(filters[i]);
      }
      print("startMonth");
      print(startMonth.length);
      print(startMonth);
      if (filters[i] == "2021" || filters[i] == "2022") {
        startYear.add(filters[i]);
      }
      print("startYear");
      print(startYear.length);
    }
  if (locations.isNotEmpty){
    List<Course> filterOne = filterLocation(locations, courseList);
    courseList = filterOne;
  }
  if (ageGroups.isNotEmpty){
    List<Course> filterTwo = filterAgeGroup(ageGroups, courseList);
    courseList = filterTwo;
  }

  if (startMonth.length > 0){
    List<Course> filterThree = filterMonth(startMonth, courseList);

    courseList = filterThree;
  }
  if (startYear.isNotEmpty){
    List<Course> filterFour = filterYear(startYear, courseList);
    courseList = filterFour;
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
  List<Course> filterAgeGroup (List<String> ageGroups, List<Course> listOfCourses)
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
  List<Course> filterMonth (List<String> startMonth, List<Course> listOfCourses) {
    print("entered");
    List<int> month = [];
    List<Course> filteredCourseList = [];

    print(startMonth.length);
    for (int i = 0; i < startMonth.length; i++) {
      month.add(monthMap[startMonth[i]]);
    }
    print("month");
    print(month);
    print("reached");
    print(listOfCourses.length);
    for (int i = 0; i < listOfCourses.length; i++) {
      for (int j = 0; j < month.length; j++) {
          if (int.parse(listOfCourses[i].startDate.split('/')[1]) == month[j]) {
            filteredCourseList.add(listOfCourses[i]);
        }
      }
      // DateTime dateStart = DateTime.parse(startMonth); //convert string to datetime format
      // List<Course> courseList = []; //return variable
      // for (var i = 0; i <listofCourses.length; i++){ //check if every course in the list is after startDate
      //   DateTime date = DateTime.parse(listofCourses[i].startDate);
      //   if(date.isAfter(dateStart)){   //if it is after startDate, add to courseList
      //     courseList.add(listofCourses[i]);
      //   }
      // }
    }
    print("filteredCourseList");
    print(filteredCourseList.length);
    return filteredCourseList;
  }
  /// Orders the list of courses by Year
  List<Course> filterYear (List<String> startYear, List<Course> listOfCourses) {
    List<int> year = [];
    List<Course> filteredCourseList = [];
    for (int i = 0; i < startYear.length; i++) {
      year.add(int.parse(startYear[i]));
    }
    for (int i = 0; i < listOfCourses.length; i++) {
      for (int j = 0; j < startYear.length; j++) {
          if (int.parse(listOfCourses[i].startDate.split('/')[2]) == year[j]) {
            filteredCourseList.add(listOfCourses[i]);

        }
      }

    }
    return filteredCourseList;
  }

    /// Orders the list of courses by order_choice =
    /// 1: price, ascending 2: price, descending 3: rating 4: popularity
    // popularity to be implemented
    List<Course> orderBy(int order_choice, List<Course> listofCourses) {
      switch (order_choice) {
        case 1:
          listofCourses.sort((b, a) => a.price.compareTo(b.price));
          break;
        case 2:
          listofCourses.sort((a, b) => b.price.compareTo(a.price));
          break;
        case 3:
          listofCourses.sort((b, a) => a.rating.compareTo(b.rating));
          break;
        default:
          break;
      }
      return listofCourses;
    }

    /// Selects top 5 courses according to ratings to display on the default Home Page
    Future<List<Course>> allCourses() async {
      List<Course> topcourses;
      DBHelper db_helper = new DBHelper();
      topcourses = await db_helper.getAllCourses();
      topcourses = orderBy(3, topcourses);
      // topcourses = topcourses.sublist(0, 5);
      return topcourses;
    }
}