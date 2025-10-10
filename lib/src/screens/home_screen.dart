import 'package:flutter/material.dart';
import '../services/game_data_service.dart';
import '../models/character.dart';
import 'campaign_screen.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  List<Character> _characters = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCharacters();
  }

  Future<void> _loadCharacters() async {
    try {
      final characters = await GameDataService.getAllCharacters();
      setState(() {
        _characters = characters;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('❌ Erreur chargement personnages: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _startCampaign() {
    if (_characters.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vous devez créer un personnage d\'abord !'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final character = _characters.first;
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CampaignScreen(
          characterId: character.id,
          characterName: character.name,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF1A237E),
              const Color(0xFF311B92),
              Colors.black,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.amber,
                  ),
                )
              : Column(
                  children: [
                    const SizedBox(height: 40),
                    
                    Text(
                      'DICE DESTINY',
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 3,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'IDLE RIFTS',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
                        letterSpacing: 4,
                        fontWeight: FontWeight.w300,
                      ),
                    ),

                    const SizedBox(height: 60),

                    // Menu principal
                    Expanded(
                      child: Center(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildMenuButton(
                                context,
                                icon: Icons.campaign,
                                label: 'CAMPAGNE',
                                color: Colors.amber,
                                onPressed: _startCampaign,
                              ),
                              const SizedBox(height: 20),
                              _buildMenuButton(
                                context,
                                icon: Icons.map,
                                label: 'EXPÉDITIONS',
                                color: Colors.blue,
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Bientôt disponible !'),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 20),
                              _buildMenuButton(
                                context,
                                icon: Icons.casino,
                                label: 'ARÈNE',
                                color: Colors.red,
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Bientôt disponible !'),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 20),
                              _buildMenuButton(
                                context,
                                icon: Icons.shopping_bag,
                                label: 'BOUTIQUE',
                                color: Colors.green,
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Bientôt disponible !'),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    if (_characters.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          border: Border(
                            top: BorderSide(
                              color: Colors.amber.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.person,
                              color: Colors.amber,
                              size: 32,
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Personnage actif',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  _characters.first.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 280,
      height: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black.withOpacity(0.6),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: color, width: 2),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}