import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../provider/employeeProfileProvider.dart';

class PersonalTab extends StatelessWidget {
  final EmployeeProfile employeeProfile;

  const PersonalTab({Key? key, required this.employeeProfile})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [],
                ),
              ],
            ),
            SizedBox(height: 8),
            _buildPersonalInfoItem('Position', employeeProfile.position),
            FutureBuilder(
                future: getDepartmentTitle(employeeProfile.departmentID),
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else {
                    final depName = snapshot.data;
                   // print(depName);
                    return _buildPersonalInfoItem('Depatment',
                        depName != null ? depName : "not Found 404 error");
                  }
                }),
            _buildPersonalInfoItem('Date of Birth',
                DateFormat.yMMMMd().format(employeeProfile.dob)),
            _buildPersonalInfoItem('Email', employeeProfile.email),
            _buildPersonalInfoItem('Gender', employeeProfile.gender),
            _buildPersonalInfoItem('Hiring Date',
                DateFormat.yMMMMd().format(employeeProfile.hiringDate)),
            _buildPersonalInfoItem('Nationality', employeeProfile.nationality),
            _buildPersonalInfoItem('Phone Number', employeeProfile.phoneNr),
            FutureBuilder(
                future: getWeekendTitle(employeeProfile.weekendId),
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else {
                    final weekendTitle = snapshot.data;
                    return _buildPersonalInfoItem(
                      'Weekends',
                      weekendTitle != null
                          ? weekendTitle
                          : "not Found 404 error",
                    );
                  }
                })
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInfoItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Future<String> getWeekendTitle(String documentId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('weekEnd')
        .doc(documentId)
        .get();

    final title = snapshot.data()?['title'] ?? '';
    final days = (snapshot.data()?['days'] ?? [])
        .map<String>((day) => day.toString())
        .join(', ');

    return '$title: $days';
  }

  Future<String> getDepartmentTitle(String depId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('Departments')
        .doc(depId)
        .get();

    final title = snapshot.data()?['title'] ?? '';

    return title;
  }
}
