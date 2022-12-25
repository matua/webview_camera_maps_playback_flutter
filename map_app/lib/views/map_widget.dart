import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'button_widget.dart';

class MapsWidget extends StatefulWidget {
  const MapsWidget({super.key});

  @override
  MapsWidgetState createState() => MapsWidgetState();
}

class MapsWidgetState extends State<MapsWidget> {
  final double lat = 57.161297;
  final double lng = 65.525017;
  final double zoom = 11;
  late final Timer timer;
  late CameraPosition center;
  GoogleMapController? googleMapController;

  @override
  void initState() {
    super.initState();
    center = CameraPosition(
      target: LatLng(lat, lng),
      zoom: zoom,
    );
    googleMapController = null;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      GoogleMap(
        initialCameraPosition: center,
        onMapCreated: (GoogleMapController controller) {
          setState(() {
            googleMapController = controller;
          });
        },
      ),
      Positioned(
        bottom: 5,
        left: 5,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3), borderRadius: const BorderRadius.all(Radius.circular(5))),
          height: 150,
          width: 150,
          child: Column(
            children: [
              ButtonWidget(lat: 0, lng: -10, icon: const Icon(Icons.arrow_upward), controller: googleMapController),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ButtonWidget(lat: -10, lng: 0, icon: const Icon(Icons.arrow_back), controller: googleMapController),
                  ButtonWidget(lat: 10, lng: 0, icon: const Icon(Icons.arrow_forward), controller: googleMapController),
                ],
              ),
              ButtonWidget(lat: 0, lng: 10, icon: const Icon(Icons.arrow_downward), controller: googleMapController),
            ],
          ),
        ),
      ),
    ]);
  }
}
