import 'package:flutter/material.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';

class headlinewidget extends StatelessWidget {
  const headlinewidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return OutlineGradientButton(
      gradient: LinearGradient(
        colors: List.generate(360, (h) => HSLColor.fromAHSL(1, h.toDouble(), 1, 0.5).toColor()),
      ),
      strokeWidth: 2,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      radius: const Radius.circular(8),
      child: const Text('NEWS UPDATES ', style:
       TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 12)),
    );
  }
}
