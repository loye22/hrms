import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hrms/models/Dialog.dart';
import 'package:hrms/models/staticVars.dart';
import 'package:hrms/widgets/sideBar.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'button.dart';

class addLocations extends StatefulWidget {
  @override
  _addLocationsState createState() => _addLocationsState();
}

class _addLocationsState extends State<addLocations> {
  late List<String> bracnshesList;
  late Position officePossion;

  bool isLoding = false;
  String? _selectedBranch;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 700,
      height: 500,
      child: FutureBuilder(
        future: _fetchBranches(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final branches = snapshot.data;

            return Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    image: DecorationImage(
                      image: AssetImage('assests/tstiBackGround.jpg'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      //borderRadius: BorderRadius.all(Radius.circular(30)),
                      border: Border.all(color: Colors.white.withOpacity(0.13)),
                      color: Colors.grey.shade200.withOpacity(0.25),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    border: Border.all(color: Colors.white.withOpacity(0.13)),
                    color: Colors.grey.shade200.withOpacity(0.23),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Please assign the office location to the barnsh',
                          style:staticVars.textStyle2,
                        ),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 100,
                  child: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) =>
                        Container(
                      width: MediaQuery.of(context).size.width - 1200,
                      child: DropdownButtonFormField<String>(
                        value: _selectedBranch,
                        hint: Text('Select a branch'),
                        onChanged: (value) {
                          setState(() {
                            _selectedBranch = value!;
                          });
                        },
                        items: branches!.map((branch) {
                          return DropdownMenuItem<String>(
                            value: branch,
                            child: Text(branch),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  right: 10,
                  child: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) =>
                        Container(
                      width: 120,
                      height: 50,
                      child: Center(
                        child: isLoding
                            ? Center(child: CircularProgressIndicator())
                            : Button(
                                txt: 'submit',
                                icon: Icons.subdirectory_arrow_left,
                                isSelected: true,
                                onPress: () async{
                                  try {
                                    if (_selectedBranch == null) {
                                      MyDialog.showAlert(
                                          context, "Please select the bransh!");
                                      return;
                                    }

                                    isLoding = true;
                                    setState(() {});
                                    CollectionReference locationsCollection =
                                    FirebaseFirestore.instance
                                        .collection('locations');
                                    // to check if the current bansh is exesit or not
                                    // if he exist we will update the Longitude and latitude
                                    QuerySnapshot existingDocuments =
                                    await locationsCollection
                                        .where('title',
                                        isEqualTo: _selectedBranch)
                                        .get();

                                    // check if the current brash has exist
                                    // if yes update the current locaion
                                    if (existingDocuments.docs.isNotEmpty) {
                                      // Update the latitude and longitude values of the existing document
                                      await locationsCollection
                                          .doc(existingDocuments.docs[0].id)
                                          .update({
                                        'latitude': this
                                            .officePossion
                                            .latitude
                                            .toString(),
                                        'longitude': this
                                            .officePossion
                                            .longitude
                                            .toString(),
                                      });
                                      MyDialog.showAlert(context,
                                          "$_selectedBranch  location has been updated successfully");
                                      isLoding = false;
                                      setState(() {});
                                      return;
                                    }
                                    await locationsCollection.add({
                                      'title': _selectedBranch,
                                      'latitude':
                                      this.officePossion.latitude.toString(),
                                      'longitude':
                                      this.officePossion.longitude.toString(),
                                    });
                                    isLoding = false;
                                    setState(() {});
                                    Navigator.of(context).pop(context);
                                    MyDialog.showAlert(context,
                                        "$_selectedBranch  location has been successfully added");
                                  }
                                  catch(e){
                                    print(e);
                                    MyDialog.showAlert(context, e.toString());
                                  }

                                },
                              ),
                      ),
                    )
                  ),
                ),
                Container(
                    width: 500,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: locaionDetecion())
              ],
            );
          }
        },
      ),
    );
  }

  Future<List<String>> _fetchBranches() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('branchs').get();
    final branches =
        snapshot.docs.map((doc) => doc['title'] as String).toList();
    this.bracnshesList = branches;
    this.officePossion = await _determinePosition();
    print(this.officePossion.longitude.toString() +
        " " +
        this.officePossion.latitude.toString());
    return branches;
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.

    // Retrieve the current position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    //  print('Latitude: ${position.latitude} from the function');
    // print('Longitude: ${position.longitude} from funtion');
    return position;
  }
}

class locaionDetecion extends StatefulWidget {
  @override
  State<locaionDetecion> createState() => _locaionDetecionState();
}

class _locaionDetecionState extends State<locaionDetecion> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _determinePositionfff(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return FlutterMap(
            options: MapOptions(
              center: latLng.LatLng(
                  snapshot.data!.latitude, snapshot.data!.longitude),
              zoom: 15.2,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              CircleLayer(
                circles: [
                  CircleMarker(
                    point: latLng.LatLng(
                        snapshot.data!.latitude, snapshot.data!.longitude),
                    // center of 't Gooi
                    radius: 200,
                    useRadiusInMeter: true,
                    color: Colors.green.withOpacity(0.3),
                    borderColor: Colors.red.withOpacity(0.7),
                    borderStrokeWidth: 2,
                  )
                ],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: latLng.LatLng(
                        snapshot.data!.latitude, snapshot.data!.longitude),
                    width: 80,
                    height: 80,
                    builder: (context) => Icon(
                      Icons.location_on,
                      color: Colors.white,
                    ),
                  ),
                ],
              )
            ],
          );
        }
      },
    );
  }

  Future<Position> _determinePositionfff() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.

    // Retrieve the current position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    // print('Latitude: ${position.latitude} from the function');
    // print('Longitude: ${position.longitude} from funtion');
    return position;
  }
}
