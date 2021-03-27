import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:powerup/entities/Course.dart';

class CoursePage extends StatefulWidget {
  @override
  //All the parameters required for CoursePage that is brought forward from Home Page - LI SHENG
  String courseName;
  bool registered;
  CoursePage(this.registered, this.courseName);
  /// This function displays the Course Page
  _CoursePageState createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  String sessionChosen;
  final sessionList = ["Session 1", "Session 2", "Session 3"];
  final _formKey = GlobalKey<FormState>();
  bool _autovalidate = false;
  //bool registered;

  @override
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
                Image.asset(
                    'assets/leatherworkshop.jpg',
                    fit: BoxFit.fitWidth,
                ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Column(
                    children: [

                      Text(
                          widget.courseName,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          )
                      ),
                      SizedBox(height: 30),
                      Text(
                          'WeatherLeather Pte Ltd. presents a workshop for beginners on the basics of leathercrafting. In this exciting series, you will learn to craft simple accessories such as pouches and keyrings.',
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
                        title: Text("Course fees: \$58"),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.location_on,
                          color: Colors.red[700],
                        ),
                        title: Text('123 Tanjong Pagar Ris, Singapore 29384'),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.calendar_today,
                          color: Colors.red[700],
                        ),
                        title: Text('Session 1: 21-02-21, 1400-1700 Session 2: 25-02-21, 1400-1700 Session 3: 27-02-21, 1400-1700'),
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
                                              value: sessionChosen,
                                              validator: (value) => value == null ? 'Please select a session': null,
                                              onChanged: (newValue){
                                                setState(() {
                                                  sessionChosen = newValue;
                                                });
                                              },
                                              items: sessionList.map((valueItem){
                                                return DropdownMenuItem(
                                                  value: valueItem,
                                                  child: Text(valueItem),
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
                                                                          widget.courseName,
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
                                                                            "Course fees: \$58",
                                                                          style: TextStyle(fontSize: 20),
                                                                        ),
                                                                      ),
                                                                      ListTile(
                                                                        leading: Icon(
                                                                          Icons.location_on,
                                                                          color: Colors.red[700],
                                                                        ),
                                                                        title: Text(
                                                                            '123 Tanjong Pagar Ris, Singapore 29384',
                                                                          style: TextStyle(fontSize: 20),
                                                                        ),
                                                                      ),
                                                                      ListTile(
                                                                        leading: Icon(
                                                                          Icons.calendar_today,
                                                                          color: Colors.red[700],
                                                                        ),
                                                                        title: Text(
                                                                          sessionChosen,
                                                                          style: TextStyle(fontSize: 20),
                                                                        ),
                                                                      ),
                                                                      SizedBox(height: 20),
                                                                      RaisedButton(onPressed: () {
                                                                        Navigator.of(context).pop();
                                                                        Navigator.of(context).pop();
                                                                        Navigator.push(context, MaterialPageRoute(
                                                                            builder: (context) => CoursePage(
                                                                                widget.registered, widget.courseName,
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
                                              widget.registered, widget.courseName,
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


