import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hrms/models/Dialog.dart';

import 'button.dart';

class WorkflowExecutionPage extends StatefulWidget {
  final Function(Map<String, String> x) fun;

  const WorkflowExecutionPage({Key? key, required this.fun}) : super(key: key);

  @override
  _WorkflowExecutionPageState createState() => _WorkflowExecutionPageState();
}

class _WorkflowExecutionPageState extends State<WorkflowExecutionPage> {
  List<String> workflowSteps = ['Process 1'];
  Map<String, String> employeeMap = {
    'Employee 1': 'ID_1215',
    'Employee 2': 'ID_61542',
    'Employee 3': 'ID_514893',
    'Employee 4': 'ID_514fgfg893',
    'Employee 5': 'ID_514fgfg893',
    'Employee 6': 'ID_fef514893',
    'Employee 3': 'ID_51489s3',
  };
  Map<String, String> selectedEmployeeMap = {};

  Widget buildStep(int index) {
    String stepTitle = workflowSteps[index];

    return FutureBuilder(
      future: getAdminUsersData(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('404 error ');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          Center(
            child: CircularProgressIndicator(),
          );
        }

        return Animate(
          effects: [FadeEffect(), ScaleEffect()],
          child: Row(
            children: [
              Text(
                stepTitle,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(width: 10),
              Theme(
                data: Theme.of(context).copyWith(
                  canvasColor:
                      Colors.black12, // Set the desired background color here
                ),
                child: Expanded(
                  child: DropdownButton<String>(
                    iconEnabledColor: Colors.white,
                    isExpanded: true,
                    value: selectedEmployeeMap[stepTitle],
                    hint: Text('Select Employee',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    onChanged: (String? newValue) {
                      setState(() {
                        if (selectedEmployeeMap.containsValue(newValue!)) {
                          MyDialog.showAlert(context,
                              "This emplye is already selected above!");
                          return;
                        }

                        selectedEmployeeMap[stepTitle] = newValue!;
                        //print(selectedEmployeeMap);
                      });
                    },
                    items: employeeMap.entries
                        .map((MapEntry<String, String> entry) {
                      return DropdownMenuItem<String>(
                        value: entry.value,
                        child: Text(
                          entry.key,
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  if (selectedEmployeeMap[stepTitle] == null) {
                    //print('Select employee first');
                    MyDialog.showAlert(context, 'Select employee first');
                    return;
                  }
                  setState(() {
                    if (index == workflowSteps.length - 1) {
                      workflowSteps.add('Process ${index + 2}');
                    }
                  });

                  //widget.fun()
                },
                icon: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> handleSubmit() async {
    if (selectedEmployeeMap.isEmpty) {
      print('Select employee first');
      MyDialog.showAlert(context, 'Select employee first');
      return;
    }
    widget.fun(selectedEmployeeMap);
   // print(selectedEmployeeMap);

    // print(await getAdminUsersData());
  //  print('Selected Employees:');
   // print(selectedEmployeeMap);
  }

  Future<Map<String, String>> getAdminUsersData() async {
    Map<String, String> adminUsersData = {};

    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('Adminusers').get();

      snapshot.docs.forEach((doc) {
        String id = doc.id;
        String userName = doc.get('userName');
        if (userName != null) {
          adminUsersData[userName] = id;
        }
        //  adminUsersData[userName] = id;
      });
      this.employeeMap = adminUsersData;
      return adminUsersData;
    } catch (e) {
      // Handle error if needed
      MyDialog.showAlert(context, e.toString());
      print('Error retrieving admin users data: $e');
    }

    return adminUsersData;
  }

  @override
  Widget build(BuildContext context) {
    //print( MediaQuery.of(context).size.width - 1200);
    return Container(
      width: MediaQuery.of(context).size.width - 800 < 0
          ? MediaQuery.of(context).size.width - 800
          : MediaQuery.of(context).size.width - 400,
      height: 500,
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
              // borderRadius: BorderRadius.circular(30),
              borderRadius: BorderRadius.all(Radius.circular(30)),

              //border: Border.all(color: Colors.red),
              color: Colors.grey.shade200.withOpacity(0.25),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: Text(
                    'Workflow Steps',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    MediaQuery.of(context).size.width - 1200 == 720
                        ? SizedBox(
                            width: 400,
                          )
                        : SizedBox(
                            width: 400,
                          ),
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Container(
                        width: MediaQuery.of(context).size.width - 1250 > 0
                            ? MediaQuery.of(context).size.width - 1250
                            : 400,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Column(
                          children: [
                            Column(
                              children: List.generate(
                                workflowSteps.length,
                                (index) => Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: buildStep(index),
                                ),
                              ),
                            ),
                            Button(
                              isSelected: true,
                              icon: Icons.subdirectory_arrow_left_outlined,
                              onPress: handleSubmit,
                              txt: 'Create workflow',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
