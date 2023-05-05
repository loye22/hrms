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
              child: Center(child: Column(
                children: [
                  Text("HOMe screen"),

                ],
              )),
            ),
          ),
          Positioned(
            child: sideBar(),
          ),
        ],
      ),
    );
  }

}