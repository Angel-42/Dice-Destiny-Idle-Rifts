/// États d'animation pour les sprites de combat
enum AnimationState {
  /// Idle - Animation de repos/attente
  idle,
  
  /// Attack - Animation d'attaque
  attack,
  
  /// Hit - Animation quand le personnage reçoit des dégâts
  hit,
  
  /// Death - Animation de mort/défaite
  death,
  
  /// Victory - Animation de victoire (optionnel)
  victory,
}

/// Configuration d'une animation de sprite
class AnimationConfig {
  final String assetPath;
  final int frameCount;
  final Duration frameDuration;
  final bool loop;

  const AnimationConfig({
    required this.assetPath,
    required this.frameCount,
    this.frameDuration = const Duration(milliseconds: 150),
    this.loop = true,
  });
}

/// Set d'animations pour un personnage/ennemi
class AnimationSet {
  final AnimationConfig? idle;
  final AnimationConfig? attack;
  final AnimationConfig? hit;
  final AnimationConfig? death;
  final AnimationConfig? victory;

  const AnimationSet({
    this.idle,
    this.attack,
    this.hit,
    this.death,
    this.victory,
  });

  /// Récupère l'animation pour un état donné
  AnimationConfig? getAnimation(AnimationState state) {
    switch (state) {
      case AnimationState.idle:
        return idle;
      case AnimationState.attack:
        return attack;
      case AnimationState.hit:
        return hit;
      case AnimationState.death:
        return death;
      case AnimationState.victory:
        return victory;
    }
  }

  /// Vérifie si cet ensemble a au moins une animation
  bool get hasAnimations => 
    idle != null || attack != null || hit != null || death != null || victory != null;
}
