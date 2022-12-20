import 'package:camera/camera.dart';
import 'package:camera_app/views/repo/image_repository.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'views/views/home_widget.dart';

Future<void> main() async {
  GetIt.I.registerSingleton<ImageRepository>(ImageRepository());

  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  runApp(MyApp(cameras: cameras));
}

class MyApp extends StatelessWidget {
  final List<CameraDescription> cameras;

  const MyApp({Key? key, required this.cameras}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Camera App',
      home: HomeWidget(
        cameras: cameras,
      ),
    );
  }
}
