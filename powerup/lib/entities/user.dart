class User {
  String _name;
  String _DOB;
  String _emailAddress;
  int _contactNum;
  String _passwordU;
  String _NOKname;
  int _NOKcontactNum;
  //String _regCourseList;
  //String _favCourseList;

  User(this._name,this._DOB,this._emailAddress,this._contactNum,this._passwordU,this._NOKname,this._NOKcontactNum);

  Map<String,dynamic> toMap() {
    var map = <String,dynamic>{
      'name':_name,
      'DOB': _DOB,
      'emailAddress': _emailAddress,
      'int': _contactNum,
      'passwordU': _passwordU,
      'NOKname': _NOKname,
      'NOKcontactNum': _NOKcontactNum,
    };
    return map;
  }

  User.fromMap(Map<String,dynamic> map){
    _name = map['name'];
    _DOB = map['DOB'];
    _emailAddress = map['emailAddress'];
    _contactNum= map['int'];
    _passwordU= map['passwordU'];
    _NOKname= map['NOKname'];
    _NOKcontactNum= map['NOKcontactNum'];
  }

  //Getters and Setters
  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get DOB => _DOB;

  set DOB(String value) {
    _DOB = value;
  }

  String get emailAddress => _emailAddress;

  set emailAddress(String value) {
    _emailAddress = value;
  }

  int get contactNum => _contactNum;

  set contactNum(int value) {
    _contactNum = value;
  }

  String get passwordU => _passwordU;

  set passwordU(String value) {
    _passwordU = value;
  }

  String get NOKname => _NOKname;

  set NOKname(String value) {
    _NOKname = value;
  }

  int get NOKcontactNum => _NOKcontactNum;

  set NOKcontactNum(int value) {
    _NOKcontactNum = value;
  }
}