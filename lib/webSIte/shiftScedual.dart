import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hrms/models/Dialog.dart';
import 'package:hrms/widgets/button.dart';
import 'package:hrms/widgets/rightBar.dart';
import '../widgets/sideBar.dart';
import 'package:intl/intl.dart';

class shiftScedual extends StatefulWidget {
  static const routeName = '/shiftScedual';
  List<Map<String, dynamic>> employeesData2 = [];

  shiftScedual({Key? key}) : super(key: key);

  @override
  State<shiftScedual> createState() => _shiftScedualState();
}

class _shiftScedualState extends State<shiftScedual> {
  @override
  Widget build(BuildContext context) {
    List<String> weekdays =
        DateFormat('EEEE', 'en_US').format(DateTime.now()).split(' ');
    List<String> dates = List.generate(
        7,
        (index) =>
            DateFormat('d').format(DateTime.now().add(Duration(days: index))));
    Map<String, dynamic> emplyeeData = {
      'Jane': 2,
      'Jane': 2,
      'Jane': 3,
    };

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
                color: Colors.red,
                gradient: LinearGradient(colors: [
                  Color.fromRGBO(90, 137, 214, 1),
                  Color.fromRGBO(95, 167, 210, 1),
                  Color.fromRGBO(49, 162, 202, 1)
                ])),
            child: Container(
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white.withOpacity(0.13)),
                color: Colors.grey.shade200.withOpacity(0.25),
              ),
            ),
          ),
          rightBar(),
          Positioned(
            left: 280,
            bottom: 15,
            child: Container(
              width: MediaQuery.of(context).size.width - 650,
              //padding: EdgeInsets.all(10),
              height: MediaQuery.of(context).size.height - 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: Colors.white.withOpacity(0.13)),
                color: Colors.grey.shade200.withOpacity(0.23),
              ),
              child: FutureBuilder(
                future: fetchEmployeesData(),
                //.then((value) => widget.employeesData2 = value ) ,
                builder: (ctx, f) {
                  if (f.hasError) {
                    return Container(
                      child: Center(child: Text("Error")),
                      decoration: BoxDecoration(
                        // borderRadius: BorderRadius.circular(30),
                        border:
                            Border.all(color: Colors.white.withOpacity(0.13)),
                        color: Colors.grey.shade200.withOpacity(0.35),
                      ),
                    );
                  }
                  if (f.connectionState == ConnectionState.waiting) {
                    return Container(
                      child: Center(child: CircularProgressIndicator()),
                      decoration: BoxDecoration(
                        // borderRadius: BorderRadius.circular(30),
                        border:
                            Border.all(color: Colors.white.withOpacity(0.13)),
                        color: Colors.grey.shade200.withOpacity(0.25),
                      ),
                    );
                  } else {
                    if (widget.employeesData2.isEmpty) {
                      widget.employeesData2 = f.data!;
                    }

                    return EmployeeCalendarWidget(
                      employeeData: widget.employeesData2,
                    );
                  }
                },
              ),
            ),
          ),
          Positioned(
            child: sideBar(),
          ),
          Positioned(
              left: 280,
              top: 15,
              child: Container(
                height: MediaQuery.of(context).size.height - 950 > 0
                    ? MediaQuery.of(context).size.height - 950
                    : 50,
                width: MediaQuery.of(context).size.width - 650 > 0
                    ? MediaQuery.of(context).size.width - 650
                    : 500,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Button(
                          icon: Icons.upload,
                          onPress: () {},
                          txt: 'Publish',
                          isSelected: true),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Button(
                          icon: Icons.schedule,
                          onPress: () async {
                            // ['Abu Dabi', 'ajman']
                            //['On duty', 'Off']
                            String v1 =
                                'Abu Dabi'; // to save the  Abu Dabi/ajman
                            String v2 = 'On duty'; // On duty/Off

                            setState(() {});

                            dynamic x = await showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                  backgroundColor: Colors.transparent,
                                  content: Container(
                                    width:
                                        MediaQuery.of(context).size.width - 500,
                                    height: 600,
                                    child: Stack(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              gradient: LinearGradient(colors: [
                                                Color.fromRGBO(90, 137, 214, 1),
                                                Color.fromRGBO(95, 167, 210, 1),
                                                Color.fromRGBO(49, 162, 202, 1)
                                              ])),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              //borderRadius: BorderRadius.all(Radius.circular(30)),
                                              border: Border.all(
                                                  color: Colors.white
                                                      .withOpacity(0.13)),
                                              color: Colors.grey.shade200
                                                  .withOpacity(0.25),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(30)),
                                            border: Border.all(
                                                color: Colors.white
                                                    .withOpacity(0.13)),
                                            color: Colors.grey.shade200
                                                .withOpacity(0.23),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(16.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Shift the secdual for all employees',
                                                  style: TextStyle(
                                                      fontSize: 24,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                                SizedBox(height: 16),
                                                DropdownButtonFormField<String>(
                                                  value: 'On duty',
                                                  onChanged: (value) {
                                                    v1 = value!;
                                                  },
                                                  items: ['On duty', 'Off']
                                                      .map((String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Text(value),
                                                    );
                                                  }).toList(),
                                                  decoration: InputDecoration(
                                                    labelText: 'On duty / Off',
                                                    border:
                                                        OutlineInputBorder(),
                                                  ),
                                                ),
                                                SizedBox(height: 16),
                                                DropdownButtonFormField<String>(
                                                  value: 'Abu Dabi',
                                                  onChanged: (value) {
                                                    v2 = value!;
                                                    //widget.onSelectedItems();
                                                  },
                                                  items: ['Abu Dabi', 'ajman']
                                                      .map((String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Text(value),
                                                    );
                                                  }).toList(),
                                                  decoration: InputDecoration(
                                                    labelText:
                                                        'Please select the bransh',
                                                    border:
                                                        OutlineInputBorder(),
                                                  ),
                                                ),
                                                SizedBox(height: 16),
                                                Button(
                                                  icon: Icons.add,
                                                  txt: 'Submit',
                                                  isSelected: true,
                                                  onPress: () {
                                                    try {
                                                      if (v1 == null ||
                                                          v2 == null) {
                                                        MyDialog.showAlert(
                                                            context,
                                                            "Please insert the both fileds");
                                                        return;
                                                      }

                                                      Navigator.pop(
                                                          context, [v1, v2]);
                                                    } catch (e) {
                                                      MyDialog.showAlert(
                                                          context,
                                                          e.toString());
                                                    }
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                            );
                            // print(v1 + "       " + v2 );

                            for (var i in widget.employeesData2) {
                              i['shifts']['bransh'] = v2;
                            }
                            setState(() {});
                          },
                          txt: 'Secdual for all emplyee',
                          isSelected: true),
                    ),
                    /*Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Button(icon: Icons.upload, onPress: (){}, txt: 'Publish', isSelected: true),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Button(icon: Icons.upload, onPress: (){}, txt: 'Publish', isSelected: true),
                    ),*/
                  ],
                ),
              ))
        ],
      ),
    );
  }
  Future<List<Map<String, dynamic>>> fetchEmployeesData() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('Employee').get();
    List<Map<String, dynamic>> employeesData = [];
    querySnapshot.docs.forEach((doc) {
      Map<String, dynamic> employee = {
        'id': doc.id,
        'name': doc['userName'],
        'photoUrl': doc['photo'],
        'shifts': {
          'mon': '7Am to 4 Pm',
          'tur': '7Am to 4 Pm',
          'wed': '7Am to 4 Pm',
          'thu': '7Am to 4 Pm',
          'fri': '7Am to 12 Am',
          'sat': '7Am to 4 Pm',
          'sun': 'OFF',
          'bransh': 'Abudabi'
        },
      };
      employeesData.add(employee);
    });

    return employeesData;
  }

  Future<List<String>> getBranchTitles() async {
    List<String> titles = [];

    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection('branchs').get();

    querySnapshot.docs.forEach((doc) {
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
      String title = data?['title'] ?? 'Default Title';
      titles.add(title);
    });

    return titles;
  }
}

