import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hrms/models/staticVars.dart';
import 'package:hrms/webSIte/companyDocScreen.dart';
import 'package:hrms/webSIte/homeScreen.dart';
import 'package:hrms/webSIte/workExpScreen.dart';
import 'package:hrms/webSIte/workFlowMangeScreen.dart';
import 'package:path_provider/path_provider.dart';

import '../webSIte/attendinceScreen.dart';
import '../webSIte/employeesPage.dart';
import '../webSIte/loginScreen.dart';
import '../webSIte/requistScreen.dart';
import '../webSIte/shiftScedual.dart';
import '../webSIte/timeOffMangeScreen.dart';
import 'button.dart';

class sideBar extends StatefulWidget {
final int index ;
 const  sideBar({
    super.key, required this.index,
  });

  @override
  State<sideBar> createState() => _sideBarState();
}

class _sideBarState extends State<sideBar> {
  int _selectedButtonIndex = 0;
  double spaceBetween = 10;

  void _handleButtonTap(int buttonIndex) {
    setState(() {
      _selectedButtonIndex = buttonIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250.0,
      height: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), bottomRight: Radius.circular(30)),
          border: Border.all(color: Colors.white.withOpacity(0.3)),
          /*gradient: LinearGradient(colors: [
            Color.fromRGBO(90, 137, 214, 1),
            Color.fromRGBO(95, 167, 210, 1),
            Color.fromRGBO(49, 162, 202, 1)
          ])*/
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), bottomRight: Radius.circular(30)),
          border: Border.all(color: Colors.white.withOpacity(0.13)),
          color: staticVars.c1  ,
        ),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
         // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 150),
            Button(
              icon: Icons.dashboard,
              txt: "Dashboard",
              onPress: () {
                _handleButtonTap(0);
                if(mounted){
                  Navigator.of(context).pushNamed(homeScreen.routeName);
                }
              },
              isSelected: 0 == widget.index,
            ),
            SizedBox(
              height: this.spaceBetween,
            ),
            Button(
              icon: Icons.person,
              txt: "Employee",
              onPress: () {
                //_handleButtonTap(1);
                Navigator.pushNamed(context, employeesPage.routeName);
              },
              isSelected: 1 ==widget.index,
            ),
            SizedBox(
              height: this.spaceBetween,
            ),
            Button(
              icon: Icons.sync_alt,
              txt: "requests",
              onPress: () {
                //_handleButtonTap(2);
                if(mounted){
                  Navigator.of(context).pushNamed(requistScreen.routeName);
                }
              },
              isSelected: 2 == widget.index,
            ),
            SizedBox(
              height: this.spaceBetween,
            ),
            Button(
              icon: Icons.calendar_month,
              txt: "Shifts schedule",
              onPress: () {
               // _handleButtonTap(3);
                if(mounted){
                  Navigator.of(context).pushNamed(shiftScedual.routeName);
                }

              },
              isSelected: 3 == widget.index,
            ),
            SizedBox(
              height: this.spaceBetween,
            ),
            Button(
              icon: Icons.how_to_reg,
              txt: "Attendence ",
              onPress: () {
                if(mounted){
                  Navigator.of(context).pushNamed(attendanceScreen.routeName);
                }
                //_handleButtonTap(4);
              },
              isSelected: 4 == widget.index,
            ),
            SizedBox(
              height: this.spaceBetween,
            ),
            Button(
              icon: Icons.attach_money_sharp,
              txt: "Work expensive",
              onPress: () {
               // _handleButtonTap(5);
                if(mounted){
                  Navigator.of(context).pushNamed(workExpScreen.routeName);
                }
              },
              isSelected: 5 == widget.index,
            ),
            SizedBox(
              height: this.spaceBetween,
            ),
            /*Button(
              icon: Icons.description,
              txt: "Employee claim ",
              onPress: () {
               // _handleButtonTap(6);

              },
              isSelected: 6 == widget.index,
            ),*/
            SizedBox(
              height: this.spaceBetween,
            ),
            Button(
              icon: Icons.document_scanner,
              txt: "Company documents",
              onPress: () {
               // _handleButtonTap(7);
                  if(mounted){
                    Navigator.of(context).pushNamed(companyDocScreen.routeName);
                  }


              },
              isSelected: 7 == widget.index,
            ),
            SizedBox(
              height: this.spaceBetween,
            ),
            Button(
              icon: Icons.device_hub,
              txt: "Work flow",
              onPress: () {
               // _handleButtonTap(8);
                Navigator.of(context).pushNamed(workFlowMangeScreen.routeName);
              },
              isSelected: 8== widget.index,
            ),
            SizedBox(height: this.spaceBetween,) ,
            Button(
              icon: Icons.timelapse,
              txt: "Time off manger",
              onPress: () {
                //_handleButtonTap(9);
                Navigator.of(context).pushNamed(timeOffMangeScreen.routeName);
              },
              isSelected: 9 == widget.index,
            ),
            SizedBox(height: 90,) ,
            Button(
              icon: Icons.login_outlined,
              txt: "Log out",
              onPress: () async {
              //  _handleButtonTap(10);
                await FirebaseAuth.instance.signOut();
                Navigator.popUntil(context, ModalRoute.withName("/"));



              },
              isSelected: 10 == widget.index,
            ),
          ],
        ),
      ),
    );
  }
}
