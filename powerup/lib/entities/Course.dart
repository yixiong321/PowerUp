import 'package:powerup/pages/HomePage.dart';
import 'package:powerup/entities/Session.dart';

class Course{
  String _courseID;
  String _courseTitle;
  String _courseDesc;
  String _company;
  double _rating;
  double _price;
  String _url;
  String _location;
  String _ageGroup;
  String _pocName;
  String _pocContactNumber;
  String _startDate;
  String _regDeadline;
  List<Session> sessionList;

  String get courseID => _courseID;

  set courseID(String value) {
    _courseID = value;
  }
  String get courseTitle => _courseTitle;

  set courseTitle(String value) {
    _courseTitle = value;
  }

  String get courseDesc => _courseDesc;

  set courseDesc(String value) {
    _courseDesc = value;
  }

  String get company => _company;

  set company(String value) {
    _company = value;
  }

  double get rating => _rating;

  set rating(double value) {
    _rating = value;
  }

  double get price => _price;

  set price(double value) {
    _price = value;
  }

  String get url => _url;

  set url(String value) {
    _url = value;
  }

  String get location => _location;

  set location(String value) {
    _location = value;
  }

  String get ageGroup => _ageGroup;

  set ageGroup(String value) {
    _ageGroup = value;
  }

  String get pocName => _pocName;

  set pocName(String value) {
    _pocName = value;
  }

  String get pocContactNumber => _pocContactNumber;

  set pocContactNumber(String value) {
    _pocContactNumber = value;
  }

  String get startDate => _startDate;

  set startDate(String value) {
    _startDate = value;
  }

  String get regDeadline => _regDeadline;

  set regDeadline(String value) {
    _regDeadline = value;
  }

  Course(String name, String company, double rating, String url){
    this._courseTitle = name;
    this._company = company;
    this._rating = rating;
    this._url = url;
  }

  static List<Course> search(String query, List<Course> courseList){
    List<Course> results = new List<Course>();
    for(int i = 0; i < courseList.length; i++){
      if(courseList[i]._courseTitle == query) {
        results.add(courseList[i]);
      }
    }
    return results;
  }
}