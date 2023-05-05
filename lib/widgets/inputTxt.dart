  import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class inputTxt extends StatelessWidget {
  const inputTxt({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(color: Colors.white),
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.person_outline_outlined, color: Colors.white),
        labelText: 'User name',
        labelStyle: TextStyle(color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(
            color: Colors.white,
            width: 2.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(
            color: Colors.white,
            width: 2.0,
          ),
        ),
        filled: true,
        fillColor: Colors.grey.shade200.withOpacity(0.45),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.7),
          ),
        ),
        contentPadding:
        EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      ),
    );
  }
}