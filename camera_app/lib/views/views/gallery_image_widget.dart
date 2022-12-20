import 'dart:io';

import 'package:flutter/material.dart';

import 'full_screen_image_widget.dart';

class GalleryImageWidget extends StatelessWidget {
  const GalleryImageWidget({
    Key? key,
    required this.images,
    required this.index,
  }) : super(key: key);

  final List<String> images;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => FullScreenImageWidget(image: images[index])),
        );
      },
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.white, width: 1)),
        child: Image.file(
          File(images[index]),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
