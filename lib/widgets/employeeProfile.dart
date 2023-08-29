import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hrms/webSIte/companyDocAdd.dart';
import 'package:hrms/widgets/buildDonutChart.dart';
import 'package:hrms/widgets/button.dart';
import 'package:hrms/widgets/employeeProfileTabs/personal.dart';

import '../models/Dialog.dart';
import '../provider/employeeProfileProvider.dart';
import 'employeeProfileTabs/documents.dart';

class ProfileWidget extends StatefulWidget {
  /*final String name;
  final String occupation;
  final String photoUrl;*/
  final EmployeeProfile emp;
  final String empId;

  const ProfileWidget(
      { /*required this.name, required this.occupation, required this.photoUrl,*/ required this.emp,
        required this.empId});

  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  bool isUploading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width - 650,
      height: MediaQuery
          .of(context)
          .size
          .height - 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: Colors.black.withOpacity(0.33)),
        color: Colors.grey.shade200.withOpacity(0.13),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          CircleAvatar(
            radius: 60,
            backgroundImage: NetworkImage(widget.emp.photo),
          ),
          SizedBox(height: 20),
          Text(
            widget.emp.userName,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            widget.emp.position,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 30),
          TabBar(
            controller: _tabController,
            indicatorColor: Colors.blue,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.black,
            tabs: [
              Tab(text: 'Personal'),
              Tab(text: 'Documents'),
              Tab(text: 'Attendance'),
              Tab(text: 'Time Off'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Personal Tab
                Center(
                  child: PersonalTab(employeeProfile: widget.emp),
                ),

                // Documents Tab
                Center(
                    child: FutureBuilder(
                      future: getMandatorDocumentTitles(),
                      builder: (ctx, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        } else {
                          return Center(
                            child: isUploading
                                ? CircularProgressIndicator()
                                : SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  documentTab(
                                    documentNames: snapshot.data!.toList(),
                                    eid: widget.empId,
                                  ),
                                  /*Container(
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width -
                                        1450 >
                                        0
                                        ? MediaQuery
                                        .of(context)
                                        .size
                                        .width -
                                        1200
                                        : 600,
                                    padding: EdgeInsets.all(30),
                                    child: Button(
                                      icon: Icons.notifications,
                                      onPress: () {},
                                      txt:
                                      'Remind this employee to upload ? ',
                                      isSelected: true,
                                    ),
                                  )*/
                                ],
                              ),
                            ),
                          );
                        }
                      },
                    )),

                // Attendance Tab
                Center(
                  child: Text('Documents Tab'),
                ),

                // Time Off Tab
                Center(
                    child: FutureBuilder(
                      future: getTimeOffData(widget.empId),
                      builder: (ctx, snapshop) {
                        if (snapshop.hasError) {
                          return Text("404 Error");
                        }
                        if (snapshop.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          List<DocumentSnapshot> timeOffData = snapshop.data!;
                          return Container(
                            //   width: 400,
                            padding: EdgeInsets.all(12),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: timeOffData.length,
                              itemBuilder: (ctx, idx) {
                                final data = timeOffData[idx].data() as Map<String,dynamic>;
                               // print(data);
                                return DonutChartWidget(
                                  totalDays: data["duration"]!= null ? double.parse(data["duration"]) : 0.0 ,
                                  usedDays:data["consume"]!= null ? double.parse(data["consume"])  : 0.0 ,
                                  txt: data["title"]!= null ? data["title"] : "error",
                                  color: Colors.blue,
                                );
                              },)
                            ,
                          );
                        }
                      },
                    )
                  /*Text('Time Off Tab'),*/
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<List<String>> getMandatorDocumentTitles() async {
    List<String> titles = [];

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('EmployeesMandatoryDocs')
        .get();

    querySnapshot.docs.forEach((doc) {
      String title = doc.get('title');
      titles.add(title);
    });

    return titles;
  }

  Future<String> getWeekendTitle(String documentId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('weekend')
        .doc(documentId)
        .get();

    final title = snapshot.data()?['title'] ?? '';
    final days = (snapshot.data()?['days'] ?? [])
        .map<String>((day) => day.toString())
        .join(', ');

    return '$title: $days';
  }



  Future<String> getDoumentUrl(String employeeId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('Employee')
          .doc(employeeId)
          .collection('documents')
          .get();
      final document = snapshot.docs.firstWhere((doc) => doc.exists);
      if (document == null) {
        print('Document not found');
        return "NotFound";
      }
      final documentData = document.data();
      final url = documentData['url'] as String;
      return url;
    } catch (e) {
      print('Error downloading document: $e');
      return "null";
    }
  }

  Future<String> downloadEmployeeDocument(String employeeId,
      String documentName) async {
    try {
      final documentSnapshot = await FirebaseFirestore.instance
          .collection('Employee')
          .doc(employeeId)
          .collection('documents')
          .where('documentName', isEqualTo: documentName)
          .get()
          .then((querySnapshot) => querySnapshot.docs.first);
      if (documentSnapshot.exists) {
        final documentUrl = documentSnapshot.get('url') as String;
        return documentUrl;
      } else {
        print('Document not found');
        return "";
      }
    } catch (e) {
      print('Error downloading document: $e');
      return "";
    }
  }

  Future<List<DocumentSnapshot>> getTimeOffData(String employeeId) async {

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Employee')
          .doc(employeeId)
          .collection('TimeOff')
          .get();

      return snapshot.docs;


  }
}
