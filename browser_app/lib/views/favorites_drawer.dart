import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../utility.dart';

class FavoritesDrawer extends StatelessWidget {
  const FavoritesDrawer(
      {super.key,
      required this.webViewController,
      required this.favoriteUrlsList,
      required this.textEditingController});
  final WebViewController webViewController;
  final List<String> favoriteUrlsList;
  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey.shade300,
      child: favoriteUrlsList.isEmpty
          ? Column(
              children: const <Widget>[
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
          : Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Column(
                children: <Widget>[
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
                      itemBuilder: (BuildContext context, int index) {
                        final String url = favoriteUrlsList[index];
                        return ListTile(
                            selectedColor: Colors.orange,
                            leading: const Icon(Icons.arrow_forward_ios_outlined),
                            title: Text(url.length > 50 ? '${url.substring(0, 50)}...' : url),
                            onTap: () {
                              webViewController.loadRequest(Uri.parse(formatUrl(url)));
                              Scaffold.of(context).closeDrawer();
                              textEditingController.text = url;
                            });
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
