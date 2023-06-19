import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hrms/models/Dialog.dart';
import 'package:hrms/widgets/flutterMap.dart';
import 'package:intl/intl.dart';
import '../models/gloablVar.dart';
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
    Map<String, dynamic> i = {
      'name': 'ayman',
      'checkInPhoto': 'https://f4.bcbits.com/img/0023005329_10.jpg',
      'checkOutPhoto':
          'https://yt3.googleusercontent.com/ytc/AGIKgqPs2_byeqx3sMDj4KbZvkboIjUbq142qFv_fzcA6g=s900-c-k-c0x00ffffff-no-rj',
      'checkInTimeStamp': '2023-06-18',
      'checkOutTimeStamp': '2023-06-20',
      'checkOutIsHeIn': 'true',
      'checkInIsHeIn': 'true',
      'checkInLong': '54.5989221',
      'checkInLat': '24.2761789',
      'checkOutLong': '54.5989221',
      'checkOutLat': '24.2761789',
      'BranshName': ''
    };

    return Scaffold(
      body: /*attendincePopUpEditWindows(
      item: i,
    )*/

          Stack(
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
                          Map<String, dynamic> shift =
                              modifySchedule(e['scedual']['shifts']);
                          //from checkInTimeStamp attribute we will extract the current date and we will pass it for the map above
                          // to get the current shedual
                          int milliseconds = int.parse(e['checkInTimeStamp']);
                          DateTime date =
                              DateTime.fromMillisecondsSinceEpoch(milliseconds);
                          String currentDayOfWeek =
                              DateFormat('EEEE').format(date);
                          return DataRow2(
                            onTap: () async {
                              await showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  backgroundColor: Colors.transparent,
                                  content: attendincePopUpEditWindows(item: e),
                                ),
                              );
                            },
                            //  onSelectChanged: (s) {},
                            cells: [
                              DataCell(Text(e['name'] ?? 'notFound404')),
                              DataCell(Text(
                                  shift[currentDayOfWeek] ?? 'notFound404')),
                              DataCell(Center(
                                  child: Text(convertTimestampToTime(
                                          e['checkInTimeStamp']) ??
                                      ''))),
                              DataCell(Center(
                                  child: e['checkOutTimeStamp'] == ''
                                      ? Text('---')
                                      : Text(convertTimestampToTime(
                                          e['checkOutTimeStamp'])))),
                              DataCell(
                                Center(
                                  child: Text('present'),
                                ),
                              ),
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

class attendincePopUpEditWindows extends StatefulWidget {
  final Map<String, dynamic> item;

  const attendincePopUpEditWindows({
    super.key,
    required this.item,
  });

  @override
  State<attendincePopUpEditWindows> createState() =>
      _attendincePopUpEditWindowsState();
}

class _attendincePopUpEditWindowsState
    extends State<attendincePopUpEditWindows> {
  bool isLoding = false ;
  @override
  Widget build(BuildContext context) {
    final double h = 10;
    return Container(
      width: 700,
      height: 600,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                gradient: LinearGradient(colors: [
                  Color.fromRGBO(90, 137, 214, 1),
                  Color.fromRGBO(95, 167, 210, 1),
                  Color.fromRGBO(49, 162, 202, 1)
                ])),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              color: Colors.grey.shade200.withOpacity(0.25),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 20, left: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.item['name'].toString(),
                    style: global.txtStyle1,
                  ),
                  SizedBox(
                    height: h,
                  ),
                  Text(
                    'Check in detals',
                    style: global.txtStyle1,
                  ),
                  SizedBox(
                    height: h,
                  ),
                  // cehckOut UI part
                  Container(
                    padding: EdgeInsets.only(left: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              NetworkImage(widget.item['checkInPhoto']),
                          radius: 50,
                        ),
                        SizedBox(
                          width: h,
                        ),
                        Expanded(
                          child: Text(
                            timeStampToDate(widget.item['checkInTimeStamp']) ??
                                '404 notfound',
                            style: global.txtStyle1,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        //Check in UI Part
                        Column(
                          children: [
                            widget.item['checkInIsHeIn'] == 'true'
                                ? Text(
                                    'Inside',
                                    style: global.txtStyle1,
                                  )
                                : Text(
                                    'Outside',
                                    style: global.txtStyle1,
                                  ),
                            Container(
                                clipBehavior: Clip.antiAlias,
                                width: 300,
                                height: 150,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30)),
                                child: flutterMap(
                                    centerLang: '54.5988998',
                                    centerLat: '24.2762571',
                                    p2Lang: widget.item['checkInLong'],
                                    p2Lat: widget.item['checkInLat'])),
                          ],
                        ),
                        SizedBox(
                          width: 10,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: h,
                  ),
                  // Check out parts///////////////////////////////////////////////////////////////////////////////////////////////////
                  Text(
                    'Check Out detals',
                    style: global.txtStyle1,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        widget.item['checkOutPhoto'] == null ||
                                widget.item['checkOutPhoto'] == ''
                            ? Text(
                                '----',
                                style: global.txtStyle1,
                              )
                            : CircleAvatar(
                                backgroundImage:
                                    NetworkImage(widget.item['checkOutPhoto']),
                                radius: 50,
                              ),
                        SizedBox(
                          width: 10,
                        ),
                        widget.item['checkOutTimeStamp'] == null ||
                                widget.item['checkOutTimeStamp'] == ''
                            ? Text(
                                '----',
                                style: global.txtStyle1,
                              )
                            : Expanded(
                                child: Text(
                                timeStampToDate(
                                    widget.item['checkOutTimeStamp']),
                                // widget.item['checkOutTimeStamp'],
                                style: global.txtStyle1,
                              )),
                        SizedBox(
                          width: 20,
                        ),
                        widget.item['checkOutLat'] == null
                            ? Text(
                                '-----',
                                style: global.txtStyle1,
                              )
                            : Column(
                                children: [
                                  widget.item['checkOutIsHeIn'] == 'true'
                                      ? Text(
                                          'Inside',
                                          style: global.txtStyle1,
                                        )
                                      : Text(
                                          'Outside',
                                          style: global.txtStyle1,
                                        ),
                                  widget.item['checkOutLong'] == '' ||
                                          widget.item['checkOutLong'] == null
                                      ? Text(
                                          '----',
                                          style: global.txtStyle1,
                                        )
                                      : Container(
                                          clipBehavior: Clip.antiAlias,
                                          width: 300,
                                          height: 150,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                          child: flutterMap(
                                              centerLang: '54.5988998',
                                              centerLat: '24.2762571',
                                              p2Lang:
                                                  widget.item['checkOutLong'],
                                              p2Lat:
                                                  widget.item['checkOutLat'])),
                                ],
                              ),
                        SizedBox(
                          width: 10,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Center(
                    child:isLoding == true ? CircularProgressIndicator() :
                    GestureDetector(
                      onTap: () async {
                        try {
                          isLoding = true ;
                          setState(() {});
                          final FirebaseFirestore firestore = FirebaseFirestore.instance;
                          final DocumentReference docRef = firestore.collection('attendance').doc(widget.item['documentId']);
                          await docRef.delete();
                          MyDialog.showAlert(context, 'This record deleted sucsefully');
                          Future.delayed(Duration(seconds: 3));
                          isLoding = false  ;
                          setState(() {});
                          Navigator.pop(context);
                          Navigator.pop(context);
                        } catch (e) {
                          MyDialog.showAlert(context, 'error $e');
                          print('Error deleting document: $e');
                        }

                      },
                      child: Container(
                        width: 100,
                        height: 40,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(30)),
                        child: Center(
                            child: Text(
                          'Delete',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  String timeStampToDate(String date) {
    DateTime dt = DateTime.fromMillisecondsSinceEpoch(int.parse(date));
    String result =
        DateFormat('dd/MM/yyyy\nHH:mm:ss', 'en_US').format(dt).toString();
    return result;
  }
}
