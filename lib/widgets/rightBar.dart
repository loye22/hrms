import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hrms/webSIte/companyDocAdd.dart';
import 'package:hrms/webSIte/singUpScreen.dart';
import 'package:hrms/widgets/workHoursPicker.dart';
import 'package:hrms/widgets/workflow.dart';
import 'package:provider/provider.dart';

import '../provider/UserData.dart';
import '../webSIte/addNewEmployeeScreen.dart';
import '../webSIte/weekEndMangerScreen.dart';
import 'AddDepartmantForm.dart';
import 'AddNewReq.dart';
import 'addMandetoryEmplyeDoc.dart';
import 'addNewBranch.dart';
import 'addNewTimeOff.dart';
import 'button.dart';
import 'emplyeeCard.dart';
import 'iconWiget.dart';

class rightBar extends StatelessWidget {
  const rightBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 10,
      top: 15,
      child: Container(
        width: MediaQuery.of(context).size.width - 1600 > 0 ? MediaQuery.of(context).size.width - 1600  : 300,
        height: MediaQuery.of(context).size.height,
        //decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        child: ListView(
        //  crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              height: 20,
            ),
            FutureBuilder(
              future: fun(context),
              builder: (ctx, p) => p.connectionState == ConnectionState.waiting
                  ? Center(child: CircularProgressIndicator())
                  : Consumer<AuthProvider>(
                      builder: (ctx, p, _) => emplyeeCard(
                        name: p.userdata!.name,
                        email: p.userdata!.email,
                        occupation: "Software eng",
                        url: p.userdata!.uri,
                      ),
                    ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              width: 300,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  iconWiget(
                    icon: Icons.notifications_none_sharp,
                    fun: () {},
                  ),
                  iconWiget(
                    icon: Icons.help_outline,
                    fun: () {},
                  ),
                  iconWiget(
                    icon: Icons.search,
                    fun: () {},
                  )
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              width: 300,
              child: Button(
                txt: "Add new employee",
                icon: Icons.add,
                isSelected: true,
                onPress: () {
                  Navigator.pushNamed(context, addNewEmployeeScreen.routeName);
                  //  setState(() {});
                },
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              width: 300,
              child: Button(
                txt: "Add new company doc",
                icon: Icons.add,
                isSelected: true,
                onPress: () {
                  Navigator.of(context).pushNamed(companyDocAdd.routeName);
                },
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              width: 300,
              child: Button(
                txt: "Add new Adminstrator",
                icon: Icons.add,
                isSelected: true,
                onPress: () {
                  Navigator.of(context).pushNamed(singUpScreen.routeName);
                },
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              width: 300,
              child: Button(
                txt: "Mange the weekend",
                icon: Icons.weekend,
                isSelected: true,
                onPress: () {
                  Navigator.pushNamed(context, weekEndMangerScreen.routeName);
                },
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              width: 300,
              child: Button(
                txt: "Add new department",
                icon: Icons.business,
                isSelected: true,
                onPress: () async {
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                        backgroundColor: Colors.transparent,
                        content: AddDepartmantForm()),
                  );
                },
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              width: 300,
              child: Button(
                txt: "Make a required employee document",
                icon: Icons.description,
                isSelected: true,
                onPress: () async {
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                        backgroundColor: Colors.transparent,
                        content: addMandetoryEmplyeDoc()),
                  );
                },
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              width: 300,
              child: Button(
                txt: "Add new time off ",
                icon: Icons.more_time_rounded,
                isSelected: true,
                onPress: () async {
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                        backgroundColor: Colors.transparent,
                        content: addNewTimeOff()),
                  );
                },
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              width: 300,
              child: Button(
                txt: "Add new branch",
                icon: Icons.star_border,
                isSelected: true,
                onPress: () async {
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                        backgroundColor: Colors.transparent,
                        content: addNewBranch()),
                  );
                },
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              width: 300,
              child: Button(
                txt: "Add working hours",
                icon: Icons.hourglass_bottom,
                isSelected: true,
                onPress: () async {
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                        backgroundColor: Colors.transparent,
                        content: Container(
                            child: WorkHoursPicker(
                          title: 'Please add working hours',
                        ))),
                  );
                },
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              width: 300,
              child: Button(
                txt: "Add new work flow",
                icon: Icons.device_hub,
                isSelected: true,
                onPress: () async {
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      backgroundColor: Colors.transparent,
                      content: WorkflowExecutionPage(fun: (s){}),
                    ),
                  );
                },
              ),
            ),
            /*SizedBox(
              height: 15,
            ),
            Container(
              width: 300,
              child: Button(
                txt: "Add new requists",
                icon: Icons.sync_alt,
                isSelected: true,
                onPress: () async {
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      backgroundColor: Colors.transparent,
                      content: AddNewReq(),
                    ),
                  );
                },
              ),
            ),*/
            SizedBox(height: 100,)
          ],
        ),
      ),
    );
  }
}

Future<void> fun(BuildContext ctx) async {
  String s = Provider.of<AuthProvider>(ctx, listen: false).userdata!.uri;
  if (s == null || s == "") {
    var res = await FirebaseAuth.instance.currentUser!;
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('Adminusers')
        .doc(res.uid)
        .get();
    String name = await userDoc.get('userName');
    String email = await userDoc.get('email');
    String url = await userDoc.get('photo');
    Provider.of<AuthProvider>(ctx, listen: false)
        .setData(userdataa(email: email, name: name, uri: url), "token");
  }
}
