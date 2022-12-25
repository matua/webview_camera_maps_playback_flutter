import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsWidget extends StatefulWidget {
  const MapsWidget({super.key});

  @override
  MapsWidgetState createState() => MapsWidgetState();
}

class MapsWidgetState extends State<MapsWidget> {
  late GoogleMapController mapController;

  LatLng _center = const LatLng(57.161297, 65.525017);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 11.0,
        ),
      ),
      Positioned(
        bottom: 5,
        left: 5,
        child: Container(
          decoration:
              BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.all(Radius.circular(5))),
          height: 150,
          width: 150,
          child: Column(
            children: [
              Container(
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8), borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.arrow_upward,
                        color: Colors.grey,
                      ))),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8), borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.grey,
                          ))),
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8), borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.arrow_forward,
                            color: Colors.grey,
                          ))),
                ],
              ),
              Container(
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8), borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.arrow_downward,
                        color: Colors.grey,
                      ))),
            ],
          ),
        ),
      ),
    ]);
  }
}
//
// void moveLeft(GoogleMapController controller, LatLng center) async {
//   final currentScreenCoordinates = await controller.getScreenCoordinate(center);
//   final currentPosition = controller.getLatLng(currentScreenCoordinates);
//   controller.moveCamera(
//     CameraUpdate.newLatLng(
//       LatLng(
//         currentPosition. + _moveStep,
//         currentPosition.target.longitude,
//       ),
//     ),
//   );
// }
