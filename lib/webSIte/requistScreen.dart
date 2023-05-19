import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hrms/models/yesNoDialog.dart';
import 'package:intl/intl.dart';
import '../models/Dialog.dart';
import '../widgets/rightBar.dart';
import '../widgets/sideBar.dart';

class requistScreen extends StatefulWidget {
  static const routeName = '/requistScreen';
  late Map<String, String> reqNameMap;
  late Map<String, String> empNamesMap;
  late List<Map<String, dynamic>> dataTable;
  late List<String> TimeOffTitlesList;

  @override
  State<requistScreen> createState() => _requistScreenState();
}

class _requistScreenState extends State<requistScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    // print(MediaQuery.of(context).size.width - 650);
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
              width: MediaQuery
                  .of(context)
                  .size
                  .width - 650,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: Colors.white.withOpacity(0.13)),
                color: Colors.grey.shade200.withOpacity(0.23),
              ),
              child: Center(
                child: Text(
                  'Work flow manege screen ',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ),
          Positioned(
            left: 280,
            bottom: 15,
            child: FutureBuilder(
              future: initt(),
              // Replace with your function to load workflow data
              builder: (ctx, snapshot) =>
              snapshot.connectionState ==
                  ConnectionState.waiting
                  ? Center(child: CircularProgressIndicator())
                  : Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width - 650,
                height: MediaQuery
                    .of(context)
                    .size
                    .height - 130,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  border:
                  Border.all(color: Colors.white.withOpacity(0.13)),
                  color: Colors.grey.shade200.withOpacity(0.23),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width - 650,
                    height: MediaQuery
                        .of(context)
                        .size
                        .height - 150,
                    padding: EdgeInsets.all(12),
                    child: isLoading
                        ? Center(child: CircularProgressIndicator())
                        : DataTable(
                      columnSpacing:
                      MediaQuery
                          .of(context)
                          .size
                          .width - 650 <
                          1000
                          ? 110
                          : 202,
                      columns: [
                        DataColumn(
                          label: Text('Requist type'),
                        ),
                        DataColumn(
                          label: Expanded(child: Text('Requisted by')),
                        ),
                        DataColumn(
                          label: Expanded(child: Text('Requisted date')),
                        ),
                        DataColumn(
                          label: Text('Options'),
                        ),
                      ],
                      rows: widget.dataTable
                          .map((e) {
                        bool reqFlag = false;
                        User? user = FirebaseAuth.instance.currentUser;
                        // sort the flow
                        List<String> sortedKeys = e['flow'].keys.toList()
                          ..sort();
                        Map<String, dynamic> sortedMap = {};
                        for (var key in sortedKeys) {
                          sortedMap[key] = e['flow'][key];
                        }
                        if (sortedMap.values
                            .toList()
                            .length > 0 &&
                            sortedMap.values.toList()[0] == user!.uid) {
                          // display the requists
                          reqFlag = true;
                          //print(reqFlag);
                        }
                        return DataRow(cells: [
                          DataCell(Text(widget.reqNameMap[e['title']] ??
                              '404 not found!')),
                          DataCell(Text(widget.empNamesMap[e['eId']] ??
                              '404 not found!')),
                          DataCell(Text(DateFormat('yyyy-MM-dd').format(
                              e['date'].toDate().toLocal()))),
                          DataCell(reqFlag ? Row(
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  // the last admin in the pipline
                                  if (e['flow'].length == 1) {
                                    try {

                                      //  print(widget.TimeOffTitlesList);
                                      //  print(widget.reqNameMap[e['title']]);
                                      if (widget.TimeOffTitlesList.contains(
                                          widget.reqNameMap[e['title']])) {
                                        print('sdasda');
                                        // this to handle the time off requsits
                                        // we check if time off tilte is exsist
                                        // we need to check if the employee has enght days
                                        Map<String, dynamic> timeOff = {};
                                        Map<String,
                                            dynamic> employeeTimeOffData = {};

                                        QuerySnapshot querySnapshot = await FirebaseFirestore
                                            .instance
                                            .collection('Employee')
                                            .doc(e['eId'])
                                            .collection('TimeOff')
                                            .where('title', isEqualTo: widget
                                            .reqNameMap[e['title']])
                                            .get();

                                        String timeOffDocId = '';
                                        querySnapshot.docs.forEach((doc) {
                                          Map<String, dynamic> data = doc
                                              .data() as Map<String, dynamic>;
                                          timeOffDocId = doc.id;
                                          employeeTimeOffData = data;
                                        });

                                        int d = int.parse(employeeTimeOffData['duration']);
                                        int c = int.parse(employeeTimeOffData['consume']);
                                        int r = int.parse(e['ReqistedDays']);
                                        print(d - (c+r) );
                                        if (d - (c+r) >= 0 ){
                                          // the emplyee has enght days to precess
                                          // we update consume value where the new value is and change the status to accepted
                                          // consume = c + r toString.....
                                          // Get a reference to the employee document
                                          print(d - (c+r)  );
                                          print(timeOffDocId + "<<<");
                                          final DocumentReference employeeRef =
                                          FirebaseFirestore.instance.collection('Employee').doc(e['eId']);
                                          // Get a reference to the time-off document within the employee document
                                          final DocumentReference timeOffRef =
                                          employeeRef.collection('TimeOff').doc(timeOffDocId);
                                          // Update the consume attribute
                                          timeOffRef.update({
                                            'consume': (c+r).toString() // Replace 'new_consume_value' with the desired value
                                          }).then((_) {
                                            MyDialog.showAlert(context, 'Consume attribute updated successfully.');
                                            print('Consume attribute updated successfully.');
                                          }).catchError((error) {MyDialog.showAlert(context, 'Failed to update consume attribute: $error');print('Failed to update consume attribute: $error');});


                                          //change the requist statuse
                                          FirebaseFirestore.instance.collection(
                                              'requests').doc(e['docId']).update({
                                            'status': 'Accepted',
                                            'flow': {}
                                          }).then((value) {
                                            MyDialog.showAlert(context,
                                                'Status updated successfully.');
                                            print('Status updated successfully.');
                                          }).catchError((error) {
                                            MyDialog.showAlert(context,
                                                'Failed to update status: $error');
                                            print('Failed to update status: $error');
                                          });
                                          setState(() {});


                                        }
                                        else {
                                          // no enght days
                                          MyDialog.showAlert(context, "The employee has requested or exceeded their allotted number of days");
                                          return;
                                        }
                                      }
                                      else {
                                        // handing the non time off requists
                                        await FirebaseFirestore.instance.collection(
                                            'requests').doc(e['docId']).update({
                                          'status': 'Accepted',
                                          'flow': {}
                                        }).then((value) {
                                          MyDialog.showAlert(context,
                                              'Status updated successfully.');
                                          print('Status updated successfully.');
                                        }).catchError((error) {
                                          MyDialog.showAlert(context,
                                              'Failed to update status: $error');
                                          print('Failed to update status: $error');
                                        });
                                        setState(() {});
                                        return;
                                      }
                                    }

                                    catch (e) {
                                      print(e);
                                      MyDialog.showAlert(context,'Please make sure that this the holaday assinged to this emplyee \n' + e.toString());
                                    }

                                    return;

                                    // here we are handing the pip line it self
                                    // in case if the admin approved will go to nex admin
                                    e['flow'].removeWhere((key,
                                        value) => value == user!.uid);
                                    String documentId = e['docId']; // Assuming this is the document ID where the data is stored
                                    FirebaseFirestore.instance.collection(
                                        'requests').doc(documentId).update({
                                      'flow': e['flow'],
                                      'status': 'pending'
                                    }).then((value) {
                                      MyDialog.showAlert(context,
                                          'Status updated successfully.');
                                      print('Status updated successfully.');
                                    }).catchError((error) {
                                      MyDialog.showAlert(context,
                                          'Failed to update status: $error');
                                      print('Failed to update status: $error');
                                    });
                                    return;
                                  }



                                  // passing the requist to hte next admin
                                  e['flow'].removeWhere((key, value) =>
                                  value == user!.uid);
                                  String documentId = e['docId']; // Assuming this is the document ID where the data is stored
                                  FirebaseFirestore.instance.collection(
                                      'requests').doc(documentId).update({
                                    'flow': e['flow']
                                  }).then((value) {
                                    MyDialog.showAlert(context,
                                        'Status updated successfully.');
                                    print('Status updated successfully.');
                                  }).catchError((error) {
                                    MyDialog.showAlert(context,
                                        'Failed to update status: $error');
                                    print('Failed to update status: $error');
                                  });

                                  setState(() {});
                                },
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.green),
                                child: Text('Approve'),
                              ),
                              SizedBox(width: 16.0),
                              ElevatedButton(
                                onPressed: () {
                                  String documentId = e['docId']; // Assuming this is the document ID where the data is stored
                                  FirebaseFirestore.instance.collection(
                                      'requests').doc(documentId).update({
                                    'status': 'reject',
                                    'flow': {}
                                  }).then((value) {
                                    MyDialog.showAlert(context,
                                        'Status updated successfully.');
                                    print('Status updated successfully.');
                                  }).catchError((error) {
                                    MyDialog.showAlert(context,
                                        'Failed to update status: $error');
                                    print('Failed to update status: $error');
                                  });
                                  setState(() {});
                                },
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.red),
                                child: Text('Reject'),
                              ),
                            ],
                          ) : (Text(e['status'] != 'pending'
                              ? e['status']
                              : 'pending')))
                        ]);
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            child: sideBar(
              index: 2,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> initt() async {
    try {
      widget.reqNameMap = await getWorkflowTitles();
      widget.empNamesMap = await getEmployeeNames();
      widget.dataTable = await getAllRequests();
      widget.TimeOffTitlesList = await getTimeOffTitles();
    } catch (e) {}
  }

  Future<Map<String, String>> getWorkflowTitles() async {
    Map<String, String> workflowTitles = {};

    // Retrieve the documents from the "workflow" collection
    QuerySnapshot workflowSnapshot =
    await FirebaseFirestore.instance.collection('workflow').get();

    // Iterate through the documents and extract the document ID and title
    workflowSnapshot.docs.forEach((doc) {
      String docId = doc.id;
      String title = (doc.data() as Map<String, dynamic>)['title'] ?? '';

      workflowTitles[docId] = title;
    });
    // print(workflowTitles);

    return workflowTitles;
  }

  Future<Map<String, String>> getEmployeeNames() async {
    Map<String, String> employeeNames = {};

    // Retrieve the documents from the "Employee" collection
    QuerySnapshot employeeSnapshot =
    await FirebaseFirestore.instance.collection('Employee').get();

    // Iterate through the documents and extract the document ID and name
    employeeSnapshot.docs.forEach((doc) {
      String docId = doc.id;
      String name = (doc.data() as Map<String, dynamic>)['userName'] ?? '';

      employeeNames[docId] = name;
    });

    //  print(employeeNames);
    return employeeNames;
  }

  Future<List<Map<String, dynamic>>> getAllRequests() async {
    List<Map<String, dynamic>> requestData = [];

    // Retrieve the documents from the "requests" collection
    QuerySnapshot requestSnapshot =
    await FirebaseFirestore.instance.collection('requests').get();

    // Iterate through the documents and store the data
    requestSnapshot.docs.forEach((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['docId'] = doc.id;
      requestData.add(data);
    });
    return requestData;
  }

  Future<List<String>> getTimeOffTitles() async {
    List<String> dataList = [];

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('timeOff')
        .get();

    querySnapshot.docs.forEach((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      dataList.add(data['title']);
    });
    return dataList;
  }


}
