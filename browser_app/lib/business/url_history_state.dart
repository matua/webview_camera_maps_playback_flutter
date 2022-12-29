import 'package:flutter/material.dart';

class UrlHistoryState extends ChangeNotifier {
  List<String> _urls = List<String>.empty(growable: true);

  List<String> get urls => _urls;

  void addUrl(String url) {
    if (url.isNotEmpty) {
      _urls = [url, ..._urls];
    }
    notifyListeners();
  }

  void removeUrl(String url) {
    _urls.removeWhere((element) => element == url);
    notifyListeners();
  }

  void cleanUrls() {
    _urls.clear();
    notifyListeners();
  }
}
