import 'package:flutter/material.dart';
import 'package:webviewx/webviewx.dart';

class BrowserPage extends StatefulWidget {
  const BrowserPage({Key? key}) : super(key: key);

  @override
  State<BrowserPage> createState() => _BrowserPageState();
}

class _BrowserPageState extends State<BrowserPage> {
  TextEditingController textEditingController = TextEditingController();
  late WebViewXController<dynamic> webViewController;
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_back)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_forward)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.home)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.history)),
        ],
      ),
      drawer: const Drawer(),
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
                        keyboardAppearance: Brightness.dark,
                        controller: textEditingController,
                        decoration: const InputDecoration(
                          labelText: 'URL',
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Icon(
                      Icons.cached_sharp,
                      color: Colors.grey,
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
                    setState(() {
                      isLoading = true;
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
