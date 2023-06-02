import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../webSIte/test.dart';
import 'button.dart';

class addLocations extends StatefulWidget {
  @override
  _addLocationsState createState() => _addLocationsState();
}

class _addLocationsState extends State<addLocations> {
  late List<String> bracnshesList;

  bool isLoding = false;
  String? _selectedBranch;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 1200,
      height: 500,
      child: FutureBuilder(
        future: _fetchBranches(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final branches = snapshot.data;

            return Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: LinearGradient(colors: [
                        Color.fromRGBO(90, 137, 214, 1),
                        Color.fromRGBO(95, 167, 210, 1),
                        Color.fromRGBO(49, 162, 202, 1)
                      ])),
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
                  width: double.infinity,
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
                          'Please assign the office location to the barnsh',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 100,
                  child: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) =>
                        Container(
                      width: MediaQuery.of(context).size.width - 1500,
                      child: DropdownButtonFormField<String>(
                        value: _selectedBranch,
                        hint: Text('Select a branch'),
                        onChanged: (value) {
                          setState(() {
                            _selectedBranch = value!;
                          });
                        },
                        items: branches!.map((branch) {
                          return DropdownMenuItem<String>(
                            value: branch,
                            child: Text(branch),
                          );
                        }).toList(),
                      ),
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
                              onPress: () async {},
                            ),
                    ),
                  ),
                ),
                Container(
                  width: 500,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: Colors.black , width: 5)
                  ),

                    child: ClipRect(
                        clipBehavior: Clip.antiAlias,
                        child: test()))
              ],
            );
          }
        },
      ),
    );
  }

  Future<List<String>> _fetchBranches() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('branchs').get();
    final branches =
        snapshot.docs.map((doc) => doc['title'] as String).toList();
    this.bracnshesList = branches;
    return branches;
  }
}
