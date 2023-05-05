
import 'package:flutter/foundation.dart';


class EmployeeProfilesProvider with ChangeNotifier {
  List<EmployeeProfile> _employeeProfiles = [];

  List<EmployeeProfile> get employeeProfiles => _employeeProfiles;

  void addEmployeeProfile(EmployeeProfile employeeProfile) {
    final existingProfile = _employeeProfiles.firstWhere(
          (profile) => profile.userName == employeeProfile.userName,
      orElse: () => EmployeeProfile(
        departmentID: '',
        eId: "",
        dob: DateTime(2000),
        email: '',
        gender: '',
        hiringDate: DateTime(2000),
        nationality: '',
        phoneNr: '',
        photo: '',
        position: '',
        userName: '',
        weekendId: '',
      ),
    );

    if (existingProfile.userName == '') {
      _employeeProfiles.add(employeeProfile);
      notifyListeners();
    }
  }


  void removeEmployeeProfile(EmployeeProfile employeeProfile) {
    _employeeProfiles.remove(employeeProfile);
    notifyListeners();
  }

  void updateEmployeeProfile(EmployeeProfile oldProfile, EmployeeProfile newProfile) {
    final index = _employeeProfiles.indexOf(oldProfile);
    _employeeProfiles[index] = newProfile;
    notifyListeners();
  }
  int getEmployeeProfilesLength() {
    return _employeeProfiles.length;
  }

  EmployeeProfile getEmployeeProfileByEid(String eid) {
    return _employeeProfiles.firstWhere((profile) => profile.eId == eid, orElse: () => EmployeeProfile(
      eId: "",
      departmentID: '',
      dob: DateTime(2000),
      email: '',
      gender: '',
      hiringDate: DateTime(2000),
      nationality: '',
      phoneNr: '',
      photo: '',
      position: '',
      userName: '',
      weekendId: '',
    ),);
  }



}




class EmployeeProfile {
  final String departmentID;
  final DateTime dob;
  final String email;
  final String gender;
  final DateTime hiringDate;
  final String nationality;
  final String phoneNr;
  final String photo;
  final String position;
  final String userName;
  final String weekendId;
  final String eId ;

  EmployeeProfile( {
    required this.eId ,
    required this.departmentID,
    required this.dob,
    required this.email,
    required this.gender,
    required this.hiringDate,
    required this.nationality,
    required this.phoneNr,
    required this.photo,
    required this.position,
    required this.userName,
    required this.weekendId,
  });
  @override
  String toString() {
    return 'Employee Profile:\n'
        '-----------------\n'
        'Department ID: $departmentID\n'
        'DOB: $dob\n'
        'Email: $email\n'
        'Gender: $gender\n'
        'Hiring Date: $hiringDate\n'
        'Nationality: $nationality\n'
        'Phone Number: $phoneNr\n'
        'Photo URL: $photo\n'
        'Position: $position\n'
        'Username: $userName\n'
        'Weekend ID: $weekendId';
  }
}

