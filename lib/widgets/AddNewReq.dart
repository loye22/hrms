import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'button.dart';

class AddNewReq extends StatefulWidget {
  @override
  _AddNewReqState createState() => _AddNewReqState();
}

class _AddNewReqState extends State<AddNewReq> {
  String title = '';
  String selectedOption = 'Option 1';
  bool isLoading = false;

  final titleController = TextEditingController();

  final List<String> dropdownOptions = [
    'Option 1',
    'Option 2',
    'Option 3',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 1200,
      height: 500,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: LinearGradient(colors: [
                Color.fromRGBO(90, 137, 214, 1),
                Color.fromRGBO(95, 167, 210, 1),
                Color.fromRGBO(49, 162, 202, 1)
              ]),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
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
                    'Please enter the the requist name ',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
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
                  DropdownButtonFormField<String>(
                    value: selectedOption,
                    items: dropdownOptions.map((option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text(option),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedOption = value!;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Select the work flow',
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
                child: isLoading
                    ? CircularProgressIndicator()
                    : Button(
                        txt: 'Submit',
                        icon: Icons.subdirectory_arrow_left,
                        isSelected: true,
                        onPress: () async {
                          if (titleController.text == '') {
                            Navigator.pop(context);
                            print("Invalid input");
                            return;
                          }
                          try {
                            setState(() {
                              isLoading = true;
                            });


                            // Create a new document with an auto-generated ID

                            setState(() {
                              isLoading = false;
                            });
                          } catch (e) {
                            print(e);
                          } finally {
                            setState(() {
                              isLoading = false;
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
