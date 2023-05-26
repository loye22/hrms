
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class departmentsDropDownMenu extends StatefulWidget {
  final Function(String) onItemSelected;

  departmentsDropDownMenu({required this.onItemSelected});

  @override
  _departmentsDropDownMenuState createState() => _departmentsDropDownMenuState();
}

class _departmentsDropDownMenuState extends State<departmentsDropDownMenu> {
  String? _selectedItem;
  List<String> _weekendTitles = [];
  List<String> _weekendDocIds = [];

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('Departments')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          _weekendTitles.add(doc['title']);
          _weekendDocIds.add(doc.id);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 1600 > 1
          ? MediaQuery.of(context).size.width - 1600
          : 300,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: Colors.white.withOpacity(0.13)),
        color: Colors.grey.shade200.withOpacity(0.23),
      ),
      child: DropdownButton<String>(
        value: _selectedItem,
        underline: Container(),
        hint: Text(
          'Select the depatrment',
          style: TextStyle(color: Colors.white),
        ),
        onChanged: (value) {
          setState(() {
            _selectedItem = value;
          });
          int index = _weekendTitles.indexOf(value!);
          widget.onItemSelected(_weekendDocIds[index]);
        },
        items: _weekendTitles.map((title) {
          return DropdownMenuItem<String>(
            value: title,
            child: Text(title),
          );
        }).toList(),
      ),
    );
  }
}
