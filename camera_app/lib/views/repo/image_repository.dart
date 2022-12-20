import 'package:camera/camera.dart';

class ImageRepository {
  final List<String> _images = [];

  addImage(XFile image) {
    _images.add(image.path);
    print('Path is ${image.path}');
  }

  List<String> get images => _images;
}
