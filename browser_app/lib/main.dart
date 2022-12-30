import 'package:browser_app/business/favorites_state.dart';
import 'package:browser_app/business/page_status_state.dart';
import 'package:browser_app/business/url_history_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'views/browser_page.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<UrlHistoryState>(
      create: (context) => UrlHistoryState(),
    ),
    ChangeNotifierProvider<FavoritesState>(
      create: (context) => FavoritesState(),
    ),
    ChangeNotifierProvider<PageStatusPage>(
      create: (context) => PageStatusPage(),
    ),
  ], child: const BrowserApp()));
}

class BrowserApp extends StatelessWidget {
  const BrowserApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Browser App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const BrowserPage(),
    );
  }
}
