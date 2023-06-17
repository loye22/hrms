import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/rightBar.dart';
import '../widgets/sideBar.dart';

class attendanceScreen extends StatefulWidget {
  static const routeName = '/attendinceScreen';

  const attendanceScreen({Key? key}) : super(key: key);

  @override
  State<attendanceScreen> createState() => _attendanceScreenState();
}

class _attendanceScreenState extends State<attendanceScreen> {
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
          sideBar(
            index: 4,
          ),
          rightBar(),
          Positioned(
              left: 280,
              bottom: 15,
              child: Container(
                width: MediaQuery.of(context).size.width - 650,
                height: MediaQuery.of(context).size.height - 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: Colors.white.withOpacity(0.13)),
                  color: Colors.grey.shade200.withOpacity(0.23),
                ),
                child: FutureBuilder(
                  future: fetchAttendanceData(),
                  builder: (ctx, snapShot) {
                    if (snapShot.hasError) {
                      return Center(child: Text('Error : ${snapShot.error}'));
                    }
                    if (snapShot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return DataTable2(
                        columns: [
                          DataColumn(
                            label: Text('Name'),
                          ),
                          DataColumn(
                            label: Center(child: Text('Schedule')),
                          ),
                          DataColumn(
                            label: Center(child: Text('Check in')),
                          ),
                          DataColumn(
                            label: Center(child: Text('Check out')),
                          ),
                          DataColumn(
                            label: Center(child: Text('Status')),
                          ),
                        ],
                        rows: snapShot.data!.map((e) {
                          // get the current shift shecdual
                          Map<String, dynamic> shift = modifySchedule(e['scedual']['shifts']);
                          //from checkInTimeStamp attribute we will extract the current date and we will pass it for the map above
                          // to get the current shedual
                          int milliseconds = int.parse(e['checkInTimeStamp']);
                          DateTime date = DateTime.fromMillisecondsSinceEpoch(milliseconds);
                          String currentDayOfWeek = DateFormat('EEEE').format(date);

                          return DataRow2(
                            onTap: () {},
                            //  onSelectChanged: (s) {},
                            cells: [
                              DataCell(Text(e['name'] ?? 'notFound404')),
                              DataCell(Text(shift[currentDayOfWeek] ?? 'notFound404')),
                              DataCell(Center(child: Text(convertTimestampToTime(e['checkInTimeStamp']) ?? ''))),
                              DataCell(Center(child:e['checkOutTimeStamp'] == '' ?   Text('---')  : Text( convertTimestampToTime(e['checkOutTimeStamp']))    )),
                              DataCell(Center(child: Text('present'))),
                            ],
                          );
                        }).toList(),
                      );
                    }
                  },
                ),
              ))
        ],
      ),
    );
  }

  Future<List<Map<String, dynamic>>> fetchAttendanceData() async {
    List<Map<String, dynamic>> attendanceList = [];

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('attendance')
          .orderBy('checkInTimeStamp', descending: true)
          .get();

      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> attendanceData =
            doc.data() as Map<String, dynamic>;
        attendanceData['documentId'] = doc.id;
        attendanceList.add(attendanceData);
      });
      return attendanceList;
    } catch (error) {
      print('Error retrieving attendance data: $error');
      return [];
    }
  }

  String getDayName(String day) {
    switch (day) {
      case 'mon':
        return 'Monday';
      case 'tur':
        return 'Tuesday';
      case 'wed':
        return 'Wednesday';
      case 'thu':
        return 'Thursday';
      case 'fri':
        return 'Friday';
      case 'sat':
        return 'Saturday';
      case 'sun':
        return 'Sunday';
      default:
        return '';
    }
  }

  Map<String, String> modifySchedule(Map<String, dynamic> originalSchedule) {
    Map<String, String> modifiedSchedule = {};

    originalSchedule.forEach((day, value) {
      String modifiedDay = getDayName(day);
      modifiedSchedule[modifiedDay] = value;
    });
    return modifiedSchedule;
  }

  String convertTimestampToTime(String timestamp) {
    int milliseconds = int.parse(timestamp);
    DateTime date = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    String formattedTime = DateFormat('hh:mm a').format(date);
    return formattedTime;
  }
}
