import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:firebase_admin/firebase_admin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hrms/models/Dialog.dart';
import 'package:hrms/models/staticVars.dart';
import 'package:hrms/models/yesNoDialog.dart';

import 'package:hrms/widgets/rightBar.dart';
import 'package:provider/provider.dart';

import '../provider/employeeProfileProvider.dart';
import '../widgets/sideBar.dart';
import 'emplyeeProfile.dart';

class employeesPage extends StatefulWidget {
  static const routeName = '/employeesPage';

  const employeesPage({Key? key}) : super(key: key);

  @override
  State<employeesPage> createState() => _employeesPageState();
}

class _employeesPageState extends State<employeesPage> {
  late Future<List<DocumentSnapshot>> employeeDocsFuture;
  late Future<List<DocumentSnapshot>> departmentDocsFuture;

  @override
  void initState() {
    super.initState();
    employeeDocsFuture = loadEmployeeListFromFirestore();
  }

  Future<List<DocumentSnapshot>> loadEmployeeListFromFirestore() async {
    final snapshot =
    await FirebaseFirestore.instance.collection('Employee').get();
    return snapshot.docs;
  }

  Future<String?> getDepartmentTitle(String docId) async {
    final docSnapshot = await FirebaseFirestore.instance
        .collection('Departments')
        .doc(docId)
        .get();
    final title = docSnapshot.data()?['title'];
    return title;
  }

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
              child: Center(
                child: FutureBuilder(
                  future: loadEmployeeListFromFirestore(),
                  builder: (ctx, response) =>
                  response.connectionState ==
                      ConnectionState.waiting
                      ? CircularProgressIndicator()
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
                              .height - 30,
                          padding: EdgeInsets.all(12),
                          child: DataTable2(
                            columnSpacing: 12,
                            horizontalMargin: 12,
                            columns: [
                              DataColumn2(
                                label: Text('Name'),
                              ),
                              DataColumn2(
                                label: Text('Hiring Date'),
                              ),
                              DataColumn2(
                                label: Text('Job Title'),
                              ),
                              DataColumn2(
                                label: Text('Department'),
                              ),
                              DataColumn2(
                                label: Text('More options '),
                              ),
                            ],
                            rows: response.data!.map((employee) {
                              return DataRow2(onTap: () {

                                EmployeeProfile employeeProfileFromMap(Map<String, dynamic> data) {
                                  return EmployeeProfile(
                                    eId:  employee.id.toString(),
                                    departmentID: data['departmentID'],
                                    dob: data['dob'].toDate(),
                                    email: data['email'],
                                    gender: data['gender'],
                                    hiringDate: data['hiringDate'].toDate(),
                                    nationality: data['nationality'],
                                    phoneNr: data['phoneNr'],
                                    photo: data['photo'],
                                    position: data['position'],
                                    userName: data['userName'],
                                    weekendId: data['weekendId'],
                                  );
                                }
                                EmployeeProfile employeeProfile = employeeProfileFromMap(employee.data() as Map<String, dynamic>);
                                EmployeeProfilesProvider employeeProvider =
                                Provider.of<EmployeeProfilesProvider>(context, listen: false);
                                employeeProvider.addEmployeeProfile(employeeProfile);
                                print(employeeProvider.getEmployeeProfilesLength());
                                Navigator.pushNamed(context, emplyeeProfile.routeName , arguments:{"eId" : employee.id.toString() , "index" :employeeProvider.getEmployeeProfilesLength() - 1    });
                              }, cells: [
                                DataCell(Row(
                                  children: [


                                   CircleAvatar(
                                      radius: 20,
                                      backgroundImage:
                                      NetworkImage(employee['photo']),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(child: Text(employee['userName'])),
                                  ],
                                )),
                                DataCell(Text(employee['hiringDate']
                                    ?.toDate()
                                    .toString()
                                    .substring(0, 10) ??
                                    '')),
                                DataCell(Text(employee['position'] ?? '')),
                                DataCell(
                                  FutureBuilder(
                                    future: getDepartmentTitle(
                                        employee["departmentID"]),
                                    builder: (ctx, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Text('Loading...');
                                      }
                                      return Text(snapshot.data ?? '');
                                    },

                                  ),
                                ),
                                DataCell(IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                  ),
                                  color: Colors.red,
                                  onPressed: () async {
                                    await MyAlertDialog.showConfirmationDialog(context,
                                        "Are you certain that you want to remove this employee from the system?", () async {
                                          try {
                                            await FirebaseFirestore.instance
                                                .collection('Employee')
                                                .doc(employee.id)
                                                .delete();
                                             MyDialog.showAlert(context, 'Employee deleted successfully.') ;
                                             setState(() {});
                                          } catch (error) {
                                            print('Failed to delete employee: $error');
                                          }
                                        }, () {
                                          print("no");
                                        }) ;
                                  },
                                ))
                              ]);
                            }).toList(),
                          ),
                        ),
                      ),
                ),
              ),
            ),

            /* Container(
              width: MediaQuery.of(context).size.width - 650,
              //padding: EdgeInsets.all(10),
              height: MediaQuery.of(context).size.height - 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: Colors.white.withOpacity(0.13)),
                color: Colors.grey.shade200.withOpacity(0.23),
              ),
              child: Center(child: Text("employeesPage")),
            ),*/
          ),
          Positioned(
            child: sideBar(index: 1),
          ),
        ],
      ),
    );
  }
}
