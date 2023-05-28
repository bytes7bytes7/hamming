import 'package:flutter/material.dart';

import 'hamming_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Hamming code',
      home: HammingScreen(),
    );
  }
}
