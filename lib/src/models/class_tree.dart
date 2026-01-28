import 'skill.dart';
import 'character.dart';

enum ClassTier {
  novice,
  advanced,
  elite,
  supreme,
}

class PromotionCondition {
  final int minLevel;
  final List<String> requiredClasses;

  const PromotionCondition({this.minLevel = 1, this.requiredClasses = const []});

  bool isSatisfiedBy(Character c, Set<String> ownedClasses) {
    if (c.level < minLevel) return false;
    for (final id in requiredClasses) {
      if (!ownedClasses.contains(id)) return false;
    }
    return true;
  }
  Map<String, dynamic> toJson() => {
        'minLevel': minLevel,
        'requiredClasses': requiredClasses,
      };

  static PromotionCondition fromJson(Map<String, dynamic> j) => PromotionCondition(
        minLevel: j['minLevel'] ?? 1,
        requiredClasses: List<String>.from(j['requiredClasses'] ?? []),
      );
}

class ClassNode {
  final String id;
  final String name;
  final ClassTier tier;
  final String emoji;
  final String description;

  // Boosts multiplicatifs ou additifs simples (ex: {'swordMastery': 0.10, 'maxHp': 0.15})
  final Map<String, double> masteryBoosts;

  // Compétence active ou null
  final Skill? activeSkill;

  // Si true => boost/passif appliqué en permanence; sinon peut être lié à compétence/condition
  final bool passiveAlways;

  // Conditions pour débloquer / promouvoir vers cette classe
  final PromotionCondition promotionCondition;

  // Liste d'ids de classes accessibles depuis ce noeud (pour l'arborescence)
  final List<String> children;

  const ClassNode({
    required this.id,
    required this.name,
    required this.tier,
    required this.emoji,
    required this.description,
    this.masteryBoosts = const {},
    this.activeSkill,
    this.passiveAlways = false,
    this.promotionCondition = const PromotionCondition(),
    this.children = const [],
  });

  bool canPromoteFrom(Character c, Set<String> ownedClasses) {
    return promotionCondition.isSatisfiedBy(c, ownedClasses);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'tier': tier.name,
        'emoji': emoji,                                                                                                                                                                                                                                                                                                       
        'description': description,                                                                                                 
        'masteryBoosts': masteryBoosts,           
        'activeSkill': activeSkill != null ? activeSkill!.toJson() : null,
        'passiveAlways': passiveAlways,
        'promotionCondition': promotionCondition.toJson(),
        'children': children,
      };

  static ClassNode fromJson(Map<String, dynamic> j) {
    return ClassNode(
      id: j['id'],
      name: j['name'],
      tier: ClassTier.values.byName(j['tier']),
      emoji: j['emoji'] ?? '',
      description: j['description'] ?? '',
      masteryBoosts: Map<String, double>.from(j['masteryBoosts'] ?? {}),
      activeSkill: j['activeSkill'] != null ? Skill.fromJson(j['activeSkill']) : null,
      passiveAlways: j['passiveAlways'] ?? false,
      promotionCondition: PromotionCondition.fromJson(Map<String, dynamic>.from(j['promotionCondition'] ?? {})),
      children: List<String>.from(j['children'] ?? []),
    );
  }
}

class ClassTree {
  final Map<String, ClassNode> nodes;

  ClassTree(this.nodes);

  // Cached default tree to avoid reconstructing nodes on hot paths
  static ClassTree? _cachedDefault;

  ClassNode? get(String id) => nodes[id];

  // Retourne les classes promouvables pour un personnage (en se basant sur ses classes possédées)
  List<ClassNode> promotableFor(Character c, Set<String> ownedClasses) {
    return nodes.values.where((n) => n.canPromoteFrom(c, ownedClasses) && !ownedClasses.contains(n.id)).toList();
  }

  // Appliquer les boosts passifs d'une classe à un personnage (fonction simple, retourne map de boosts)
  Map<String, double> aggregatePassiveBoostsFor(Set<String> ownedClasses) {
    final agg = <String, double>{};
    for (final id in ownedClasses) {
      final node = nodes[id];
      if (node == null) continue;
      if (node.passiveAlways) {
        node.masteryBoosts.forEach((k, v) {
          agg[k] = (agg[k] ?? 0.0) + v;
        });
      }
    }
    return agg;
  }

  Map<String, dynamic> toJson() => {
        'nodes': nodes.map((k, v) => MapEntry(k, v.toJson())),
      };

