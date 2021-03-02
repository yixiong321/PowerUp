import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CoursePage extends StatefulWidget {
  @override
  _CoursePageState createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
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
                          'Leathercraft Workshop',
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
                      RaisedButton(

                          color: Colors.red,
                          elevation: 0,
                          onPressed: (){
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "Register",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          )
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


