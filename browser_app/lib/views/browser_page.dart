import 'package:browser_app/business/favorites_state.dart';
import 'package:browser_app/business/url_history_state.dart';
import 'package:browser_app/views/favorites_drawer.dart';
import 'package:browser_app/views/history_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../business/page_status_state.dart';
import 'error_page_widget.dart';
import 'url_widget.dart';

class BrowserPage extends StatefulWidget {
  const BrowserPage({Key? key}) : super(key: key);

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
              if (Provider.of<PageStatusPage>(context, listen: false).status == PageStatus.correct) {
                _progressIndicatorValue = progress;
              }
            });
          },
          onPageStarted: (String src) {
            setState(() {
              webViewController.canGoForward().then((value) {
                _canGoForward = value;
              });
              webViewController.canGoBack().then((value) {
                _canGoBack = value;
              });
              webViewController.currentUrl().then((url) => textEditingController.text = url!);
            });
            Provider.of<PageStatusPage>(context, listen: false).setLoadingStatus(true);
            Provider.of<PageStatusPage>(context, listen: false).setErrorStatus(PageStatus.correct);
            Provider.of<UrlHistoryState>(context, listen: false).addUrl(_currentUrl);
          },
          onPageFinished: (String src) {
            setState(() {
              Provider.of<PageStatusPage>(context, listen: false).setLoadingStatus(false);
              webViewController.currentUrl().then((url) => _currentUrl = url.toString());
            });
          },
          onWebResourceError: (WebResourceError error) {
            Provider.of<PageStatusPage>(context, listen: false).setErrorStatus(PageStatus.error);
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
    List<String> favoriteUrlsList = Provider.of<FavoritesState>(context).urls;
    return Scaffold(
      appBar: AppBar(
        actions: showActions(favoriteUrlsList, context),
      ),
      drawer: FavoritesDrawer(
          webViewController: webViewController,
          textEditingController: textEditingController,
          favoriteUrlsList: favoriteUrlsList),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(children: [
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
          // Provider.of<PageStatusPage>(context).status == PageStatus.error
          //     ?
          _error?.errorType != null && _error?.errorCode != null
              ? Expanded(
                  child: ErrorPageWidget(
                    error: _error,
                  ),
                )
              : Expanded(child: WebViewWidget(controller: webViewController)),
        ]),
      ),
    );
  }

  List<Widget> showActions(List<String> favoriteUrlsList, BuildContext context) {
    return [
      IconButton(
          onPressed: _canGoBack ? () => webViewController.goBack() : null,
          icon: const Icon(Icons.arrow_back),
          disabledColor: Colors.green),
      IconButton(
          onPressed: _canGoForward ? () => webViewController.goForward() : null,
          icon: const Icon(Icons.arrow_forward),
          disabledColor: Colors.green),
      IconButton(
        onPressed: () {
          if (favoriteUrlsList.contains(_currentUrl)) {
            Provider.of<FavoritesState>(context, listen: false).removeUrl(_currentUrl);
          } else {
            Provider.of<FavoritesState>(context, listen: false).addUrl(_currentUrl);
          }
        },
        icon: const Icon(Icons.star),
        color: Provider.of<FavoritesState>(context).urls.contains(_currentUrl) ? Colors.amber : Colors.white,
      ),
      IconButton(
          onPressed: () {
            webViewController.loadRequest(Uri.parse(_homeUrl));
          },
          icon: const Icon(Icons.home),
          disabledColor: Colors.green),
      IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) =>
                    HistoryPage(textEditingController: textEditingController, webViewController: webViewController),
              ),
            );
          },
          icon: const Icon(Icons.history),
          disabledColor: Colors.green),
    ];
  }
}
