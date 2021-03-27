import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:powerup/pages/CoursePage.dart';
import 'package:powerup/pages/CreateCoursePage.dart';

class UserProfile extends StatefulWidget {
  @override
  /// This function displays the User Profile Page
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget CourseInProfile(String courseName, String vendorName){
    return GestureDetector(
        onTap:(){
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => CoursePage(
                  false, courseName
              )));
        },
        child: Card(
          margin: EdgeInsets.fromLTRB(16, 5, 16, 0),
          child: Column(
            children: [
              Text(
                  courseName,
                  style: TextStyle(
                      fontSize: 18,
                  )
              ),
              SizedBox(height: 6),
              Text(
                vendorName,
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
    String name = "Sophie Ng";
    String email = "sophie112@gmail.com";
    int contactNo = 23148374;
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
                                child: ListView(
                                  children: [
                                    CourseInProfile("Watercolour Course", "ArtWithFriends"),
                                    CourseInProfile("Leathercraft Workshop", "WeatherLeather Pte. Ltd."),
                                    CourseInProfile("App Design: Flutter", "Benjamin Ng"),
                                    CourseInProfile("Watercolour Course", "ArtWithFriends"),
                                    CourseInProfile("Leathercraft Workshop", "WeatherLeather Pte. Ltd."),
                                    CourseInProfile("App Design: Flutter", "Benjamin Ng"),CourseInProfile("Watercolour Course", "ArtWithFriends"),
                                    CourseInProfile("Leathercraft Workshop", "WeatherLeather Pte. Ltd."),
                                    CourseInProfile("App Design: Flutter", "Benjamin Ng"),

                                  ],
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
                                  child: ListView(
                                    children: [
                                      CourseInProfile("Watercolour Course", "ArtWithFriends"),
                                      CourseInProfile("Leathercraft Workshop", "WeatherLeather Pte. Ltd."),
                                      CourseInProfile("App Design: Flutter", "Benjamin Ng"),
                                      CourseInProfile("Watercolour Course", "ArtWithFriends"),
                                      CourseInProfile("Leathercraft Workshop", "WeatherLeather Pte. Ltd."),
                                      CourseInProfile("App Design: Flutter", "Benjamin Ng"),
                                      CourseInProfile("Leathercraft Workshop", "WeatherLeather Pte. Ltd."),
                                      CourseInProfile("App Design: Flutter", "Benjamin Ng"),

                                    ],
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
