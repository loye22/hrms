import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'button.dart';

class AddWeekendForm extends StatefulWidget {
  @override
  _AddWeekendFormState createState() => _AddWeekendFormState();
}

class _AddWeekendFormState extends State<AddWeekendForm> {
  String title = '';
  String description = '';
  List<String> selectedDays = [];
  List<String> daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];
  bool isLoding = false ;

  void _onTitleChanged(String value) {
    setState(() {
      title = value;
    });
  }

  void _onDescriptionChanged(String value) {
    setState(() {
      description = value;
    });
  }

  void _onDaySelected(bool selected, String day) {
    setState(() {
      if (selected) {
        selectedDays.add(day);
      } else {
        selectedDays.remove(day);
      }
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
                    'Add New Weekend',
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
                  SizedBox(height: 16),
                  TextField(
                    onChanged: _onDescriptionChanged,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Days:',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: daysOfWeek.map((day) {
                      return FilterChip(
                        label: Text(day),
                        selected: selectedDays.contains(day),
                        onSelected: (selected) => _onDaySelected(selected, day),
                        selectedColor: Colors.blue,
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Selected Days: ${selectedDays.join(", ")}',
                    style: TextStyle(fontSize: 16, color: Colors.white),
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
                    child:isLoding ? CircularProgressIndicator() :  Button(
                  txt: 'submit',
                  icon: Icons.subdirectory_arrow_left,
                  isSelected: true,
                  onPress: () async {
                    if(title == '' || description == '' || selectedDays == []){
                      Navigator.pop(context);
                      return ;
                    }
                    try{
                      setState(() {isLoding = true ; });
                      FirebaseFirestore firestore = FirebaseFirestore.instance;

                      // Create a new document with an auto-generated ID
                      DocumentReference docRef = await firestore.collection('weekEnd').add({
                        'title': title,
                        'description': description,
                        'days': selectedDays,
                      });
                      setState(() {isLoding = false ; });
                      //print(title  + " " +  description  + " " +  selectedDays.toString());




                    }
                    catch(e){
                      print(e);

                    }
                    finally{
                      setState(() {isLoding = false ; });
                      Navigator.pop(context);
                    }


                  },
                ),),),
          ),
        ],
      ),
    );
  }
}
