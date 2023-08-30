import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class staticVars {
  static BoxDecoration tstiBackGround = BoxDecoration(
    image: DecorationImage(
        image: AssetImage("assests/tstiBackGround.jpg"), fit: BoxFit.cover),
    //   color: Colors.red,
    /* gradient: LinearGradient(colors: [
                  Color.fromRGBO(90, 137, 214, 1),
                  Color.fromRGBO(95, 167, 210, 1),
                  Color.fromRGBO(49, 162, 202, 1)
                ])*/
  );

  static BoxDecoration tstiPobUpBackGround = BoxDecoration(
    borderRadius: BorderRadius.circular(30),
    gradient: LinearGradient(
        colors: [
          Color.fromRGBO(67, 160, 71, 1),
          Color.fromRGBO(56, 142, 60, 1),
          Color.fromRGBO(27, 94, 32, 1),
        ]
    ),
    /*image: DecorationImage(
        image: AssetImage("assests/popUpWindow.jpg"), fit: BoxFit.fill),*/
  );


  static TextStyle textStyle1 = GoogleFonts.montserratAlternates(
      fontSize: 20,
      color: Color.fromRGBO(0, 81, 45, 100),
      fontWeight: FontWeight.bold);

  static TextStyle textStyle2 = GoogleFonts.montserratAlternates(
      fontSize: 20,
      color: Color.fromRGBO(0, 81, 45, 100),
      fontWeight: FontWeight.bold);


  static TextStyle textStyle3 = GoogleFonts.montserratAlternates(
      fontSize: 15,
      color: Colors.white,
      fontWeight: FontWeight.bold);

  static TextStyle textStyle4 = GoogleFonts.montserratAlternates(
      fontSize: 16,
      color: Color.fromRGBO(0, 81, 45, 100),
      fontWeight: FontWeight.bold);


  static Color c1 =  Color.fromRGBO(0, 81, 45, 100) ;





}