  static ClassTree defaultTree() {
    if (_cachedDefault != null) return _cachedDefault!;

    final nodes = <String, ClassNode>{};

    // NOVICES (4)
    nodes['novice_swordsman'] = ClassNode(
      id: 'novice_swordsman',
      name: 'Épéiste',
      tier: ClassTier.novice,
      emoji: '🗡️',
      description: 'Apprenti épéiste, équilibré en attaque et défense.',
      masteryBoosts: {'sword': 0.05},
      passiveAlways: true,
      children: ['adv_blade_master', 'adv_dualist'],
      promotionCondition: const PromotionCondition(minLevel: 1),
    );

    nodes['novice_peasant'] = ClassNode(
      id: 'novice_peasant',
      name: 'Paysan',
      tier: ClassTier.novice,
      emoji: '🥊',
      description: 'Combattant polyvalent, bon en combat au corps à corps et à l\'arc.',
      masteryBoosts: {'unarmed': 0.07, 'maxHp': 0.05},
      passiveAlways: true,
      children: ['adv_berserker', 'adv_guard'],
      promotionCondition: const PromotionCondition(minLevel: 1),
    );

    nodes['novice_mage'] = ClassNode(
      id: 'novice_mage',
      name: 'Mage',
      tier: ClassTier.novice,
      emoji: '🪄',
      description: 'Étudiant des arcanes, bon en magie.',
      masteryBoosts: {'staff': 0.05, 'magic': 0.05},
      passiveAlways: true,
      children: ['adv_pyromancer', 'adv_sorcerer'],
      promotionCondition: const PromotionCondition(minLevel: 1),
    );

    nodes['novice_healer'] = ClassNode(
      id: 'novice_healer',
      name: 'Soigneur',
      tier: ClassTier.novice,
      emoji: '💚',
      description: 'Apprend les bases du soin et du soutien.',
      masteryBoosts: {'rod': 0.05, 'healMultiplier': 0.10},
      passiveAlways: true,
      children: ['adv_cleric', 'adv_medic'],
      promotionCondition: const PromotionCondition(minLevel: 1),
    );

    // ADVANCED (2 variantes par novice)
    nodes['adv_dualist'] = ClassNode(
      id: 'adv_dualist',
      name: 'Duelliste',
      tier: ClassTier.advanced,
      emoji: '⚔️',
      description: 'Attaques rapides et précision.',
      masteryBoosts: {'sword': 0.12, 'speed': 0.05},
      activeSkill: const Skill(
        id: 'riposte',
        name: 'Riposte',
        emoji: '↩️',
        description: 'Riposte quand on est touché (dégâts modérés).',
        type: SkillType.active,
        statBonuses: {'damageMultiplier': 0.20},
      ),
      passiveAlways: false,
      promotionCondition: const PromotionCondition(minLevel: 5, requiredClasses: ['novice_swordsman']),
      children: ['elite_blademaster'],
    );

    nodes['adv_guard'] = ClassNode(
      id: 'adv_guard',
      name: 'Garde',
      tier: ClassTier.advanced,
      emoji: '🛡️',
      description: 'Tank solide, protège les alliés.',
      masteryBoosts: {'maxHp': 0.12, 'defense': 0.12},
      passiveAlways: true,
      promotionCondition: const PromotionCondition(minLevel: 5, requiredClasses: ['novice_swordsman']),
      children: ['elite_guard'],
    );

    nodes['adv_berserker'] = ClassNode(
      id: 'adv_berserker',
      name: 'Berserker',
      tier: ClassTier.advanced,
      emoji: '👹',
      description: 'Dégâts élevés au prix de défense.',
      masteryBoosts: {'unarmed': 0.18, 'attack': 0.10},
      activeSkill: const Skill(
        id: 'frenzy',
        name: 'Frénésie',
        emoji: '🔥',
        description: 'Augmente les dégâts pour quelques tours.',
        type: SkillType.active,
        statBonuses: {'damageMultiplier': 0.35},
      ),
      passiveAlways: false,
      promotionCondition: const PromotionCondition(minLevel: 5, requiredClasses: ['novice_peasant']),
      children: ['elite_berserker'],
    );

    nodes['adv_bowman'] = ClassNode(
      id: 'adv_bowman',
      name: 'Archer',
      tier: ClassTier.advanced,
      emoji: '🏹',
      description: 'Spécialiste des attaques à distance.',
      masteryBoosts: {'bow': 0.15, 'speed': 0.07},
      activeSkill: const Skill(
        id: 'piercing_shot',
        name: 'Tir Perçant',
        emoji: '🎯',
        description: 'Tir qui ignore une partie de la défense ennemie.',
        type: SkillType.active,
        statBonuses: {'damageMultiplier': 0.40},
      ),
      passiveAlways: false,
      promotionCondition: const PromotionCondition(minLevel: 5, requiredClasses: ['novice_peasant']),
      children: ['elite_bowman'],
    );

    nodes['adv_pyromancer'] = ClassNode(
      id: 'adv_pyromancer',
      name: 'Pyromancien',
      tier: ClassTier.advanced,
      emoji: '🔥',
      description: 'Spécialiste dégâts feu.',
      masteryBoosts: {'magic': 0.15},
      activeSkill: const Skill(
        id: 'fireball_plus',
        name: 'Fireball+',
        emoji: '🔥',
        description: 'Boule de feu améliorée.',
        type: SkillType.active,
        statBonuses: {'damageMultiplier': 0.45},
      ),
      passiveAlways: false,
      promotionCondition: const PromotionCondition(minLevel: 5, requiredClasses: ['novice_mage']),
      children: ['elite_archmage'],
    );

    nodes['adv_sorcerer'] = ClassNode(
      id: 'adv_sorcerer',
      name: 'Sorcier',
      tier: ClassTier.advanced,
      emoji: '🧙',
      description: 'Maîtrise des arcanes et utilitaires.',
      masteryBoosts: {'magic': 0.12, 'evasion': 0.05},
      passiveAlways: true,
      promotionCondition: const PromotionCondition(minLevel: 5, requiredClasses: ['novice_mage']),
      children: ['elite_archmage'],
    );

    nodes['adv_cleric'] = ClassNode(
      id: 'adv_cleric',
      name: 'Clerc',
      tier: ClassTier.advanced,
      emoji: '⛑️',
      description: 'Soins et protections renforcés.',
      masteryBoosts: {'healMultiplier': 0.18, 'magic': 0.08},
      activeSkill: const Skill(
        id: 'mass_heal',
        name: 'Soin de Groupe',
        emoji: '✨',
        description: 'Soigne plusieurs alliés.',
        type: SkillType.active,
        statBonuses: {'healMultiplier': 0.30},
      ),
      passiveAlways: false,
      promotionCondition: const PromotionCondition(minLevel: 5, requiredClasses: ['novice_healer']),
      children: ['elite_champion'],
    );

    nodes['adv_medic'] = ClassNode(
      id: 'adv_medic',
      name: 'Médecin',
      tier: ClassTier.advanced,
      emoji: '🩺',
      description: 'Soutien axé sur buff et utilitaires.',
      masteryBoosts: {'magic': 0.08, 'lootBonus': 0.05},
      passiveAlways: true,
      promotionCondition: const PromotionCondition(minLevel: 5, requiredClasses: ['novice_healer']),
      children: ['elite_champion'],
    );

    // ELITES (exemples)
    nodes['elite_blademaster'] = ClassNode(
      id: 'elite_blademaster',
      name: 'Maître Lame',
      tier: ClassTier.elite,
      emoji: '🏅',
      description: 'Élite de l\'épée, boost majeur de maîtrise.',
      masteryBoosts: {'sword': 0.30, 'attack': 0.12},
      activeSkill: const Skill(
        id: 'tempest',
        name: 'Tempête de Lames',
        emoji: '🌪️',
        description: 'Attaque multi-cible puissante.',
        type: SkillType.active,
        statBonuses: {'damageMultiplier': 0.60},
      ),
      passiveAlways: false,
      promotionCondition: const PromotionCondition(minLevel: 10, requiredClasses: ['adv_blade_master']),
      children: ['supreme_legendary'],
    );

    nodes['elite_guard'] = ClassNode(
      id: 'elite_guard',
      name: 'Gardien',
      tier: ClassTier.elite,
      emoji: '🛡️',
      description: 'Tank d\'élite, défense et soutien accrus.',
      masteryBoosts: {'maxHp': 0.25, 'defense': 0.20},
      activeSkill: const Skill(
        id: 'fortress',
        name: 'Forteresse',
        emoji: '🏰',
        description: 'Augmente fortement la défense de tous les alliés.',
        type: SkillType.active,
        statBonuses: {'defense': 0.30},
      ),
      passiveAlways: false,
      promotionCondition: const PromotionCondition(minLevel: 10, requiredClasses: ['adv_guard']),
      children: ['supreme_legendary'],
    );

    nodes['elite_berserker'] = ClassNode(
      id: 'elite_berserker',
      name: 'Berserker Légendaire',
      tier: ClassTier.elite,
      emoji: '💥',
      description: 'Violence débridée, dégâts énormes.',
      masteryBoosts: {'unarmed': 0.35, 'attack': 0.18},
      activeSkill: const Skill(
        id: 'rage_unbound',
        name: 'Rage Déchaînée',
        emoji: '💢',
        description: 'Augmente massivement les dégâts pour X tours.',
        type: SkillType.active,
        statBonuses: {'damageMultiplier': 0.80},
      ),
      passiveAlways: false,
      promotionCondition: const PromotionCondition(minLevel: 10, requiredClasses: ['adv_berserker']),
      children: ['supreme_legendary'],
    );

    nodes['elite_bowman'] = ClassNode(
      id: 'elite_bowman',
      name: 'Archer d\'Élite',
      tier: ClassTier.elite,
      emoji: '🎯',
      description: 'Maître archer, précision et dégâts accrus.',
      masteryBoosts: {'bow': 0.30, 'speed': 0.12},
      activeSkill: const Skill(
        id: 'rain_of_arrows',
        name: 'Pluie de Flèches',
        emoji: '🌧️',
        description: 'Attaque en zone avec des flèches multiples.',
        type: SkillType.active,
        statBonuses: {'damageMultiplier': 0.70},
      ),
      passiveAlways: false,
      promotionCondition: const PromotionCondition(minLevel: 10, requiredClasses: ['adv_bowman']),
      children: ['supreme_legendary'],
    );

    nodes['elite_archmage'] = ClassNode(
      id: 'elite_archmage',
      name: 'Archimage',
      tier: ClassTier.elite,
      emoji: '🔮',
      description: 'Maître des arcanes, grande puissance magique.',
      masteryBoosts: {'magic': 0.35},
      activeSkill: const Skill(
        id: 'arcane_storm',
        name: 'Orage Arcane',
        emoji: '⚡',
        description: 'Dégâts magiques massifs en zone.',
        type: SkillType.active,
        statBonuses: {'damageMultiplier': 0.75},
      ),
      passiveAlways: false,
      promotionCondition: const PromotionCondition(minLevel: 10, requiredClasses: ['adv_sorcerer']),
      children: ['supreme_legendary'],
    );

    nodes['elite_dragon'] = ClassNode(
      id: 'elite_dragon',
      name: 'Hybride Dragon',
      tier: ClassTier.elite,
      emoji: '🐉',
      description: 'Puissance draconique, maîtrise du feu.',
      masteryBoosts: {'magic': 0.28, 'fireMastery': 0.25},
      activeSkill: const Skill(
        id: 'dragon_breath',
        name: 'Souffle du Dragon',
        emoji: '🔥',
        description: 'Souffle de feu dévastateur en cône.',
        type: SkillType.active,
        statBonuses: {'damageMultiplier': 0.70},
      ),
      passiveAlways: false,
      promotionCondition: const PromotionCondition(minLevel: 10, requiredClasses: ['adv_pyromancer']),
      children: ['supreme_legendary'],
    );

    nodes['elite_clampion'] = ClassNode(
      id: 'elite_champion',
      name: 'Champion',
      tier: ClassTier.elite,
      emoji: '🏆',
      description: 'Soigneur et support d\'élite.',
      masteryBoosts: {'healMultiplier': 0.25, 'magic': 0.12},
      activeSkill: const Skill(
        id: 'holy_light',
        name: 'Lumière Sacrée',
        emoji: '🌟',
        description: 'Soigne fortement un allié.',
        type: SkillType.active,
        statBonuses: {'healMultiplier': 0.40},
      ),
      passiveAlways: false,
      promotionCondition: const PromotionCondition(minLevel: 10, requiredClasses: ['adv_cleric', 'adv_medic']),
      children: ['supreme_legendary'],
    );

    // SUPREME (condition spéciale: exiger une elite + niveau élevé)
    nodes['supreme_legendary'] = ClassNode(
      id: 'supreme_legendary',
      name: 'Suprême',
      tier: ClassTier.supreme,
      emoji: '🌟',
      description: 'Forme ultime, débloquée sous conditions strictes.',
      masteryBoosts: {'attack': 0.30, 'magic': 0.30, 'sword': 0.25},
      activeSkill: const Skill(
        id: 'ultimate_destiny',
        name: 'Destin Ultime',
        emoji: '✨',
        description: 'Compétence ultime aux effets dévastateurs.',
        type: SkillType.ultimate,
        statBonuses: {'damageMultiplier': 1.2},
      ),
      passiveAlways: false,
      promotionCondition: const PromotionCondition(minLevel: 15, requiredClasses: ['elite_blademaster', 'elite_archmage']),
      children: [],
    );

    _cachedDefault = ClassTree(nodes);
    return _cachedDefault!;
  }

  /// Clear the cached default tree (useful for tests or dynamic reloads)
  static void clearCache() {
    _cachedDefault = null;
  }

  /// Convenience accessor for the cached default tree.
  /// Use `ClassTree.instance` instead of `ClassTree.defaultTree()` in hot paths.
  static ClassTree get instance {
    if (_cachedDefault != null) return _cachedDefault!;
    return defaultTree();
  }
}