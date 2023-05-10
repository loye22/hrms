import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'button.dart';

class AddDepartmantForm extends StatefulWidget {
//  const AddDepartmantForm({Key? key}) : super(key: key);

  @override
  State<AddDepartmantForm> createState() => _AddDepartmantFormState();
}

class _AddDepartmantFormState extends State<AddDepartmantForm> {
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
      width: MediaQuery.of(context).size.width - 1200,
      height: 500,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                gradient: LinearGradient(colors: [
                  Color.fromRGBO(90, 137, 214, 1),
                  Color.fromRGBO(95, 167, 210, 1),
                  Color.fromRGBO(49, 162, 202, 1)
                ])),
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
                    'Add New Department',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
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
                            DocumentReference docRef =
                                await firestore.collection('Departments').add({
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
