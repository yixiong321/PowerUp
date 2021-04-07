import 'dart:ui';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:powerup/controllers/UserController.dart';
import 'package:powerup/entities/User.dart';
import 'package:powerup/entities/Course.dart';
import 'package:powerup/pages/CoursePage.dart';


class UserProfile extends StatefulWidget {

  /// Brings over the user object
  User user;
  UserProfile(this.user);
  /// This function displays the User Profile Page
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> with TickerProviderStateMixin {

  List<Course> courseList = [];
  List<Course> favouriteList = [];
  UserController userController = UserController();
  User user;
  String uN;
  int uC;
  int _selectedIndex = 0;
  TabController _controller;
  int length = 0;

  Future<List<Course>> getRegisteredCourses() async {
    return await userController.getUserRegisteredCourse(widget.user.emailAddress);
  }

  getRegisteredCourses1(){
    getRegisteredCourses().then((list){
      courseList = list;
      setState((){
      });
    });
  }

  Future<List<Course>> getFavoriteCourses() async {
    return await userController.getUserFavoriteCourses(widget.user.emailAddress);
  }

  getFavoriteCourses1(){
    getFavoriteCourses().then((list){
      favouriteList = list;
      setState((){

      });
    });
  }



  @override
  void initState(){
    super.initState();
    _controller = TabController(length: 2, vsync: this);
    getRegisteredCourses1();
    getFavoriteCourses1();
    /*_controller.addListener(() {
        setState(() {
          _selectedIndex = _controller.index;

          if (_selectedIndex == 0) getRegisteredCourses1();
          else if (_selectedIndex == 1) getFavoriteCourses1();
          else getRegisteredCourses();

        });
    });*/


  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget CourseInProfile(Course course){
    return GestureDetector(
        onTap:(){
          userController.checkUserRegisteredForCourse(widget.user.emailAddress, course.courseID).then((registered){
            Navigator.push(context, MaterialPageRoute(
                builder: (context) => CoursePage(
                    registered, course, widget.user
                )));
          });
        },
        child: Card(
          margin: EdgeInsets.fromLTRB(16, 5, 16, 0),
          child: Column(
            children: [
              Text(
                  course.courseTitle,
                  style: TextStyle(
                    fontSize: 18,
                  )
              ),
              SizedBox(height: 6),
              Text(
                course.company,
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600]
                ),
              )
            ],

          ),
        )
    );
  }
  Widget build(BuildContext context) {
    /// Test right now is invalid
    if (widget.user.name == null) uN = "Null";
    else uN = widget.user.name;
    if (widget.user.contactNum == null) uC = 94232394;
    else uC = widget.user.contactNum;
    /// code wise you can just include widget.user.name here
    String name = uN;
    String email = widget.user.emailAddress;
    /// code wise you can just include widget.user.contactNum here
    int contactNo = uC;
    return DefaultTabController(
      length: 2,

      child: Scaffold(

        appBar: AppBar(
          title: Text(
            'Power Up!',
            style: TextStyle(color: Colors.black, fontSize: 28),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Stack(
            children: [
              Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/background.png'),
                        fit: BoxFit.cover,
                      )
                  )
              ),
              Row(
                children: [
                  ElevatedButton(
                    child: Text('Log Out'),
                    onPressed: (){
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  SizedBox(height: 30),
                  Icon(Icons.account_circle, size: 100,),
                  SizedBox(height: 10),
                  Text("Name: " + name, style: TextStyle(fontSize: 20)),
                  SizedBox(height: 10),
                  Text("Email: " + email, style: TextStyle(fontSize: 20)),
                  SizedBox(height: 10),
                  Text("Contact Number: " + contactNo.toString(), style: TextStyle(fontSize: 20),),
                  SizedBox(height: 40),
                  SizedBox(
                    height: 50,
                    child: AppBar(
                      backgroundColor: Colors.grey[400],
                      bottom: TabBar(
                        controller: _controller,
                        onTap: (value){
                          if(value == 0){
                              getRegisteredCourses1();
                          }
                          else if(value == 1){
                              getFavoriteCourses1();
                          }
                        },
                        tabs: [
                          Tab(
                            icon: Icon(Icons.check, color: Colors.greenAccent[700]),
                          ),
                          Tab(icon: Icon(Icons.favorite, color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _controller,
                      children:[
                        Container(
                          child: Column(
                              children:[
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                                  child: Text(
                                    "Registered Courses",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),

                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(10, 0, 10, 20),
                                    child: Scrollbar(
                                      child: ListView.builder(
                                          itemCount: courseList.length,
                                          itemBuilder: (context, index){
                                            /// need an error handling format here
                                            return CourseInProfile(courseList[index]);

                                          }
                                      ),
                                    ),
                                  ),
                                )
                              ]
                          ),

                          color: Colors.grey[350],
                        ),

                        Container(
                          child: Column(
                              children:[
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                                  child: Text(
                                    "Favourited Courses",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),

                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(10, 0, 10, 20),
                                    child: Scrollbar(
                                      child: ListView.builder(
                                          itemCount: favouriteList.length,
                                          itemBuilder: (context, index){
                                            /// need an error handling format here
                                            return CourseInProfile(favouriteList[index]);

                                          }

                                      ),
                                    ),
                                  ),
                                )
                              ]
                          ),
                          color: Colors.grey[350],
                        ),
                      ],
                    ),
                  ),
                ],
              ),]
        ),
      ),
    );
  }
}