import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../business/url_history_state.dart';
import '../utility.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({required this.textEditingController, super.key, required this.webViewController});
  final WebViewController webViewController;
  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    final List<String> historyUrlsList = Provider.of<UrlHistoryState>(context).urls;

    return Scaffold(
      appBar: AppBar(title: const Text('Browser History')),
      body: ListView.builder(
        itemCount: historyUrlsList.length,
        itemBuilder: (BuildContext context, int index) {
          final String url = historyUrlsList[index];
          return ListTile(
            selectedColor: Colors.orange,
            leading: const Icon(Icons.history),
            title: Text(url.length > 50 ? '${url.substring(0, 50)}...' : url),
            onTap: () {
              webViewController.loadRequest(Uri.parse(formatUrl(url)));
              textEditingController.text = url;
              Navigator.of(context).pop();
            },
          );
        },
      ),
    );
  }
}
