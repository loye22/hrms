import 'package:flutter/foundation.dart';


class userdataa {
  final String email;
  final String name;
  final String uri;

  userdataa(
      {required this.email,
      required this.name,
      required this.uri});

  userdataa getUserData(){
    return this ;
  }

}

class AuthProvider extends ChangeNotifier {

  String? _token = "";
  userdataa? _userdata = userdataa(email: "defalt" ,name: "defalt",uri: "");
  String? _uid ;


  String? get token => _token;
  userdataa? get userdata => _userdata;
  String? get uid => _uid;

  void setUid(String s ){
    _uid = s  ;
    notifyListeners();

  }



  void setData(userdataa userdata,String token) {

    _token = token;
    _userdata= userdata ;
    notifyListeners();
  }
}
