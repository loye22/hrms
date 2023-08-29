import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dart/storage.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hrms/models/gloablVar.dart';
import 'package:hrms/models/staticVars.dart';
import 'package:hrms/provider/companyDoc.dart';
import 'package:hrms/webSIte/singUpScreen.dart';
import 'package:hrms/widgets/rightBar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:table_calendar/table_calendar.dart';
import '../widgets/sideBar.dart';

class homeScreen extends StatefulWidget {
  static const routeName = '/homeScreen';

  const homeScreen({Key? key}) : super(key: key);

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  final Map<String, Color> attributeColors = {
    'Accept': Colors.green,
    'Reject': Colors.red,
    'Pending': Colors.grey,
  };
  Map<String,String> empMap = {} ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration:  staticVars.tstiBackGround,
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
            top: 15,
            child: Container(
              width: MediaQuery.of(context).size.width - 650,
              //padding: EdgeInsets.all(10),
              height: MediaQuery.of(context).size.height - 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                //border: Border.all(color: Colors.black),
                //color: Colors.grey.shade200.withOpacity(0.23),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  //crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Container(
                              width:MediaQuery.of(context).size.width <1920 ? 420:  800,
                              height: 200,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                border:
                                    Border.all(color: Colors.black.withOpacity(0.33)),
                                color: Colors.grey.shade200.withOpacity(0.25),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Welcome Admin',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Expanded(
                                          child: Text(
                                            ' manage all the things from single dashboard',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  MediaQuery.of(context).size.width <1920 ?SizedBox.shrink(): Container(
                                    height: double.infinity,
                                    alignment: Alignment.center, // This is needed
                                    child: Image.asset(
                                      'assests/last.png',
                                      fit: BoxFit.contain,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 20,),
                            Container(
                              width:MediaQuery.of(context).size.width <1920 ? 420:  800,
                              height: 500,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                border: Border.all(color: Colors.black.withOpacity(.33)),
                                color: Colors.grey.shade200.withOpacity(0.23),
                              ),
                              child: FutureBuilder(
                                future: _loadData(),
                                  builder: (ctx,snapShot){
                                  if(snapShot.connectionState == ConnectionState.waiting){
                                    return Center(child: CircularProgressIndicator(),);
                                  }
                                  if(snapShot.hasError){
                                    print(snapShot.error.toString());
                                    return Center(child: Text(snapShot.error.toString()),);
                                  }
                                  return Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: SfCartesianChart(
                                      primaryXAxis: CategoryAxis(),
                                      series: <ChartSeries>[
                                        ColumnSeries<WorkExperienceData, String>(
                                          dataSource: snapShot.data!,
                                          xValueMapper: (WorkExperienceData data, _) => this.empMap[data.eid] ?? 'Notfound',
                                          yValueMapper: (WorkExperienceData data, _) => data.amount,
                                          dataLabelSettings: DataLabelSettings(isVisible: true),
                                        ),
                                      ],
                                    ),
                                  );
                                  },
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              width: 430,
                              height: 500,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                border:
                                    Border.all(color: Colors.black.withOpacity(0.33)),
                                color: Colors.grey.shade200.withOpacity(0.25),
                              ),
                              child: TableCalendar(
                                firstDay: DateTime.utc(2023, 1, 1),
                                lastDay: DateTime.utc(2023, 12, 31),
                                focusedDay: DateTime.now(),
                                onFormatChanged: (x) {},
                                calendarStyle: CalendarStyle(
                                  // Customize the colors here
                                  weekendTextStyle: TextStyle(
                                      color: Colors.red, fontWeight: FontWeight.bold),
                                  holidayTextStyle: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold),
                                  selectedTextStyle: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                  todayTextStyle: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold),
                                  outsideDaysVisible: false,
                                  defaultTextStyle:
                                      TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            SizedBox(height: 10,),
                            Container(
                                width: 430,
                                height: 400,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  border:
                                  Border.all(color: Colors.black.withOpacity(0.33)),
                                  color: Colors.grey.shade200.withOpacity(0.25),
                                ),
                                child: FutureBuilder(
                                  future: countStatusOccurrences(),
                                  builder: (ctx,snapShot){
                                    if(snapShot.hasError){
                                      return Center(child: Text(snapShot.error.toString()),);
                                    }
                                    if(snapShot.connectionState == ConnectionState.waiting){
                                      return Center(child: CircularProgressIndicator(),);
                                    }
                                    return Center(
                                      child: Column(
                                        children: [
                                          Text('Requests status' , style: TextStyle(color: Colors.black , fontWeight: FontWeight.bold,fontSize: 20),),
                                          SfCircularChart(
                                            series: <CircularSeries>[
                                              PieSeries<ChartData, String>(
                                                dataSource: <ChartData>[
                                                  ChartData('Accept', snapShot.data!['Accepted'] ?? 1 ),
                                                  ChartData('Reject', snapShot.data!['reject'] ?? 1),
                                                  ChartData('Pending', snapShot.data!['pending'] ?? 1),
                                                ],
                                                xValueMapper: (ChartData data, _) =>
                                                data.attribute,
                                                yValueMapper: (ChartData data, _) =>
                                                data.value,
                                                pointColorMapper: (ChartData data, _) =>
                                                attributeColors[data.attribute],
                                                dataLabelSettings: DataLabelSettings(
                                                  isVisible: true,
                                                  labelPosition:
                                                  ChartDataLabelPosition.outside,
                                                  textStyle: TextStyle(fontSize: 12),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                              padding: EdgeInsets.all(2),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Container(
                                                    width: 20,
                                                    height: 20,
                                                    decoration: BoxDecoration(
                                                      color: Colors.green,
                                                      shape: BoxShape.rectangle,
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Text(
                                                    'Accepted',
                                                    style: TextStyle(fontSize: 15 , fontWeight: FontWeight.bold),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Container(
                                                    width: 20,
                                                    height: 20,
                                                    decoration: BoxDecoration(
                                                      color: Colors.red,
                                                      shape: BoxShape.rectangle,
                                                    ),
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text(
                                                    'Rejected',
                                                    style: TextStyle(fontSize: 15 , fontWeight: FontWeight.bold),
                                                  ),
                                                  SizedBox(width: 10,),
                                                  Container(
                                                    width: 20,
                                                    height: 20,
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey,
                                                      shape: BoxShape.rectangle,
                                                    ),
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text(
                                                    'Pending',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                ],
                                              ))
                                        ],
                                      ),
                                    );

                                  },

                                )
                            ),

                          ],
                        )
                      ],
                    ),

                  ],
                ),
              ),
            ),
          ),
          Positioned(
            child: sideBar(
              index: 0,
            ),
          ),
        ],
      ),
    );
  }

  Future<Map<String, double>> countStatusOccurrences() async {
    final CollectionReference requestsCollection =
    FirebaseFirestore.instance.collection('requests');

    QuerySnapshot snapshot = await requestsCollection.get();

    Map<String, double> statusCount = {
      'pending': 0,
      'Accepted': 0,
      'reject': 0,
    };

    snapshot.docs.forEach((doc) {
      Map<String,dynamic>  data = doc.data() as Map<String,dynamic> ;
      if (data['status'] != null && statusCount.containsKey(data['status'])) {
        statusCount[data['status']] = statusCount[data['status']]! + 1;
      }
    });
    print(statusCount);
    return statusCount;
  }


  /////////////////////////// test aria ///////////////////////////////////////////////////////////////////////////////////////////////

  Future<List<WorkExperienceData>> _loadData() async {
    // extract the emplyee data {eid:name}
    final snap = await FirebaseFirestore.instance.collection('Employee').get();
    Map<String, String> employeeUserNames = {};
    snap.docs.forEach((doc) {
      String docId = doc.id;
      String userName = doc.data()['userName'];

      employeeUserNames[docId] = userName;
    });
    this.empMap = employeeUserNames ;





    final snapshot = await FirebaseFirestore.instance.collection('workExp').get();
    Map<String, double> employeeAmounts = {};

    snapshot.docs.forEach((doc) {
      String eid = doc.data()['eid'];
      double amount = double.parse(doc.data()['amount']);


      if (employeeAmounts.containsKey(eid)) {
        employeeAmounts[eid] = employeeAmounts[eid]! + amount;
      } else {
        employeeAmounts[eid] = amount;
      }
    });

    List<WorkExperienceData> data = employeeAmounts.entries.map((entry) {
      return WorkExperienceData(eid: entry.key, amount: entry.value);
    }).toList();

    return data;
  }


  Future<void> newRequist(String userId, String workflowId) async {
    try {
      print(userId + '    userId');
      print(workflowId + '        workflowId');
      DateTime currentDate = DateTime.now();
      List<String> flowOrder = [];
      // Create the request document data
      Map<String, dynamic> requestData = {
        'eId': userId,
        'date': currentDate,
        'title': workflowId,
        'flow': {},
        'status': 'pending',
        'ReqistedDays': "7"
      };
      // Retrieve the workflow document
      DocumentSnapshot workflowSnapshot = await FirebaseFirestore.instance
          .collection('workflow')
          .doc(workflowId)
          .get();

      // Check if the workflow document exists
      if (workflowSnapshot.exists) {
        // Retrieve the flow map from the workflow document
        Map<String, dynamic>? flowMap =
        workflowSnapshot.data() as Map<String, dynamic>?;
        // print(flowMap.toString()  + "<<<<<<<<");
        //print(flowMap!['flow']!.keys.toList()..sort());
        List<String> sortedKeys = flowMap!['flow'].keys.toList()..sort();
        Map<String, dynamic> sortedMap = {};
        for (var key in sortedKeys) {
          sortedMap[key] = flowMap['flow'][key];
        }

        requestData['flow'] = sortedMap;
        // Create the request document in the requests collection
        CollectionReference requestsCollection =
        FirebaseFirestore.instance.collection('requests');

        requestsCollection.add(requestData).catchError((error) {
          print('Failed to create request document: $error');
        });

        // print(requestData);
      }
    } catch (e) {
      print(e);
    }
  }

  final Random random = Random();

