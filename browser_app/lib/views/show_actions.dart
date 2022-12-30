import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../business/favorites_state.dart';
import 'history_page.dart';

List<Widget> showActions(
    {required List<String> favoriteUrlsList,
    required BuildContext context,
    required WebViewController webViewController,
    required TextEditingController textEditingController,
    required bool canGoBack,
    required bool canGoForward,
    required String currentUrl,
    required String homeUrl}) {
  return [
    IconButton(
        onPressed: canGoBack ? () => webViewController.goBack() : null,
        icon: const Icon(Icons.arrow_back),
        disabledColor: Colors.green),
    IconButton(
        onPressed: canGoForward ? () => webViewController.goForward() : null,
        icon: const Icon(Icons.arrow_forward),
        disabledColor: Colors.green),
    IconButton(
      onPressed: () {
        if (favoriteUrlsList.contains(currentUrl)) {
          Provider.of<FavoritesState>(context, listen: false).removeUrl(currentUrl);
        } else {
          Provider.of<FavoritesState>(context, listen: false).addUrl(currentUrl);
        }
      },
      icon: const Icon(Icons.star),
      color: Provider.of<FavoritesState>(context).urls.contains(currentUrl) ? Colors.amber : Colors.white,
    ),
    IconButton(
        onPressed: () {
          webViewController.loadRequest(Uri.parse(homeUrl));
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
