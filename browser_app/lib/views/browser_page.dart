import 'package:browser_app/business/favorites_state.dart';
import 'package:browser_app/business/url_history_state.dart';
import 'package:browser_app/views/custom_drawer.dart';
import 'package:browser_app/views/error_page_widget.dart';
import 'package:browser_app/views/history_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../utility.dart';

class BrowserPage extends StatefulWidget {
  const BrowserPage({Key? key}) : super(key: key);

  @override
  State createState() => _BrowserPageState();
}

class _BrowserPageState extends State<BrowserPage> {
  TextEditingController textEditingController = TextEditingController();
  late WebViewController webViewController;
  bool? _isLoading;
  bool _isError = false;
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
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (int progress) {
          setState(() {
            if (!_isError) {
              _progressIndicatorValue = progress;
            }
          });
        },
        onPageStarted: (String src) {
          setState(() {
            _isLoading = true;
            webViewController.canGoForward().then((value) {
              _canGoForward = value;
            });
            webViewController.canGoBack().then((value) {
              _canGoBack = value;
            });
            webViewController.currentUrl().then((url) => textEditingController.text = url!);
          });
          context.read<UrlHistoryState>().addUrl(_currentUrl);
          print('Added $_currentUrl to history');
        },
        onPageFinished: (String src) {
          setState(() {
            _isLoading = false;
            webViewController.currentUrl().then((url) => _currentUrl = url.toString());
          });
          print(_currentUrl);
        },
        onWebResourceError: (WebResourceError error) {
          setState(() {
            _isError = true;
            _error = error;
          });
        },
      ))
      ..loadRequest(Uri.parse(_homeUrl));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> favoriteUrlsList = context.watch<FavoritesState>().urls;
    return Scaffold(
        appBar: AppBar(
          actions: showActions(favoriteUrlsList, context),
        ),
        drawer: CustomDrawer(
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
                child: Row(
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
                        !_isLoading!
                            ? webViewController.loadRequest(Uri.parse(formatUrl(textEditingController.text)))
                            : webViewController.runJavaScript('window.stop();');
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: (_isLoading == true)
                            ? const Icon(
                                Icons.close,
                                color: Colors.grey,
                              )
                            : const Icon(
                                Icons.cached_sharp,
                                color: Colors.grey,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: _isError
                      ? ErrorPageWidget(
                          error: _error,
                        )
                      : WebViewWidget(controller: webViewController)),
            ])));
  }

  List<Widget> showActions(List<String> favoriteUrlsList, BuildContext context) {
    return [
      IconButton(
          onPressed: _canGoBack ? () => webViewController.goBack() : null,
          icon: const Icon(Icons.arrow_back),
          disabledColor: Colors.blue),
      IconButton(
          onPressed: _canGoForward ? () => webViewController.goForward() : null,
          icon: const Icon(Icons.arrow_forward),
          disabledColor: Colors.blue),
      IconButton(
        onPressed: () {
          if (favoriteUrlsList.contains(_currentUrl)) {
            context.read<FavoritesState>().removeUrl(_currentUrl);
          } else {
            context.read<FavoritesState>().addUrl(_currentUrl);
          }
        },
        icon: const Icon(Icons.star),
        color: context.watch<FavoritesState>().urls.contains(_currentUrl) ? Colors.amber : Colors.white,
      ),
      IconButton(
          onPressed: () {
            webViewController.loadRequest(Uri.parse(_homeUrl));
          },
          icon: const Icon(Icons.home),
          disabledColor: Colors.blue),
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
          disabledColor: Colors.blue),
    ];
  }
}
