import 'package:browser_app/business/favorites_state.dart';
import 'package:browser_app/business/url_history_state.dart';
import 'package:browser_app/views/history_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webviewx/webviewx.dart';

import '../utility.dart';

class BrowserPage extends StatefulWidget {
  const BrowserPage({Key? key}) : super(key: key);

  @override
  State createState() => _BrowserPageState();
}

class _BrowserPageState extends State<BrowserPage> {
  TextEditingController textEditingController = TextEditingController();
  late WebViewXController<dynamic> webViewController;
  bool isLoading = true;
  bool canGoBack = false;
  bool canGoForward = false;
  String currentUrl = '';

  @override
  Widget build(BuildContext context) {
    List<String> favoriteUrlsList = context.watch<FavoritesState>().urls;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: canGoBack ? () => webViewController.goBack() : null,
              icon: const Icon(Icons.arrow_back),
              disabledColor: Colors.blue),
          IconButton(
              onPressed: canGoForward ? () => webViewController.goForward() : null,
              icon: const Icon(Icons.arrow_forward),
              disabledColor: Colors.blue),
          IconButton(
            onPressed: () {
              if (favoriteUrlsList.contains(currentUrl)) {
                context.read<FavoritesState>().removeUrl(currentUrl);
                print('Removed $currentUrl from favorites');
              } else {
                context.read<FavoritesState>().addUrl(currentUrl);
                print('Added $currentUrl to favorites');
              }
            },
            icon: const Icon(Icons.star),
            color: context.watch<FavoritesState>().urls.contains(currentUrl) ? Colors.amber : Colors.white,
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.home), disabledColor: Colors.blue),
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
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.grey.shade300,
        child: favoriteUrlsList.isEmpty
            ? Column(
                children: const [
                  Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: ListTile(
                      leading: Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 30,
                      ),
                      title: Text(
                        'My Favorites',
                        style: TextStyle(fontSize: 27, color: Colors.grey),
                      ),
                    ),
                  ),
                  Expanded(child: Center(child: Text('No favorites yet 😉'))),
                ],
              )
            : Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Column(
                    children: [
                      const ListTile(
                        leading: Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 30,
                        ),
                        title: Text(
                          'My Favorites',
                          style: TextStyle(fontSize: 27, color: Colors.grey),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: favoriteUrlsList.length,
                          itemBuilder: (context, index) {
                            var url = favoriteUrlsList[index];
                            return ListTile(
                                selectedColor: Colors.orange,
                                leading: const Icon(Icons.arrow_forward_ios_outlined),
                                title: Text(url.length > 50 ? '${url.substring(0, 50)}...' : url),
                                onTap: () {
                                  webViewController.loadContent(formatUrl(url), SourceType.urlBypass);
                                  Scaffold.of(context).closeDrawer();
                                  textEditingController.text = url;
                                });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: Colors.grey.shade400)),
              height: 50,
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: TextField(
                        onSubmitted: (value) {
                          webViewController.loadContent(formatUrl(value), SourceType.urlBypass);
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
                      webViewController.loadContent(formatUrl(textEditingController.text), SourceType.urlBypass);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: isLoading
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
              child: Stack(children: <Widget>[
                WebViewX(
                  initialContent: 'https://skillbox.ru',
                  initialSourceType: SourceType.urlBypass,
                  onWebViewCreated: (WebViewXController<dynamic> controller) => webViewController = controller,
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  onPageFinished: (String src) {
                    setState(() {
                      isLoading = false;
                      webViewController.evalRawJavascript('document.baseURI').then((url) => currentUrl = url);
                    });
                  },
                  onPageStarted: (String src) {
                    setState(() {
                      isLoading = true;
                      webViewController.canGoForward().then((value) {
                        canGoForward = value;
                      });
                      webViewController.canGoBack().then((value) {
                        canGoBack = value;
                      });
                      context.read<UrlHistoryState>().addUrl(currentUrl);
                      print('Added $currentUrl to history');
                    });
                  },
                ),
                isLoading
                    ? const LinearProgressIndicator(
                        minHeight: 10,
                      )
                    : Stack(),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
