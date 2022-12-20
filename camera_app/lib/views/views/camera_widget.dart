import 'package:audioplayers/audioplayers.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../repo/image_repository.dart';
import 'package:get_it/get_it.dart';

class CameraWidget extends StatefulWidget {
  const CameraWidget({Key? key, required this.cameras}) : super(key: key);
  final List<CameraDescription> cameras;

  @override
  State<CameraWidget> createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.cameras.first,
      ResolutionPreset.high,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SizedBox(
        height: 72,
        width: 72,
        child: FloatingActionButton(
          backgroundColor: Colors.red,
          onPressed: () async {
            AudioPlayer().play(AssetSource('camera-shutter-click-08.mp3'));
            try {
              await _initializeControllerFuture;
              GetIt.I<ImageRepository>().addImage(await _controller.takePicture());
              if (!mounted) return;
            } catch (e) {
              if (kDebugMode) {
                print(e);
              }
            }
          },
          child: const Icon(Icons.circle),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SingleChildScrollView(
        child: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return CameraPreview(_controller);
            } else {
              return const LinearProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
