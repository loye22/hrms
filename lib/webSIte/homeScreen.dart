import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hrms/models/gloablVar.dart';
import 'package:hrms/provider/companyDoc.dart';
import 'package:hrms/webSIte/singUpScreen.dart';
import 'package:hrms/widgets/rightBar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider/UserData.dart';
import '../widgets/BarChartSample2.dart';
import '../widgets/emplyeeCard.dart';
import '../widgets/iconWiget.dart';
import '../widgets/sideBar.dart';
import 'package:hrms/widgets/button.dart';

import 'companyDocAdd.dart';

class homeScreen extends StatefulWidget {
  static const routeName = '/homeScreen';

  const homeScreen({Key? key}) : super(key: key);

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
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
              //padding: EdgeInsets.all(10),
              height: MediaQuery.of(context).size.height - 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: Colors.white.withOpacity(0.13)),
                color: Colors.grey.shade200.withOpacity(0.23),
              ),
              child: Center(
                  child: Column(
                children: [
                  Text("HOMe screen for testing "),
                  Button(
                      icon: Icons.forward_to_inbox,
                      onPress: () async {
                        await newRequist("VIW12XiEaTY7cm91niDKEgvlRCv2", "IDkjkEURfUtxvyNG8ngZ");
                      },
                      txt: "New requist",
                      isSelected: true)
                ],
              )),
            ),
          ),
          Positioned(
            child: sideBar(
              index: 0,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> newRequist(String userId, String workflowId) async {
    try {
      print(userId + '    userId');
      print(workflowId + '        workflowId');
      DateTime currentDate = DateTime.now();
      List<String> flowOrder = [];
      // Create the request document data
      Map<String, dynamic> requestData = {
        'eId': userId,
        'date': currentDate,
        'title': workflowId,
        'flow': {},
        'status':'pending' ,
        'ReqistedDays': "7"

      };
      // Retrieve the workflow document
      DocumentSnapshot workflowSnapshot = await FirebaseFirestore.instance
          .collection('workflow')
          .doc(workflowId)
          .get();

      // Check if the workflow document exists
      if (workflowSnapshot.exists) {
        // Retrieve the flow map from the workflow document
        Map<String, dynamic>? flowMap =
            workflowSnapshot.data() as Map<String, dynamic>?;
        // print(flowMap.toString()  + "<<<<<<<<");
        //print(flowMap!['flow']!.keys.toList()..sort());
        List<String> sortedKeys = flowMap!['flow'].keys.toList()..sort();
        Map<String, dynamic> sortedMap = {};
        for (var key in sortedKeys) {
          sortedMap[key] = flowMap['flow'][key];
        }


        requestData['flow'] = sortedMap;
        // Create the request document in the requests collection
        CollectionReference requestsCollection =
            FirebaseFirestore.instance.collection('requests');

        requestsCollection.add(requestData).catchError((error) {
          print('Failed to create request document: $error');
        });

        // print(requestData);
      }
    } catch (e) {
      print(e);
    }
  }
}
