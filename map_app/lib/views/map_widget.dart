import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_app/views/home_button_widget.dart';

import 'button_widget.dart';

class MapsWidget extends StatefulWidget {
  const MapsWidget({super.key});

  @override
  MapsWidgetState createState() => MapsWidgetState();
}

class MapsWidgetState extends State<MapsWidget> {
  final double lat = 57.161297;
  final double lng = 65.525017;
  double zoom = 11;
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
                  HomeButtonWidget(
                    icon: const Icon(Icons.home),
                    controller: googleMapController,
                    home: center,
                  ),
                  ButtonWidget(lat: 10, lng: 0, icon: const Icon(Icons.arrow_forward), controller: googleMapController),
                ],
              ),
              ButtonWidget(lat: 0, lng: 10, icon: const Icon(Icons.arrow_downward), controller: googleMapController),
            ],
          ),
        ),
      ),
      Positioned(
        top: 50,
        // left: MediaQuery.of(context).size.width / 2,
        width: MediaQuery.of(context).size.width,
        child: Slider(
          activeColor: Colors.black,
          inactiveColor: Colors.black54,
          thumbColor: Colors.orange,
          min: 0,
          max: 25,
          value: zoom,
          onChanged: (newZoom) {
            setState(() {
              zoom = newZoom;
            });
            googleMapController?.animateCamera(CameraUpdate.zoomTo(zoom));
          },
        ),
      ),
    ]);
  }
}
