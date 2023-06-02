


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hrms/widgets/sideBar.dart';
import 'package:latlong2/latlong.dart' as latLng;


class test extends StatefulWidget {
  static const routeName = '/test' ;


  @override
  State<test> createState() => _testState();
}

class _testState extends State<test> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _determinePositionfff(),
        builder: (ctx, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
          }
          else {
            return FlutterMap(
              options: MapOptions(
                center: latLng.LatLng(snapshot.data!.latitude, snapshot.data!.longitude),
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
                      point: latLng.LatLng(snapshot.data!.latitude, snapshot.data!.longitude), // center of 't Gooi
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
                      point: latLng.LatLng(snapshot.data!.latitude, snapshot.data!.longitude),
                      width: 80,
                      height: 80,
                      builder: (context) => Icon(Icons.location_on , color: Colors.white,),
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
    print('Latitude: ${position.latitude} from the function');
    print('Longitude: ${position.longitude} from funtion');
    return position;
  }
}
