import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hrms/models/staticVars.dart';
import 'package:hrms/models/yesNoDialog.dart';
import 'package:intl/intl.dart';
import '../models/Dialog.dart';
import '../widgets/rightBar.dart';
import '../widgets/sideBar.dart';
import 'dart:html' as html;

class workExpScreen extends StatefulWidget {
  static const routeName = '/workExpScreen';

  late Map<String, String> empNamesMap;
  late List<Map<String, dynamic>> dataTable;

  @override
  State<workExpScreen> createState() => _workExpScreenState();
}

class _workExpScreenState extends State<workExpScreen> {
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
            decoration: staticVars.tstiBackGround , /*BoxDecoration(
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
          rightBar(),
          /*Positioned(
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
                  'Work Expensive Management Screen',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ),*/
          Positioned(
            left: 280,
            bottom: 15,
            child: Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width - 650,
                height: MediaQuery
                    .of(context)
                    .size
                    .height - 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  border:
                  Border.all(color: Colors.black.withOpacity(0.33)),
                  color: Colors.grey.shade200.withOpacity(0.23),
                ) ,
              child: FutureBuilder(
                future: initt(),
                // Replace with your function to load workflow data
                builder: (ctx, snapshot) =>
                snapshot.connectionState ==
                    ConnectionState.waiting
                    ? Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
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
                            : DataTable2(
                          columnSpacing:
                          MediaQuery
                              .of(context)
                              .size
                              .width - 650 <
                              1000
                              ? 5
                              : 202,

                          columns: [
                            DataColumn(
                              label: Text('Title'),
                            ), DataColumn(
                              label: Text('Amount'),
                            ),
                            DataColumn(
                              label: Text('Requisted by'),
                            ),
                            DataColumn(
                              label: Text('Requisted date'),
                            ),
                            DataColumn(
                              label: Text('Options'),
                            ),
                          ],
                          rows: widget.dataTable.map((e) {
                            return DataRow2(
                                onTap: () {
                                  try {
                                    html.window.open(e['docUrl'], 'new tab');
                                  }
                                  catch (e) {
                                    print('error $e');
                                  }
                                },
                                cells: [
                                  DataCell(Text(
                                      e['title'] ??
                                          '404 not found!')), DataCell(Text(
                                      e['amount'] ??
                                          '404 not found!')),
                                  DataCell(Text(
                                      widget.empNamesMap[e['eid']] ??
                                          '404 not found!')),
                                  DataCell(
                                    Text(
                                      timestampToDate(e['date']).toString(),
                                    ),
                                  ),
                                  e['finalStatus'] == null ? DataCell(
                                    AcceptRejectButtonRow(
                                        onAcceptPressed: () {
                                          MyAlertDialog.showConfirmationDialog(
                                              context,
                                              "Are you certain that you wish to proceed with accepting this payment?",
                                                  () async {
                                                await addFinalStatusToWorkExperience(e['docId'] ,'accepted');
                                              }, () {});
                                        },
                                        onRejectPressed: () {
                                          MyAlertDialog.showConfirmationDialog(
                                              context,
                                              "Are you certain that you wish to reject with accepting this payment?",
                                                  () async {
                                                await addFinalStatusToWorkExperience(e['docId'] ,'reject');
                                              }, () {});
                                        }),
                                    ) : DataCell(Text(e['finalStatus'] )),
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
              index: 5,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> initt() async {
    try {
      widget.empNamesMap = await getEmployeeNames();
      widget.dataTable = await getAllRequests();
    } catch (e) {}
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
    QuerySnapshot requestSnapshot = await FirebaseFirestore.instance
        .collection('workExp')
        .orderBy('date', descending: true)
        .get();

    // Iterate through the documents and store the data
    requestSnapshot.docs.forEach((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['docId'] = doc.id;
      requestData.add(data);
    });
    return requestData;
  }

  String timestampToDate(String timestampString) {
    int timestamp = int.parse(timestampString);
    DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm');
    dateFormat.format(DateTime.fromMillisecondsSinceEpoch(timestamp));
    return dateFormat.format(DateTime.fromMillisecondsSinceEpoch(timestamp));
  }


  Future<void> addFinalStatusToWorkExperience(String documentId , String status) async {
   try{
     // Reference to the document in the 'workExp' collection
     DocumentReference docRef = FirebaseFirestore.instance.collection('workExp').doc(documentId);

     // Update the document with the 'finalStatus' attribute
     await docRef.update({
       'finalStatus': status,
     });

     print('Final status added successfully to the document.');
     MyDialog.showAlert(context, 'Final status added successfully to the document.');
     setState(() {});
   }
   catch(e){
     MyDialog.showAlert(context, 'Error $e');
     print('error $e');
   }
  }


}


class AcceptRejectButtonRow extends StatelessWidget {
  final VoidCallback onAcceptPressed;
  final VoidCallback onRejectPressed;

  AcceptRejectButtonRow(
      {required this.onAcceptPressed, required this.onRejectPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: onAcceptPressed,
          style: ElevatedButton.styleFrom(
            primary: Colors.green,
            onPrimary: Colors.white,
          ),
          child: Text('Accept'),
        ),
        ElevatedButton(
          onPressed: onRejectPressed,
          style: ElevatedButton.styleFrom(
            primary: Colors.red,
            onPrimary: Colors.white,
          ),
          child: Text('Reject'),
        ),
      ],
    );
  }
}

