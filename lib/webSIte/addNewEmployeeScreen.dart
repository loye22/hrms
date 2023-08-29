import 'dart:typed_data';

import 'package:country_list_pick/country_list_pick.dart';
import 'package:country_list_pick/support/code_country.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:gender_picker/source/gender_picker.dart';
import 'package:hrms/models/staticVars.dart';
import 'package:image_picker/image_picker.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:universal_html/html.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/Dialog.dart';
import '../models/gender.dart';
import '../widgets/button.dart';
import '../widgets/departmentsDropDownMenu.dart';
import '../widgets/rightBar.dart';
import '../widgets/sideBar.dart';
import 'package:path/path.dart' as path;

import '../widgets/GenderPicker.dart';

class addNewEmployeeScreen extends StatefulWidget {
  static const routeName = '/addNewEmployeeScreen';

  const addNewEmployeeScreen({Key? key}) : super(key: key);

  @override
  State<addNewEmployeeScreen> createState() => _addNewEmployeeScreenState();
}

class _addNewEmployeeScreenState extends State<addNewEmployeeScreen> {
  final _key2 = GlobalKey<FormState>();
  bool _isLoading = false;
  dynamic _imgFile = null;
  String _userName = '';
  String _email = '';
  String _passwd = '';
  DateTime dob = DateTime.now();

  String selectedNationality = '';

  String phoneNr = '';
  String position = '';
  DateTime hiringDate = DateTime.now();
  late Map<String, dynamic> weekEnd = {};

