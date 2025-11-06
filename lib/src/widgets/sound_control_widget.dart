import 'package:flutter/material.dart';
import '../services/sound_manager.dart';

/// Widget pour contrôler le son (musique et SFX) dans l'UI
class SoundControlWidget extends StatefulWidget {
  const SoundControlWidget({super.key});

  @override
  State<SoundControlWidget> createState() => _SoundControlWidgetState();
}

class _SoundControlWidgetState extends State<SoundControlWidget> {
  final SoundManager _soundManager = SoundManager();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Bouton musique
        IconButton(
          icon: Icon(
            _soundManager.musicEnabled ? Icons.music_note : Icons.music_off,
            color: _soundManager.musicEnabled ? Colors.amber : Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _soundManager.musicEnabled = !_soundManager.musicEnabled;
            });
          },
          tooltip: 'Toggle Music',
        ),
        
        // Bouton effets sonores
        IconButton(
          icon: Icon(
            _soundManager.sfxEnabled ? Icons.volume_up : Icons.volume_off,
            color: _soundManager.sfxEnabled ? Colors.amber : Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _soundManager.sfxEnabled = !_soundManager.sfxEnabled;
            });
          },
          tooltip: 'Toggle SFX',
        ),
      ],
    );
  }
}

/// Dialog pour ajuster finement les volumes
class SoundSettingsDialog extends StatefulWidget {
  const SoundSettingsDialog({super.key});

  @override
  State<SoundSettingsDialog> createState() => _SoundSettingsDialogState();
}

class _SoundSettingsDialogState extends State<SoundSettingsDialog> {
  final SoundManager _soundManager = SoundManager();
  late double _musicVolume;
  late double _sfxVolume;

  @override
  void initState() {
    super.initState();
    _musicVolume = _soundManager.musicVolume;
    _sfxVolume = _soundManager.sfxVolume;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('🎵 Sound Settings'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Music Volume
          Row(
            children: [
              const Icon(Icons.music_note, color: Colors.amber),
              const SizedBox(width: 12),
              const Text('Music'),
              Expanded(
                child: Slider(
                  value: _musicVolume,
                  min: 0.0,
                  max: 1.0,
                  divisions: 20,
                  label: '${(_musicVolume * 100).round()}%',
                  onChanged: (value) {
                    setState(() {
                      _musicVolume = value;
                      _soundManager.musicVolume = value;
                    });
                  },
                ),
              ),
            ],
          ),
          
          // SFX Volume
          Row(
            children: [
              const Icon(Icons.volume_up, color: Colors.amber),
              const SizedBox(width: 12),
              const Text('SFX'),
              Expanded(
                child: Slider(
                  value: _sfxVolume,
                  min: 0.0,
                  max: 1.0,
                  divisions: 20,
                  label: '${(_sfxVolume * 100).round()}%',
                  onChanged: (value) {
                    setState(() {
                      _sfxVolume = value;
                      _soundManager.sfxVolume = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
