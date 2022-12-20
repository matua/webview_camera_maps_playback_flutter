import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'camera_widget.dart';
import 'gallery_widget.dart';

class HomeWidget extends StatefulWidget {
  final List<CameraDescription> cameras;

  const HomeWidget({super.key, required this.cameras});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  int _selectedIndex = 0;
  static late List<CameraDescription> cameras;

  @override
  void initState() {
    super.initState();
    cameras = widget.cameras;
  }

  static final List<Widget> _widgetOptions = <Widget>[
    CameraWidget(cameras: cameras),
    const GalleryWidget(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.camera),
              label: 'Camera',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.image_rounded),
              label: 'Gallery',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.blueGrey[200],
          onTap: _onItemTapped,
        ),
        body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      ),
    );
  }
}
