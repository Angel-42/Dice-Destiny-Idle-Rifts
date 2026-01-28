import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

/// Service singleton pour gérer tous les sons du jeu
/// - Musiques de fond (loop)
/// - Effets sonores (one-shot)
class SoundManager {
  static final SoundManager _instance = SoundManager._internal();
  factory SoundManager() => _instance;
  SoundManager._internal();

  // Players séparés pour musique et SFX
  final AudioPlayer _musicPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();

  // État
  bool _isInitialized = false;
  bool _musicEnabled = true;
  bool _sfxEnabled = true;
  double _musicVolume = 0.7;
  double _sfxVolume = 1.0;
  
  String? _currentMusic;

  /// Initialise le SoundManager avec les settings par défaut
  /// Pour charger les settings sauvegardés, appeler loadSettingsIfLinked() séparément
  Future<void> initialize() async {
    if (_isInitialized) {
      print('⚠️ SoundManager déjà initialisé');
      return;
    }

    try {
      // Configure le player de musique en mode loop
      await _musicPlayer.setReleaseMode(ReleaseMode.loop);
      await _musicPlayer.setVolume(_musicVolume);
      
      // Configure le player de SFX en mode release
      await _sfxPlayer.setReleaseMode(ReleaseMode.release);
      await _sfxPlayer.setVolume(_sfxVolume);
      
      _isInitialized = true;
      print('✅ SoundManager initialisé');
    } catch (e) {
      print('❌ Erreur initialization SoundManager: $e');
    }
  }

  /// Charge les settings SEULEMENT si une sauvegarde existe
  /// Sinon, réinitialise aux valeurs par défaut (nouvelle partie)
  Future<void> loadSettingsIfSaveExists({required bool hasSave}) async {
    if (!hasSave) {
      // Nouvelle partie (pas de sauvegarde) : reset aux valeurs par défaut
      print('🆕 Nouvelle partie détectée - Settings audio par défaut');
      await resetToDefaults();
      return;
    }

    // Sauvegarde existe : charger les settings sauvegardés
    await _loadSettings();
  }

  /// Charge les settings depuis SharedPreferences
  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _musicEnabled = prefs.getBool('music_enabled') ?? true;
      _sfxEnabled = prefs.getBool('sfx_enabled') ?? true;
      _musicVolume = prefs.getDouble('music_volume') ?? 0.7;
      _sfxVolume = prefs.getDouble('sfx_volume') ?? 0.8;
      
      // Appliquer les volumes chargés aux players
      await _musicPlayer.setVolume(_musicVolume);
      await _sfxPlayer.setVolume(_sfxVolume);
      
