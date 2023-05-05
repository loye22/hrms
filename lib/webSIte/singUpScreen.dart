import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:html' as html; // import html library
import '../widgets/button.dart';
import '../widgets/imagePicker.dart';
import '../widgets/sideBar.dart';

class singUpScreen extends StatefulWidget {
  static const routeName = '/singUpScreen';

  const singUpScreen({Key? key}) : super(key: key);

  @override
  State<singUpScreen> createState() => _singUpScreenState();
}

class _singUpScreenState extends State<singUpScreen> {
  final _key2 = GlobalKey<FormState>();
  String _userName = '';
  String _email = '';
  String _passwd = '';
  var _islogIn = true;
  dynamic _imgFile = null  ;



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
          Positioned(
            left: 280,
            top: 15,
            child: Container(
              //padding: EdgeInsets.all(50),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white.withOpacity(0.13)),
                  color: Colors.grey.shade200.withOpacity(0.25),
                ),
                width: 1200,
                height: 750,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                      child: Form(

                        key: _key2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 200,
                            ),
                            CircleAvatar(
                              radius: 90,
                              backgroundImage: this._imgFile == null  ? AssetImage("assests/momo.jfif") :  Image.memory(this._imgFile  ).image,

                            ),
                            Button(icon:Icons.camera , txt: 'Upload images ',onPress:_image,isSelected: true, ),
                            Container(
                              height: 50,
                              width: 300,
                              child: TextFormField(
                                  key: ValueKey('username'),
                                  style: TextStyle(color: Colors.white),
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    errorStyle:TextStyle(fontWeight: FontWeight.bold),
                                    prefixIcon: Icon(
                                      Icons.person_outline_outlined,
                                      color: Colors.white,),
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
                                    fillColor:
                                    Colors.grey.shade200.withOpacity(0.45),
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
                                      val = val?.replaceAll(" ", "").toString();
                                      _userName = val!;
                                    }
                                  },
                                  validator: (val) {
                                    if (val == "" || val!.contains(" ")) {
                                      return "Please enter valid the username";
                                    }
                                    //   val = val?.replaceAll(" ", "").toString();
                                  }),
                            ),
                            SizedBox(height: 10),
                            Container(
                              height: 50,
                              width: 300,
                              child: TextFormField(
                                key: ValueKey('email'),
                                style: TextStyle(color: Colors.white),
                                // obscureText: true,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  prefixIcon:
                                  Icon(Icons.email, color: Colors.white),
                                  labelText: 'Email',
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
                                  fillColor: Colors.grey.shade200.withOpacity(
                                      0.45),
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
                                    val = val?.replaceAll(" ", "").toString();
                                    _email = val!;
                                  }
                                },
                                validator: (v) {
                                  if (v == null || !v.contains("@")) {
                                    return "Please enter valid email address ";
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 50,
                              width: 300,
                              child: TextFormField(
                                key: ValueKey('password'),
                                style: TextStyle(color: Colors.white),
                                obscureText: true,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  prefixIcon:
                                  Icon(Icons.password, color: Colors.white),
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
                                  fillColor: Colors.grey.shade200.withOpacity(
                                      0.45),
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
                            SizedBox(height: 10),
                            Container(
                              height:50,
                              width: 300,
                              child: TextFormField(
                                key: ValueKey('password'),
                                style: TextStyle(color: Colors.white),
                                obscureText: true,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  prefixIcon:
                                  Icon(Icons.password, color: Colors.white),
                                  labelText: 'Confirm password',
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
                                  fillColor: Colors.grey.shade200.withOpacity(
                                      0.45),
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
                                    // _passwd = val;
                                  }
                                },
                                validator: (v) {
                                  if (v != _passwd) {
                                    return "the passwords dose not match";
                                  }
                                },
                              ),
                            ),
                            SizedBox(height: 10),

                            SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: Button(
                                txt: "Sing Up",
                                icon: Icons.add,
                                isSelected: true,
                                onPress: () {
                                  _submit();
                                  _image();
                                },

                              ),
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
                )),
          ),
          Positioned(
            child: sideBar(),
          ),
        ],
      ),
    );
  }

  void _submit() {
    final v = _key2.currentState?.validate();

    if (v != null) {
      _key2.currentState?.save();
      FocusScope.of(context).unfocus();
      //log in logic ...
      print(_passwd + " " + _userName);
    }
  }

  Future<void>  _image() async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? f = await _picker.pickImage(source: ImageSource.gallery) ;
    this._imgFile =await f?.readAsBytes() ;


    setState(() {

    });
  }

}

