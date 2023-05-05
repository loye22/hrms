import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class companyDoc {
  final String title;

  final String des;

  final DateTime expDate;

  final String url;

  final String theUploader;

  companyDoc(
      {required this.title,
      required this.des,
      required this.expDate,
      required this.url,
      required this.theUploader});
}

class CompanyDocProvider extends ChangeNotifier {
  List<companyDoc> _companyDocs = [];

  List<companyDoc> get companyDocs => _companyDocs;

  void addCompanyDoc(companyDoc companyDoc) {
    _companyDocs.add(companyDoc);
    notifyListeners();
  }

  void removeCompanyDoc(int index) {
    _companyDocs.removeAt(index);
    notifyListeners();
  }

  void editCompanyDoc(int index, companyDoc updatedCompanyDoc) {
    _companyDocs[index] = updatedCompanyDoc;
    notifyListeners();
  }

  Future<void> loadCompanyDocsFromFirestore() async {
    final companyDocc = FirebaseFirestore.instance.collection('Company docs');
    final querySnapshot = await companyDocc.get();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();


    for (final data in allData) {
      final x = companyDoc(
        title: data['title'],
        des: data['des'],
        expDate: (data['expDate'] as Timestamp).toDate(),
        url: data['url'],
        theUploader: data['uploader'],
      );
      _companyDocs.add(x);
    }

    notifyListeners();


  }
}
