import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  const VideoPlayerWidget({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.network(
      'https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_10mb.mp4',
    )..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _controller.value.isPlaying ? _controller.pause() : _controller.play();
            });
          },
          child: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ),
        body: Column(
          children: [
            SizedBox(
              height: 300,
              child: Column(
                children: [
                  SizedBox(
                      height: (MediaQuery.of(context).size.width - 100) / 2.7,
                      width: double.infinity - 300,
                      child: VideoPlayer(_controller)),
                  Expanded(
                    child: Slider(
                      value: _controller.value.position.inSeconds.toDouble(),
                      onChanged: (newValue) {
                        _controller.seekTo(Duration(seconds: newValue.round()));
                      },
                      min: 0,
                      max: _controller.value.duration.inSeconds.toDouble(),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    _controller.seekTo(
                      _controller.value.position - const Duration(seconds: 10),
                    );
                  },
                  child: const Text('Backward'),
                ),
                TextButton(
                  onPressed: () {
                    _controller.seekTo(
                      _controller.value.position + const Duration(seconds: 10),
                    );
                  },
                  child: const Text('Forward'),
                ),
              ],
            ),
            Text(
              '${_controller.value.position.inSeconds} seconds',
            ),
          ],
        ),
      ),
    );
  }
}
