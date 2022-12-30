import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'business/favorites_state.dart';
import 'business/page_status_state.dart';
import 'business/url_history_state.dart';
import 'views/browser_page.dart';

void main() {
  runApp(MultiProvider(providers: <ChangeNotifierProvider<dynamic>>[
    ChangeNotifierProvider<UrlHistoryState>(
      create: (BuildContext context) => UrlHistoryState(),
    ),
    ChangeNotifierProvider<FavoritesState>(
      create: (BuildContext context) => FavoritesState(),
    ),
    ChangeNotifierProvider<PageStatusPage>(
      create: (BuildContext context) => PageStatusPage(),
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
