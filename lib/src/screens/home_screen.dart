import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../services/game_data_service.dart';
import '../services/sound_manager.dart';
import '../models/player.dart';
import '../widgets/player_bar.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  final SoundManager _soundManager = SoundManager();

  @override
  void initState() {
    super.initState();
    _initializeSound();
  }

  Future<void> _initializeSound() async {
    // Lance la musique du menu avec un fade-in de 1 seconde
    // (pas besoin d'initialize(), déjà fait dans main.dart)
    await _soundManager.playMusic('musics/menu.mp3', fadeIn: 1000);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
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
            child: Column(
              children: [
                // Barre du joueur
                StreamBuilder<Player?>(
                  stream: GameDataService.watchPlayer(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        height: 80,
                        color: Colors.black.withOpacity(0.3),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Colors.amber,
                            strokeWidth: 2,
                          ),
                        ),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data == null) {
                      return Container(
                        height: 80,
                        color: Colors.black.withOpacity(0.3),
                        child: const Center(
                          child: Text(
                            'No player data',
                            style: TextStyle(color: Colors.white54),
                          ),
                        ),
                      );
                    }

                    return PlayerBar(player: snapshot.data!);
                  },
                ),
            
            // Contenu principal
            Expanded(
              child: SafeArea(
                top: false,
                child: Column(
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
                    
                    const Spacer(),
                    
                    // Message de bienvenue
                    Padding(
                      padding: const EdgeInsets.all(32),
                      child: Text(
                        S.of(context)!.welcomeMessage,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 16,
                        ),
                      ),
                    ),
                    
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      
    ],
      ),
    );
  }
}