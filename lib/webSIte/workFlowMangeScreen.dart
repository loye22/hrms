import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hrms/models/staticVars.dart';
import 'package:hrms/models/yesNoDialog.dart';

import '../models/Dialog.dart';
import '../widgets/rightBar.dart';
import '../widgets/sideBar.dart';

class workFlowMangeScreen extends StatefulWidget {
  static const routeName = '/workFlowMangeScreen';

  const workFlowMangeScreen({Key? key}) : super(key: key);

  @override
  State<workFlowMangeScreen> createState() => _workFlowMangeScreenState();
}

class _workFlowMangeScreenState extends State<workFlowMangeScreen> {
  bool isLoading = false;

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
         /* Positioned(
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
                future: getWorkflowDataWithEmployeeNames(),
                // Replace with your function to load workflow data
                builder: (ctx, snapshot) => snapshot.connectionState ==
                        ConnectionState.waiting
                    ? Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Container(
                        width: MediaQuery.of(context).size.width - 650,
                        height: MediaQuery.of(context).size.height - 30,
                        padding: EdgeInsets.all(12),
                        child: isLoading
                            ? Center(child: CircularProgressIndicator())
                            : DataTable2(
                                columnSpacing: 50,
                                columns: [
                                  DataColumn(
                                    label: Text('Title'),
                                  ),
                                  DataColumn(
                                    label: Text('The flow'),
                                  ),
                                  DataColumn(
                                    label: Text('More Options'),
                                  ),
                                ],
                                rows: (snapshot.data != null)
                                    ? snapshot.data!.entries
                                        .map<DataRow>((entry) {
                                        final workflowId = entry.key;
                                        final workflowData = entry.value
                                            as Map<String, dynamic>;
                                        final title =
                                            workflowData['title'] ?? '';
                                        final flow = workflowData['flow']
                                            as Map<String, String>?;

                                        return DataRow(
                                          cells: [
                                            DataCell(Text(title)),
                                            DataCell(Text(flow != null
                                                ? flow.values.join('>>> ')
                                                : '')),
                                            DataCell(
                                              Row(
                                                children: [
                                                  IconButton(
                                                    onPressed: () async {
                                                      // Delete workflow logic here
                                                      try {
                                                        // Show confirmation dialog before deleting
                                                        MyAlertDialog
                                                            .showConfirmationDialog(
                                                          context,
                                                          "Are you sure you want to delete this workflow?",
                                                          () async {
                                                            try {
                                                              await FirebaseFirestore.instance
                                                                  .collection('workflow')
                                                                  .doc(workflowId)
                                                                  .delete();
                                                              print('Workflow deleted successfully');
                                                              MyDialog.showAlert(context, 'Workflow deleted successfully');
                                                              setState(() {});
                                                            } catch (e) {
                                                              print('Error deleting workflow: $e');
                                                              MyDialog.showAlert(context, 'error  $e');

                                                            }
                                                          },
                                                          () {},
                                                        );
                                                      } catch (e) {
                                                        MyDialog.showAlert(
                                                            context,
                                                            e.toString());
                                                      }
                                                    },
                                                    icon: Icon(
                                                      Icons.delete,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        );
                                      }).toList()
                                    : [],
                              ),

                        /*map<DataRow>((item) {
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(item['title'] ?? '')),
                                      DataCell(
                                          Text(item['employeeId'] ?? '')),
                                      DataCell(
                                        Row(
                                          children: [
                                            IconButton(
                                              onPressed: () async {
                                                // Delete workflow logic here
                                                try {
                                                  // Show confirmation dialog before deleting
                                                  MyAlertDialog
                                                      .showConfirmationDialog(
                                                    context,
                                                    "Are you sure you want to delete this workflow?",
                                                    () {},
                                                    () {},
                                                  );
                                                } catch (e) {
                                                  MyDialog.showAlert(
                                                      context, e.toString());
                                                }
                                              },
                                              icon: Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),*/
                      ),
                    ),
              ),
            ),
          ),
          Positioned(
            child: sideBar(
              index: 8,
            ),
          ),
        ],
      ),
    );
  }

  Future<Map<String, dynamic>> getWorkflowDataWithEmployeeNames() async {
    try {
      final workflowSnapshot =
          await FirebaseFirestore.instance.collection('workflow').get();
      final adminUsersSnapshot =
          await FirebaseFirestore.instance.collection('Adminusers').get();

      final adminUsersMap = <String, String>{};
      final workflowMap = <String, dynamic>{};

      // Build the admin users map
      for (final doc in adminUsersSnapshot.docs) {
        final id = doc.id;
        final userName = doc.data()['userName'] as String? ?? '';

        adminUsersMap[id] = userName;
      }

      // Build the workflow map with employee names
      for (final doc in workflowSnapshot.docs) {
        final workflowId = doc.id;
        final workflowData = doc.data();
        final title = workflowData['title'] as String? ?? '';
        final flow = workflowData['flow'] as Map<String, dynamic>?;

        final updatedFlow = <String, String>{};

        if (flow != null) {
          final sortedKeys = flow.keys.toList()..sort();
          for (final processKey in sortedKeys) {
            final processValue = flow[processKey] as String?;
            final employeeName = adminUsersMap[processValue] ?? '';
            updatedFlow[processKey] = employeeName;
          }
        }

        /*if (flow != null) {
          flow.forEach((processKey, processValue) {
            final employeeId = processValue as String?;
            final employeeName = adminUsersMap[employeeId] ?? '';
            updatedFlow[processKey] = employeeName;
          });
        }*/

        workflowMap[workflowId] = {'title': title, 'flow': updatedFlow};
      }

      // print(workflowMap);
      return workflowMap;
    } catch (e) {
      print(e);
      return {};
    }
  }
}