  XFile? xfile = null;
  Genderss _selectedGender = Genderss.male;
  String weekEndId = '';
  String departmantID ='';

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
          rightBar(),
          /*Positioned(
            left: 280,
            top: 15,
            child: Container(
              width: MediaQuery.of(context).size.width - 650,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: Colors.black.withOpacity(0.33)),
                color: Colors.grey.shade200.withOpacity(0.23),
              ),
              child: Center(
                child: Text(
                  'Add new employee',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ),*/
          Positioned(
            left: 280,
            bottom: 15,
            child: Container(
              //padding: EdgeInsets.all(50),

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.black.withOpacity(0.33)),
                color: staticVars.c1,
              ),
              width: MediaQuery.of(context).size.width - 650,
              height: MediaQuery.of(context).size.height - 30,
              child: Form(
                  key: _key2,
                  child: SingleChildScrollView(
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
                                    labelText: 'Employee name ',
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
                                    return null;
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
                                  final RegExp emailRegex = RegExp(
                                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,}$');
                                  if (v == null || !emailRegex.hasMatch(v)) {
                                    return "Please enter valid email address ";
                                  }
                                  return null;
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
                                validator: (v) {
                                  //  print("this v -->  " + v.toString());
                                  // print("this _paswrd -->  " + _passwd);
                                  if (v.toString() != _passwd.toString()) {
                                    return "The passwords dose not match";
                                  }
                                  return null;
                                },
                                onSaved: (val) {
                                  this._passwd = val.toString().trim();
                                },
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              height: 50,
                              width: 300,
                              child: TextFormField(
                                  key: ValueKey('Phone number'),
                                  style: TextStyle(color: Colors.white),
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    errorStyle:
                                        TextStyle(fontWeight: FontWeight.bold),
                                    prefixIcon: Icon(
                                      Icons.phone_android,
                                      color: Colors.white,
                                    ),
                                    labelText: 'Phone number ',
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
                                      this.phoneNr =
                                          val.replaceAll(" ", "").toString();
                                    }
                                  },
                                  validator: (val) {
                                    final RegExp phoneRegex =
                                        RegExp(r'^\d{10}$');
                                    if (val == "" ||
                                        !phoneRegex.hasMatch(val!) ||
                                        val.length <= 8) {
                                      return "Please enter valid the Phone number";
                                    }
                                    return null;
                                    //   val = val?.replaceAll(" ", "").toString();
                                  }),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 50,
                              width: 300,
                              child: TextFormField(
                                  key: ValueKey('Position'),
                                  style: TextStyle(color: Colors.white),
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    errorStyle:
                                        TextStyle(fontWeight: FontWeight.bold),
                                    prefixIcon: Icon(
                                      Icons.sensor_occupied,
                                      color: Colors.white,
                                    ),
                                    labelText: 'Position ',
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
                                      this.position = val.trim();
                                    }
                                  },
                                  validator: (val) {
                                    if (val == "" || val!.contains(" ")) {
                                      return "Please enter valid the username";
                                    }
                                    return null;
                                    //   val = val?.replaceAll(" ", "").toString();
                                  }),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                              width: 300,
                              child: TextFormField(
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  labelStyle: TextStyle(color: Colors.white),
                                  labelText: "Date of birth",
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 2),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 2),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                onTap: () async {
                                  final DateTime? picked2 =
                                      await showDatePicker(
                                    context: context,
                                    initialDate: DateTime(1990),
                                    firstDate: DateTime(1950),
                                    lastDate: DateTime.now(),
                                  );
                                  if (picked2 != null) {
                                    setState(() {
                                      dob = picked2;
                                    });
                                  }
                                },
                                validator: (value) {
                                  if (dob == DateTime.now()) {
                                    return 'Please select valid birth date';
                                  }
                                  return null;
                                },
                                readOnly: true,
                                controller: TextEditingController(
                                  text: dob != null
                                      ? '${dob.toLocal()}'.split(' ')[0]
                                      : '',
                                ),
                                onSaved: (value) =>
                                    dob = DateTime.parse(value!),
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              width: 300,
                              child: TextFormField(
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    labelStyle: TextStyle(color: Colors.white),
                                    labelText: "Hiring date",
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 2),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 2),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  onTap: () async {
                                    final DateTime? picked =
                                        await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1950),
                                      lastDate: DateTime(2100),
                                    );
                                    if (picked != null) {
                                      setState(() {
                                        hiringDate = picked;
                                      });
                                    }
                                  },
                                  readOnly: true,
                                  controller: TextEditingController(
                                    text: this.hiringDate != null
                                        ? '${this.hiringDate.toLocal()}'
                                            .split(' ')[0]
                                        : '',
                                  ),
                                  onSaved: (value) {
                                    // print("this is hiring  " +   value.toString());
                                    this.hiringDate = DateTime.parse(value!);
                                  }),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                              width:
                                  MediaQuery.of(context).size.width - 1600 > 1
                                      ? MediaQuery.of(context).size.width - 1600
                                      : 300,
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.13)),
                                color: Colors.grey.shade200.withOpacity(0.23),
                              ),
                              child: CountryListPick(

                                  appBar: AppBar(
                                    backgroundColor: Colors.white,
                                    title: Text('Chose you county '),
                                  ),

                                  // if you need custome picker use this
                                  // pickerBuilder: (context, CountryCode countryCode){
                                  //   return Row(
                                  //     children: [
                                  //       Image.asset(
                                  //         countryCode.flagUri,
                                  //         package: 'country_list_pick',
                                  //       ),
                                  //       Text(countryCode.code),
                                  //       Text(countryCode.dialCode),
                                  //     ],
                                  //   );
                                  // },

                                  // To disable option set to false
                                  theme: CountryTheme(

                                    isShowFlag: true,
                                    isShowTitle: true,
                                    isShowCode: true,
                                    isDownIcon: true,
                                    showEnglishName: true,
                                  ),
                                  // Set default value
                                  initialSelection: '+62',
                                  // or
                                  // initialSelection: 'US'
                                  onChanged: (code) {
                                    this.selectedNationality = code!.name!;
                                    // print(this.selectedNationality);
                                  },
                                  // Whether to allow the widget to set a custom UI overlay
                                  useUiOverlay: true,
                                  // Whether the country list should be wrapped in a SafeArea
                                  useSafeArea: false),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 60,

                              child: Center(
                                child: WeekendDropdownMenu(
                                  onItemSelected: (c) {
                                    this.weekEndId = c;
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 60,
                              child: Center(
                                child:departmentsDropDownMenu(onItemSelected: (s ) {this.departmantID = s ; },),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              width:
                                  MediaQuery.of(context).size.width - 1750 > 1
                                      ? MediaQuery.of(context).size.width - 1750
                                      : 300,
                              child: GenderPicker(
                                initialGender: _selectedGender,
                                onGenderChanged: (gender) {
                                  try {
                                    setState(() {
                                      _selectedGender = gender;
                                      // print(_selectedGender);
                                    });
                                  } catch (e) {
                                    print(e);
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              height: 15,
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
                                    "* This page serves the purpose of partially adding a new employee. Please ensure that their details are accurate.",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height - 1100 > 1
                                      ? MediaQuery.of(context).size.height -
                                          1100
                                      : 10,
                            ),
                            Container(
                              width: 500,
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                  child: _isLoading
                                      ? CircularProgressIndicator()
                                      : Button(
                                          icon: Icons.add,
                                          onPress: () async {
                                            setState(() {
                                              _isLoading = true;
                                            });
                                            await _submit();
                                            setState(() {
                                              _isLoading = false;
                                            });
                                          },
                                          txt: 'Submit',
                                          isSelected: true)),
                            )
                          ],
                        ),
                      ],
                    ),
                  )),
            ),
          ),
          Positioned(
            child: sideBar(index: 0),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    try {
      if (this.xfile == null) {
        MyDialog.showAlert(context, "PLease upload you photo and try angin");
        return;
      }
      if (this.selectedNationality == "") {
        MyDialog.showAlert(context, "PLease select your nationality");
        return;
      }
      if (this.departmantID == "") {
        MyDialog.showAlert(context, "PLease select the department");
        return;
      }
      if (this.weekEndId == "") {
        MyDialog.showAlert(context, "PLease select the weekend");
        return;
      }

      _key2.currentState?.save();
      final v = _key2.currentState!.validate();

      if (v && weekEndId != "") {
        String url = await _uploadImageFile(this._email);
        await singUpNewEmployee(
            this._email,
            this._passwd,
            this._userName,
            url,
            this.phoneNr,
            this.position,
            this.dob,
            this.hiringDate,
            this.selectedNationality,
            this.weekEndId,
            this._selectedGender.toString().substring(9) ,
          this.departmantID

        );
        _key2.currentState!.reset();
        // MyDialog.showAlert(context, "New employee has been added successfully");
      }
    } catch (e) {
      MyDialog.showAlert(context, "error $e");
    }
  }

  final FirebaseStorage _storage =
      FirebaseStorage.instanceFor(bucket:/*'gs://hrms-6c649.appspot.com'*/ 'gs://hrmststi.appspot.com');

  Future<String> _uploadImageFile(String imageName) async {
    try {
      Uint8List? uint8list = await this.xfile!.readAsBytes();
      String fileName = imageName + path.extension(this.xfile!.name).toString();
      Reference firebaseStorageRef =
          _storage.ref().child('employees/$fileName');
      UploadTask uploadTask = firebaseStorageRef.putData(uint8list!);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } on FirebaseException catch (e) {
      print('File upload error: $e');
      throw e;
    }
  }

  Future<void> singUpNewEmployee(
      String email,
      String pass,
      String username,
      String url,
      String phoneNr,
      String position,
      DateTime dob,
      DateTime Hdate,
      String nationality,
      String weekEndId,
      String gender ,
      String departmentID) async {
    UserCredential s;
    try {
      final _auth = FirebaseAuth.instance;
      s = await _auth.createUserWithEmailAndPassword(
          email: email, password: pass);

      await FirebaseFirestore.instance
          .collection('Employee')
          .doc(s.user!.uid)
          .set({
        "photo": url,
        'userName': username,
        'email': email,
        'phoneNr': phoneNr,
        'position': position,
        'dob': dob,
        'hiringDate': Hdate,
        'nationality': nationality,
        'weekendId': weekEndId,
        'gender': gender,
        'departmentID' : departmentID
      });
      MyDialog.showAlert(context, "New employee has been added successfully.");
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
}

class WeekendDropdownMenu extends StatefulWidget {
  final Function(String) onItemSelected;

  WeekendDropdownMenu({required this.onItemSelected});

  @override
  _WeekendDropdownMenuState createState() => _WeekendDropdownMenuState();
}

class _WeekendDropdownMenuState extends State<WeekendDropdownMenu> {
  String? _selectedItem;
  List<String> _weekendTitles = [];
  List<String> _weekendDocIds = [];

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('weekEnd')
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
          'Select a weekend',
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
