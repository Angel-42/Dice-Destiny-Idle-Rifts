import 'package:flutter/material.dart';

class SummonScreen extends StatelessWidget {
  const SummonScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Summon'),
      ),
      body: Center(
        child: const Text(
          'Summon Screen',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}