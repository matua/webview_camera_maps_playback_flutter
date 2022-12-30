import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ErrorPageWidget extends StatelessWidget {
  const ErrorPageWidget({super.key, required this.error});
  final WebResourceError? error;
  @override
  Widget build(BuildContext context) {
    return Visibility(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'Error loading page',
            style: TextStyle(fontSize: 30, color: Colors.black12, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 21,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
                'Your page could not be loaded due to: ${error?.description}, error code: ${error?.errorCode}, error type: ${error?.errorType ?? 'unknown'}'),
          ),
        ],
      ),
    );
  }
}
