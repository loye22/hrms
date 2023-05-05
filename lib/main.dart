
import 'package:hrms/webSIte/homeScreen.dart';
import 'package:hrms/webSIte/loginScreen.dart';
import 'package:hrms/webSIte/singUpScreen.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'mobile/mobileScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: singUpScreen(),
    ) ;
  }
}
