import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  const TicTacToeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Colorful Tic Tac Toe',
      theme: ThemeData(primarySwatch: Colors.purple, fontFamily: 'ComicNeue'),
      home: const SplashScreen(),
    );
  }
}
