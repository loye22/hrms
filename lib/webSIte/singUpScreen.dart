import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hrms/models/staticVars.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:provider/provider.dart';
import 'dart:html' as html; // import html library
import '../models/Dialog.dart';
import '../provider/UserData.dart';
import '../widgets/button.dart';
import '../widgets/emplyeeCard.dart';
import '../widgets/imagePicker.dart';
import '../widgets/sideBar.dart';
import 'dart:io' as io;

import 'dart:async';
import 'package:universal_html/html.dart' as html2;
import 'package:firebase/firebase.dart' as fb;
import 'package:path/path.dart' as path;

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
  dynamic _imgFile = null; //  = null ;
  bool _isLoading = false;
  XFile? xfile = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration:  staticVars.tstiBackGround , /*BoxDecoration(
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
              width: MediaQuery.of(context).size.width - 300,
              height: MediaQuery.of(context).size.height - 50,
              child: Form(
                  key: _key2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 30,
                          ),
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 90,
                                backgroundImage: this._imgFile == null
                                    ? AssetImage("assests/momo.jfif")
                                    : Image.memory(this._imgFile).image,
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: InkWell(
                                  onTap: () async {
                                    // code to select an image from the gallery or take a photo using the camera
                                    final ImagePicker _picker = ImagePicker();
                                    this.xfile = await _picker.pickImage(
                                        source: ImageSource.gallery);
                                    Uint8List? uint8list =
                                        await this.xfile!.readAsBytes();
                                    this._imgFile = uint8list;
                                    setState(() {});
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black,
                                    ),
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 50,
                            width: 300,
                            child: TextFormField(
                                key: ValueKey('username'),
                                style: TextStyle(color: Colors.white),
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  errorStyle:
                                      TextStyle(fontWeight: FontWeight.bold),
                                  prefixIcon: Icon(
                                    Icons.person_outline_outlined,
                                    color: Colors.white,
                                  ),
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
                                  //val = val?.replaceAll(" ", "").toString();
                                  _passwd = val;
                                }
                              },
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'Please enter a password';
                                }
                                if (val.length < 8) {
                                  return 'Password must be at least 8 characters';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            height: 50,
                            width: 300,
                            child: TextFormField(
                              key: ValueKey('xxpassword'),
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
                          _isLoading
                              ? CircularProgressIndicator()
                              : Button(
                                  txt: "Add new admin",
                                  icon: Icons.add,
                                  isSelected: true,
                                  onPress: () async {
                                    try {
                                      if (!_isLoading) {
                                        setState(() {
                                          _isLoading = true;
                                        });
                                      }
                                      var x = await _submit();

                                      setState(() {});
                                    } catch (e) {
                                      MyDialog.showAlert(context,
                                          'Kindly reattempt by uploading your photo and providing your details.');
                                      print("error $e");
                                    } finally {
                                      _isLoading = false;
                                      this._email = "";
                                      this._userName = "";
                                      this._passwd = "";
                                      this._imgFile = null;
                                      this.xfile = null;
                                    }
                                  },
                                ),
                          SizedBox(
                            height: 15,
                          ),
                          Button(
                            txt: "Cancel",
                            icon: Icons.cancel,
                            isSelected: true,
                            onPress: () async {
                              try {
                                Navigator.pop(context);
                              } catch (e) {
                                MyDialog.showAlert(context, 'e');
                                print("error $e");
                              } finally {
                                _isLoading = false;
                                this._email = "";
                                this._userName = "";
                                this._passwd = "";
                                this._imgFile = null;
                                this.xfile = null;
                              }
                            },
                          ),

                          // SizedBox(height: MediaQuery.of(context).size.height),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.only(bottom: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10),
                            Text(
                              "* Please ensure that the email you entered is valid.",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "* Please ensure that your password is valid and contains at least 8 characters. Also, don't forget to upload your photo.",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "* This page serves the purpose of partially adding a new system administrator. Please ensure that their details are accurate..",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )
                    ],
                  )),
            ),
          ),
          Positioned(
            child: sideBar(index: 0,),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    final v = _key2.currentState?.validate();
    if (v != null) {
      _key2.currentState?.save();
      FocusScope.of(context).unfocus();
      print(_passwd + " " + _userName);
      String url = await _uploadImageFile(_email);

      await singUp(_email, _passwd, _userName, url);
    } else {
      print("faild");
      return;
    }
  }

  final _auth = FirebaseAuth.instance;

// Function to create a new user with email and password

  Future<void> singUp(
      String email, String pass, String username, String url) async {
    UserCredential s;
    try {
      s = await _auth.createUserWithEmailAndPassword(
          email: email, password: pass);

      await FirebaseFirestore.instance
          .collection('Adminusers')
          .doc(s.user!.uid)
          .set({'userName': username, 'email': email, "photo": url});
      MyDialog.showAlert(
          context, "New administrator has been added successfully.");
    } on PlatformException catch (err) {
      MyDialog.showAlert(context, "$err");
      String msg = 'some thing went wrong';
      if (err.message != null) {}
    } catch (e) {
      String displayMessage =
          e.toString().substring(e.toString().indexOf("]") + 2);

      MyDialog.showAlert(context, displayMessage);
      print('error');
      print(e);
    }
  }

/*
  final FirebaseStorage _storage =
  FirebaseStorage.instanceFor(bucket: 'gs://hrms-6c649.appspot.com');

  Future<void> _uploadImageFile(String imageName) async {
    try {
     // final ImagePicker _picker = ImagePicker();
    //  final XFile? xfile = await _picker.pickImage(source: ImageSource.gallery);
      Uint8List? uint8list = await this.xfile!.readAsBytes();
    //  this._imgFile = uint8list;
      String fileName = imageName +  path.extension(this.xfile!.name).toString();
      Reference firebaseStorageRef =
      _storage.ref().child('Administrator /$fileName');
      UploadTask uploadTask = firebaseStorageRef.putData(uint8list!);
      await uploadTask.whenComplete(() => print('File uploaded'));
    } on FirebaseException catch (e) {

    }}
*/

  final FirebaseStorage _storage =
      FirebaseStorage.instanceFor(bucket:/*'gs://hrms-6c649.appspot.com'*/  'gs://hrmststi.appspot.com' );

  Future<String> _uploadImageFile(String imageName) async {
    try {
      Uint8List? uint8list = await this.xfile!.readAsBytes();
      String fileName = imageName + path.extension(this.xfile!.name).toString();
      Reference firebaseStorageRef =
          _storage.ref().child('Administrator/$fileName');
      UploadTask uploadTask = firebaseStorageRef.putData(uint8list!);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } on FirebaseException catch (e) {
      print('File upload error: $e');
      throw e;
    }
  }
}
