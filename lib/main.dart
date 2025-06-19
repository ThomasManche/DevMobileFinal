import 'package:flutter/material.dart';
import 'affichage/page_acceuil/page_acceuil.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChessArena',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PageAcceuil(),
    );
  }
}
