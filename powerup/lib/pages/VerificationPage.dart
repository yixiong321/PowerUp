import 'dart:async';
import 'dart:convert';
import 'package:email_auth/email_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:powerup/controllers/LoginRegisterController.dart';
import 'package:powerup/entities/User.dart';
import 'package:powerup/entities/Vendor.dart';
import 'package:powerup/pages/VendorProfile.dart';
import 'HomePage.dart';


class VerificationPage extends StatefulWidget {

  TextEditingController email = TextEditingController();
  TextEditingController otpcontroller = TextEditingController();
  String name;
  String dob;
  String userEmail;
  int contactNumber;
  String password;
  String nokName;
  int nokContact;
  String nameOfPoc;
  String brn;
  String companyName;
  int companyNumber;
  String companyEmail;
  String companyPassword;


  LoginRegisterController lr_controller = new LoginRegisterController();

  // receive data from the FirstScreen as a parameter
  VerificationPage({Key key, @required this.email, @required this.otpcontroller}) : super(key: key);
  VerificationPage.fromUser(this.name, this.dob, this.userEmail, this.contactNumber, this.password, this.nokName, this.nokContact);
  VerificationPage.fromVendor(this.nameOfPoc, this.brn, this.companyName, this.companyNumber, this.companyEmail, this.companyPassword);


