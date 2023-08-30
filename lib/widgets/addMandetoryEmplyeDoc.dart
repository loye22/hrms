import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hrms/models/staticVars.dart';

import 'button.dart';

class addMandetoryEmplyeDoc extends StatefulWidget {
//  const AddDepartmantForm({Key? key}) : super(key: key);

  @override
  State<addMandetoryEmplyeDoc> createState() => _addMandetoryEmplyeDocState();
}

class _addMandetoryEmplyeDocState extends State<addMandetoryEmplyeDoc> {
  String title = '';

  bool isLoding = false;

  void _onTitleChanged(String value) {
    setState(() {
      title = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 700,
      height: 500,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              image: DecorationImage(
                image: AssetImage('assests/tstiBackGround.jpg'),
                fit: BoxFit.fill,
              ),

            ),
            child: Container(
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(30),
                borderRadius: BorderRadius.all(Radius.circular(30)),

                border: Border.all(color: Colors.white.withOpacity(0.13)),
                color: Colors.grey.shade200.withOpacity(0.25),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              border: Border.all(color: Colors.white.withOpacity(0.13)),
              color: Colors.grey.shade200.withOpacity(0.23),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add required employee document.',
                    style: staticVars.textStyle2,
                  ),
                  SizedBox(height: 16),
                  TextField(
                    onChanged: _onTitleChanged,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            right: 10,
            child: Container(
              width: 120,
              height: 50,
              child: Center(
                child: isLoding
                    ? CircularProgressIndicator()
                    : Button(
                        txt: 'submit',
                        icon: Icons.subdirectory_arrow_left,
                        isSelected: true,
                        onPress: () async {
                          if (title == '') {
                            Navigator.pop(context);
                            return;
                          }
                          try {
                            setState(() {
                              isLoding = true;
                            });
                            FirebaseFirestore firestore =
                                FirebaseFirestore.instance;
                            DocumentReference docRef = await firestore
                                .collection('EmployeesMandatoryDocs')
                                .add({
                              'title': title,
                            });
                            setState(() {
                              isLoding = false;
                            });
                          } catch (e) {
                            print(e);
                          } finally {
                            setState(() {
                              isLoding = false;
                            });
                            Navigator.pop(context);
                          }
                        },
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
