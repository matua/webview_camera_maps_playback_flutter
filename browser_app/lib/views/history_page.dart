import 'package:browser_app/business/url_history_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webviewx/webviewx.dart';

import '../utility.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({required this.textEditingController, Key? key, required this.webViewController}) : super(key: key);
  final WebViewXController<dynamic> webViewController;
  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    final List<String> historyUrlsList = context.watch<UrlHistoryState>().urls;
    print(historyUrlsList);
    return Scaffold(
      appBar: AppBar(title: const Text('Browser History')),
      body: ListView.builder(
        itemCount: historyUrlsList.length,
        itemBuilder: (context, index) {
          var url = historyUrlsList[index];
          return ListTile(
            selectedColor: Colors.orange,
            leading: const Icon(Icons.arrow_forward_ios_outlined),
            title: Text(url.length > 50 ? '${url.substring(0, 50)}...' : url),
            onTap: () {
              webViewController.loadContent(formatUrl(url), SourceType.urlBypass);
              Scaffold.of(context).closeDrawer();
              textEditingController.text = url;
            },
          );
        },
      ),
    );
  }
}
