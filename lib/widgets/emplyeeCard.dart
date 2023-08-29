import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hrms/models/staticVars.dart';
import 'package:image_picker/image_picker.dart';

class emplyeeCard extends StatelessWidget {
  const emplyeeCard(
      {Key? key,
  //    required this.photo,
      required this.name,
      required this.occupation,
      required this.email, required this.url})
      : super(key: key);

 // final XFile photo;

  final String name;

  final String occupation;

  final String email;
  final String url ;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        border: Border.all(color: Colors.white.withOpacity(0.13)),
        color:staticVars.c1,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: Image.network(url).image,//NetworkImage(url),
            ),
            SizedBox(height: 20,),
            Text(name , style: staticVars.textStyle3),
            SizedBox(height: 5,),
            Text(occupation , style:staticVars.textStyle3),
            SizedBox(height: 5),
            Text(email , style: staticVars.textStyle3)
          ],
        ),
      ),
    );
  }
}
