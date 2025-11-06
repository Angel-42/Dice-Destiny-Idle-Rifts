import 'package:audioplayers/audioplayers.dart';

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
  bool _musicEnabled = true;
  bool _sfxEnabled = true;
  double _musicVolume = 0.7;
  double _sfxVolume = 1.0;
  
  String? _currentMusic;

  /// Initialise le SoundManager
  Future<void> initialize() async {
    // Configure le player de musique en mode loop
    await _musicPlayer.setReleaseMode(ReleaseMode.loop);
    await _musicPlayer.setVolume(_musicVolume);
    
    // Configure le player de SFX en mode release
    await _sfxPlayer.setReleaseMode(ReleaseMode.release);
    await _sfxPlayer.setVolume(_sfxVolume);
  }

  /// Joue une musique de fond (loop automatique)
  /// 
  /// [musicPath] : chemin relatif depuis assets/ (ex: 'musics/menu.mp3')
  /// [fadeIn] : durée du fade-in en millisecondes (0 = pas de fade)
  Future<void> playMusic(String musicPath, {int fadeIn = 0}) async {
    if (!_musicEnabled) return;
    
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
    await _musicPlayer.pause();
  }

  /// Reprend la musique
  Future<void> resumeMusic() async {
    if (_musicEnabled && _currentMusic != null) {
      await _musicPlayer.resume();
    }
  }

  /// Joue un effet sonore (one-shot)
  /// 
  /// [sfxPath] : chemin relatif depuis assets/ (ex: 'sounds/click.mp3')
  /// [volume] : volume spécifique pour ce son (null = utilise le volume global)
  Future<void> playSfx(String sfxPath, {double? volume}) async {
    if (!_sfxEnabled) return;

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
    if (!value) {
      _musicPlayer.pause();
    } else if (_currentMusic != null) {
      _musicPlayer.resume();
    }
  }

  /// Active/désactive les effets sonores
  set sfxEnabled(bool value) {
    _sfxEnabled = value;
  }

  /// Change le volume de la musique (0.0 à 1.0)
  set musicVolume(double value) {
    _musicVolume = value.clamp(0.0, 1.0);
    _musicPlayer.setVolume(_musicVolume);
  }

  /// Change le volume des SFX (0.0 à 1.0)
  set sfxVolume(double value) {
    _sfxVolume = value.clamp(0.0, 1.0);
  }

  /// Libère les ressources
  Future<void> dispose() async {
    await _musicPlayer.dispose();
    await _sfxPlayer.dispose();
  }
}