// Generate a random check-in timestamp between 7:00 AM and 8:00 AM
  int generateCheckInTimestamp(DateTime date) {
    final checkInHour = 7 + random.nextInt(2);
    final checkInMinute = random.nextInt(60);
    final checkInTimestamp =
        DateTime(date.year, date.month, date.day, checkInHour, checkInMinute);
    return checkInTimestamp.millisecondsSinceEpoch;
  }

// Generate a random check-out timestamp between 2:00 PM and 5:00 PM
  int generateCheckOutTimestamp(DateTime date) {
    final checkOutHour = 14 + random.nextInt(4);
    final checkOutMinute = random.nextInt(60);
    final checkOutTimestamp =
        DateTime(date.year, date.month, date.day, checkOutHour, checkOutMinute);
    return checkOutTimestamp.millisecondsSinceEpoch;
  }

// Generate a dummy attendance record for a given date and employee UID
  Map<String, dynamic> generateAttendanceRecord(DateTime date, String uid) {
    final checkInTimestamp = generateCheckInTimestamp(date);
    final checkOutTimestamp = generateCheckOutTimestamp(date);

    return {
      'BranshName': 'AbuDabi',
      'checkInIsHeIn': true.toString(),
      'checkInLat': '0',
      'checkInLong': '0',
      'checkInPhoto':
          'https://www.shutterstock.com/image-photo/portrait-attractive-cheerful-girl-demonstrating-260nw-2113649489.jpg',
      'checkInTimeStamp': checkInTimestamp.toString(),
      'checkOutIsHeIn': true.toString(),
      'checkOutLat': '0',
      'checkOutLong': '0',
      'checkOutPhoto':
          'https://www.shutterstock.com/image-photo/portrait-attractive-cheerful-girl-demonstrating-260nw-2113649489.jpg',
      'checkOutTimeStamp': checkOutTimestamp.toString(),
      'email': 'employee@example.com',
      'name': 'Employee Name',
      'scedual': {
        'shifts': {
          'thu': ' 9:00 AM 5:00 PM AbuDabi',
          'fri': ' 9:00 AM 5:00 PM AbuDabi',
          'wed': ' 9:00 AM 5:00 PM AbuDabi',
          'tur': '9:00 AM 5:00 PM AbuDabi',
          'mon': '9:00 AM 5:00 PM AbuDabi',
          'sun': 'OFF',
          'sat': '9:00 AM 5:00 PM AbuDabi'
        },
        'timestamp': '2023-06-21 13:21:00.521'
      },
      'uid': uid,
    };
  }

