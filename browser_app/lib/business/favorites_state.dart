import 'package:flutter/material.dart';

class FavoritesState extends ChangeNotifier {
  List<String> _urls = List<String>.empty(growable: true);

  List<String> get urls => _urls;

  void addUrl(String url) {
    if (urls.contains(url)) {
      throw Exception('URL is already in the list. Only one is allowed.');
    }
    if (url.isNotEmpty) {
      _urls = [url, ..._urls];
    }
    notifyListeners();
  }

  void removeUrl(String url) {
    _urls.removeWhere((String element) => element == url);
    notifyListeners();
  }

  void cleanUrls() {
    _urls.clear();
    notifyListeners();
  }
}
