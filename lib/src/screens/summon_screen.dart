import 'package:flutter/material.dart';

class SummonScreen extends StatelessWidget {
  const SummonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: const Text(
          'Summon Screen',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}