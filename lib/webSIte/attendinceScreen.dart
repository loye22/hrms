import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hrms/models/Dialog.dart';
import 'package:hrms/models/staticVars.dart';
import 'package:hrms/widgets/flutterMap.dart';
import 'package:hrms/widgets/iconWiget.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/gloablVar.dart';
import '../widgets/button.dart';
import '../widgets/rightBar.dart';
import '../widgets/sideBar.dart';
import 'package:intl/intl.dart';

class attendanceScreen extends StatefulWidget {
  static const routeName = '/attendinceScreen';

  const attendanceScreen({Key? key}) : super(key: key);

  @override
  State<attendanceScreen> createState() => _attendanceScreenState();
}

class _attendanceScreenState extends State<attendanceScreen> {
  Map<String, Map<String, String>> branshLocaions = {};
  List<Map<String, dynamic>> emplyeeDataForFilter = [];
  List<Map<String, dynamic>> globalAttendanceList = [];

  bool isLoading = false;
  bool reportFlag = false;
  bool filterFlag = false;
  bool absenceFlag = false;

  // this range for calculate the working hours
  DateTime selectedStartDate = DateTime.now();
  DateTime selectedEndDate = DateTime.now();

  // this for date filter
  DateTime filterStartDate = DateTime.now();
  DateTime filterEndDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    double globalWidth = MediaQuery.of(context).size.width < 1920 ? 175 : 210;
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: staticVars.tstiBackGround,
            /*BoxDecoration(
                color: Colors.red,
                gradient: LinearGradient(colors: [
                  Color.fromRGBO(90, 137, 214, 1),
                  Color.fromRGBO(95, 167, 210, 1),
                  Color.fromRGBO(49, 162, 202, 1)
                ])),*/
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
              top: 15,
              child: Container(
                height: MediaQuery.of(context).size.height - 950 > 0
                    ? MediaQuery.of(context).size.height - 950
                    : 60,
                width: MediaQuery.of(context).size.width - 650 > 0
                    ? MediaQuery.of(context).size.width - 650
                    : 500,
                child: MediaQuery.of(context).size.width <= 1400
                    ? Container()
                    : Row(
                        children: [
                          Container(
                            width: globalWidth,
                            padding: const EdgeInsets.only(right: 10),
                            child: Button(
                              icon: Icons.keyboard_backspace,
                              txt: 'Back',
                              isSelected: false,
                              onPress: () {
                                this.reportFlag = false;
                                this.filterFlag = false;
                                this.absenceFlag = false;
                                setState(() {});
                              },
                            ),
                          ),
                          Container(
                            width: globalWidth,
                            padding: const EdgeInsets.only(right: 10),
                            child: Button(
                              txt: 'Reports',
                              isSelected: false,
                              icon: Icons.report_gmailerrorred,
                              onPress: () {
                                try {
                                  reportFlag = true;
                                  setState(() {});
                                } catch (e) {
                                  MyDialog.showAlert(context, e.toString());
                                  print(e);
                                }
                              },
                            ),
                          ),
                          this.reportFlag
                              ? SizedBox.shrink()
                              : Container(
                                  width: globalWidth,
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Button(
                                    icon: Icons.filter_alt_outlined,
                                    txt: 'Filter By date ',
                                    isSelected: false,
                                    onPress: () async {
                                      if (this.filterFlag) {
                                        this.emplyeeDataForFilter =
                                            this.globalAttendanceList;
                                      }
                                      await _filterDateRange(context);
                                      filterAttendanceDataWithRange(
                                          fromDate: this.filterStartDate,
                                          toDate: this.filterEndDate,
                                          attendanceDataList:
                                              this.emplyeeDataForFilter);
                                      this.filterFlag = true;
                                      setState(() {});
                                    },
                                  ),
                                ),
                          this.reportFlag
                              ? SizedBox.shrink()
                              : Container(
                                  width: globalWidth,
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Button(
                                    icon: Icons.near_me_disabled,
                                    txt: 'Absence ',
                                    isSelected: false,
                                    onPress: () async {
                                      this.absenceFlag = true;
                                      setState(() {});
                                      //List <String?> s  = await  getAbsentEmployeesUid();
                                    },
                                  ),
                                ),
                          this.reportFlag
                              ? Row(
                                  children: [
                                    Container(
                                      width: globalWidth,
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Button(
                                        icon: Icons.date_range,
                                        txt:
                                            'From ${formatter.format(selectedStartDate)}',
                                        isSelected: false,
                                        onPress: () =>
                                            _selectStartDate(context),
                                      ),
                                    ),
                                    Container(
                                      width: globalWidth,
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Button(
                                        icon: Icons.date_range,
                                        txt:
                                            'To ${formatter.format(selectedEndDate)}',
                                        isSelected: false,
                                        onPress: () => _selectEndDate(context),
                                      ),
                                    ),
                                    Container(
                                      width: globalWidth,
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Button(
                                        icon: Icons.import_export,
                                        txt: 'Export',
                                        isSelected: false,
                                        onPress: () {},
                                      ),
                                    ),
                                  ],
                                )
                              : SizedBox.shrink(),
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
              )),
          Positioned(
            left: 280,
            bottom: 15,
            child: Container(
              width: MediaQuery.of(context).size.width - 650,
              height: MediaQuery.of(context).size.height - 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: Colors.white.withOpacity(0.13)),
                color: Colors.grey.shade200.withOpacity(0.23),
              ),
              // please note that the fetchAttendanceData() function call another function called getLocations();
              // to load the beanshes names with there locaions to be used in the popup window
              //so it will load the employee locaion with his bransh loacion
              // after that the fetchAttendanceData() function will load the attendince data from firebase .
              // we will handel the filter event using the filterFlag varuable
              child: this.absenceFlag
                  ? FutureBuilder(
                      future: getAbsentEmployeesUid(),
                      builder: (ctx, snapShot) {
                        if (snapShot.hasError) {
                          return Center(
                            child: Text('error ${snapShot.error}'),
                          );
                        }
                        if (snapShot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black.withOpacity(.33)) ,
                              borderRadius: BorderRadius.circular(30) ,
                              color: staticVars.c1
                            ),
                            child: Center(
                              child: DataTable2(
                                columns: [
                                  DataColumn(
                                    label: Center(child: Text('Name')),
                                  ),
                                  DataColumn(
                                    label: Center(child: Text('status')),
                                  ),
                                ],
                                rows: snapShot.data!
                                    .map((e) => DataRow2(cells: [
                                          DataCell(Center(
                                              child: Text(e.toString()))),
                                          DataCell(
                                              Center(child: Text('Absence')))
                                        ]))
                                    .toList(),
                              ),
                            ),
                          );
                        }
                      },
                    )
                  : (this.reportFlag
                      ? FutureBuilder(
                          future: calculateWorkingHours2(
                              selectedStartDate, selectedEndDate),
                          builder: (ctx, snapShot) {
                            if (snapShot.hasError) {
                              return Center(
                                child: Text(snapShot.error.toString()),
                              );
                            }
                            if (snapShot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              return Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black.withOpacity(.33)) ,
                                      borderRadius: BorderRadius.circular(30) ,
                                      color: staticVars.c1
                                  ),
                                child: DataTable2(
                                  columns: [
                                    DataColumn(
                                      label: Center(child: Text('Employee name')),
                                    ),
                                    DataColumn(
                                      label: Center(child: Text('Working hours')),
                                    ),
                                  ],
                                  rows: snapShot.data!.map((e) {
                                    return DataRow2(cells: [
                                      DataCell(Center(
                                          child: Text(
                                              e['eName'] ?? '404Notfounbd'))),
                                      DataCell(Center(
                                          child: Text(
                                              '${e['workingHours'].inHours} hours and ${e['workingHours'].inMinutes.remainder(60)} minutes' ??
                                                  '404Notfounbd')))
                                    ]);
                                  }).toList(),
                                ),
                              );
                            }
                          },
                        )
                      : (this.filterFlag
                          ? Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black.withOpacity(.33)) ,
                      borderRadius: BorderRadius.circular(30) ,
                      color: staticVars.c1
                  ),
                            child: DataTable2(
                                columns: [
                                  DataColumn(
                                    label: Text('Namex'),
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
                                rows: this.emplyeeDataForFilter.map((e) {
                                  // get the current shift shecdual
                                  Map<String, dynamic> shift =
                                      modifySchedule(e['scedual']['shifts']);

                                  //from checkInTimeStamp attribute we will extract the current date and we will pass it for the map above
                                  // to get the current shedual
                                  int milliseconds =
                                      int.parse(e['checkInTimeStamp']);
                                  DateTime date =
                                      DateTime.fromMillisecondsSinceEpoch(
                                          milliseconds);
                                  String currentDayOfWeek =
                                      DateFormat('EEEE').format(date);
                                  return DataRow2(
                                    onTap: () async {
                                      await showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                          backgroundColor: Colors.transparent,
                                          content: attendincePopUpEditWindows(
                                              item: e,
                                              bLoacions: this.branshLocaions),
                                        ),
                                      );
                                    },
                                    //  onSelectChanged: (s) {},
                                    cells: [
                                      DataCell(Text(e['name'] ?? 'notFound404')),
                                      DataCell(Text(shift[currentDayOfWeek] ??
                                          'notFound404')),
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
                              ),
                          )
                          : FutureBuilder(
                              future: fetchAttendanceData(),
                              builder: (ctx, snapShot) {
                                if (snapShot.hasError) {
                                  return Center(
                                      child: Text('Error : ${snapShot.error}'));
                                }
                                if (snapShot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else {
                                  return Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(color: Colors.black.withOpacity(.33)) ,
                                          borderRadius: BorderRadius.circular(30) ,
                                          color: staticVars.c1
                                      ),
                                    child: DataTable2(
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
                                        //   print('snapShot.data! ${snapShot.data!.length}');
                                        // get the current shift shecdual
                                        Map<String, dynamic> shift =
                                            modifySchedule(
                                                e['scedual']['shifts']);

                                        //from checkInTimeStamp attribute we will extract the current date and we will pass it for the map above
                                        // to get the current shedual
                                        int milliseconds =
                                            int.parse(e['checkInTimeStamp']);
                                        DateTime date =
                                            DateTime.fromMillisecondsSinceEpoch(
                                                milliseconds);
                                        String currentDayOfWeek =
                                            DateFormat('EEEE').format(date);
                                        return DataRow2(
                                          onTap: () async {
                                            await showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  AlertDialog(
                                                backgroundColor:
                                                    Colors.transparent,
                                                content:
                                                    attendincePopUpEditWindows(
                                                        item: e,
                                                        bLoacions:
                                                            this.branshLocaions),
                                              ),
                                            );
                                          },
                                          //  onSelectChanged: (s) {},
                                          cells: [
                                            DataCell(
                                                Text(e['name'] ?? 'notFound404' ,) ,),
                                            DataCell(Text(
                                                shift[currentDayOfWeek] ??
                                                    'notFound404')),
                                            DataCell(Center(
                                                child: Text(convertTimestampToTime(
                                                        e['checkInTimeStamp']) ??
                                                    ''))),
                                            DataCell(Center(
                                                child: e['checkOutTimeStamp'] ==
                                                        ''
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
                                    ),
                                  );
                                }
                              },
                            ))),
            ),
          )
        ],
      ),
    );
  }

  Future<List<String?>> getAbsentEmployeesUid() async {
    // this function will retrever the absence emplyee names using the folowing alogrithem
    // 1. get all the employee data and store them as Map<String,dunamic>
    // 2. get all the employees eid , and all the checked in emplyee for the current data  and substact them from each other
    //    the result will be all the absence emplyee

    // 1.
    final CollectionReference employeeCollection1 =
        FirebaseFirestore.instance.collection('Employee');
    QuerySnapshot employeeQuerySnapshot1 = await employeeCollection1.get();
    Map<String, String> employeeDataMap = {};

    for (QueryDocumentSnapshot employeeDoc in employeeQuerySnapshot1.docs) {
      String docId = employeeDoc.id;
      Map<String, dynamic> data = employeeDoc.data() as Map<String, dynamic>;
      employeeDataMap[docId] = data['userName'];
    }

    //2.
    final CollectionReference employeeCollection =
        FirebaseFirestore.instance.collection('Employee');
    final CollectionReference attendanceCollection =
        FirebaseFirestore.instance.collection('attendance');
    // Get current date
    DateTime currentDate = DateTime.now();

    // Retrieve all employee UIDs
    QuerySnapshot employeeQuerySnapshot = await employeeCollection.get();
    List<String> allEmployeeUids = employeeQuerySnapshot.docs
        .map((employeeDoc) => employeeDoc.id)
        .toList();

    // Retrieve employee UIDs for the current date from attendance
    QuerySnapshot attendanceQuerySnapshot = await attendanceCollection
        .where('checkInTimeStamp',
            isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime(
                    currentDate.year, currentDate.month, currentDate.day))
                .millisecondsSinceEpoch
                .toString())
        .get();
    List<String> presentEmployeeUids =
        attendanceQuerySnapshot.docs.map((attendanceDoc) {
      Map<String, dynamic> data = attendanceDoc.data() as Map<String, dynamic>;
      return data['uid'].toString();
    }).toList();
    //print(presentEmployeeUids);

    // Find absent employee UIDs by subtracting present UIDs from all UIDs
    List<String> absentEmployeeUids = allEmployeeUids
        .toSet()
        .difference(presentEmployeeUids.toSet())
        .toList();

    //print(absentEmployeeUids);
    return absentEmployeeUids.map((e) => employeeDataMap[e]).toList();
  }

  List<Map<String, dynamic>> filterAttendanceDataWithRange(
      {DateTime? fromDate,
      DateTime? toDate,
      required List<Map<String, dynamic>> attendanceDataList}) {
    List<Map<String, dynamic>> filteredData = attendanceDataList;

    if (fromDate != null && toDate != null) {
      filteredData = filteredData.where((entry) {
        int checkInTimeStamp = int.parse(entry["checkInTimeStamp"]);
        return DateTime.fromMillisecondsSinceEpoch(checkInTimeStamp)
                .isAfter(fromDate) &&
            DateTime.fromMillisecondsSinceEpoch(checkInTimeStamp)
                .isBefore(toDate.add(Duration(days: 1)));
      }).toList();
    }

    this.emplyeeDataForFilter = filteredData;
    return filteredData;
  }

  Future<void> _filterDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
        context: context,
        firstDate: DateTime(2020),
        lastDate: DateTime(2025),
        initialDateRange: DateTimeRange(
          start: filterStartDate ?? DateTime.now(),
          end: filterEndDate ?? DateTime.now(),
        ),
        builder: (context, child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light(primary: Colors.green),
              // Customize the color of the header
              buttonTheme: ButtonThemeData(
                  textTheme: ButtonTextTheme
                      .primary), // Customize the text style of buttons
              // Add any other customizations here...
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.9,
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: child,
                  ),
                ),
              ],
            ),
          );
        });

    if (picked != null && picked.start != null && picked.end != null) {
      filterStartDate = picked.start;
      filterEndDate = picked.end;
      // print('filterStartDate $filterStartDate');
      // print('filterEndDate $filterEndDate');
    }
  }

  Future<List<dynamic>> calculateWorkingHours2(
      DateTime startDate, DateTime endDate) async {
    // this function take date range and return the totall working hours for each employee

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

      // in the case we want to calc the working hours were some emplyee didnot check out yet
      // in this matter the checkout will be equat to checkin to avoid any format errors
      final int checkOutTimestamp = attendanceData['checkOutTimeStamp'] == ''
          ? int.parse(attendanceData['checkInTimeStamp'])
          : int.parse(attendanceData['checkOutTimeStamp']);

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

    List<dynamic> res = [];

    // Print the calculated working hours for each employee
    for (final entry in workingHoursMap.entries) {
      final String eName = entry.key;
      final Duration workingHours = entry.value ?? Duration();
      res.add({'eName': eName, 'workingHours': workingHours});
      // print('Employee UID: $uid');
      //print('Working Hours: ${workingHours.inHours} hours ${workingHours.inMinutes.remainder(60)} minutes');
      //print('---------------------');
    }
    // print(res);
    return res;
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? pickedStartDate = await showDatePicker(
      context: context,
      initialDate: selectedStartDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedStartDate != null && pickedStartDate != selectedStartDate) {
      setState(() {
        selectedStartDate = pickedStartDate;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? pickedEndDate = await showDatePicker(
      context: context,
      initialDate: selectedEndDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedEndDate != null && pickedEndDate != selectedEndDate) {
      setState(() {
        selectedEndDate = pickedEndDate;
      });
    }
  }

  Future<List<Map<String, dynamic>>> fetchAttendanceData() async {
    List<Map<String, dynamic>> attendanceList = [];
    try {
      await getLocations();
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

      this.emplyeeDataForFilter = attendanceList;
      this.globalAttendanceList = attendanceList;

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

  Future<void> getLocations() async {
    Map<String, Map<String, String>> locationMap = {};
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('locations').get();
    for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot
        in querySnapshot.docs) {
      String title = documentSnapshot.data()['title'];
      String latitude = documentSnapshot.data()['latitude'];
      String longitude = documentSnapshot.data()['longitude'];
      locationMap[title] = {
        'checkInLat': latitude,
        'checkInLong': longitude,
      };
    }

    this.branshLocaions = locationMap;
  }
}

class attendincePopUpEditWindows extends StatefulWidget {
  final Map<String, dynamic> item;
  final Map<String, dynamic> bLoacions;

  const attendincePopUpEditWindows(
      {super.key, required this.item, required this.bLoacions});

  @override
  State<attendincePopUpEditWindows> createState() =>
      _attendincePopUpEditWindowsState();
}

class _attendincePopUpEditWindowsState
    extends State<attendincePopUpEditWindows> {
  bool isLoding = false;
  String timeStamp = '';

  @override
  Widget build(BuildContext context) {
    final double h = 10;
    //  print(widget.bLoacions[widget.item['BranshName']]);
    return Container(
      width: 900,
      height: 600,
      child: Stack(
        children: [
          Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                image: DecorationImage(
                  image: AssetImage(
                      'assests/tstiBackGround.jpg'),
                  fit: BoxFit.fill,
                ),

              )
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
                    style:staticVars.textStyle2,
                  ),
                  SizedBox(
                    height: h,
                  ),
                  Row(
                    children: [
                      Text(
                        'Check in detals',
                        style:staticVars.textStyle2,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      IconButton(
                        onPressed: () async {
                          final TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (pickedTime != null) {
                            final int existingTimestamp =
                                int.parse(widget.item['checkInTimeStamp']);
                            final DateTime existingDateTime =
                                DateTime.fromMillisecondsSinceEpoch(
                                    existingTimestamp);
                            final DateTime updatedDateTime = DateTime(
                              existingDateTime.year,
                              existingDateTime.month,
                              existingDateTime.day,
                              pickedTime.hour,
                              pickedTime.minute,
                            );
                            final int updatedTimestamp =
                                updatedDateTime.millisecondsSinceEpoch;
                            try {
                              final CollectionReference attendanceCollection =
                                  FirebaseFirestore.instance
                                      .collection('attendance');
                              await attendanceCollection
                                  .doc(widget.item['documentId'])
                                  .update({
                                'checkInTimeStamp': updatedTimestamp.toString(),
                              });
                              MyDialog.showAlert(context,
                                  'Check in time updated successfully');
                            } catch (e) {
                              MyDialog.showAlert(context, 'Error: $e');
                            }
                          }
                          // print(timeStamp);
                        },
                        icon: Icon(
                          Icons.edit,
                          color: staticVars.c1 ,
                        ),
                      )
                    ],
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
                            style:staticVars.textStyle2,
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
                              style:staticVars.textStyle2,
                                  )
                                : Text(
                                    'Outside',
                              style:staticVars.textStyle2,
                                  ),
                            Container(
                                clipBehavior: Clip.antiAlias,
                                width: 300,
                                height: 150,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30)),
                                child: widget.bLoacions[
                                            widget.item['BranshName']] ==
                                        null
                                    ? Text('error404LocaionNotFound')
                                    : flutterMap(
                                        centerLang: widget.bLoacions[widget
                                            .item['BranshName']]['checkInLong'],
                                        centerLat: widget.bLoacions[widget
                                            .item['BranshName']]['checkInLat'],
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
                  Row(
                    children: [
                      Text(
                        'Check Out detals',
                        style:staticVars.textStyle2,
                      ),
                      IconButton(
                        onPressed: () async {
                          final TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (pickedTime != null) {
                            final int existingTimestamp =
                                int.parse(widget.item['checkOutTimeStamp']);
                            final DateTime existingDateTime =
                                DateTime.fromMillisecondsSinceEpoch(
                                    existingTimestamp);
                            final DateTime updatedDateTime = DateTime(
                              existingDateTime.year,
                              existingDateTime.month,
                              existingDateTime.day,
                              pickedTime.hour,
                              pickedTime.minute,
                            );
                            final int updatedTimestamp =
                                updatedDateTime.millisecondsSinceEpoch;
                            try {
                              final CollectionReference attendanceCollection =
                                  FirebaseFirestore.instance
                                      .collection('attendance');
                              await attendanceCollection
                                  .doc(widget.item['documentId'])
                                  .update({
                                'checkOutTimeStamp':
                                    updatedTimestamp.toString(),
                              });
                              MyDialog.showAlert(context,
                                  'Check out time updated successfully');
                            } catch (e) {
                              MyDialog.showAlert(context, 'Error: $e');
                            }
                          }
                          //   print(timeStamp);
                        },
                        icon: Icon(
                          Icons.edit,
                          color: staticVars.c1,
                        ),
                      )
                    ],
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
                          style:staticVars.textStyle2,
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
                          style:staticVars.textStyle2,
                              )
                            : Expanded(
                                child: Text(
                                timeStampToDate(
                                    widget.item['checkOutTimeStamp']),
                                // widget.item['checkOutTimeStamp'],
                                  style:staticVars.textStyle2,
                              )),
                        SizedBox(
                          width: 20,
                        ),
                        widget.item['checkOutLat'] == null
                            ? Text(
                                '-----',
                          style:staticVars.textStyle2,
                              )
                            : Column(
                                children: [
                                  widget.item['checkOutIsHeIn'] == 'true'
                                      ? Text(
                                          'Inside',
                                    style:staticVars.textStyle2,                                        )
                                      : Text(
                                          'Outside',
                                    style:staticVars.textStyle2,
                                        ),
                                  widget.item['checkOutLong'] == '' ||
                                          widget.item['checkOutLong'] == null
                                      ? Text(
                                          '----',
                                    style:staticVars.textStyle2,
                                        )
                                      : Container(
                                          clipBehavior: Clip.antiAlias,
                                          width: 300,
                                          height: 150,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                          child: flutterMap(
                                              centerLang: widget.bLoacions[
                                                      widget.item['BranshName']]
                                                  ['checkInLong'],
                                              centerLat: widget.bLoacions[
                                                      widget.item['BranshName']]
                                                  ['checkInLat'],
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
                    child: isLoding == true
                        ? CircularProgressIndicator()
                        : GestureDetector(
                            onTap: () async {
                              try {
                                isLoding = true;
                                setState(() {});
                                final FirebaseFirestore firestore =
                                    FirebaseFirestore.instance;
                                final DocumentReference docRef = firestore
                                    .collection('attendance')
                                    .doc(widget.item['documentId']);
                                await docRef.delete();
                                MyDialog.showAlert(
                                    context, 'This record deleted sucsefully');
                                Future.delayed(Duration(seconds: 3));
                                isLoding = false;
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
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )),
                            ),
                          ),
                  ),
                  SizedBox(
                    height: 10,
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
    String result = DateFormat('dd/MM/yyyy\nHH:mm').format(dt).toString();

    return result;
  }
}
