import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'button.dart';
//import 'package:image_picker/image_picker.dart';

class imagePicker extends StatefulWidget {
//  const imagePicker({Key? key}) : super(key: key);

  @override
  State<imagePicker> createState() => _imagePickerState();
  final Function(File image) _fun;

  imagePicker(this._fun);
}

class _imagePickerState extends State<imagePicker> {
   File _mfile = File(r'C:\Users\Louie\StudioProjects\hrms\lib\assests\x.png');

  void _picImage() async {
    var image = await ImagePicker.platform.pickImage(
      source: ImageSource.gallery,
      // imageQuality: 50,
      // maxWidth: 150

    );
    if (image == null) {
      return;
    }
    setState(() {
      //_mfile =image as File;
      _mfile = File(image.path);
    });
    widget._fun(_mfile);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 90,
          backgroundImage: AssetImage('assests/x.png'),

        ),
        Button(icon:Icons.camera , txt: 'Upload images ',onPress: (){},isSelected: true, ),



      ],
    );
  }
}