import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({
    Key? key,
    required this.lat,
    required this.lng,
    required this.icon,
    required this.controller,
  }) : super(key: key);
  final GoogleMapController? controller;
  final Icon icon;
  final double lat;
  final double lng;

  @override
  Widget build(BuildContext context) {
    Timer? timer;

    return GestureDetector(
      onLongPress: () {
        timer = Timer.periodic(
          const Duration(milliseconds: 100),
          (t) {
            controller?.moveCamera(
              CameraUpdate.scrollBy(lat, lng),
            );
          },
        );
      },
      onLongPressEnd: (_) {
        timer?.cancel();
      },
      child: Container(
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8), borderRadius: const BorderRadius.all(Radius.circular(5))),
          child: IconButton(
              onPressed: () {
                controller?.moveCamera(
                  CameraUpdate.scrollBy(lat, lng),
                );
              },
              icon: icon)),
    );
  }
}
