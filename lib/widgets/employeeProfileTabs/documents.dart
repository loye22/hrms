import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hrms/models/yesNoDialog.dart';

import '../../models/Dialog.dart';
import 'dart:html' as html;


class documentTab extends StatefulWidget {
  final List<String> documentNames;
  final String eid;

  // final void Function(String documentName) deleteDocument;
  //final void Function(String documentName) uploadDocument;
  //final void Function(String documentName) downloadDocument;

  documentTab({
    required this.documentNames,
    required this.eid,
    // required this.deleteDocument,
    // required this.uploadDocument,
    // required this.downloadDocument,
  });

  @override
  State<documentTab> createState() => _documentTabState();
}

class _documentTabState extends State<documentTab> {
  bool isUploading = false;

  Future<void> Upload(String empID, BuildContext ctx, String docName) async {
    try {
      await showDialog(
        context: ctx,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Alert'),
            content:
                Text("Please choose the expiration date for this document"),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'OK',
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      final date = await _selectDate(ctx);
      // print(date);
      // print(date.toString().substring(0,11));
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        final FirebaseStorage storage =
            FirebaseStorage.instanceFor(bucket: 'gs://hrmststi.appspot.com'  /*'gs://hrms-6c649.appspot.com'*/);
        final String fileName =
            DateTime.now().microsecondsSinceEpoch.toString() +
                "__" +
                result.files.first.name!;
        Reference storageRef =
            storage.ref().child('employeeDouments/$fileName');
        final UploadTask uploadTask =
            storageRef.putData(result.files.first.bytes!);

        setState(() {
          isUploading = true;
        });

        final TaskSnapshot snapshot = await uploadTask;
        final String downloadUrl = await snapshot.ref.getDownloadURL();
        final String documentName = docName;
        final String employeeId = empID; // replace with the actual employee id

        await FirebaseFirestore.instance
            .collection('Employee')
            .doc(employeeId)
            .collection('documents')
            .doc()
            .set({
          "documentName": documentName,
          "url": downloadUrl,
          "expDate": date.toString().substring(0, 11),
          // set the expiration date to 30 days from now
        });
        setState(() {
          isUploading = false;
        });

        MyDialog.showAlert(context, "Your document uploaded successfully");
      } else {
        MyDialog.showAlert(context, "Please pick a file and try again");
      }
    } catch (error) {
      MyDialog.showAlert(context, "Error $error");
    }
  }

  Future<DateTime?> _selectDate(BuildContext context) async {
    DateTime? selectedDate = DateTime.now();
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate!,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));

    if (picked != null && picked != selectedDate) selectedDate = picked;

    return selectedDate;
  }

  Future<String?> getEmployeeDocumentUrl(
      String employeeId, String documentName) async {
    try {
      final documentsCollectionRef = FirebaseFirestore.instance
          .collection('Employee')
          .doc(employeeId)
          .collection('documents');
      final querySnapshot = await documentsCollectionRef
          .where('documentName', isEqualTo: documentName)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        final documentSnapshot = querySnapshot.docs.first;
        final data = documentSnapshot.data();
        final expDate = data['expDate'] as String;
        final url = data['url'] as String;
        return url;
      } else {
        MyDialog.showAlert(context, "This dopcument not found ");
        return null;
      }
    } catch (e) {
      MyDialog.showAlert(context, "error $e");
    }
  }

  Future<void> deleteEmployeeDocument(
      String employeeId, String documentName) async {
    try {
      final documentsCollectionRef = FirebaseFirestore.instance
          .collection('Employee')
          .doc(employeeId)
          .collection('documents');
      final querySnapshot = await documentsCollectionRef
          .where('documentName', isEqualTo: documentName)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        final documentSnapshot = querySnapshot.docs.first;
        await documentSnapshot.reference.delete();
        MyDialog.showAlert(context, "Document deleted successfully!");
        //print('Document deleted successfully!');
      } else {
        MyDialog.showAlert(context, "Document does not exist!");
        //print('Document does not exist!');
      }
    } catch (e) {
      MyDialog.showAlert(context, "Error $e");
    }
  }

  Future<String> missing2(String employeeId, String documentName) async {
    try {
      final documentsCollectionRef = FirebaseFirestore.instance
          .collection('Employee')
          .doc(employeeId)
          .collection('documents');
      final querySnapshot = await documentsCollectionRef
          .where('documentName', isEqualTo: documentName)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        final querySnapshot = await FirebaseFirestore.instance
            .collection('Employee')
            .doc(employeeId)
            .collection('documents')
            .where('expDate', isNotEqualTo: null)
            .limit(1)
            .get();
        final expDate = querySnapshot.docs[0].get('expDate');

        return expDate.toString(); // Document exists, return empty string
      } else {
        return "null";
      }
    } catch (e) {
      MyDialog.showAlert(context, "Error $e");
      return ""; // Return empty string if an error occurs
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //width:MediaQuery.of(context).size.width - 650,
      padding: EdgeInsets.all(30),
      child: isUploading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.documentNames.map((documentName) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: FutureBuilder(
                          future: missing2(widget.eid, documentName),
                          builder: (ctx, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasData) {
                              return Row(
                                children: [
                                  Text(
                                    documentName,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  snapshot.data != "null"
                                      ? Text(
                                          "Exp data"+snapshot.data!.toString(),
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        )
                                      : Text(
                                          "  * missing",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10,
                                              color: Colors.red),
                                        ),
                                ],
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red, size: 35),
                        onPressed: () {
                          MyAlertDialog.showConfirmationDialog(context,
                              "Do you confirm your intention to delete this?",
                              () {
                            deleteEmployeeDocument(widget.eid, documentName);
                          }, () {});
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.upload_file,
                            color: Colors.green, size: 35),
                        onPressed: () {
                          Upload(this.widget.eid, context,
                              documentName.toString());
                        },
                      ),
                      IconButton(
                        icon:
                            Icon(Icons.download, color: Colors.blue, size: 35),
                        onPressed: () async {
                          try {
                            final s = await getEmployeeDocumentUrl(
                                widget.eid, documentName);
                            if (s == null) return;
                            html.window.open(s != null ? s : "", 'new tab');
                          } catch (e) {
                            MyDialog.showAlert(context, e.toString());
                            print(e);
                          }
                        },
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
    );
  }
}
