import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/button.dart';
import '../widgets/emplyeeCard.dart';
import '../widgets/inputTxt.dart';
import '../widgets/sideBar.dart';

class loginScreen extends StatefulWidget {
  static const routeName = '/loginScreen';

  const loginScreen({Key? key}) : super(key: key);

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  final _key = GlobalKey<FormState>();
  String _userName = '';
  String _passwd = '';
  var _islogIn = true;

  void _submit() {
    final v = _key.currentState?.validate();

    if (v != null) {
      _key.currentState?.save();
      FocusScope.of(context).unfocus();
      //log in logic ...
      print(_passwd + " " + _userName);
    }
  }

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
          Center(
              child: Form(
                key: _key,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 200,
                    ),
                    Container(
                      height: 40,
                      width: 300,
                      child: TextFormField(
                        key: ValueKey('username'),
                        style: TextStyle(color: Colors.white),
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person_outline_outlined,
                              color: Colors.white),
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
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 16.0),
                        ),
                        onSaved: (val) {
                          if (val!= null) {
                            val = val?.replaceAll(" ", "").toString();
                            _userName = val!;
                          }
                        },
                        validator: (val) {
                          if (val == null){
                            return;
                          }
                      //   val = val?.replaceAll(" ", "").toString();


                        }
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 40,
                      width: 300,
                      child: TextFormField(
                        key: ValueKey('password'),
                        style: TextStyle(color: Colors.white),
                        obscureText: true,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.password, color: Colors.white),
                          labelText: 'Password',
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
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 16.0),
                        ),
                        onSaved: (val) {
                          if (val != null) {
                            //val = val?.replaceAll(" ", "").toString();
                            _passwd = val;
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 50,
                      child: Center(
                        child: Button(
                          txt: "Log in ",
                          icon: Icons.login,
                          isSelected: true,
                          onPress: () {
                            _submit();
                          },

                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    /* Container(
                  height: 50,
                  child: Center(
                    child: Button(
                      txt: "Sing Up ",
                      icon: Icons.add,
                      isSelected: true,
                      onPress: () {},
                    ),
                  ),
                )*/
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
