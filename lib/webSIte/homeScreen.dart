import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hrms/models/gloablVar.dart';
import 'package:hrms/provider/companyDoc.dart';
import 'package:hrms/webSIte/singUpScreen.dart';
import 'package:hrms/widgets/rightBar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider/UserData.dart';
import '../widgets/BarChartSample2.dart';
import '../widgets/emplyeeCard.dart';
import '../widgets/iconWiget.dart';
import '../widgets/sideBar.dart';
import 'package:hrms/widgets/button.dart';

import 'companyDocAdd.dart';

class homeScreen extends StatefulWidget {
  static const routeName = '/homeScreen';

  const homeScreen({Key? key}) : super(key: key);

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
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
            top: 15,
            child: Container(
              width: MediaQuery.of(context).size.width - 650,
              //padding: EdgeInsets.all(10),
              height: MediaQuery.of(context).size.height - 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: Colors.white.withOpacity(0.13)),
                color: Colors.grey.shade200.withOpacity(0.23),
              ),
              child: Center(
                  child: Column(
                children: [
                  Text("HOMe screen for testing "),
                  /*Button(
                      icon: Icons.forward_to_inbox,
                      onPress: () async {
                        print('start');
                       // await insertDummyAttendanceData();
                        print('end');
                       // await newRequist("VIW12XiEaTY7cm91niDKEgvlRCv2", "IDkjkEURfUtxvyNG8ngZ");
                      },
                      txt: "New requist",
                      isSelected: true) ,*/
                  Button(icon: Icons.ac_unit, onPress: () async {

                    final startDate = DateTime(2022,1, 22);
                    final endDate = DateTime(2024, 7, 22);
                    print('start');
                    await calculateWorkingHours2(startDate, endDate);
                    print('end');



                  }, txt: 'txt', isSelected: true)
                ],
              )),
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
        'status':'pending' ,
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


  /////////////////////////// test aria ///////////////////////////////////////////////////////////////////////////////////////////////


  final Random random = Random();

// Generate a random check-in timestamp between 7:00 AM and 8:00 AM
  int generateCheckInTimestamp(DateTime date) {
    final checkInHour = 7 + random.nextInt(2);
    final checkInMinute = random.nextInt(60);
    final checkInTimestamp = DateTime(date.year, date.month, date.day, checkInHour, checkInMinute);
    return checkInTimestamp.millisecondsSinceEpoch;
  }

// Generate a random check-out timestamp between 2:00 PM and 5:00 PM
  int generateCheckOutTimestamp(DateTime date) {
    final checkOutHour = 14 + random.nextInt(4);
    final checkOutMinute = random.nextInt(60);
    final checkOutTimestamp = DateTime(date.year, date.month, date.day, checkOutHour, checkOutMinute);
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
      'checkInPhoto': 'https://www.shutterstock.com/image-photo/portrait-attractive-cheerful-girl-demonstrating-260nw-2113649489.jpg',
      'checkInTimeStamp': checkInTimestamp.toString(),
      'checkOutIsHeIn': true.toString(),
      'checkOutLat': '0',
      'checkOutLong': '0',
      'checkOutPhoto': 'https://www.shutterstock.com/image-photo/portrait-attractive-cheerful-girl-demonstrating-260nw-2113649489.jpg',
      'checkOutTimeStamp': checkOutTimestamp.toString(),
      'email': 'employee@example.com',
      'name': 'Employee Name',
      'scedual': {'shifts': {'thu':' 9:00 AM 5:00 PM AbuDabi', 'fri':' 9:00 AM 5:00 PM AbuDabi', 'wed':' 9:00 AM 5:00 PM AbuDabi', 'tur': '9:00 AM 5:00 PM AbuDabi', 'mon': '9:00 AM 5:00 PM AbuDabi', 'sun': 'OFF', 'sat': '9:00 AM 5:00 PM AbuDabi'}, 'timestamp': '2023-06-21 13:21:00.521'},
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



  Future<Map<String, Duration>> calculateWorkingHours2(DateTime startDate, DateTime endDate) async {
    // Retrieve the attendance records from Firestore within the specified date range
    final CollectionReference attendanceCollection = FirebaseFirestore.instance.collection('attendance');
    final QuerySnapshot attendanceSnapshot = await attendanceCollection
        .where('checkInTimeStamp', isGreaterThanOrEqualTo:startDate.millisecondsSinceEpoch.toString())
        .where('checkInTimeStamp', isLessThanOrEqualTo: endDate.millisecondsSinceEpoch.toString())
        .get();

    // Map to store the total working hours for each employee
    final Map<String, Duration> workingHoursMap = {};

    // Calculate working hours for each attendance record
    for (final attendanceDoc in attendanceSnapshot.docs) {
      final attendanceData = attendanceDoc.data() as Map<String,dynamic>;
      final String eName = attendanceData['name'];
      final int checkInTimestamp = int.parse(attendanceData['checkInTimeStamp']);
      final int checkOutTimestamp = int.parse(attendanceData['checkOutTimeStamp']);

      final DateTime checkInDateTime = DateTime.fromMillisecondsSinceEpoch(checkInTimestamp);
      final DateTime checkOutDateTime = DateTime.fromMillisecondsSinceEpoch(checkOutTimestamp);

      final Duration workingHours = checkOutDateTime.difference(checkInDateTime);

      if (workingHoursMap.containsKey(eName)) {
        workingHoursMap[eName] = (workingHoursMap[eName] ?? Duration()) + workingHours;
      } else {
        workingHoursMap[eName] = workingHours;
      }
    }

    Map<String,Duration> res = {}  ;

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
    return res ;
  }




/////////////////////////// test aria ///////////////////////////////////////////////////////////////////////////////////////////////



}
