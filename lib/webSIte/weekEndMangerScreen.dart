import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hrms/models/staticVars.dart';
import 'package:hrms/models/yesNoDialog.dart';

import '../widgets/rightBar.dart';
import '../widgets/sideBar.dart';
import '../widgets/AddWeekendForm.dart';

class weekEndMangerScreen extends StatefulWidget {
  static const routeName = '/weekEndMangerScreen';

  //const weekEndMangerScreen({Key? key}) : super(key: key);

  @override
  State<weekEndMangerScreen> createState() => _weekEndMangerScreenState();
}

class _weekEndMangerScreenState extends State<weekEndMangerScreen> {
  List<DataRow> _rows = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: staticVars.tstiBackGround ,  /*BoxDecoration(
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

          Positioned(
            left: 280,
            top: 40,
            child: Container(
              width: MediaQuery.of(context).size.width - 650,
              height: MediaQuery.of(context).size.height - 130,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: Colors.black.withOpacity(0.33)),
                color: Colors.grey.shade200.withOpacity(0.23),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  width: MediaQuery.of(context).size.width - 650,
                  height: MediaQuery.of(context).size.height - 150,
                  padding: EdgeInsets.all(12),
                  child: DataTable2(
                    columnSpacing: 12,
                    horizontalMargin: 12,
                    minWidth: 600,
                    columns: [
                      DataColumn2(
                        label: Text('Title'),
                        size: ColumnSize.S,
                      ),
                      DataColumn2(
                        label: Text('Dayes'),
                        size: ColumnSize.L,
                      ),
                      DataColumn2(
                        label: Text('Description'),
                        size: ColumnSize.S,
                      ),
                      DataColumn2(
                        label: Text('More options'),
                        size: ColumnSize.S,
                      ),
                    ],
                    rows: _rows,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            child: sideBar(index: 0,),
          ),
          Positioned(
            left: 280,
            bottom: 15,
            child: InkWell(
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
                    'Add new weekend',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
              onTap: () async {
                try {
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                        backgroundColor: Colors.transparent,
                        content: AddWeekendForm()),);

                   await this._fetchData();
                } catch (e) {
                  print(e);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _fetchData() async {
    try {
      // Access the Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Query the form_data collection
      QuerySnapshot querySnapshot = await firestore.collection('weekEnd').get();

      // Iterate over each document and create a DataRow for each one
      List<DataRow> rows = querySnapshot.docs.map((doc) {
        // Extract the fields from the document data
        String title = doc.get('title');
        String description = doc.get('description');
        List<String> days = List<String>.from(doc.get('days'));

        // Create the DataRow with the extracted fields
        DataRow row = DataRow(
          cells: [
            DataCell(Text(title)),
            DataCell(Text(days.join(', '))),
            DataCell(Text(description)),
            DataCell(
              IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                onPressed: () async {
                  try {
                    await MyAlertDialog.showConfirmationDialog(
                        context, "Are you sure you want to delete this ?", () async {
                      await FirebaseFirestore.instance
                          .collection('weekEnd')
                          .doc(doc.id)
                          .delete();
                      _fetchData();
                    }, () {});
                  } catch (e) {
                    print(e);
                  }
                },
              ),
            ),
          ],
        );

        return row;
      }).toList();

      // Update the state with the rows
      setState(() {
        _rows = rows;
      });
    } catch (e) {
      print('Error fetching form data: $e');
      // Handle the error as needed
    }
  }
}
