import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webviewx/webviewx.dart';

import '../data/model/favoriteUrlsList.dart';
import '../utility.dart';

class BrowserPage extends ConsumerStatefulWidget {
  const BrowserPage({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _BrowserPageState();
}

class _BrowserPageState extends ConsumerState<BrowserPage> {
  TextEditingController textEditingController = TextEditingController();
  late WebViewXController<dynamic> webViewController;
  bool isLoading = true;
  bool canGoBack = false;
  bool canGoForward = false;
  bool isAmber = true;
  String currentUrl = '';

  @override
  Widget build(BuildContext context) {
    List<String> favoriteUrlsList = ref.watch(favoriteUrlsProvider.notifier).list;
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
          InkWell(
              onTap: () {
                setState(() {
                  isAmber = !isAmber; // Toggle the value of the boolean
                });
              },
              child: IconButton(
                onPressed: () {
                  if (favoriteUrlsList.contains(currentUrl)) {
                    ref.read(favoriteUrlsProvider.notifier).removeFromList(currentUrl);
                  } else {
                    ref.read(favoriteUrlsProvider.notifier).addToList(currentUrl);
                  }
                  print(favoriteUrlsList);
                },
                icon: const Icon(Icons.star),
                color: isAmber ? Colors.amber : Colors.white,
              )),
          IconButton(onPressed: () {}, icon: const Icon(Icons.home), disabledColor: Colors.blue),
          IconButton(onPressed: () {}, icon: const Icon(Icons.history), disabledColor: Colors.blue),
        ],
      ),
      drawer: Drawer(
        child: favoriteUrlsList.isEmpty
            ? const Center(child: Text('No URLs added yet'))
            : ListView.builder(
                itemCount: favoriteUrlsList.length,
                itemBuilder: (context, index) => SizedBox(height: 25, child: Text(favoriteUrlsList[index])),
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
                    });
                  },
                  onPageStarted: (String src) {
                    webViewController
                        .evalRawJavascript('window.location.href')
                        .then((url) => currentUrl = url.substring(1, url.length - 1));
                    setState(() {
                      isLoading = true;
                      webViewController.canGoForward().then((value) {
                        canGoForward = value;
                      });
                      webViewController.canGoBack().then((value) {
                        canGoBack = value;
                      });
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
