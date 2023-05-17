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
              width: MediaQuery.of(context).size.width - 650,
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
              builder: (ctx, snapshot) => snapshot.connectionState ==
                      ConnectionState.waiting
                  ? Center(child: CircularProgressIndicator())
                  : Container(
                      width: MediaQuery.of(context).size.width - 650,
                      height: MediaQuery.of(context).size.height - 130,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border:
                            Border.all(color: Colors.white.withOpacity(0.13)),
                        color: Colors.grey.shade200.withOpacity(0.23),
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Container(
                          width: MediaQuery.of(context).size.width - 650,
                          height: MediaQuery.of(context).size.height - 150,
                          padding: EdgeInsets.all(12),
                          child: isLoading
                              ? Center(child: CircularProgressIndicator())
                              : DataTable(
                                  columnSpacing:
                                      MediaQuery.of(context).size.width - 650 <
                                              1000
                                          ? 110
                                          : 202,
                                  columns: [
                                    DataColumn(
                                      label: Text('Requist type'),
                                    ),
                                    DataColumn(
                                      label: Text('Requisted by'),
                                    ),
                                    DataColumn(
                                      label: Text('date'),
                                    ),
                                    DataColumn(
                                      label: Text('Options'),
                                    ),
                                  ],
                                  rows: widget.dataTable
                                      .map((e) => DataRow(cells: [
                                            DataCell(Text(widget.reqNameMap[e['title']] ?? '404 not found!')),
                                            DataCell(Text(widget.empNamesMap[e['eId']] ?? '404 not found!')),
                                            DataCell(Text(DateFormat('yyyy-MM-dd').format(e['date'].toDate().toLocal()))),
                                            DataCell(Row(

                                              children: [
                                                ElevatedButton(
                                                  onPressed: (){},
                                                  style: ElevatedButton.styleFrom(primary: Colors.green),
                                                  child: Text('Approve'),
                                                ),
                                                SizedBox(width: 16.0),
                                                ElevatedButton(
                                                  onPressed: (){



                                                    User? user = FirebaseAuth.instance.currentUser;
                                                    // sort the flow
                                                    List<String> sortedKeys = e['flow'].keys.toList()..sort();
                                                    Map<String, dynamic> sortedMap = {};
                                                    for (var key in sortedKeys) {
                                                      sortedMap[key] = e['flow'][key];
                                                    }

                                                    // flag variables
                                                    bool notMyTurn = false;
                                                    bool alreadyAccepted = false;

                                                    sortedMap.forEach((outerKey, innerMap) {
                                                      innerMap.forEach((innerKey, innerValue) {
                                                        if (innerKey != user!.uid && !innerValue) {
                                                          notMyTurn = true;
                                                        } else if (innerKey == user!.uid && innerValue) {
                                                          alreadyAccepted = true;
                                                        }
                                                      });
                                                    });

                                                    if (notMyTurn) {
                                                      print('Not my turn / Pending');
                                                   //  return;
                                                    } else if (alreadyAccepted) {
                                                      print('You have already accepted this');
                                                    //  return;
                                                    } else {
                                                      // Display buttons and apply logic
                                                      print('Display buttons');
                                                    }







                                                  },
                                                  style: ElevatedButton.styleFrom(primary: Colors.red),
                                                  child: Text('Reject'),
                                                ),
                                              ],
                                            ))
                                          ]))
                                      .toList(),
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
      requestData.add(data);
    });
    return requestData;
  }




}