      print('🔊 Settings chargés depuis la sauvegarde:');
      print('   Music: $_musicEnabled (Volume: $_musicVolume)');
      print('   SFX: $_sfxEnabled (Volume: $_sfxVolume)');
    } catch (e) {
      print('⚠️ Erreur chargement settings audio: $e');
      // Garder les valeurs par défaut
    }
  }

  /// Réinitialise les settings aux valeurs par défaut et les sauvegarde
  Future<void> resetToDefaults() async {
    _musicEnabled = true;
    _sfxEnabled = true;
    _musicVolume = 0.7;
    _sfxVolume = 0.8;
    
    // Appliquer les volumes seulement si le manager est initialisé
    if (_isInitialized) {
      await _musicPlayer.setVolume(_musicVolume);
      await _sfxPlayer.setVolume(_sfxVolume);
    }
    
    await _saveSettings();
    print('🔄 Settings audio réinitialisés aux valeurs par défaut');
  }

  /// Sauvegarde les settings automatiquement
  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('music_enabled', _musicEnabled);
      await prefs.setBool('sfx_enabled', _sfxEnabled);
      await prefs.setDouble('music_volume', _musicVolume);
      await prefs.setDouble('sfx_volume', _sfxVolume);
    } catch (e) {
      print('⚠️ Erreur sauvegarde settings audio: $e');
    }
  }

  /// Joue une musique de fond (loop automatique)
  /// 
  /// [musicPath] : chemin relatif depuis assets/ (ex: 'musics/menu.mp3')
  /// [fadeIn] : durée du fade-in en millisecondes (0 = pas de fade)
  Future<void> playMusic(String musicPath, {int fadeIn = 0}) async {
    if (!_isInitialized) {
      print('⚠️ SoundManager pas encore initialisé, impossible de jouer la musique');
      return;
    }

    if (!_musicEnabled) {
      print('🔇 Musique désactivée, pas de lecture');
      return;
    }
    
    // Si c'est déjà la musique en cours, ne rien faire
    if (_currentMusic == musicPath) return;

    // Arrête la musique précédente
    if (_currentMusic != null) {
      await stopMusic(fadeOut: fadeIn > 0 ? fadeIn : 0);
    }

    try {
      _currentMusic = musicPath;
      
      if (fadeIn > 0) {
        // Fade-in progressif
        await _musicPlayer.setVolume(0);
        await _musicPlayer.play(AssetSource(musicPath));
        
        // Augmente progressivement le volume
        final steps = 20;
        final stepDuration = fadeIn ~/ steps;
        final volumeStep = _musicVolume / steps;
        
        for (int i = 1; i <= steps; i++) {
          await Future.delayed(Duration(milliseconds: stepDuration));
          await _musicPlayer.setVolume(volumeStep * i);
        }
      } else {
        // Lecture directe
        await _musicPlayer.setVolume(_musicVolume);
        await _musicPlayer.play(AssetSource(musicPath));
      }
    } catch (e) {
      print('❌ Erreur lors de la lecture de la musique $musicPath: $e');
      _currentMusic = null;
    }
  }

  /// Arrête la musique en cours
  /// 
  /// [fadeOut] : durée du fade-out en millisecondes (0 = arrêt immédiat)
  Future<void> stopMusic({int fadeOut = 0}) async {
    if (!_isInitialized) return;
    if (_currentMusic == null) return;

    try {
      if (fadeOut > 0) {
        // Fade-out progressif
        final currentVolume = _musicVolume;
        final steps = 20;
        final stepDuration = fadeOut ~/ steps;
        final volumeStep = currentVolume / steps;
        
        for (int i = steps - 1; i >= 0; i--) {
          await Future.delayed(Duration(milliseconds: stepDuration));
          await _musicPlayer.setVolume(volumeStep * i);
        }
      }
      
      await _musicPlayer.stop();
      _currentMusic = null;
    } catch (e) {
      print('❌ Erreur lors de l\'arrêt de la musique: $e');
    }
  }

  /// Met la musique en pause
  Future<void> pauseMusic() async {
    if (!_isInitialized) return;

    try {
      final state = _musicPlayer.state;
      if (state == PlayerState.playing) {
        await _musicPlayer.pause();
      }
    } catch (e) {
      print('❌ Erreur lors de la mise en pause de la musique: $e');
    }
  }

  /// Reprend la musique
  Future<void> resumeMusic() async {
    if (!_isInitialized || !musicEnabled) return;

    try {
      final state = _musicPlayer.state;
      if (state == PlayerState.paused) {
        await _musicPlayer.resume();
      }
    } catch (e) {
      print('❌ Erreur lors de la reprise de la musique: $e');
    }
  }

  /// Joue un effet sonore (one-shot)
  /// 
  /// [sfxPath] : chemin relatif depuis assets/ (ex: 'sounds/click.mp3')
  /// [volume] : volume spécifique pour ce son (null = utilise le volume global)
  Future<void> playSfx(String sfxPath, {double? volume}) async {
    if (!_isInitialized || !_sfxEnabled) return;

    try {
      final player = AudioPlayer();
      await player.setReleaseMode(ReleaseMode.release);
      await player.setVolume(volume ?? _sfxVolume);
      await player.play(AssetSource(sfxPath));
      
      // Libère le player après lecture
      player.onPlayerComplete.listen((_) {
        player.dispose();
      });
    } catch (e) {
      print('❌ Erreur lors de la lecture du SFX $sfxPath: $e');
    }
  }

  // === Getters / Setters ===

  bool get musicEnabled => _musicEnabled;
  bool get sfxEnabled => _sfxEnabled;
  double get musicVolume => _musicVolume;
  double get sfxVolume => _sfxVolume;
  String? get currentMusic => _currentMusic;

  /// Active/désactive la musique
  set musicEnabled(bool value) {
    _musicEnabled = value;
    if (!_isInitialized) return;

    if (!value) {
      _musicPlayer.pause();
    } else if (_currentMusic != null) {
      _musicPlayer.resume();
    }
    _saveSettings(); // Sauvegarde automatique
  }

  /// Active/désactive les effets sonores
  set sfxEnabled(bool value) {
    _sfxEnabled = value;
    _saveSettings(); // Sauvegarde automatique
  }

  /// Change le volume de la musique (0.0 à 1.0)
  set musicVolume(double value) {
    _musicVolume = value.clamp(0.0, 1.0);
    if (_isInitialized) {
      _musicPlayer.setVolume(_musicVolume);
    }
    _saveSettings(); // Sauvegarde automatique
  }

  /// Change le volume des SFX (0.0 à 1.0)
  set sfxVolume(double value) {
    _sfxVolume = value.clamp(0.0, 1.0);
    _saveSettings(); // Sauvegarde automatique
  }

  /// Libère les ressources
  Future<void> dispose() async {
    if (!_isInitialized) return;
    
    try {
      await _musicPlayer.stop();
      await _musicPlayer.dispose();
    } catch (e) {
      debugPrint('Erreur lors du dispose de _musicPlayer: $e');
    }
    
    try {
      await _sfxPlayer.stop();
      await _sfxPlayer.dispose();
    } catch (e) {
      debugPrint('Erreur lors du dispose de _sfxPlayer: $e');
    }
    
    _isInitialized = false;
  }
}
