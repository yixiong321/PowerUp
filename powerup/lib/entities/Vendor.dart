
class Vendor{
  String _emailAddress;

  String get emailAddress => _emailAddress;

  set emailAddress(String value) {
    _emailAddress = value;
  }

  String _nameOfPOC;
  int _contactNumOfPOC;
  String _passwordV;
  String _busRegNum;
  String _companyName;
  List<int> _vendorCourseList;

  Vendor(this.emailAddress, this.nameOfPOC, this.contactNumOfPOC,
      this.passwordV, this.busRegNum, this.companyName, this.vendorCourseList);

  Map<String,dynamic> toMap() {
    return {
      'emailAddress':emailAddress,
      'nameOfPOC':nameOfPOC,
    'contactNumOfPOC':contactNumOfPOC,
    'passwordV':passwordV,
    'busRegNum':busRegNum,
    'companyName':companyName,
    'vendorCourseList':vendorCourseList,
    };
  }

  Vendor.fromMap(Map<String,dynamic> map){
    emailAddress=map['emailAddress'];
    nameOfPOC= map['nameOfPOC'];
    contactNumOfPOC=map['contactNumOfPOC'];
    passwordV=map['passwordV'];
    busRegNum=map['busRegNum'];
    companyName=map['companyName'];
    vendorCourseList=map['vendorCourseList'];
  }

  String get nameOfPOC => _nameOfPOC;

  set nameOfPOC(String value) {
    _nameOfPOC = value;
  }

  int get contactNumOfPOC => _contactNumOfPOC;

  set contactNumOfPOC(int value) {
    _contactNumOfPOC = value;
  }

  String get passwordV => _passwordV;

  set passwordV(String value) {
    _passwordV = value;
  }

  String get busRegNum => _busRegNum;

  set busRegNum(String value) {
    _busRegNum = value;
  }

  String get companyName => _companyName;

  set companyName(String value) {
    _companyName = value;
  }

  List<int> get vendorCourseList => _vendorCourseList;

  set vendorCourseList(List<int> value) {
    _vendorCourseList = value;
  }
}