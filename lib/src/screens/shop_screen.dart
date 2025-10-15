import 'package:flutter/material.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: const Text(
          'Welcome to the Shop!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}