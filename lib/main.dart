import 'package:flutter/material.dart';
import 'src/screens/main_menu_screen.dart';

void main() {
  runApp(const TacticalDiceApp());
}

class TacticalDiceApp extends StatelessWidget {
  const TacticalDiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dice Destiny: Idle Rifts',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.dark,
      ),
      home: const MainMenuScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}