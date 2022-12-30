import 'package:flutter/material.dart';

class PageStatusPage extends ChangeNotifier {
  PageStatus status = PageStatus.correct;
  bool isLoading = true;

  void setErrorStatus(PageStatus status) {
    status = status;
    print('PAGE STATUS: $status');
    notifyListeners();
  }

  void setLoadingStatus(bool isLoadingStatus) {
    isLoading = isLoadingStatus;
    notifyListeners();
  }
}

enum PageStatus {
  error,
  correct,
}
