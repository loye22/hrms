import 'dart:async';
import 'dart:html' ;


import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_web_view/easy_web_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hrms/models/gloablVar.dart';
import 'package:hrms/models/staticVars.dart';
import 'package:hrms/widgets/rightBar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:path/path.dart' as path;
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hrms/webSIte/singUpScreen.dart';
import 'package:pdf_render/pdf_render_widgets.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:http/http.dart' as http;
import '../models/Dialog.dart';
import '../provider/UserData.dart';
import '../provider/companyDoc.dart';
import '../widgets/button.dart';
import '../widgets/emplyeeCard.dart';
import '../widgets/iconWiget.dart';
import '../widgets/sideBar.dart';

class companyDocAdd extends StatefulWidget {
  static const routeName = '/companyDocAdd';

  @override
  State<companyDocAdd> createState() => _companyDocAddState();
}

class _companyDocAddState extends State<companyDocAdd> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  late DateTime _expirationDate = DateTime(1999);
  late SfPdfViewer PDFfile;
  late PlatformFile file;

  bool isPdfLoaded = false;
  bool isLoading = false;

  TextEditingController _Tcontroller = TextEditingController();
  TextEditingController _Dcontroller = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    this.isPdfLoaded = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width - 1250;


    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration:  staticVars.tstiBackGround, /*BoxDecoration(
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
            left: 290,
            top: 50,
            child: Container(
              width: MediaQuery.of(context).size.width - 650,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: Colors.white.withOpacity(0.13)),
                color: Colors.grey.shade200.withOpacity(0.23),
              ),
              child: Center(
                child: Text(
                  'Add new company document',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ),*/
          Positioned(
              left: 290,
              top: 20,
              child: Container(
                width: MediaQuery.of(context).size.width - 650,
                height: MediaQuery.of(context).size.height - 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: Colors.black.withOpacity(0.33)),
                  color: staticVars.c1,
                ),
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width < 1920 ?  400 :  MediaQuery.of(context).size.width - 1400,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 2),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30)),
                              child: isPdfLoaded
                                  ? this.PDFfile
                                  : Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.cloud_upload_rounded,
                                            color: Colors.white,
                                            size: 200,
                                          ),
                                          Text(
                                            "Please upload your document",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                              /*SfPdfViewer.network(
                                  'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf'),*/
                            ),
                          ),

                          //    child: SfPdfViewer.memory(bytes),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 16),
                            Container(
                              width: w,
                              child: TextFormField(
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  labelStyle: TextStyle(color: Colors.white),
                                  labelText: 'Title',
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
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a title';
                                  }
                                  return null;
                                },
                                onSaved: (value) => _title = value!,
                              ),
                            ),
                            SizedBox(height: 16),
                            Container(
                              width: w,
                              child: TextFormField(
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  labelStyle: TextStyle(color: Colors.white),
                                  labelText: "Description",
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
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a description';
                                  }
                                  return null;
                                },
                                onSaved: (value) => _description = value!,
                              ),
                            ),
                            SizedBox(height: 16),
                            Container(
                              width: w,
                              child: TextFormField(
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  labelStyle: TextStyle(color: Colors.white),
                                  labelText: "Expiration Date",
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
                                  final DateTime? picked = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2100),
                                  );
                                  if (picked != null) {
                                    setState(() {
                                      _expirationDate = picked;
                                    });
                                  }
                                },
                                validator: (value) {
                                  if (_expirationDate == null) {
                                    return 'Please select an expiration date';
                                  }
                                  return null;
                                },
                                readOnly: true,
                                controller: TextEditingController(
                                  text: _expirationDate != null
                                      ? '${_expirationDate.toLocal()}'
                                          .split(' ')[0]
                                      : '',
                                ),
                                onSaved: (value) =>
                                    _expirationDate = DateTime.parse(value!),

                              ),
                            ),
                            SizedBox(height: 16),
                            Container(
                              width: w,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Button(
                                      icon: Icons.picture_as_pdf,
                                      onPress: picUpfile,
                                      txt: "Pic up the document",
                                      isSelected: true),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  this.isLoading
                                      ? CircularProgressIndicator()
                                      : Consumer<AuthProvider>(
                                          builder: (ctx, p, _) => Button(
                                              icon: Icons.upload,
                                              onPress: () async {
                                                try {
                                                  if (!isPdfLoaded) {
                                                    MyDialog.showAlert(
                                                        context,
                                                        "Please upload the document first");
                                                    this.isLoading = false;
                                                    setState(() {});
                                                    return;
                                                  }
                                                  if (_formKey.currentState!
                                                      .validate() ==
                                                      false) {
                                                    MyDialog.showAlert(
                                                        context, "Please enter the document details");
                                                    return;
                                                  }
                                                  setState(() {
                                                    isLoading = true;
                                                  });

                                                  if (_formKey.currentState!
                                                      .validate()) {
                                                    _formKey.currentState!
                                                        .save();

                                                    // uploading the document
                                                    final FirebaseStorage
                                                        _storage =
                                                        FirebaseStorage.instanceFor(
                                                            bucket:'gs://hrmststi.appspot.com'
                                                                /*'gs://hrms-6c649.appspot.com'*/);
                                                    Reference storageRef =
                                                        _storage.ref().child(
                                                            'companyDocs/${DateTime.now().microsecondsSinceEpoch.toString()  +"__"+this.file.name }');
                                                    final uploadTask =
                                                        storageRef.putData(
                                                            this.file.bytes!);
                                                    final snapshot =
                                                        await uploadTask
                                                            .whenComplete(
                                                                () => null);
                                                    final downloadUrl =
                                                        await snapshot.ref
                                                            .getDownloadURL();


                                                    this.isPdfLoaded = false;
                                                    this.isLoading = false;
                                                    setState(() {});
                                                    companyDoc cd = companyDoc(
                                                      title: this._title,
                                                      des: this._description,
                                                      url: downloadUrl
                                                          .toString(),
                                                      theUploader: p
                                                          .userdata!.name
                                                          .toString(),
                                                      expDate:
                                                          this._expirationDate,
                                                    );

                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection(
                                                            'Company docs')
                                                        .doc(p.uid)
                                                        .set({
                                                      "title": cd.title,
                                                      "description": cd.des,
                                                      "expDate": cd.expDate ,
                                                      "uploader" : cd.theUploader ,
                                                      "url" : cd.url
                                                    }).then((value) {
                                                      MyDialog.showAlert(
                                                          context,
                                                          "Your document uploaded successfully ");

                                                    });
                                                    //  print(cd.title+ "\n" + cd.des + "\n" + cd.url + "\n" +cd.theUploader+ "\n" +cd.expDate.toString());

                                                    //  completer.complete(downloadUrl);
                                                  }
                                                } catch (e) {
                                                  MyDialog.showAlert(
                                                      context, "Error $e");
                                                  print(e);
                                                }
                                                finally{
                                                  _formKey.currentState!.reset();
                                                  _Dcontroller.clear();
                                                  _Tcontroller.clear();

                                                }
                                              },
                                              txt: "Upload the document",
                                              isSelected: true),
                                        ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )),
          Positioned(
            child: sideBar(index: 0,),
          ),
        ],
      ),
    );
  }

  Future<String> uploadFile() async {

    final input = FileUploadInputElement()..accept = 'image/*,application/pdf';

    input.click();

    final completer = Completer<String>();

    input.onChange.listen((event) async {
      final file = input.files!.first;

      final fileName = file.name;

      // Check the file type
      final fileType = fileName.split('.').last;
      if (fileType != 'jpg' &&
          fileType != 'jpeg' &&
          fileType != 'png' &&
          fileType != 'pdf') {
        // Handle invalid file type
        return;
      }

      final FirebaseStorage _storage =
          FirebaseStorage.instanceFor(bucket: 'gs://hrms-6c649.appspot.com');
      Reference storageRef = _storage.ref().child('companyDocs/$fileName');
      final uploadTask = storageRef.putBlob(file);
      final snapshot = await uploadTask.whenComplete(() => null);
      final downloadUrl = await snapshot.ref.getDownloadURL();
      completer.complete(downloadUrl);
    });

    return completer.future;
  }

  Future<void> picUpfile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        this.file = result.files.first;
        this.PDFfile = await SfPdfViewer.memory(await file.bytes as Uint8List);
        this.isPdfLoaded = true;
        setState(() {});
      } else {
        // User canceled the picker
        MyDialog.showAlert(context, "please pic up file and try again");
      }
    } catch (e) {
      MyDialog.showAlert(context, "error $e");
    }
  }
}
