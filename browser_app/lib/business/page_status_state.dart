import 'package:flutter/material.dart';

class PageStatusPage extends ChangeNotifier {
  bool isLoading = true;

  void setLoadingStatus(bool isLoadingStatus) {
    isLoading = isLoadingStatus;
    notifyListeners();
  }
}
