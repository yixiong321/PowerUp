
class Vendor{
  String _emailAddress;
  String _nameOfPOC;
  int _contactNumOfPOC;
  String _passwordV;
  String _busRegNum;
  String _companyName;
  //List<int> _vendorCourseList;

  Vendor(this._emailAddress, this._nameOfPOC, this._contactNumOfPOC,
      this._passwordV, this._busRegNum, this._companyName); //this._vendorCourseList);

  Map<String,dynamic> toMap() {
    return {
      '_emailAddress':_emailAddress,
      '_nameOfPOC':_nameOfPOC,
      '_contactNumOfPOC':_contactNumOfPOC,
      '_passwordV':_passwordV,
      '-busRegNum':_busRegNum,
      '_companyName':_companyName,

    };
  }

  Vendor.fromMap(Map<String,dynamic> map){
    _emailAddress=map['_emailAddress'];
    _nameOfPOC= map['_nameOfPOC'];
    _contactNumOfPOC=map['_contactNumOfPOC'];
    _passwordV=map['_passwordV'];
    _busRegNum=map['_busRegNum'];
    _companyName=map['_companyName'];

  }


  String get emailAddress => _emailAddress;

  set emailAddress(String value) {
    _emailAddress = value;
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


}