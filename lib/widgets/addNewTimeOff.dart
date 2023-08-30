import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hrms/models/staticVars.dart';

import 'button.dart';

class addNewTimeOff extends StatefulWidget {
  @override
  _addNewTimeOffState createState() => _addNewTimeOffState();
}

class _addNewTimeOffState extends State<addNewTimeOff> {
  String title = '';
  int duration = 0;
  bool isLoding = false;

  final titleController = TextEditingController();
  final DurationController = TextEditingController();

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
                borderRadius: BorderRadius.circular(30),
                //borderRadius: BorderRadius.all(Radius.circular(30)),
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
                    'Add new time off ',
                    style: staticVars.textStyle2,
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: DurationController,
                    decoration: InputDecoration(
                      labelText: 'Duration',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
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
                          if (titleController.text == '' ||
                              int.parse(DurationController.text) == 0 ||
                              DurationController.text == "") {
                            Navigator.pop(context);
                            print("invalid input");
                            return;
                          }
                          try {
                            setState(() {
                              isLoding = true;
                            });
                            FirebaseFirestore firestore =
                                FirebaseFirestore.instance;

                            // Create a new document with an auto-generated ID
                            DocumentReference docRef =
                                await firestore.collection('timeOff').add({
                              'title': titleController.text,
                              'duration': DurationController.text,
                            });
                            setState(() {
                              isLoding = false;
                            });
                            //print(title  + " " +  description  + " " +  selectedDays.toString());
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
