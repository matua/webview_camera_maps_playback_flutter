import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ErrorPageWidget extends StatelessWidget {
  const ErrorPageWidget({Key? key, required this.error}) : super(key: key);
  final WebResourceError? error;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text('''
        Your page could not be loaded due to: ${error?.description}, error code: ${error?.errorCode}, error type: ${error?.errorType}
        '''),
      ),
    );
  }
}
