import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
        color: Colors.grey.shade200.withOpacity(0.25),
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
            Text(name , style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold ,fontSize: 18),),
            SizedBox(height: 5,),
            Text(occupation , style: TextStyle(color: Colors.black54 ),),
            SizedBox(height: 5),
            Text(email , style: TextStyle(color: Colors.black54 ),)
          ],
        ),
      ),
    );
  }
}
