import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeButtonWidget extends StatelessWidget {
  const HomeButtonWidget({
    Key? key,
    required this.icon,
    required this.controller,
    required this.home,
  }) : super(key: key);
  final GoogleMapController? controller;
  final Icon icon;
  final CameraPosition home;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8), borderRadius: const BorderRadius.all(Radius.circular(5))),
        child: IconButton(
            onPressed: () {
              controller?.moveCamera(
                CameraUpdate.newCameraPosition(home),
              );
            },
            icon: icon));
  }
}
