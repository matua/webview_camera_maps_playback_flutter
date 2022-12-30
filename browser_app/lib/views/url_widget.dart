import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../business/page_status_state.dart';
import '../utility.dart';

class UrlWidget extends StatelessWidget {
  const UrlWidget({Key? key, required this.webViewController, required this.textEditingController}) : super(key: key);
  final WebViewController webViewController;
  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    bool isLoading = Provider.of<PageStatusPage>(context).isLoading;

    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: TextField(
              onSubmitted: (value) {
                webViewController.loadRequest(Uri.parse(googleSearch(value)));
              },
              keyboardAppearance: Brightness.dark,
              controller: textEditingController,
              decoration: const InputDecoration(
                labelText: 'URL',
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            if (!isLoading) {
              webViewController.loadRequest(Uri.parse(googleSearch(textEditingController.text)));
            } else {
              webViewController.runJavaScript('window.stop();');
              Provider.of<PageStatusPage>(context, listen: false).setErrorStatus(PageStatus.error);
              isLoading = false;
            }
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: (isLoading)
                ? const Icon(
                    Icons.close,
                    color: Colors.grey,
                  )
                : const Icon(
                    Icons.cached_rounded,
                    color: Colors.grey,
                  ),
          ),
        ),
      ],
    );
  }
}
