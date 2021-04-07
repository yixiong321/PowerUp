import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:powerup/entities/Course.dart';
import 'package:powerup/entities/User.dart';
import 'package:powerup/entities/Session.dart';
import 'package:powerup/controllers/UserController.dart';

class CoursePage extends StatefulWidget {
  @override
  User user;
  Course course;
  bool registered;
  CoursePage(this.registered, this.course, this.user);
  /// This function displays the Course Page
  _CoursePageState createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  String allSessions = "";
  final _formKey = GlobalKey<FormState>();
  bool _autovalidate = false;
  UserController userController = UserController();
  List<Session> sessions = [];
  Session selectedSession;
  bool favourite = false;

  Future<String> allSessionsForCourse() async{
    List<Session> sessionList = await userController.getAllSessionByCourse(widget.course.courseID);
    String string = "";
    for(int i = 0; i < sessionList.length; i++){
        string += "Session " + (i+1).toString() + ": " + sessionList[i].startDate + ", " + sessionList[i].dateTime + "\n";
    }
    return string;
  }

  allSessionsForCourseStr() {
    allSessionsForCourse().then((string) {
      allSessions = string;
      if(mounted) {
        setState(() {});
      }
    });
  }
  Future<List<Session>> allSessionsWithVac() async{
    return await userController.getAvailSessionByCourse(widget.course.courseID);
  }

  checkFavourite() {
    userController.containsFavoriteCourse(widget.user.emailAddress, widget.course.courseID).then((value){
      favourite = value;
    });
    setState(() {

    });
  }

  @override
  void initState() {
    super.initState();
    allSessionsWithVac().then((list){
      selectedSession = list[0];
    });
  }
  /*Future<List> allSessionsWithVacancy() async{
    List<Session> sessionList = await userController.getAvailSessionByCourse(widget.course.courseID);
    List sessions = [];
    for(int i = 0; i < sessionList.length; i++){
      sessions.add("Session " + (i+1).toString() + ": " + sessionList[i].startDate + ", " + sessionList[i].dateTime + ", vacancy = " + sessionList[i].vacancy.toString());
    }
    return sessions;
  }*/

