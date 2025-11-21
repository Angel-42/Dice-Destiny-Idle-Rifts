import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dice_destiny_idle_rifts/src/screens/welcome_screen.dart';
import 'package:dice_destiny_idle_rifts/src/services/data_migration_service.dart';
import 'package:dice_destiny_idle_rifts/src/services/auth_service.dart';
import 'package:dice_destiny_idle_rifts/src/services/game_data_service.dart';
import 'package:dice_destiny_idle_rifts/src/services/locale_provider.dart';
import 'package:dice_destiny_idle_rifts/src/services/sound_manager.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await LocaleProvider.instance.load();
  await SoundManager().initialize();

  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  // Migrations de données
  DataMigrationService.migrateSkillsToV2();
  
  // Restaurer les inventaires customs des personnages presets AVANT de lancer l'app
  // (utile si les inventaires ont été perdus lors de sauvegardes précédentes)
  try {
    await GameDataService.restoreCustomInventories();
    print('✅ Vérification des inventaires terminée');
  } catch (e) {
    print('⚠️ Erreur restauration inventaires: $e');
  }
  
  runApp(const TacticalDiceApp());
}

class TacticalDiceApp extends StatelessWidget {
  const TacticalDiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: LocaleProvider.instance,
      builder: (context, _) {
        return MaterialApp(
          title: 'Dice Destiny: Idle Rifts',
          localizationsDelegates: S.localizationsDelegates,
          supportedLocales: S.supportedLocales,
          locale: LocaleProvider.instance.locale,
          theme: ThemeData(
            primarySwatch: Colors.deepPurple,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            brightness: Brightness.dark,
            colorScheme: ColorScheme.dark(
              primary: Colors.deepPurple,
              secondary: Colors.amber,
            ),
          ),
          home: const AuthWrapper(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _settingsLoaded = false;

  Future<void> _loadSettingsBasedOnSaveData(User? user) async {
    if (_settingsLoaded) return;

    final bool hasSave = await GameDataService.hasSaveData();
    
    await SoundManager().loadSettingsIfSaveExists(hasSave: hasSave);
    
    setState(() {
      _settingsLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Colors.amber),
            ),
          );
        }

        if (snapshot.hasData || snapshot.data == null) {
          _loadSettingsBasedOnSaveData(snapshot.data);
        }

        return const WelcomeScreen();
      },
    );
  }
}