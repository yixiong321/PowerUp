import 'package:powerup/pages/HomePage.dart';
import 'package:powerup/entities/Session.dart';

class Course{
  int _courseID;
  String _courseTitle;
  String _courseDesc;
  String _company;
  double _rating;
  double _price;
  String _url;
  String _location;
  String _ageGroup;
  String _nameOfPOC;
  int _contactNumOfPOC;
  String _startDate;
  String _regDeadline;
  List<Session> sessionList;

  Course(
      this._courseTitle,
      this._courseDesc,
      this._company,
      this._price,
      this._url,
      this._location,
      this._ageGroup,
      this._nameOfPOC,
      this._contactNumOfPOC,
      this._startDate,
      this._regDeadline,
      );

  Map<String, dynamic> toMap(){
    var map = <String, dynamic>{
    'courseID' : _courseID,
    'courseTitle' : _courseTitle,
    'courseDesc' : _courseDesc,
    'companyName' : _company,
    'rating' : _rating,
    'price' : _price,
    'url' : _url,
    'location' : _location,
    'ageGroup' : _ageGroup,
    'nameOfPOC' : _nameOfPOC,
    'contactNumOfPOC' : _contactNumOfPOC,
    'startDate' : _startDate,
    'regDeadline' : _regDeadline,
    };
    return map;
  }

  Course.fromMap(Map<String,dynamic> map){
    _courseID = map['courseID'];
    _courseTitle = map['courseTitle'];
    _courseDesc = map['courseDesc'];
    _company = map['companyName'];
    _rating = map['rating'];
    _price = map['price'];
    _url = map['url'];
    _location = map['location'];
    _ageGroup = map['ageGroup'];
    _nameOfPOC = map['nameOfPOC'];
    _contactNumOfPOC = map['contactNumOfPOC'];
    _startDate = map['startDate'];
    _regDeadline = map['regDeadline'];
  }

  int get courseID => _courseID;

  set courseID(int value) {
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

  String get nameOfPOC => _nameOfPOC;

  set nameOfPOC(String value) {
    _nameOfPOC = value;
  }

  int get contactNumOfPOC => _contactNumOfPOC;

  set contactNumOfPOC(int value) {
    _contactNumOfPOC = value;
  }

  String get startDate => _startDate;

  set startDate(String value) {
    _startDate = value;
  }

  String get regDeadline => _regDeadline;

  set regDeadline(String value) {
    _regDeadline = value;
  }
}