


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hrms/widgets/sideBar.dart';

class test extends StatefulWidget {
  static const routeName = '/test' ;
  const test({Key? key}) : super(key: key);

  @override
  State<test> createState() => _testState();
}

class _testState extends State<test> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: sideBar(index: 0),
    );
  }
}
