import 'dart:core';
import 'package:powerup/DBHelper.dart';
import 'package:powerup/entities/Course.dart';

class SearchController {
  /// Searches through entire list of courses to return list of courses
  /// which contain the search term either within their course title, description
  /// or company name.

  Future<List<Course>> searchAllCourses(String search_term) async {
    List<Course> search_results;
    DBHelper db_helper = new DBHelper();
    db_helper.getCourses().then((List<Course>courses) {
      search_results = search(search_term, courses);
    });
    return search_results;
  }

  // List<Course>filter(int filter_choice){}
  // Not sure what the above filter is for,,,

  /// Searches through filtered results to return list of courses which contain
  /// the search term either within their course title, description, or company name.
  List<Course> search(String search_term, List<Course> listofCourses){
    List<Course> search_results;
    for(Course course in listofCourses){
      if(course.courseTitle.contains(search_term)||
          course.courseDesc.contains(search_term)||
          course.company.contains(search_term))
        search_results.add(course);
    }
    return search_results;
  }

  /// Filters through list of courses/search results to return list of courses which
  /// meet any filter value defined for each criteria (e.g. West OR North) and
  /// multiple filter criteria (e.g. Location = 'West' OR 'North' AND Start Month = 'January')
  List<Course> sFilterLocationAgeGroupStartMonth(List<String> locations,
      List<String> age_groups, List<String> start_months, List<Course> listofCourses) {}

  /// Filters through list of courses/search results to return list of courses which
  /// meet any filter value defined for location criteria (e.g. West OR North)
  /// *whoo more clear definition -> filter criteria west and north
  List<Course> filterLocation (List<String> locations, List<Course> listofCourses) {}

  /// Filters through list of courses/search results to return list of courses which
  /// meet any filter value defined for age group criteria (e.g. '13-18' OR '19-35')
  List<Course> filterAgeGroup (List<String> age_groups, List<Course> listofCourses) {}

  /// Filters through list of courses/search results to return list of courses which
  /// meet any filter value defined for start month criteria (e.g. 'January' OR 'February')
  List<Course> filterStartMonth (List<String> start_months, List<Course> listofCourses) {}

  /// Orders search and/or filtered results by the selected order criterion
  /// order_choice mapping: 1 - price, low to high; 2 - price, high to low; 3 - rating
  List<Course> orderBy (int order_choice, List<Course> listofCourses){
    switch(order_choice){
      case 1:
        listofCourses.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 2:
        listofCourses.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 3:
        listofCourses.sort((a, b) => a.rating.compareTo(b.rating));
        break;
      default:
        break;
    }
    return listofCourses;
  }

}