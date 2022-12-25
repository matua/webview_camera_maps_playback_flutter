import 'package:flutter/material.dart';

class Button_Widget extends StatelessWidget {
  const Button_Widget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.8), borderRadius: BorderRadius.circular(16)),
    );
  }
}
