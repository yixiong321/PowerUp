import 'dart:core';

import 'package:powerup/entities/Course.dart';

class SearchController {
  /// Initial search through entire list of courses to return list of courses
  /// which contain the search term either within their course title or company name.
  List<Course> search(String search_term){}


  // List<Course>filter(int filter_choice){}
  // Not sure what the above filter is for,,,

  /// Search through filtered results to return list of courses which contain
  /// the search term either within their course title or company name.
  List<Course> fSearch(String search_term, List<Course> listofCourses){}

  /// Filter through list of courses/search results to return list of courses which
  /// meet any filter value defined for each criteria (e.g. West OR North) and
  /// multiple filter criteria (e.g. Location = 'West' OR 'North' AND Start Month = 'January')
  List<Course> sFilterLocationAgeGroupStartMonth(List<String> locations,
      List<String> age_groups, List<String> start_months, List<Course> listofCourses) {}

  /// Filter through list of courses/search results to return list of courses which
  /// meet
  List<Course> filterLocation (List<String> locations, List<Course> listofCourses) {}
  List<Course> filterAgeGroup (List<String> age_groups, List<Course> listofCourses) {}
  List<Course> filterStartMonth (List<String> start_months, List<Course> listofCourses) {}
  List<Course> orderBy (int order_choice, List<Course> listofCourses)

}