import 'package:flutter/material.dart';
import '../models/character.dart';

class ShopScreen extends StatelessWidget {
  final Character character;

  const ShopScreen({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🏪', style: TextStyle(fontSize: 80)),
          const SizedBox(height: 20),
          const Text(
            'Boutique',
            style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            'En cours de développement',
            style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.7)),
          ),
        ],
      ),
    );
  }
}