class EmployeeCalendarWidget extends StatelessWidget {
  List<Map<String, dynamic>> employeeData;

  EmployeeCalendarWidget({super.key, required this.employeeData});

  @override
  Widget build(BuildContext context) {
    final List<String> weekdays = [
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun'
    ];
    final List<DateTime> weekDates = [];
    final List<String> daysGon = [
      'mon',
      'tur',
      'wed',
      'thu',
      'fri',
      'sat',
      'sun'
    ];

    // Get current week dates
    DateTime now = DateTime.now();
    int currentWeekday = now.weekday;
    DateTime currentWeekMonday =
        now.subtract(Duration(days: currentWeekday - 1));
    for (int i = 0; i < 7; i++) {
      weekDates.add(currentWeekMonday.add(Duration(days: i)));
    }

    return DataTable2(
      dataRowHeight: 100,
      columnSpacing: 10,
      columns: List.generate(
        8,
        (index) {
          if (index == 0) {
            return DataColumn(label: SizedBox.shrink());
          } else {
            return DataColumn(
                label: Text(
                    '   ${weekdays[index - 1]} ${DateFormat.d().format(weekDates[index - 1])}'));
          }
        },
      ),
      rows: this
          .employeeData
          .map(
            (e) => DataRow2(cells: [
              DataCell(
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                          backgroundImage: NetworkImage(e['photoUrl'] ??
                              'https://imglarger.com/Images/before-after/ai-image-enlarger-1-after-2.jpg'),
                          radius: 30),
                      Expanded(
                          child: Center(
                        child: Text(
                          e['name'],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ))
                    ],
                  ),
                ),
              ),
              ...List.generate(
                  7,
                  (index) => DataCell(StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) =>
                            HoverContainer(
                          empName: e['name'] ?? 'NotFound 404',
                          firstDropDownList: ['On duty', 'Off'],
                          secondDropDownList: ['Abu Dabi', 'ajman'],
                          text: e['shifts'][daysGon[index].toString()] ??
                              'not found 404',
                          text2: e['shifts']['bransh'] ?? 'not found 404',
                          shiftDate:
                              '${DateFormat("MMMM").format(DateTime.now())} ${weekdays[index]} ${DateFormat.d().format(weekDates[index])}',
                          onSelectedItems: (x, y) {
                            setState(() {
                              e['shifts'][daysGon[index].toString()] = x;
                              e['shifts']['bransh'] = y;
                            });
                          },
                        ),
                      ) /* Text('Shift data for ${weekdays[index]}')  */)),
            ]),
          )
          .toList(),
    );
  }
}

