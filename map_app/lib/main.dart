import 'package:flutter/material.dart';

import 'views/map_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Google Maps Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Scaffold(
        body: MapsWidget(),
      ),
    );
  }
}
