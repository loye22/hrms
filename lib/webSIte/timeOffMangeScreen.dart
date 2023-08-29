import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hrms/models/staticVars.dart';

import '../models/Dialog.dart';
import '../widgets/rightBar.dart';
import '../widgets/sideBar.dart';

class timeOffMangeScreen extends StatefulWidget {
  static const routeName = '/timeOffMangeScreen';

  const timeOffMangeScreen({Key? key}) : super(key: key);

  @override
  State<timeOffMangeScreen> createState() => _timeOffMangeScreenState();
}

class _timeOffMangeScreenState extends State<timeOffMangeScreen> {
  bool isLOading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration:  staticVars.tstiBackGround , /*BoxDecoration(
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
              width: MediaQuery.of(context).size.width - 650,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: Colors.white.withOpacity(0.13)),
                color: Colors.grey.shade200.withOpacity(0.23),
              ),
              child: Center(
                child: Text(
                  'Time off manege screen ',
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
                ),
              child: FutureBuilder(
                future: this.loadTimeOffData(),
                builder: (ctx, response) => response.connectionState ==
                        ConnectionState.waiting
                    ? Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Container(
                        width: MediaQuery.of(context).size.width - 650,
                        height: MediaQuery.of(context).size.height - 30,
                        padding: EdgeInsets.all(12),
                        child: isLOading
                            ? Center(child: CircularProgressIndicator())
                            : DataTable2(
                                columnSpacing: 12,
                                horizontalMargin: 12,
                                minWidth: 600,
                                columns: [
                                  DataColumn2(
                                    label: Text('Title'),
                                    size: ColumnSize.L,
                                  ),
                                  DataColumn2(
                                    label: Text('Duration'),
                                    size: ColumnSize.L,
                                  ),
                                  DataColumn2(
                                    label: Text('More Options'),
                                    size: ColumnSize.S,
                                  ),
                                ],
                                rows: response.data!.map((item) {
                                  return DataRow2(
                                    //  onSelectChanged: (s) {},
                                    cells: [
                                      DataCell(Text(item['title'] ?? '')),
                                      DataCell(Text(item['duration'] ?? '')),
                                      DataCell(
                                        Row(
                                          children: [
                                            IconButton(
                                              onPressed: () async {
                                                try {
                                                  print('xxx');
                                                  //  MyAlertDialog.showConfirmationDialog(context, "Are you sure you want to delete this document ? ", (){}, (){});
                                                  //html.window.location.reload();
                                                  //     setState(() {});
                                                } catch (e) {
                                                  MyDialog.showAlert(
                                                      context, e.toString());
                                                  //    print(e.toString());
                                                } finally {}
                                              },
                                              icon: Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                            ),
                                            Tooltip(
                                              child: IconButton(
                                                onPressed: () async {
                                                  await addTimeOffCollectionToEmployees(
                                                      item['title'],
                                                      item['duration']);
                                                },
                                                icon: Icon(
                                                  Icons.publish,
                                                  color: Colors.green,
                                                ),
                                              ),
                                              message: "publish",
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                      ),
                    ),
              ),
            ),
          ),
          Positioned(
            child: sideBar(index: 9,),
          ),
        ],
      ),
    );
  }

  Future<List<Map<String, dynamic>>> loadTimeOffData() async {
    final companyDocc = FirebaseFirestore.instance.collection('timeOff');
    final querySnapshot = await companyDocc.get();
    final allData = querySnapshot.docs
        .map((doc) => {
              ...doc.data(), // Spread the existing data into the new Map
              'id': doc.id, // Add a new key-value pair for the document ID
            })
        .toList();

    return allData;
  }

  Future<void> addTimeOffCollectionToEmployees(
      String title, String duration) async {
    try {
      setState(() {
        isLOading = true;
      });
      final QuerySnapshot employeeSnapshot =
          await FirebaseFirestore.instance.collection('Employee').get();

      for (final DocumentSnapshot employeeDoc in employeeSnapshot.docs) {
        final employeeId = employeeDoc.id;

        // Check if a time off collection with the given title already exists for the current employee
        final timeOffSnapshot = await FirebaseFirestore.instance
            .collection('Employee')
            .doc(employeeId)
            .collection('TimeOff')
            .where('title', isEqualTo: title)
            .get();

        if (timeOffSnapshot.docs.isNotEmpty) {
          // A time off collection with the same title already exists for this employee
          print(
              'TimeOff collection already exists for employee with ID $employeeId');
          continue;
        }

        // Add a new time off collection for the current employee
        await FirebaseFirestore.instance
            .collection('Employee')
            .doc(employeeId)
            .collection('TimeOff')
            .add({
          'title': title,
          'duration': duration,
          'consume': "0",
        });

        print('TimeOff collection added to employee with ID $employeeId.');
      }

      print('TimeOff collection added to all employees.');
      setState(() {
        isLOading = false;
      });
      MyDialog.showAlert(context, "Published successfully!") ;
    } catch (e) {
      print('error $e');
      MyDialog.showAlert(context, "error $e") ;
    }
  }
}
