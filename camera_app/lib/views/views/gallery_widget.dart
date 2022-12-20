import 'dart:io';

import 'package:camera_app/views/repo/image_repository.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class GalleryWidget extends StatefulWidget {
  const GalleryWidget({Key? key}) : super(key: key);

  @override
  State<GalleryWidget> createState() => _GalleryWidgetState();
}

class _GalleryWidgetState extends State<GalleryWidget> {
  List<String> images = GetIt.I<ImageRepository>().images;

  @override
  Widget build(BuildContext context) {
    return images.isEmpty
        ? const Center(
            child: Text(
                style: TextStyle(
                  fontSize: 20,
                ),
                'No pictures taken yet'))
        : GridView.builder(
            itemCount: images.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            itemBuilder: (BuildContext context, int index) => Image.file(
                  File(images[index]),
                  fit: BoxFit.cover,
                ));
  }
}
