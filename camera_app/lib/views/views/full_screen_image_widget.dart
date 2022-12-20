import 'dart:io';

import 'package:flutter/material.dart';

class FullScreenImageWidget extends StatelessWidget {
  const FullScreenImageWidget({Key? key, required this.image}) : super(key: key);
  final String image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Center(
        child: Hero(
          tag: 'imageHero',
          child: Image.file(
            File(image),
          ),
        ),
      ),
    );
  }
}
