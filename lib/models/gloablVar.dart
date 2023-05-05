

import 'package:flutter/cupertino.dart';

class global extends ChangeNotifier {



  static var uid ;



  static void set(u){
    uid = u ;
    print(uid);

  }

  static get uidd => uid ;


}