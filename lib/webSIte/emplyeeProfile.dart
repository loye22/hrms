import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hrms/models/staticVars.dart';
import 'package:provider/provider.dart';

import '../provider/employeeProfileProvider.dart';
import '../widgets/rightBar.dart';
import '../widgets/sideBar.dart';
import '../widgets/employeeProfile.dart';

class emplyeeProfile extends StatefulWidget {
  static const routeName = '/emplyeeProfile';

  const emplyeeProfile({Key? key}) : super(key: key);

  @override
  State<emplyeeProfile> createState() => _emplyeeProfileState();
}

class _emplyeeProfileState extends State<emplyeeProfile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    late final  snapshotemplyeeID ;
    try {
       snapshotemplyeeID =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    } catch (e) {
      Navigator.pop(context);
    }

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: staticVars.tstiBackGround,/*BoxDecoration(
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
            top: 15,
            child: Container(
              width: MediaQuery.of(context).size.width - 650,
              //padding: EdgeInsets.all(10),
              height: MediaQuery.of(context).size.height - 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: Colors.white.withOpacity(0.13)),
                color: Colors.grey.shade200.withOpacity(0.23),
              ),
              child: Center(
                child: Consumer<EmployeeProfilesProvider>(
                  builder: (ctx,pro,_)=>FutureBuilder(
                    future: getEmployeeById(  snapshotemplyeeID["eId"]),
                    builder: (ctx, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      } else {

                        /*EmployeeProfile profile = EmployeeProfile(
                          eId:snapshotemplyeeID["eId"]  ,
                          departmentID: snapshot.data?['departmentID'],
                          dob: snapshot.data?['dob'] != null
                              ? DateTime.parse(
                              snapshot.data!['dob'].toDate().toString())
                              : DateTime.now(),
                          email: snapshot.data?['email'],
                          gender: snapshot.data?['gender'],
                          hiringDate: snapshot.data?['hiringDate'] != null
                              ? DateTime.parse(
                              snapshot.data!['hiringDate'].toDate().toString())
                              : DateTime.now(),
                          nationality: snapshot.data?['nationality'],
                          phoneNr: snapshot.data?['phoneNr'],
                          photo: snapshot.data?['photo'],
                          position: snapshot.data?['position'],
                          userName: snapshot.data?['userName'],
                          weekendId: snapshot.data?['weekendId'],
                        );*/
                        EmployeeProfile p = pro.getEmployeeProfileByEid(snapshotemplyeeID["eId"] )  ;
                        return ProfileWidget(
                            empId : snapshotemplyeeID["eId"] ,
                            emp: p

                        );

                        /*
                        return Center(
                          child: Text(snapshot.data.toString()),*/

                      }
                    },
                  )
                ),
              ),
            ),
          ),
          Positioned(
            child: sideBar(index: 0,),
          ),
        ],
      ),
    );
  }

  Future<Map<String, dynamic>?> getEmployeeById(String id) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection("Employee").doc(id).get();
    Map<String, dynamic>? data = snapshot.data();

    if (data != null) {
      return data;
    } else {
      return null;
    }
  }


}
