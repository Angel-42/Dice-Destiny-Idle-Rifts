import 'package:flutter/material.dart';

/// Widget pour afficher une icône (sprite ou emoji)
/// Utilisé pour les skills, équipements, personnages, etc.
class IconDisplay extends StatelessWidget {
  final String icon;
  final double size;
  final BoxFit fit;

  const IconDisplay({
    super.key,
    required this.icon,
    this.size = 32,
    this.fit = BoxFit.contain,
  });

  /// Détermine si l'icône est un sprite (chemin de fichier) ou un emoji
  bool get _isSprite {
    return icon.startsWith('assets/') || 
           icon.startsWith('~/assets/') ||
           icon.endsWith('.png') || 
           icon.endsWith('.jpg') || 
           icon.endsWith('.webp');
  }

  @override
  Widget build(BuildContext context) {
    if (_isSprite) {
      // Nettoyer le chemin (enlever ~/ si présent)
      final cleanPath = icon.startsWith('~/') ? icon.substring(2) : icon;
      
      return Image.asset(
        cleanPath,
        width: size,
        height: size,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          // Fallback sur un emoji générique si l'image n'existe pas
          return Text(
            '❓',
            style: TextStyle(fontSize: size * 0.8),
          );
        },
      );
    } else {
      // Afficher l'emoji
      return Text(
        icon,
        style: TextStyle(fontSize: size * 0.8),
      );
    }
  }
}

/// Extension pour faciliter l'affichage depuis les modèles
extension IconDisplayHelper on Widget {
  static Widget fromSkillOrEquipment({
    required String displayIcon,
    double size = 32,
    BoxFit fit = BoxFit.contain,
  }) {
    return IconDisplay(
      icon: displayIcon,
      size: size,
      fit: fit,
    );
  }
}
