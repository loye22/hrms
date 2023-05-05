import 'package:flutter/material.dart';
import 'package:hrms/models/gloablVar.dart';

import '../models/gender.dart';



class GenderPicker extends StatefulWidget {
  final Genderss initialGender;
  final ValueChanged<Genderss>? onGenderChanged;

  const GenderPicker({
    Key? key,
    required this.initialGender,
    this.onGenderChanged,
  }) : super(key: key);

  @override
  _GenderPickerState createState() => _GenderPickerState();
}

class _GenderPickerState extends State<GenderPicker> {
  late Genderss _selectedGender;

  @override
  void initState() {
    super.initState();
    _selectedGender = widget.initialGender;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text('Male'),
          leading: Radio(
            value: Genderss.male,
            groupValue: _selectedGender,
            onChanged: (value) {
              setState(() {
                _selectedGender = value as Genderss;
                widget.onGenderChanged?.call(_selectedGender);
              });
            },
          ),
        ),
        ListTile(
          title: Text('Female'),
          leading: Radio(
            value: Genderss.female,
            groupValue: _selectedGender,
            onChanged: (value) {
              setState(() {
                _selectedGender = value as Genderss;
                widget.onGenderChanged?.call(_selectedGender);
              });
            },
          ),
        ),
      ],
    );
  }
}