  @override
  /// This function displays the Verification Page
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> with TickerProviderStateMixin {
  User user;
  ///the boolean to handle the dynamic operations
  bool submitValid = false;
  bool countdownEnd = false;

  ///testediting controllers to get the value from text fields
  final TextEditingController _otpcontroller = TextEditingController();


  /// Edit timer here 5 to 1800 for 30 min
  AnimationController _controller;
  int levelClock = 5;
  int _counter;
  Timer _timer;

  void _startTimer(levelClock) {
    _counter = levelClock - 1;
    if (_timer != null) {
      _timer.cancel();
    }
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_counter > 0) {
          _counter--;
        } else {
          _timer.cancel();
        }
      });
    });
  }


  @override
  void initState() {
    super.initState();

    _startTimer(levelClock);

    _controller = AnimationController(
        vsync: this,
        duration: Duration(
            seconds:
            levelClock)

    );


    _controller.forward(); // gameData.levelClock is a user entered number elsewhere in the applciation




  }

  ///a void function to verify if the Data provided is true
  bool verify() {
    bool validate;
    validate = EmailAuth.validate(
        receiverMail:widget.email.value.text,
        userOTP: widget.otpcontroller.value.text);
    return validate;
  }



  ///a void funtion to send the OTP to the user
  void sendOtp() async {
    EmailAuth.sessionName = "powerup";
    bool result =
    await EmailAuth.sendOtp(receiverMail: widget.email.value.text);
    if (result) {
      setState(() {
        submitValid = true;
      });
    }
  }






  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      home: Scaffold(
          appBar: AppBar(
            title: const Text('Verification Page'),
          ),

          body: Builder(builder:(context){
            return Center(
                child: Center(
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 10),
                      Text('Countdown until verification code expires'),
                      Container(
                        margin: EdgeInsets.only(top: 5),
                        height: 50,
                        width: 200,
                        color: Colors.grey,
                        child: Center(

                          child : Countdown(
                            animation: StepTween(
                              begin: levelClock, // THIS IS A USER ENTERED NUMBER
                              end: 0,

                            ).animate(_controller),


                          ),),
                      ),


                      //Verification Functions
                      SizedBox(height: 30),
                      Text('A verification code has been sent to ' + widget.email.text),
                      Text(''),
                      Text('Please enter the corresponding verification OTP'),
                      fieldBox(widget.otpcontroller, null, false),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        height: 50,
                        width: 200,
                        color: Colors.green[400],

                        child: ElevatedButton(
                          onPressed:() {
                            if(verify()) {
                              if (widget.companyEmail == null) {
                                /// user creation
                                widget.lr_controller.createUser(
                                    widget.name,
                                    widget.dob,
                                    widget.userEmail,
                                    widget.contactNumber,
                                    widget.password,
                                    widget.nokName,
                                    widget.nokContact).then((User user) {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              HomePage(user
                                                /// user object
                                              ))
                                  );
                                });
                              }
                              else if (widget.email == null) {
                                /// vendor creation
                                widget.lr_controller.createVendor(
                                    widget.companyEmail, widget.nameOfPoc,
                                    widget.companyNumber, widget.companyPassword,
                                    widget.brn, widget.companyName).then((
                                    Vendor vendor) {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              HomePage(user

                                                /// vendor object
                                                // right now vendor object is replaced with user
                                                // as the connections from verification page to
                                                // Vendor Profile page has not been established - jess
                                              ))
                                  );
                                });

                                /// vendor creation
                              }
                              else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text(
                                        'The input Verification Code is invalid',
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      backgroundColor: Colors.redAccent,
                                      duration: const Duration(seconds: 5),
                                    ));
                                // Scaffold.of(context).showSnackBar(snackbar)
                                //   ..hideCurrentSnackBar()
                                //   ..showSnackBar(sb);
                                // Scaffold.of(context).showSnackBar(sb);
                              }
                            }
                          },
                          child: Center(
                            child: Text(
                              "Verify",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),


                      // Resent OTP function

                      (_counter == 0)
                          ? Card(
                        margin: EdgeInsets.only(top: 20),
                        elevation: 6,
                        child: Container(
                          height: 50,
                          width: 200,
                          color: Colors.green[400],
                          child: ElevatedButton (
                            onPressed:() {
                              ///resend OTP
                              sendOtp();
                              ///Snackbar to notify user that it has been resent
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'OTP code has been resent to ' + widget.email.text,
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    backgroundColor: Colors.blue,
                                    duration: const Duration(seconds: 5),
                                  ));
                              ///restart timer
                              ///verification code update
                              Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => VerificationPage(email: widget.email, otpcontroller : _otpcontroller, ))
                              );


                            },
                            child: Center(
                              child: Text(
                                "Resend OTP",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                          :SizedBox(height: 1)
                    ],

                  ),
                ));
          })
      ),
    );
  }

  Widget fieldBox(TextEditingController controller, String hintText, bool obscureText) {
    return Container(
        child: TextFormField(
          obscureText: obscureText,
          controller: controller,
          validator: (string){
            if(string.isEmpty){
              return 'Compulsory field cannot be empty';
            }
            return null;
          },
          decoration: InputDecoration(
              hintText: hintText,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 20)),
        )
    );

  }


}

class Countdown extends AnimatedWidget {
  Countdown({Key key, this.animation}) : super(key: key, listenable: animation);
  Animation<int> animation;

  @override
  build(BuildContext context) {
    Duration clockTimer = Duration(seconds: animation.value);



    String timerText =
        '${clockTimer.inMinutes.remainder(60).toString()}:${clockTimer.inSeconds.remainder(60).toString().padLeft(2, '0')}';

    print('animation.value  ${animation.value} ');
    print('inMinutes ${clockTimer.inMinutes.toString()}');
    print('inSeconds ${clockTimer.inSeconds.toString()}');
    print('inSeconds.remainder ${clockTimer.inSeconds.remainder(60).toString()}');

    return Text(
      "$timerText",
      style: TextStyle(
        fontSize: 40,
        color: Theme.of(context).bottomAppBarColor,
      ),
    );
  }

  Widget fieldBox(TextEditingController controller, String hintText, bool obscureText) {
    return Container(
        child: TextFormField(
          obscureText: obscureText,
          controller: controller,
          validator: (string){
            if(string.isEmpty){
              return 'Compulsory field cannot be empty';
            }
            return null;
          },
          decoration: InputDecoration(
              hintText: hintText,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 20)),
        )
    );

  }

}