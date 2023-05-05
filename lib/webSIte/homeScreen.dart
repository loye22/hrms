import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/emplyeeCard.dart';
import '../widgets/sideBar.dart';

class homeScreen extends StatefulWidget {
  static const routeName = '/homeScreen';
  const homeScreen({Key? key}) : super(key: key);

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
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
            child:Container(
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white.withOpacity(0.13)),
                color:  Colors.grey.shade200.withOpacity(0.25),

              ),

            ),
          ),
          Positioned(child:  sideBar(),),
        ],
      ),
    );
  }
}
