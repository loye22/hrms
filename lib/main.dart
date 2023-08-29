import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hrms/provider/UserData.dart';
import 'package:hrms/provider/employeeProfileProvider.dart';
import 'package:hrms/webSIte/addNewEmployeeScreen.dart';
import 'package:hrms/webSIte/attendinceScreen.dart';
import 'package:hrms/webSIte/companyDocAdd.dart';
import 'package:hrms/webSIte/companyDocScreen.dart';
import 'package:hrms/webSIte/employeesPage.dart';
import 'package:hrms/webSIte/emplyeeProfile.dart';
import 'package:hrms/webSIte/homeScreen.dart';
import 'package:hrms/webSIte/loginScreen.dart';
import 'package:hrms/webSIte/requistScreen.dart';
import 'package:hrms/webSIte/shiftScedual.dart';
import 'package:hrms/webSIte/singUpScreen.dart';
import 'package:hrms/webSIte/timeOffMangeScreen.dart';
import 'package:hrms/webSIte/weekEndMangerScreen.dart';
import 'package:hrms/webSIte/workExpScreen.dart';
import 'package:hrms/webSIte/workFlowMangeScreen.dart';
import 'package:hrms/widgets/workflow.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyDDVXm6Kz8IfTP7GdBVYpYZevFaz0-pcvM",
          projectId: "hrmststi",
          storageBucket: "hrmststi.appspot.com",
          messagingSenderId: "562816180886",
          appId: "1:562816180886:web:dcd2db1282ef89593c98b7",

   /* apiKey: "AIzaSyAv9Ob74QE4fAeFbzMxB-13UtYrerwdzj4",
    appId: "1:110127987253:web:10e85384a44c447dec8f7c",
    messagingSenderId: "110127987253",
    projectId: "hrms-6c649",
    storageBucket: "myapp.appspot.com",*/
  ));



  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context)  {
    if (kIsWeb) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>(
            create: (_) => AuthProvider(),
          ),
          ChangeNotifierProvider<EmployeeProfilesProvider>( create: (_) => EmployeeProfilesProvider(),)
        ],
        child: MaterialApp(
          title: 'Bayanati',
          scrollBehavior: MaterialScrollBehavior().copyWith(
            dragDevices: {
              PointerDeviceKind.mouse,
              PointerDeviceKind.touch,
              PointerDeviceKind.stylus,
              PointerDeviceKind.unknown
            },
          ),
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {




              //  print(snapshot.data.uid);
                // Provider.of<AuthProvider>(context, listen: false).setUid(snapshot.data.uid);
              //  global.set(snapshot.data.uid);
                return homeScreen();
              } else {
                return loginScreen();
              }
            },

          ),
          routes: {
            loginScreen.routeName: (ctx) => loginScreen(),
            singUpScreen.routeName: (ctx) => singUpScreen(),
            homeScreen.routeName: (ctx) => homeScreen(),
            companyDocAdd.routeName: (ctx) => companyDocAdd(),
            companyDocScreen.routeName: (ctx) => companyDocScreen(),
            addNewEmployeeScreen.routeName: (ctx) => addNewEmployeeScreen(),
            weekEndMangerScreen.routeName: (ctx) => weekEndMangerScreen(),
            employeesPage.routeName: (ctx) => employeesPage(),
            emplyeeProfile.routeName: (ctx) => emplyeeProfile(),
            timeOffMangeScreen.routeName: (ctx) => timeOffMangeScreen(),
            shiftScedual.routeName: (ctx) => shiftScedual(),
            workFlowMangeScreen.routeName: (ctx) => workFlowMangeScreen(),
            requistScreen.routeName: (ctx) => requistScreen(),
            attendanceScreen.routeName: (ctx) => attendanceScreen(),
            workExpScreen.routeName: (ctx) => workExpScreen(),

          },
        ),
      );
    }

    else {
      return MaterialApp(
        home: Scaffold(),
        routes: {},
      );
    }
  }






}
