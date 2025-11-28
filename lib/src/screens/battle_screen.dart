import 'package:dice_destiny_idle_rifts/src/screens/campaign_selection_screen.dart';
import '../../l10n/app_localizations.dart';
import 'package:flutter/material.dart';
class BattleScreen extends StatefulWidget {
  const BattleScreen({super.key});

  @override
  State<BattleScreen> createState() => _BattleScreenState();
}

class _BattleScreenState extends State<BattleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF4A0E0E), // Rouge foncé
              Color(0xFF8B1A1A),
              Color(0xFF2C0A0A),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red.shade300, width: 2),
                      ),
                      child: const Icon(
                        Icons.local_fire_department,
                        color: Colors.orange,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      S.of(context)!.battleTitle,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 3,
                        shadows: [
                          Shadow(
                            color: Colors.red,
                            blurRadius: 10,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(color: Colors.red, thickness: 2, height: 2),

              // Content
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Icon géant
                      Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Colors.red.withOpacity(0.3),
                              Colors.transparent,
                            ],
                          ),
                        ),
                        child: const Icon(
                          Icons.sports_kabaddi,
                          size: 120,
                          color: Colors.red,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Texte
                      Text(
                        S.of(context)!.battleSystem,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 25),

                      // Bouton Campaign
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const CampaignSelectionScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.campaign),
                        label: Text(
                          S.of(context)!.campaignMode,
                          style: const TextStyle(fontSize: 18),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),

                      const SizedBox(height: 11),

                      // Bouton Rifts
                      ElevatedButton.icon(
                        onPressed: () {
                          // TODO: Navigate to Rifts
                        },
                        icon: const Icon(Icons.auto_awesome),
                        label: Text(
                          S.of(context)!.rifts,
                          style: const TextStyle(fontSize: 18),
                      ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),

                      const SizedBox(height: 11),

                      // Bouton Dungeons
                      ElevatedButton.icon(
                        onPressed: () {
                          // TODO: Navigate to Dungeons
                        },
                        icon: const Icon(Icons.door_front_door),
                        label: Text(
                          S.of(context)!.dungeons,
                          style: const TextStyle(fontSize: 18),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 14, 85, 17),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),

                      const SizedBox(height: 11),

                      // Bouton Arena
                      ElevatedButton.icon(
                        onPressed: () {
                          // TODO: Navigate to Arena
                        },
                        icon: const Icon(Icons.shield),
                        label: Text(
                          S.of(context)!.arena,
                          style: const TextStyle(fontSize: 18),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
