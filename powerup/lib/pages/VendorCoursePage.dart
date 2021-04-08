import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../entities/Course.dart';
import '../controllers/VendorController.dart';
import '../entities/Session.dart';
import '../pages/VendorProfile.dart';
import '../entities/Vendor.dart';

class VendorCoursePage extends StatefulWidget {
  @override
  //bool registered;
  Course course; Vendor vendor;
  VendorCoursePage(this.course, this.vendor);
  /// This function displays the Course Page
  _VendorCoursePageState createState() => _VendorCoursePageState();
}

class _VendorCoursePageState extends State<VendorCoursePage> {
  ScrollController controller = ScrollController();
  VendorController vcontroller = VendorController();
  List<Widget> participantsData = [];
  List<Widget> sessionsData = [];
  String allSessions = '';
  String allParticipants = '';

  void displayParticipantList(){
    List <Widget> listItems = [];
    vcontroller.viewParticipants(widget.course.courseID).then((allSessionsParticipantList){
      allSessionsParticipantList.forEach((session){
        session.forEach((participant) {
          listItems.add(Text(participant));
        });
      });
      setState(() {
        participantsData = listItems;
      });
    });
    //prev setstate
  }

  Future<String> allSessionsForCourse() async{
    //print('courseID: ${widget.course.courseID}');
    List<Session> sessionList = await vcontroller.getCourseSessions(widget.course.courseID);
    String string = "";
    for(int i = 0; i < sessionList.length; i++){
      string += "Session " + (i+1).toString() + ": " + sessionList[i].startDate + ", " + sessionList[i].dateTime + "\n";
    }
    return string;
  }
  allSessionsForCourseStr() {
    allSessionsForCourse().then((string) {
      allSessions = string;
      setState(() {
      });
    });
  }

  Future<String> allParticipantsForCourse() async{
    //print('courseID: ${widget.course.courseID}');
    List<List<String>> participantList = await vcontroller.viewParticipants(widget.course.courseID);
    String string = "";
    for(int i = 0; i < participantList.length; i++){
      for(int j = 0; j<participantList[i].length; j++){
        string += participantList[i][j] + '\n';
      }
      string += '\n';
    }
    return string;
  }
  allParticipantsForCourseStr() {
    allParticipantsForCourse().then((string) {
      allParticipants = string;
      setState(() {
      });
    });
  }

  @override
  _openPopup(context) {
    Alert(
        context: context,
        title: "Participant List",
        content:
        Column(
          children: <Widget>[
            Container(
                child: Text(allParticipants)
            ),
          ],
        ),
        buttons: [
          DialogButton(
            height: 35,
            width: 300,
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Back to Course",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }

  @override
  void initState() {
    super.initState();
    displayParticipantList();
    allSessionsForCourseStr();
    allParticipantsForCourseStr();
  }

  Widget build(BuildContext context) {
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
                      SizedBox(height: 10),
                      ListTile(
                        leading: Icon(
                          Icons.monetization_on_rounded,
                          color: Colors.red[700],
                        ),
                        title: Text("Course fees: \$"+ widget.course.price.toString()),
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
                        title: Text(allSessions),
                      ),
                      SizedBox(height: 10),
                      Text('Registration Deadline: ${widget.course.regDeadline}', style: TextStyle(color: Colors.redAccent), ),
                      SizedBox(height: 20),
                      Container(
                          height: 45,
                          width: 500,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text("View Participants"),
                            color: Colors.blue,
                            hoverColor: Colors.lightBlueAccent,
                            onPressed: (){
                              _openPopup(context);
                            },
                          )
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: 45,
                        width: 500,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          color: Colors.red,
                          hoverColor: Colors.redAccent,
                          child: Text("Remove Course"),
                          onPressed: (){
                            showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (builder) {
                                  return AlertDialog(
                                      backgroundColor: Colors.redAccent,
                                      title: Text(
                                        'Are you sure you want to remove this course?',
                                        textAlign: TextAlign.center,
                                      ),
                                      content: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            FlatButton(
                                              child: Text("Confirm"),
                                              onPressed: () {
                                                vcontroller.removeCourseFromDB(widget.course.courseID);
                                                Navigator.of(context).pop();
                                                Navigator.of(context).pop();
                                                Navigator.push(context, MaterialPageRoute(
                                                    builder: (context) => VendorProfile(
                                                        widget.vendor
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
                        ),
                      ),
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
