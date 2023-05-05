import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'button.dart';

class sideBar extends StatefulWidget {
  const sideBar({
    super.key,
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
          gradient: LinearGradient(colors: [
            Color.fromRGBO(90, 137, 214, 1),
            Color.fromRGBO(95, 167, 210, 1),
            Color.fromRGBO(49, 162, 202, 1)
          ])),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), bottomRight: Radius.circular(30)),
          border: Border.all(color: Colors.white.withOpacity(0.3)),
          color: Colors.grey.shade200.withOpacity(0.45),
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
              },
              isSelected: _selectedButtonIndex == 0,
            ),
            SizedBox(
              height: this.spaceBetween,
            ),
            Button(
              icon: Icons.person,
              txt: "Add Employee",
              onPress: () {
                _handleButtonTap(1);
              },
              isSelected: _selectedButtonIndex == 1,
            ),
            SizedBox(
              height: this.spaceBetween,
            ),
            Button(
              icon: Icons.sync_alt,
              txt: "requests",
              onPress: () {
                _handleButtonTap(2);
              },
              isSelected: _selectedButtonIndex == 2,
            ),
            SizedBox(
              height: this.spaceBetween,
            ),
            Button(
              icon: Icons.calendar_month,
              txt: "Shifts schedule",
              onPress: () {
                _handleButtonTap(3);
              },
              isSelected: _selectedButtonIndex == 3,
            ),
            SizedBox(
              height: this.spaceBetween,
            ),
            Button(
              icon: Icons.how_to_reg,
              txt: "Attendence ",
              onPress: () {
                _handleButtonTap(4);
              },
              isSelected: _selectedButtonIndex == 4,
            ),
            SizedBox(
              height: this.spaceBetween,
            ),
            Button(
              icon: Icons.attach_money_sharp,
              txt: "Work expensive",
              onPress: () {
                _handleButtonTap(5);
              },
              isSelected: _selectedButtonIndex == 5,
            ),
            SizedBox(
              height: this.spaceBetween,
            ),
            Button(
              icon: Icons.description,
              txt: "Employee claim ",
              onPress: () {
                _handleButtonTap(6);
              },
              isSelected: _selectedButtonIndex == 6,
            ),
            SizedBox(
              height: this.spaceBetween,
            ),
            Button(
              icon: Icons.document_scanner,
              txt: "Company documents",
              onPress: () {
                _handleButtonTap(7);
              },
              isSelected: _selectedButtonIndex == 7,
            ),
            SizedBox(
              height: this.spaceBetween,
            ),
            Button(
              icon: Icons.device_hub,
              txt: "Work flow",
              onPress: () {
                _handleButtonTap(8);
              },
              isSelected: _selectedButtonIndex == 8,
            ),
            SizedBox(height: 90,) ,
            Button(
              icon: Icons.login_outlined,
              txt: "Log out",
              onPress: () {
                _handleButtonTap(9);
              },
              isSelected: _selectedButtonIndex == 9,
            ),
          ],
        ),
      ),
    );
  }
}
