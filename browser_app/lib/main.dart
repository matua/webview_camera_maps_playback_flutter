import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'views/browser_page.dart';

void main() {
  runApp(const ProviderScope(child: BrowserApp()));
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
        primarySwatch: Colors.blue,
      ),
      home: const BrowserPage(),
    );
  }
}
