import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../screens/characters_screen.dart';
import '../screens/home_screen.dart';
import '../screens/battle_screen.dart';
import '../screens/summon_screen.dart';
import '../screens/shop_screen.dart';
import '../screens/misc_screen.dart';
import '../services/idle_income_service.dart';
import '../services/sound_manager.dart';

class GameNavbar extends StatefulWidget {
  const GameNavbar({super.key});

  @override
  State<GameNavbar> createState() => GameNavbarState();
}

class GameNavbarState extends State<GameNavbar> with WidgetsBindingObserver {
  int _selectedIndex = 0;

  late final List<Widget> _widgetOptions;
  final SoundManager _soundManager = SoundManager();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    _widgetOptions = <Widget>[
      const MainMenuScreen(),    // Home
      const BattleScreen(),      // Battle
      const CharactersScreen(),  // Allies (Characters)
      const SummonScreen(),      // Summon
      const ShopScreen(),        // Shop
      const MiscScreen(),        // Misc.
    ];

    // Démarrer le service de revenus passifs
    IdleIncomeService.start();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    IdleIncomeService.stop();
    // Ne pas disposer le SoundManager (singleton global)
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    // Gérer quand l'app passe en background/foreground
    if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      // App en background ou fermée
      debugPrint('📱 App en background/fermée');
      IdleIncomeService.stop();
      _soundManager.pauseMusic();
    } else if (state == AppLifecycleState.resumed) {
      // App de retour en foreground
      debugPrint('📱 App de retour en foreground');
      IdleIncomeService.start();
      _soundManager.resumeMusic();
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF1A1A2E),
              const Color(0xFF16213E),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
          border: Border(
            top: BorderSide(
              color: const Color(0xFF4A5568),
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  icon: Icons.home,
                  label: S.of(context)!.navHome,
                  index: 0,
                  color: const Color(0xFF4FC3F7),
                ),
                _buildNavItem(
                  icon: Icons.local_fire_department,
                  label: S.of(context)!.navBattle,
                  index: 1,
                  color: const Color(0xFFFF6B6B),
                ),
                _buildNavItem(
                  icon: Icons.groups,
                  label: S.of(context)!.navAllies,
                  index: 2,
                  color: const Color(0xFF9C27B0),
                ),
                _buildNavItem(
                  icon: Icons.auto_awesome,
                  label: S.of(context)!.navSummon,
                  index: 3,
                  color: const Color(0xFFFFA726),
                ),
                _buildNavItem(
                  icon: Icons.shopping_bag,
                  label: S.of(context)!.navShop,
                  index: 4,
                  color: const Color(0xFF66BB6A),
                ),
                _buildNavItem(
                  icon: Icons.apps,
                  label: S.of(context)!.navMisc,
                  index: 5,
                  color: const Color(0xFF78909C),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required Color color,
  }) {
    final isSelected = _selectedIndex == index;

    return InkWell(
      onTap: () => _onItemTapped(index),
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected 
              ? color.withOpacity(0.2) 
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: color, width: 2)
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? color : Colors.white.withOpacity(0.5),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? color : Colors.white.withOpacity(0.5),
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}