import 'dart:collection';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:powerup/pages/CoursePage.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:powerup/entities/Course.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController search = TextEditingController();
  bool showOrderBy = false;
  List<bool> selectedOrderBy;
  List<String> orderByCategories;
  static List<Course> courseList = [
    Course('a', 'b', 4, 'assets/leatherworkshop.jpg'),
    Course('c', 'd', 3, 'assets/leatherworkshop.jpg'),
    Course('d', 'e', 3.5, 'assets/leatherworkshop.jpg'),
  ];
  @override
  void initState(){
    super.initState();
    selectedOrderBy = [false, false, false, false];
    orderByCategories = ['PriceUp', 'PriceDown', 'Popularity', 'Ratings'];
  }

  Widget courseTemplate(String name, String companyName, double rating, String image){
    return GestureDetector(
      onTap:(){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => CoursePage()));
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        color: Colors.grey[300],
        child: Row(
          children:[
            Ink(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(image),
                )
              ),
            ),
            Flexible(
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, overflow: TextOverflow.ellipsis ,style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 7),
                    Text(companyName),
                    SizedBox(height: 5),
                    RatingBarIndicator(
                      rating: rating,
                      itemBuilder: (_, __){
                        return Icon(
                          Icons.star,
                          color: Colors.amber,
                        );
                      },
                      itemSize: 20,
                    )
                  ],
                ),
              ),
            )
          ]
        )
      )
    );
  }
  Widget filterWindow() {
    return SingleChildScrollView(
      child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(1),
                child: _titleContainer("Location"),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 8),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                      spacing: 5,
                      runSpacing: -10,
                      children: [
                        FilterChipWidget(chipName: 'North',),
                        FilterChipWidget(chipName: 'South',),
                        FilterChipWidget(chipName: 'East',),
                        FilterChipWidget(chipName: 'West',),
                        FilterChipWidget(chipName: 'Central',),
                      ]
                  )
              ),

            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(1),
                child: _titleContainer("Age"),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(left: 8),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Wrap(
                        spacing: 5,
                        runSpacing: -10,
                        children: [
                          FilterChipWidget(chipName: '7-12',),
                          FilterChipWidget(chipName: '13-18',),
                          FilterChipWidget(chipName: '19-35',),
                          FilterChipWidget(chipName: '36-55',),
                          FilterChipWidget(chipName: '56-67',),
                        ]
                    )
                )
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(1),
                child: _titleContainer("Month"),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(left: 8),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Wrap(
                        spacing: 5,
                        runSpacing: -10,
                        children: [
                          FilterChipWidget(chipName: 'January',),
                          FilterChipWidget(chipName: 'February',),
                          FilterChipWidget(chipName: 'March',),
                          FilterChipWidget(chipName: 'April',),
                          FilterChipWidget(chipName: 'May',),
                          FilterChipWidget(chipName: 'June',),
                          FilterChipWidget(chipName: 'July',),
                          FilterChipWidget(chipName: 'August',),
                          FilterChipWidget(chipName: 'September',),
                          FilterChipWidget(chipName: 'October',),
                          FilterChipWidget(chipName: 'November',),
                          FilterChipWidget(chipName: 'December',),

                        ]
                    )
                )
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(1),
                child: _titleContainer("Year"),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(left: 8),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Wrap(
                        spacing: 5,
                        runSpacing: -10,
                        children: [
                          FilterChipWidget(chipName: '2021',),
                          FilterChipWidget(chipName: '2022',),
                        ]
                    )
                )
            ),
            SizedBox(height: 30),
            RaisedButton(
                color: Colors.grey[350],
                elevation: 0,
                onPressed: () {
                  setState(() {
                    if(!FilterChipWidgetState.selectedFilters.isEmpty)
                      showOrderBy = true;
                    else
                      showOrderBy = false;
                  });
                  print(FilterChipWidgetState.selectedFilters);
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Filter",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                )
            )
          ]
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text('Power Up!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              )),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: (){},
            color: Colors.black,
            iconSize: 30,
          ),
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

                children: [Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Container(
                      height: 40,
                      width: 250,
                      margin: EdgeInsets.fromLTRB(20, 20, 0, 10),
                      child: TextField(
                          controller: search,
                          textAlignVertical: TextAlignVertical.bottom,
                          obscureText: false,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                            hintText: "Search course",
                            hintStyle: TextStyle(color: Colors.black),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                          )
                      ),
                    ),
                      IconButton(icon: Icon(Icons.search), onPressed: (){
                        setState(() {
                          if(!search.text.isEmpty)
                            showOrderBy = true;
                          else
                            showOrderBy = false;
                          //courseList = Course.search(search.text, courseList);
                        });
                        FocusManager.instance.primaryFocus.unfocus();
                      }),
                      IconButton(icon: Icon(Icons.filter_list), onPressed: () {
                        //FilterChipWidgetState.selectedFilters.clear();
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                                 return AlertDialog(
                                   content: Stack(
                                     overflow: Overflow.visible,
                                     children: <Widget>[
                                       Positioned(
                                         right: -40.0,
                                         top: -40.0,
                                         child: InkResponse(
                                           onTap: () {
                                             Navigator.of(context).pop();
                                           },
                                           child: CircleAvatar(
                                             child: Icon(Icons.close),
                                             backgroundColor: Colors.red,
                                           ),
                                         ),
                                       ),
                                       // this part needs rebuilding
                                       // need to take the new state of the widget
                                       filterWindow(),
                                     ],
                                   ),
                                 );
                            });
                      },),
                    ]
                ),
                  SizedBox(height: 5),
                  showOrderBy == true ?
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ToggleButtons(
                        borderRadius: BorderRadius.circular(6),
                        borderColor: Colors.grey,
                        color: Colors.black,
                          fillColor: Colors.orangeAccent,
                          selectedColor: Colors.black,
                          children:[
                            Text('Price ⬆'),
                            Text('Price ⬇'),
                            Text('Popularity'),
                            Text('Ratings'),
                          ],
                        constraints: BoxConstraints(minWidth: 90, maxWidth: 90, minHeight: kMinInteractiveDimension),
                        onPressed: (index){
                          setState(() {
                            for (int i = 0; i < selectedOrderBy.length; i++) {
                              selectedOrderBy[i] = i == index;
                              if(selectedOrderBy[i] == true)
                                print(orderByCategories[i]);
                            }
                          });
                        },
                        isSelected: selectedOrderBy,
                          )
                    ]
                  ) :
                  Text(''),
                  SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: courseList.length,
                      itemBuilder: (context, index){
                        return courseTemplate(courseList[index].courseTitle, courseList[index].company, courseList[index].rating, courseList[index].url);
                      }
                    ),
                  )
                ]),
          ],
        )
    );
  }
}

Widget _titleContainer(String myTitle){
  return Text(
    myTitle,
    style: TextStyle(
        color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
  );
}

class FilterChipWidget extends StatefulWidget {
  final String chipName;
  FilterChipWidget({Key key, this.chipName}) : super(key: key);
  @override
  FilterChipWidgetState createState() => FilterChipWidgetState();
}

class FilterChipWidgetState extends State<FilterChipWidget> {
  var _isSelected = false;
  static List<String> selectedFilters = new List();
  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(widget.chipName),
      selected: selectedFilters.contains(widget.chipName),
      onSelected: (isSelected){
        setState(() {
          _isSelected = isSelected;
          if(_isSelected){
            selectedFilters.add(widget.chipName);
          }
          else{
            selectedFilters.remove(widget.chipName);
          }
        });
      },
      selectedColor: Colors.lightBlue,
    );
  }
}
