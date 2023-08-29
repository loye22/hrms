import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hrms/models/gloablVar.dart';
import 'package:hrms/models/staticVars.dart';
import 'package:hrms/provider/UserData.dart';
import 'package:hrms/webSIte/homeScreen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/Dialog.dart';
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
  String _eamil = '';
  String _passwd = '';
  bool _isLoading = false;

  void _submit() {
    final v = _key.currentState?.validate();

    if (v != null) {
      _key.currentState?.save();
      FocusScope.of(context).unfocus();
      //log in logic ...
      // print(_passwd + " " + _eamil);
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
            decoration:  staticVars.tstiBackGround,/*BoxDecoration(
                color: Colors.red,
                gradient: LinearGradient(colors: [
                  Color.fromRGBO(90, 137, 214, 1),
                  Color.fromRGBO(95, 167, 210, 1),
                  Color.fromRGBO(49, 162, 202, 1)
                ])),*/
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
                    //        height: 150,
                    ),
                Container(
                  height: 200.0,
                  width: 200.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          'assests/newlogo.png'),
                      fit: BoxFit.fill,
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text('BAYANATI' , style: staticVars.textStyle1,),
                SizedBox(height: 20,),
                Container(
                  height: 40,
                  width: 300,
                  child: TextFormField(

                      key: ValueKey('username'),
                      style: TextStyle(color: staticVars.c1),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email, color: staticVars.c1),
                        labelText: 'email',
                        labelStyle: TextStyle(color: staticVars.c1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                            color: staticVars.c1,
                            width: 2.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                            color: staticVars.c1,
                            width: 3.0,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade200.withOpacity(0.45),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                            color: staticVars.c1,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 16.0),
                      ),
                      onSaved: (val) {
                        if (val != null) {
                          val = val?.replaceAll(" ", "").toString();
                          _eamil = val!;
                        }
                      },
                      validator: (val) {
                        if (val == null) {
                          return;
                        }
                        //   val = val?.replaceAll(" ", "").toString();
                      }),
                ),
                SizedBox(height: 10),
                Container(
                  height: 40,
                  width: 300,
                  child: TextFormField(
                    key: ValueKey('password'),
                    style: TextStyle(color: staticVars.c1),
                    obscureText: true,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.password, color: staticVars.c1),
                      labelText: 'Password',
                      labelStyle: TextStyle(color: staticVars.c1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: staticVars.c1,
                          width: 3.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: staticVars.c1,
                          width:3.0,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade200.withOpacity(0.45),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: staticVars.c1,
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
                    child: _isLoading
                        ? CircularProgressIndicator()
                        : Button(
                            txt: "Log in ",
                            icon: Icons.login,
                            isSelected: false,
                            onPress: () async {
                              try {
                                _submit();
                                setState(() {this._isLoading = true;});
                                // check if the this user in an admin
                                // true ==> he is
                                // false ==>
                               bool isAdmin =await  checkAdminStatus(_eamil);
                                if(!isAdmin){
                                  throw Exception('Unfortunately, the provided email ${_eamil} does not have the necessary permissions to access the admin panel');
                                }

                                dynamic res = await signInWithEmailAndPassword(
                                        _eamil, _passwd, context)
                                    .then((value) => null);

                              } catch (e) {
                                String displayMessage = e
                                    .toString()
                                    .substring(e.toString().indexOf("]") + 2);
                                print("error  $e");
                                if (mounted) {
                                  MyDialog.showAlert(
                                      context, '$displayMessage');
                                  setState(() {
                                    this._isLoading = false;
                                  });
                                }
                              } finally {}
                            },
                          ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

/*
  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    UserCredential result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    print(result);


    return result;
  }

  */

  Future<UserCredential> signInWithEmailAndPassword(
      String emaile, String password, BuildContext ctx) async {

    final FirebaseAuth _auth = FirebaseAuth.instance;
    // Sign in with email and password
    UserCredential result = await _auth.signInWithEmailAndPassword(
      email: emaile,
      password: password,
    );

    // Retrieve the user's document from Firestore
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('Adminusers')
        .doc(result.user!.uid)
        .get();

    // Set the user's name and email from the document
    String name = await userDoc.get('userName');
    String email = await userDoc.get('email');
    String url = await userDoc.get('photo');

    // Generate a token and store it in the provider
    String token = await result.user!.getIdToken();


    //print("form log in method   "+ url.toString());
    /*
    Provider.of<AuthProvider>(ctx, listen: false)
        .setData(userdataa(email: email, name: name, uri:url ), token);
*/

    /*
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', name);
    await prefs.setString('email', email);
    await prefs.setString('photo', url);
    await prefs.setString('token', token);*/

    // Return the UserCredential
    return result;
  }


  // Check if the user's email exists in the "Adminusers" collection
  Future<bool> checkAdminStatus(String userEmail) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    // Query the "Adminusers" collection based on the user's email
    QuerySnapshot querySnapshot = await _firestore
        .collection('Adminusers')
        .where('email', isEqualTo: userEmail)
        .get();
    print('debug');

    if (querySnapshot.docs.isNotEmpty) {
      // User's email exists in the "Adminusers" collection
      // Allow access to the website or perform other actions
      return true ;
    } else {
      // User's email does not exist in the "Adminusers" collection
      // Deny access or show an appropriate message
      return false ;
    }
  }
}
