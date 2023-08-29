import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:firebase/firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hrms/models/Dialog.dart';
import 'package:hrms/models/staticVars.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:hrms/provider/UserData.dart';
import '../models/yesNoDialog.dart';
import '../provider/companyDoc.dart';
import '../widgets/rightBar.dart';
import '../widgets/sideBar.dart';
import 'dart:html' as html;
import 'package:http/http.dart' as http;


class companyDocScreen extends StatefulWidget {
  static const routeName = '/companyDocScreen';

  const companyDocScreen({Key? key}) : super(key: key);

  @override
  State<companyDocScreen> createState() => _companyDocScreenState();
}

class _companyDocScreenState extends State<companyDocScreen> {
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
          rightBar(),
          /*Positioned(
            left: 280,
            top: 15,
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
                  'Company doucments',
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
                width: MediaQuery
                    .of(context)
                    .size
                    .width - 650,
                height: MediaQuery
                    .of(context)
                    .size
                    .height - 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  border:
                  Border.all(color: Colors.black.withOpacity(0.33)),
                  color: Colors.grey.shade200.withOpacity(0.23),
                ),
              child: FutureBuilder(
                future: this.loadCompanyDocsFromFirestore(),
                builder: (ctx ,response ) =>response.connectionState == ConnectionState.waiting ? Center(child: CircularProgressIndicator()) :
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child:Container(
                    width:  MediaQuery.of(context).size.width - 650,
                    height: MediaQuery.of(context).size.height - 150,
                    padding: EdgeInsets.all(12),
                    child: DataTable2(
                      columnSpacing: 12,
                      horizontalMargin: 12,
                      minWidth: 600,
                      columns: [
                        DataColumn2(
                          label: Text('Title'),
                          size: ColumnSize.L,
                        ),
                        DataColumn2(
                          label: Text('Description'),
                          size: ColumnSize.L,
                        ),
                        DataColumn2(
                          label: Text('Expiration Date'),
                          size: ColumnSize.M,
                        ),
                        DataColumn2(
                          label: Text('Uploaded By'),
                          size: ColumnSize.S,
                        ),
                        DataColumn2(
                          label: Text('More Options'),
                          size: ColumnSize.S,
                        ),
                      ],
                      rows: response.data!
                          .map((item) {
                        return DataRow2(
                          onTap: (){
                         //

                          },

                        //  onSelectChanged: (s) {},
                          cells: [
                            DataCell(Text(item['title'] ?? '')),
                            DataCell(Text(item['description'] ?? '')),
                            DataCell(Text(item['expDate']?.toDate().toString().substring(0, 10) ?? '')),
                            DataCell(Text(item['uploader'] ?? '')),
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: ()  async {
                                      try{

                                        html.window.open(item['url'], 'new tab');
                                      }
                                      catch(e){
                                        MyDialog.showAlert(context, e.toString());
                                        print(e);
                                      }



                                    },
                                    icon: Icon(Icons.download , color: Colors.green,),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                     try{
                                       MyAlertDialog.showConfirmationDialog(context, "Are you sure you want to delete this document ? ", (){
                                         final documentId = item['id'];
                                         final collectionReference = FirebaseFirestore.instance.collection('Company docs');
                                         final documentReference = collectionReference.doc(documentId);

                                         documentReference.delete().then((_) {
                                           MyDialog.showAlert(context, "Document Deleted Successfully");
                                           setState(() {});
                                           //  print("Document Deleted Successfully");
                                         }).catchError((error) {
                                           //  print("Failed to delete document: $error");
                                           MyDialog.showAlert(context, "Failed to delete document $error");
                                         });
                                       }, (){});
                                       //html.window.location.reload();
                                       //     setState(() {});
                                     }
                                     catch(e){
                                       MyDialog.showAlert(context, e.toString());
                                   //    print(e.toString());
                                     }
                                     finally{

                                     }



                                    },
                                    icon: Icon(Icons.delete , color: Colors.red,),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      })
                          .toList(),
                    ),
                  ),



                ) ,

              ),
            ),
          ),
          Positioned(
            child: sideBar(index: 7,),
          ),
        ],
      ),
    );
  }


  Future<List<Map<String, dynamic>>> loadCompanyDocsFromFirestore() async {
    final companyDocc = FirebaseFirestore.instance.collection('Company docs');
    final querySnapshot = await companyDocc.get();
    final allData = querySnapshot.docs.map((doc) =>
    {
      ...doc.data(), // Spread the existing data into the new Map
      'id': doc.id, // Add a new key-value pair for the document ID
    }
    ).toList();

    return allData;
  }







}



