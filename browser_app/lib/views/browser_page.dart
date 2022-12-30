import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../business/favorites_state.dart';
import '../business/page_status_state.dart';
import '../business/url_history_state.dart';
import 'favorites_drawer.dart';
import 'show_actions.dart';
import 'url_widget.dart';

class BrowserPage extends StatefulWidget {
  const BrowserPage({super.key});

  @override
  State createState() => _BrowserPageState();
}

class _BrowserPageState extends State<BrowserPage> {
  TextEditingController textEditingController = TextEditingController();
  late WebViewController webViewController;
  WebResourceError? _error;
  bool _canGoBack = false;
  bool _canGoForward = false;
  String _currentUrl = '';
  final String _homeUrl = 'https://skillbox.ru';
  int? _progressIndicatorValue;

  @override
  void initState() {
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white30)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              _progressIndicatorValue = progress;
            });
          },
          onPageStarted: (String src) {
            setState(() {
              _error = null;
              Provider.of<PageStatusPage>(context, listen: false).setLoadingStatus(true);
              Provider.of<UrlHistoryState>(context, listen: false).addUrl(_currentUrl);
              webViewController.canGoForward().then((bool value) {
                _canGoForward = value;
              });
              webViewController.canGoBack().then((bool value) {
                _canGoBack = value;
              });
              webViewController.currentUrl().then((String? url) => textEditingController.text = url!);
            });
          },
          onPageFinished: (String src) {
            setState(() {
              Provider.of<PageStatusPage>(context, listen: false).setLoadingStatus(false);
              webViewController.currentUrl().then((String? url) => _currentUrl = url.toString());
            });
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              _error = error;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(_homeUrl));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> favoriteUrlsList = Provider.of<FavoritesState>(context).urls;
    return Scaffold(
      appBar: AppBar(
        actions: showActions(
            webViewController: webViewController,
            textEditingController: textEditingController,
            canGoBack: _canGoBack,
            canGoForward: _canGoForward,
            context: context,
            currentUrl: _currentUrl,
            favoriteUrlsList: favoriteUrlsList,
            homeUrl: _homeUrl),
      ),
      drawer: FavoritesDrawer(
          webViewController: webViewController,
          textEditingController: textEditingController,
          favoriteUrlsList: favoriteUrlsList),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(children: <Widget>[
          LinearProgressIndicator(
            value: _progressIndicatorValue != null ? _progressIndicatorValue! / 100 : 1,
            minHeight: 10,
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: Colors.grey.shade400)),
            height: 72,
            child: UrlWidget(textEditingController: textEditingController, webViewController: webViewController),
          ),
          Expanded(child: WebViewWidget(controller: webViewController)),
        ]),
      ),
    );
  }
}
