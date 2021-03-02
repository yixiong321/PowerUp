
class Vendor{
  String emailAddress;
  String nameOfPOC;
  int contactNumOfPOC;
  String passwordV;
  String busRegNum;
  String companyName;
  List<int> vendorCourseList;

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
}