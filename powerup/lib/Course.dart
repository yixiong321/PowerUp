import 'package:powerup/HomePage.dart';

class Course{
  String name;
  String company;
  double rating;
  String url;

  String get getName => name;
  set setName(String name){this.name = name;}
  String get getCompany => company;
  set setCompany(String company){this.company = company;}
  double get getRating => rating;
  set setRating(double rating)
  String get getUrl => url;

  Course(String name, String company, double rating, String url){
    this.name = name;
    this.company = company;
    this.rating = rating;
    this.url = url;
  }

  static List<Course> search(String query, List<Course> courseList){
    List<Course> results = new List<Course>();
    for(int i = 0; i < courseList.length; i++){
      if(courseList[i].name == query) {
        results.add(courseList[i]);
      }
    }
    return results;
  }
}