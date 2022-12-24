import 'dart:async';

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
  bool _showControls = false;
  late Timer _timer;
  late Timer _controlsTimer;
  String _formattedTime = '';

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.network(
      'https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_10mb.mp4',
    )
      ..initialize().then((_) {
        setState(() {
          _formattedTime = getFormattedTime(_controller.value.position, _controller.value.duration);
        });
      })
      ..play();

    _startTimer();
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    _controlsTimer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _controlsTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _formattedTime = getFormattedTime(_controller.value.position, _controller.value.duration);
      });
    });
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
      if (_showControls) {
        _timer = Timer(const Duration(seconds: 3), () {
          setState(() {
            _showControls = false;
          });
        });
      } else {
        _timer.cancel();
      }
    });
  }

  String getFormattedDuration(Duration duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes % 60;
    int seconds = duration.inSeconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String getFormattedTime(Duration duration, Duration totalDuration) {
    String elapsedTime = getFormattedDuration(duration);
    String totalTime = getFormattedDuration(totalDuration);
    return '$elapsedTime / $totalTime';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          body: GestureDetector(
            onTap: _toggleControls,
            onDoubleTap: _toggleControls,
            child: Stack(
              children: [
                _controller.value.isInitialized
                    ? Center(
                        child: AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        ),
                      )
                    : const Center(child: CircularProgressIndicator()),
                if (_showControls)
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          color: Colors.white,
                          iconSize: 63,
                          icon: const Icon(Icons.replay_10),
                          onPressed: () {
                            setState(() {
                              _controller.seekTo(
                                _controller.value.position - const Duration(seconds: 10),
                              );
                            });
                          },
                        ),
                        IconButton(
                          color: Colors.white,
                          iconSize: 63,
                          icon: _controller.value.isPlaying ? const Icon(Icons.pause) : const Icon(Icons.play_arrow),
                          onPressed: () {
                            setState(() {
                              _controller.value.isPlaying ? _controller.pause() : _controller.play();
                            });
                          },
                        ),
                        IconButton(
                          color: Colors.white,
                          iconSize: 63,
                          icon: const Icon(Icons.forward_10),
                          onPressed: () {
                            setState(() {
                              _controller.seekTo(
                                _controller.value.position + const Duration(seconds: 10),
                              );
                            });
                          },
                        ),
                        IconButton(
                          color: Colors.white,
                          iconSize: 63,
                          icon: const Icon(Icons.refresh),
                          onPressed: () {
                            setState(() {
                              _controller.seekTo(
                                const Duration(seconds: 0),
                              );
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                Positioned(
                  width: MediaQuery.of(context).size.width,
                  bottom: 0,
                  child: Slider(
                    activeColor: Colors.orange,
                    inactiveColor: Colors.amberAccent.shade100,
                    value: _controller.value.position.inSeconds.toDouble(),
                    onChanged: (newValue) {
                      setState(() {
                        _controller.seekTo(Duration(seconds: newValue.round()));
                      });
                    },
                    min: 0,
                    max: _controller.value.duration.inSeconds.toDouble(),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 36,
                  child: Text(
                    style: const TextStyle(color: Colors.white),
                    _formattedTime,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
