import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hrms/models/Dialog.dart';
import 'package:hrms/models/staticVars.dart';

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
  final titleController = TextEditingController();
  bool isLodaing = false;

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
          child: Container(
            width: 300,
            height: 50,
            child: Row(
              children: [
                Text(
                  stepTitle,
                  style: staticVars.textStyle2,
                ),
                SizedBox(width: 10),
                Theme(
                  data: Theme.of(context).copyWith(
                    canvasColor:
                        Colors.black12, // Set the desired background color here
                  ),
                  child: Expanded(
                    child: DropdownButton<String>(
                      iconEnabledColor: staticVars.c1 ,
                      isExpanded: true,
                      value: selectedEmployeeMap[stepTitle],
                      hint: Text('Select Employee',
                        style: staticVars.textStyle2,),
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
                            style: staticVars.textStyle2,
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
                    color: staticVars.c1 ,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> handleSubmit() async {
    try {
      if (selectedEmployeeMap.isEmpty) {
        print('Select employee first');
        MyDialog.showAlert(context, 'Select employee first');
        return;
      }
      if (titleController.text.isEmpty) {
        print(
            'Please include a title for this task so that it can be referenced and utilized in the future');
        MyDialog.showAlert(context,
            'Please include a title for this workflow so that it can be referenced and utilized in the future');
        return;
      }

      String key = /*titleController.text.length > 9
          ? titleController.text.trim().substring(0, 10)
          : */titleController.text.trim();
      Map<String, dynamic> data = {'title' : key,'flow': selectedEmployeeMap};

      isLodaing = true;
      setState(() {});
      final collectionReference =
          FirebaseFirestore.instance.collection('workflow');
      await collectionReference.doc().set(data);
      isLodaing = false;
      setState(() {});
      MyDialog.showAlert(
          context, "The new workflow has been successfully added.");
      await Future.delayed(Duration(seconds: 3)); // Delay for 3 seconds
      Navigator.of(context).pop(); // Close the popup window
     // Navigator.of(context).pop(); // Close the popup window
    } catch (e) {
      MyDialog.showAlert(context, e.toString());
      print(e.toString());
    }
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
          ? MediaQuery.of(context).size.width - 600
          : MediaQuery.of(context).size.width - 200,
      height: 500,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              image: DecorationImage(
                image: AssetImage('assests/tstiBackGround.jpg'),
                fit: BoxFit.fill,
              ),
            ),
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
                Text(
                  'Workflow Steps',
                  style: staticVars.textStyle2,
                ),
                SizedBox(height: 16),
                Container(
                  width: 400,
                  child: TextField(
                    style: staticVars.textStyle2,
                    controller: titleController,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.black),
                      labelText: 'Title',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    SizedBox(width: 350,),
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Container(
                        width: MediaQuery.of(context).size.width - 1250 > 0
                            ? MediaQuery.of(context).size.width - 950
                            : 500,
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
                            isLodaing
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : Button(
                                    isSelected: true,
                                    icon:
                                        Icons.subdirectory_arrow_left_outlined,
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