  @override
  Widget build(BuildContext context) {
    allSessionsForCourseStr();
    checkFavourite();
    return Scaffold(
        resizeToAvoidBottomInset: false,
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.network(
                    widget.course.url,
                    fit: BoxFit.fitWidth,
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(Icons.favorite),
                      color: favourite?Colors.red[700]:Colors.grey[350],
                      iconSize: 40,
                      onPressed: (){
                        setState(() {
                          if(favourite){
                            favourite = false;
                            userController.removeFavoriteCourseFromList(widget.user.emailAddress, widget.course.courseID);
                          }
                          else{
                            favourite = true;
                            userController.addFavoriteCourseToList(widget.user.emailAddress, widget.course.courseID);
                          }
                        });
                      },
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Column(
                    children: [
                      Text(
                          widget.course.courseTitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          )
                      ),
                      SizedBox(height: 30),
                      Text(
                        widget.course.courseDesc,
                          style: TextStyle(
                            fontSize: 16,
                          )
                      ),
                      SizedBox(height: 30),
                      ListTile(
                        leading: Icon(
                          Icons.monetization_on_rounded,
                          color: Colors.red[700],
                        ),
                        title: Text("Course fees: \$" + widget.course.price.toString(),),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.location_on,
                          color: Colors.red[700],
                        ),
                        title: Text(widget.course.location),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.calendar_today,
                          color: Colors.red[700],
                        ),
                        title: Text(
                          allSessions,
                        ),
                      ),
                      SizedBox(height: 50),
                      (!widget.registered) ?
                      RaisedButton(
                          color: Colors.red,
                          elevation: 0,
                          onPressed: (){
                            showModalBottomSheet(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                                context: context,
                                builder: (context){
                                return Padding(
                                padding: const EdgeInsets.all(32),
                                child: Container(
                                  height: 250,
                                  child: StatefulBuilder(
                                    builder: (context, setState){
                                      userController.getAvailSessionByCourse(widget.course.courseID).then((list) {
                                        sessions = list;
                                        if(this.mounted){
                                          setState((){
                                          });
                                        }
                                        else{
                                          return;
                                        }
                                      });
                                      return Column(
                                        children: [
                                          SizedBox(height: 20),
                                          Text(
                                            "Preferred session:",
                                            style: TextStyle(
                                                fontSize: 20
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                          Form(
                                            key: _formKey,
                                            autovalidate: _autovalidate,
                                            child: DropdownButtonFormField(
                                              hint: Text("Select session"),
                                              value: selectedSession.sessionID,
                                              validator: (value) => value == null ? 'Please select a session': null,
                                              onChanged: (newSession){
                                                setState(() {
                                                  for(int i = 0; i < sessions.length; i++){
                                                    if(sessions[i].sessionID == newSession){
                                                      selectedSession = sessions[i];
                                                    }
                                                  }
                                                });
                                              },
                                              items: sessions.map((session){
                                                return DropdownMenuItem(
                                                  value: session.sessionID,
                                                  child: Text(
                                                      session.startDate + ", " + session.dateTime + "\n",
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                          SizedBox(height: 50),
                                          RaisedButton(
                                              color: Colors.red,
                                              child: Text(
                                                  'Confirm Registration',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.white,
                                                  )
                                              ),
                                              onPressed: (){
                                                if(_formKey.currentState.validate()){
                                                  userController.addCourseToList(widget.course.courseID, selectedSession.sessionID, widget.user.emailAddress);
                                                  widget.registered = true;
                                                  _formKey.currentState.save();
                                                  Navigator.of(context).pop();
                                                  showDialog(
                                                    barrierDismissible: false,
                                                    context: context,
                                                    builder: (context) {
                                                      return Dialog(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(4.0)
                                                          ),
                                                          child: Stack(
                                                            overflow: Overflow.visible,
                                                            alignment: Alignment.topCenter,
                                                            children: [
                                                              Container(
                                                                height: 450,
                                                                child: Padding(
                                                                  padding: const EdgeInsets.fromLTRB(10, 70, 10, 10),
                                                                  child: Column(
                                                                    children: [
                                                                      Text(
                                                                          "You have successfully been registered for the course - ",
                                                                        style: TextStyle(fontSize: 20),
                                                                        textAlign: TextAlign.center,
                                                                      ),
                                                                      SizedBox(height: 20),
                                                                      Text(
                                                                          widget.course.courseTitle,
                                                                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                                                                        textAlign: TextAlign.center,
                                                                      ),
                                                                      SizedBox(height: 10),
                                                                      ListTile(
                                                                        leading: Icon(
                                                                          Icons.monetization_on_rounded,
                                                                          color: Colors.red[700],
                                                                        ),
                                                                        title: Text(
                                                                            "Course fees: \$" + widget.course.price.toString(),
                                                                          style: TextStyle(fontSize: 20),
                                                                        ),
                                                                      ),
                                                                      ListTile(
                                                                        leading: Icon(
                                                                          Icons.location_on,
                                                                          color: Colors.red[700],
                                                                        ),
                                                                        title: Text(
                                                                            widget.course.location,
                                                                          style: TextStyle(fontSize: 20),
                                                                        ),
                                                                      ),
                                                                      ListTile(
                                                                        leading: Icon(
                                                                          Icons.calendar_today,
                                                                          color: Colors.red[700],
                                                                        ),
                                                                        title: Text(
                                                                          selectedSession.startDate + ", " + selectedSession.dateTime,
                                                                          style: TextStyle(fontSize: 20),
                                                                        ),
                                                                      ),
                                                                      SizedBox(height: 20),
                                                                      RaisedButton(onPressed: () {
                                                                        Navigator.of(context).pop();
                                                                        Navigator.of(context).pop();
                                                                        Navigator.push(context, MaterialPageRoute(
                                                                            builder: (context) => CoursePage(
                                                                                widget.registered, widget.course, widget.user
                                                                            )));
                                                                      },
                                                                        color: Colors.red,
                                                                        child: Text('Okay', style: TextStyle(color: Colors.white, fontSize: 20),),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              Positioned(
                                                                  top: -40,
                                                                  child: CircleAvatar(
                                                                    backgroundColor: Colors.green,
                                                                    radius: 40,
                                                                    child: Icon(Icons.check, color: Colors.white, size: 50),
                                                                  )
                                                              ),
                                                            ],
                                                          )
                                                      );
                                                    }
                                                  );
                                                }
                                                else{
                                                  setState((){
                                                    _autovalidate = true;
                                                  });
                                                }
                                              }
                                          )
                                        ],
                                      );
                                    }
                                  ),
                                ),
                              );
                            });
                          },
                          child: Text(
                            "Register",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                      ) : RaisedButton(
                        child: Text("Withdraw"),
                        onPressed: (){
                          userController.withdrawCourseFromList(widget.user.emailAddress, widget.course.courseID);
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (builder) {
                              return AlertDialog(
                                backgroundColor: Colors.redAccent,
                                title: Text(
                                    'Do you want to withdraw from this course?',
                                  textAlign: TextAlign.center,
                                ),
                                content: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    FlatButton(
                                      child: Text("Confirm"),
                                      onPressed: () {
                                        widget.registered = false;
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                        Navigator.push(context, MaterialPageRoute(
                                            builder: (context) => CoursePage(
                                              widget.registered, widget.course, widget.user
                                            )));
                                      },
                                    ),
                                    FlatButton(
                                      child: Text("Cancel"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ]
                                )
                              );
                            }
                          );
                        },
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        )
    );
  }
}