import 'dart:core';

import 'package:powerup/entities/Course.dart';

class SearchController {
  /// Searches through entire list of courses to return list of courses
  /// which contain the search term either within their course title or company
  /// name.
  List<Course> search(String search_term){}


  // List<Course>filter(int filter_choice){}
  // Not sure what the above filter is for,,,

  /// Searches through filtered results to return list of courses which contain
  /// the search term either within their course title or company name.
  List<Course> fSearch(String search_term, List<Course> listofCourses){}

  /// Filters through list of courses/search results to return list of courses which
  /// meet any filter value defined for each criteria (e.g. West OR North) and
  /// multiple filter criteria (e.g. Location = 'West' OR 'North' AND Start Month = 'January')
  List<Course> sFilterLocationAgeGroupStartMonth(List<String> locations,
      List<String> age_groups, List<String> start_months, List<Course> listofCourses) {}

  /// Filters through list of courses/search results to return list of courses which
  /// meet any filter value defined for location criteria (e.g. West OR North)
  List<Course> filterLocation (List<String> locations, List<Course> listofCourses) {}

  /// Filters through list of courses/search results to return list of courses which
  /// meet any filter value defined for age group criteria (e.g. '13-18' OR '19-35')
  List<Course> filterAgeGroup (List<String> age_groups, List<Course> listofCourses) {}

  /// Filters through list of courses/search results to return list of courses which
  /// meet any filter value defined for start month criteria (e.g. 'January' OR 'February')
  List<Course> filterStartMonth (List<String> start_months, List<Course> listofCourses) {}

  /// Orders search and/or filtered results by the selected order criterion
  List<Course> orderBy (int order_choice, List<Course> listofCourses)

}