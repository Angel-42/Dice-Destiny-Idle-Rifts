import 'package:flutter/material.dart';
import '../services/game_data_service.dart';
import 'intro_screen.dart';
import 'game_hub_screen.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _blinkAnimation;
  bool _isLoading = true;
  bool _hasCharacters = false;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _blinkAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    
    _animationController.repeat(reverse: true);
    _checkForCharacters();
  }
  
  Future<void> _checkForCharacters() async {
    try {
      // Vérifier si le joueur a un profil ET des personnages
      final hasProfile = await GameDataService.hasProfile();
      final hasChars = await GameDataService.hasCharacters();
      
      setState(() {
        _hasCharacters = hasProfile && hasChars;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Erreur lors de la vérification: $e');
      setState(() {
        _hasCharacters = false;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0D1421),
              Color(0xFF1A1A2E),
              Color(0xFF16213E),
              Color(0xFF0F1419),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Game title
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFFFD700).withOpacity(0.7),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFFD700).withOpacity(0.3),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Column(
                    children: [
                      Text(
                        'TACTICAL',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFFD700),
                          letterSpacing: 8,
                          shadows: [
                            Shadow(
                              color: Colors.black,
                              offset: Offset(3, 3),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'DICE',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFFD700),
                          letterSpacing: 8,
                          shadows: [
                            Shadow(
                              color: Colors.black,
                              offset: Offset(3, 3),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 60),
                
                // Subtitle
                const Text(
                  'Aventure Tactique et Stratégie',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                
                const SizedBox(height: 80),
                
                // Main action button
                if (_isLoading)
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFD700)),
                  )
                else
                  AnimatedBuilder(
                    animation: _blinkAnimation,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _blinkAnimation.value,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFFD700), Color(0xFFFFA000)],
                            ),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFFD700).withOpacity(0.5),
                                blurRadius: 15,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(30),
                              onTap: _handlePlayButtonPressed,
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 50,
                                  vertical: 20,
                                ),
                                child: Text(
                                  'CLIQUEZ POUR JOUER',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                
                const SizedBox(height: 40),
                
                // Version info
                const Text(
                  'Version 1.0.0 - RPG Complet',
                  style: TextStyle(
                    color: Colors.white30,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  void _handlePlayButtonPressed() async {
    if (_hasCharacters) {
      // Navigate to game hub with existing player and main character
      final player = await GameDataService.getPlayer();
      final mainCharacter = await GameDataService.getMainCharacter();
      
      if (player != null && mainCharacter != null && mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => GameHubScreen(
              player: player,
              character: mainCharacter,
            ),
          ),
        );
      }
    } else {
      // Navigate to intro for new player
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const IntroScreen(),
          ),
        );
      }
    }
  }
}
