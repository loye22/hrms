import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hrms/models/Dialog.dart';
import 'package:hrms/models/staticVars.dart';
import 'package:intl/intl.dart';

class WorkHoursPicker extends StatefulWidget {
  final String title;

  const WorkHoursPicker({Key? key, required this.title}) : super(key: key);

  @override
  _WorkHoursPickerState createState() => _WorkHoursPickerState();
}

class _WorkHoursPickerState extends State<WorkHoursPicker> {
  TimeOfDay _startTime = TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = TimeOfDay(hour: 17, minute: 0);

  void _selectStartTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _startTime,
    );
    if (picked != null) {
      setState(() {
        _startTime = picked;
      });
    }
  }

  void _selectEndTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _endTime,
    );
    if (picked != null) {
      setState(() {
        _endTime = picked;
      });
    }
  }
  bool isLoding = false ;
  @override
  Widget build(BuildContext context) {
    final TextEditingController _titleController = TextEditingController();


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
                border: Border.all(
                  color: Colors.white.withOpacity(0.13),
                ),
                color: Colors.grey.shade200.withOpacity(0.25),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              border: Border.all(
                color: Colors.white.withOpacity(0.13),
              ),
              color: Colors.grey.shade200.withOpacity(0.23),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: staticVars.textStyle2,
                  ),
                  SizedBox(height: 16,),
                  Text(
                    'Please add title',
                    style: staticVars.textStyle2,
                  ),
                  SizedBox(height: 10,),
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: Colors.grey.shade200,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 16.0,
                      ),
                    ),
                  ),


                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Start Time',
                              style: staticVars.textStyle2,
                            ),
                            SizedBox(height: 8),
                            GestureDetector(
                              onTap: () => _selectStartTime(context),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 16,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.grey.shade200,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      color: Colors.grey.shade600,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      DateFormat('hh:mm a').format(DateTime(
                                          0,
                                          0,
                                          0,
                                          _startTime.hour,
                                          _startTime.minute)),
                                      style: staticVars.textStyle2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'End Time',
                              style: staticVars.textStyle2,
                            ),
                            SizedBox(height: 8),
                            GestureDetector(
                              onTap: () => _selectEndTime(context),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 16,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.grey.shade200,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      color: Colors.grey.shade600,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      DateFormat('hh:mm a').format(DateTime(
                                          0,
                                          0,
                                          0,
                                          _endTime.hour,
                                          _endTime.minute)),
                                      style: staticVars.textStyle2,
                                    ),
                                  ],
                                ),
                              ),
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
          Positioned(
            bottom: 10,
            left: 10,
            right: 10,
            child: Container(
              width: 120,
              height: 50,
              child:isLoding ? Center(child: CircularProgressIndicator(),) :  ElevatedButton(
                onPressed: () async {
                  if (_titleController.text.isEmpty) {
                    // Handle empty title case
                    MyDialog.showAlert(context, 'Please add the title') ;
                    return;
                  }

                  try {
                    setState(() {
                      isLoding = true;
                    });
                    //print( "${_titleController.text} \n"+_startTime.format(context).toString()  + " -------------- "  +  _endTime.toString());

                    // Get a reference to the Firestore collection
                    final CollectionReference branchsCollection =
                    FirebaseFirestore.instance.collection('workingHours');

                    // Add a new document to the collection with the entered title
                    await branchsCollection.add({
                      'title': _titleController.text.toLowerCase().substring(0,7),
                      'time' :_startTime.format(context).toString() + " " + _endTime.format(context).toString()
                    });

                    setState(() {
                      isLoding = false;
                    });

                    // Success, do something if needed
                  } catch (e) {
                    print(e);
                    // Handle error if needed
                  } finally {
                    setState(() {
                      isLoding = false;
                    });
                    Navigator.pop(context);
                  }
                },

                child: Text('Submit'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
