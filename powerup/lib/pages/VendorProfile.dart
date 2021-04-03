import 'package:flutter/cupertino.dart';
import 'package:powerup/entities/Vendor.dart';

class VendorProfile extends StatefulWidget {
  
  Vendor vendor;
  
  String nameOfPoc;
  String brn;
  String companyName;
  int companyNumber;
  String companyEmail;
  String companyPassword;

  VendorProfile(this.vendor);
  
  @override
  /// This function displays the Vendor Profile Page
  _VendorProfileState createState() => _VendorProfileState();
}

class _VendorProfileState extends State<VendorProfile> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}