// Function to insert dummy attendance data into Firestore
/*
  Future<void> insertDummyAttendanceData() async {
    int c = 0 ;
    final startDate = DateTime(2023, 1, 1); // Start date of the date range
    final endDate = DateTime(2023, 4, 2); // End date of the date range
    final employeeUids = [
      '1VvCHb1DwEcJdsX9KQ9YD01sYVO2',
      'BzGREtBwtdRg1OD1s4IOKWryuv73',
      'JjKnRPmnMeZghE7eE2wydStaNKD3',
      'MEWGndjyyscGs8hOHsJ2rZMaqkk2',
      'VIW12XiEaTY7cm91niDKEgvlRCv2',
      'Y1S5WDkIFvMpdqrEPu0hWa9CMyE2',
      'kfiyUUflSVdqbWEdFJ6T1USQlyk2',
      'tfZafzUTNrXurX0EnaCqAPnuCxw1',
    ];

    final dummyAttendanceData = <Map<String, dynamic>>[];

    for (var date = startDate; date.isBefore(endDate); date = date.add(Duration(days: 1))) {
      if(c == 2){
        print(dummyAttendanceData.length);
        break ;
      }


      for (final uid in employeeUids) {
        final attendanceRecord = generateAttendanceRecord(date, uid);
        dummyAttendanceData.add(attendanceRecord);


      }
      c+=1 ;
    }


    final CollectionReference attendanceCollection = FirebaseFirestore.instance.collection('attendance');
    for (final attendanceRecord in dummyAttendanceData) {
      await attendanceCollection.add(attendanceRecord);
    }

    print('Dummy attendance data added to Firestore successfully!');
  }
  */

  Future<Map<String, Duration>> calculateWorkingHours2(
      DateTime startDate, DateTime endDate) async {
    // Retrieve the attendance records from Firestore within the specified date range
    final CollectionReference attendanceCollection =
        FirebaseFirestore.instance.collection('attendance');
    final QuerySnapshot attendanceSnapshot = await attendanceCollection
        .where('checkInTimeStamp',
            isGreaterThanOrEqualTo: startDate.millisecondsSinceEpoch.toString())
        .where('checkInTimeStamp',
            isLessThanOrEqualTo: endDate.millisecondsSinceEpoch.toString())
        .get();

    // Map to store the total working hours for each employee
    final Map<String, Duration> workingHoursMap = {};

    // Calculate working hours for each attendance record
    for (final attendanceDoc in attendanceSnapshot.docs) {
      final attendanceData = attendanceDoc.data() as Map<String, dynamic>;
      final String eName = attendanceData['name'];
      final int checkInTimestamp =
          int.parse(attendanceData['checkInTimeStamp']);
      final int checkOutTimestamp =
          int.parse(attendanceData['checkOutTimeStamp']);

      final DateTime checkInDateTime =
          DateTime.fromMillisecondsSinceEpoch(checkInTimestamp);
      final DateTime checkOutDateTime =
          DateTime.fromMillisecondsSinceEpoch(checkOutTimestamp);

      final Duration workingHours =
          checkOutDateTime.difference(checkInDateTime);

      if (workingHoursMap.containsKey(eName)) {
        workingHoursMap[eName] =
            (workingHoursMap[eName] ?? Duration()) + workingHours;
      } else {
        workingHoursMap[eName] = workingHours;
      }
    }

    Map<String, Duration> res = {};

    // Print the calculated working hours for each employee
    for (final entry in workingHoursMap.entries) {
      final String eName = entry.key;
      final Duration workingHours = entry.value ?? Duration();
      res[eName] = workingHours;
      // print('Employee UID: $uid');
      //print('Working Hours: ${workingHours.inHours} hours ${workingHours.inMinutes.remainder(60)} minutes');
      //print('---------------------');
    }
    print(workingHoursMap);
    return res;
  }

/////////////////////////// test aria ///////////////////////////////////////////////////////////////////////////////////////////////
}

class ChartData {
  final String attribute;
  final double value;

  ChartData(this.attribute, this.value);
}

class WorkExperienceData {
  final String eid;
  final double amount;

  WorkExperienceData({
    required this.eid,
    required this.amount,
  });
}