class HoverContainer extends StatefulWidget {
  final String text;
  final String text2;
  final List<String> firstDropDownList;
  final List<String> secondDropDownList;
  final String empName;
  final String shiftDate;
  final Function(String?, String?) onSelectedItems;

  HoverContainer(
      {required this.text,
      required this.firstDropDownList,
      required this.secondDropDownList,
      required this.empName,
      required this.shiftDate,
      required this.text2,
      required this.onSelectedItems});

  @override
  _HoverContainerState createState() => _HoverContainerState();
}

class _HoverContainerState extends State<HoverContainer> {
  bool _isHovering = false;
  String title = '';
  int duration = 0;
  String? selectedFirst;
  String? selectedSecond;

  final titleController = TextEditingController();
  final durationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        setState(() {
          _isHovering = true;
        });
      },
      onExit: (event) {
        setState(() {
          _isHovering = false;
        });
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: _isHovering ? Colors.grey[400] : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.text,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 20,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        widget.text2,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Visibility(
                    visible: _isHovering,
                    child: InkWell(
                      onTap: () async {
                        await showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                              backgroundColor: Colors.transparent,
                              content: Container(
                                width: MediaQuery.of(context).size.width - 500,
                                height: 600,
                                child: Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          gradient: LinearGradient(colors: [
                                            Color.fromRGBO(90, 137, 214, 1),
                                            Color.fromRGBO(95, 167, 210, 1),
                                            Color.fromRGBO(49, 162, 202, 1)
                                          ])),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          //borderRadius: BorderRadius.all(Radius.circular(30)),
                                          border: Border.all(
                                              color: Colors.white
                                                  .withOpacity(0.13)),
                                          color: Colors.grey.shade200
                                              .withOpacity(0.25),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30)),
                                        border: Border.all(
                                            color:
                                                Colors.white.withOpacity(0.13)),
                                        color: Colors.grey.shade200
                                            .withOpacity(0.23),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Shift the secdual for ${this.widget.empName}\n${this.widget.shiftDate}',
                                              style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                            SizedBox(height: 16),
                                            DropdownButtonFormField<String>(
                                              value: selectedFirst,
                                              onChanged: (value) {
                                                selectedFirst = value;
                                              },
                                              items: widget.firstDropDownList
                                                  .map((String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                              decoration: InputDecoration(
                                                labelText: 'On duty / Off',
                                                border: OutlineInputBorder(),
                                              ),
                                            ),
                                            SizedBox(height: 16),
                                            DropdownButtonFormField<String>(
                                              value: selectedSecond,
                                              onChanged: (value) {
                                                selectedSecond = value;
                                                //widget.onSelectedItems();
                                              },
                                              items: widget.secondDropDownList
                                                  .map((String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                              decoration: InputDecoration(
                                                labelText:
                                                    'Please select the bransh',
                                                border: OutlineInputBorder(),
                                              ),
                                            ),
                                            SizedBox(height: 16),
                                            Button(
                                              icon: Icons.add,
                                              txt: 'Submit',
                                              isSelected: true,
                                              onPress: () {
                                                try {
                                                  if (selectedFirst == null ||
                                                      selectedSecond == null) {
                                                    MyDialog.showAlert(context,
                                                        "Please insert the both fileds");
                                                    return;
                                                  }
                                                  widget.onSelectedItems(
                                                      selectedFirst,
                                                      selectedSecond);

                                                  Navigator.pop(context);
                                                } catch (e) {
                                                  MyDialog.showAlert(
                                                      context, e.toString());
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        );
                      },
                      child: Icon(
                        Icons.edit,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                    /* onPressed: () {
                    // Do something when pen icon is pressed
                  },*/
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
