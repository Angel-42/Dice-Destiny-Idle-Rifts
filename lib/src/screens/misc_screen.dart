import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../services/auth_service.dart';
import 'bestiary_screen.dart';
import 'codex_screen.dart';
import 'settings_screen.dart';
import 'welcome_screen.dart';

class MiscScreen extends StatelessWidget {
  const MiscScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF37474F), // Gris bleuté
              Color(0xFF263238),
              Color(0xFF1A237E),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
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
                        color: Colors.blueGrey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blueGrey.shade300, width: 2),
                      ),
                      child: const Icon(
                        Icons.apps,
                        color: Colors.cyan,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      S.of(context)!.miscTitle,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.cyan,
                        letterSpacing: 3,
                        shadows: [
                          Shadow(
                            color: Colors.blue,
                            blurRadius: 10,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(color: Colors.cyan, thickness: 2, height: 2),

              // Content - Grid of options
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    children: [
                      _buildMiscCard(
                        context: context,
                        icon: Icons.settings,
                        label: S.of(context)!.settings,
                        color: Colors.blue,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SettingsScreen(),
                            ),
                          );
                        },
                      ),
                      _buildMiscCard(
                        context: context,
                        icon: Icons.menu_book,
                        label: 'Bestiary',
                        color: Colors.deepPurple,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const BestiaryScreen(),
                            ),
                          );
                        },
                      ),
                      _buildMiscCard(
                        context: context,
                        icon: Icons.people,
                        label: 'Codex',
                        color: Colors.amber,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CodexScreen(),
                            ),
                          );
                        },
                      ),
                      _buildMiscCard(
                        context: context,
                        icon: Icons.card_giftcard,
                        label: S.of(context)!.gifts,
                        color: Colors.pink,
                        onTap: () {
                          // TODO: Gifts screen
                        },
                      ),
                      _buildMiscCard(
                        context: context,
                        icon: Icons.emoji_events,
                        label: S.of(context)!.events,
                        color: Colors.orange,
                        onTap: () {
                          // TODO: Events screen
                        },
                      ),
                      _buildMiscCard(
                        context: context,
                        icon: Icons.leaderboard,
                        label: S.of(context)!.rankings,
                        color: Colors.purple,
                        onTap: () {
                          // TODO: Rankings screen
                        },
                      ),
                      _buildMiscCard(
                        context: context,
                        icon: Icons.description,
                        label: S.of(context)!.news,
                        color: Colors.teal,
                        onTap: () {
                          // TODO: News screen
                        },
                      ),
                      _buildMiscCard(
                        context: context,
                        icon: Icons.help_outline,
                        label: S.of(context)!.help,
                        color: Colors.green,
                        onTap: () {
                          // TODO: Help screen
                        },
                      ),
                      _buildMiscCard(
                        context: context,
                        icon: Icons.group,
                        label: S.of(context)!.friends,
                        color: Colors.cyan,
                        onTap: () {
                          // TODO: Friends screen
                        },
                      ),
                      _buildMiscCard(
                        context: context,
                        icon: Icons.logout,
                        label: S.of(context)!.logout,
                        color: Colors.red,
                        onTap: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (dialogContext) => AlertDialog(
                              backgroundColor: Colors.blueGrey.shade900,
                              title: Text(S.of(context)!.logout),
                              content: Text(S.of(context)!.logoutConfirm),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(dialogContext, false),
                                  child: Text(S.of(context)!.cancel),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(dialogContext, true),
                                  child: Text(
                                    S.of(context)!.logout,
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            await AuthService.signOut();
                            
                            // 👇 FORCER LA NAVIGATION VERS WELCOME
                            if (context.mounted) {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => const WelcomeScreen(),
                                ),
                                (route) => false, // Supprime toutes les routes
                              );
                            }
                          }
                        },
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

  Widget _buildMiscCard({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.5),
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 48,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
