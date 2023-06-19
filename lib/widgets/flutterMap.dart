import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latLng;

class flutterMap extends StatefulWidget {
  final String centerLang ;
  final String  centerLat ;
  final String p2Lang ;
  final String  p2Lat;

  const flutterMap({Key? key, required this.centerLang, required this.centerLat, required this.p2Lang, required this.p2Lat}) : super(key: key);

  @override
  State<flutterMap> createState() => _flutterMapState();
}

class _flutterMapState extends State<flutterMap> {
  @override
  Widget build(BuildContext context) {
    return  FlutterMap(
      options: MapOptions(
        center: latLng.LatLng(
             double.parse(widget.centerLat) , double.parse(widget.centerLang)),
        zoom: 16.5,
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
                    double.parse(widget.centerLat),double.parse(widget.centerLang)),
              // center of 't Gooi
              radius: 100,
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
                   double.parse(widget.centerLat) ,  double.parse(widget.centerLang),),
              width: 80,
              height: 80,
              builder: (context) => Column(
                children: [
                  Text('Office'),
                  Icon(
                    Icons.location_on,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ],
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: latLng.LatLng(
                   double.parse(widget.p2Lat) ,  double.parse(widget.p2Lang),),
              width: 80,
              height: 80,
              builder: (context) => Icon(
                Icons.location_on,
                color: Colors.green,
              ),
            ),
          ],
        )
      ],
    );;
  }
}
