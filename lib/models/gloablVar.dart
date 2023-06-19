import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class global extends ChangeNotifier {
  static var uid;
  static  TextStyle txtStyle1 = TextStyle(fontSize: 24 , color: Colors.white);

  static void set(u) {
    uid = u;
    print(uid);
  }

  static get uidd => uid;
}
