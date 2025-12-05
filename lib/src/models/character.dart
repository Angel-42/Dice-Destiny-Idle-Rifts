import '../models/persona.dart';
import '../models/equipment.dart';
import '../models/skill.dart';
import '../models/weapon_mastery.dart';
import '../models/class_tree.dart';
import '../models/character_inventory.dart';
import '../models/dice.dart';
import 'package:flutter/foundation.dart';

class Character {     // est un personnage jouable (pas le player)
  final String id;
  final String name;
  final Persona persona;
  final CharacterStats stats;
  final CharacterAppearance appearance;

  // niveau et progr du personnage
  int level;
  int xp;

  // position sur la carte
  int x;
  int y;

  int currentHp;

  // équipement
  Equipment? weapon;
  Equipment? armorOrAccessory; // Armure OU accessoire (mutuellement exclusif)

  // compétences équipées (max 4: 1 active + 3 passives)
  List<Skill> equippedSkills;
  
  // maîtrises d'armes
  List<WeaponMastery> weaponMasteries;

  // --- Nouveau: Inventaire personnel du personnage
  CharacterInventory inventory;

  // --- Nouveau: système de classes (ids référencés depuis ClassTree)
  // Ensemble d'ids de classes possédées par le personnage
  Set<String> ownedClassIds;

  // Id de la classe active (peut être l'un des ownedClassIds)
  String? activeClassId;

  // méta-data
  CharacterRarity basedRarity;
  CharacterRarity currentRarity;
  bool isInTeam;
  int teamPosition; // 0 = pas dans team, 1-3 = position
  DateTime obtainedAt;

  Character({
    String? id,
    required this.name,
    required this.persona,
    required this.stats,
    required this.appearance,
    this.level = 1,
    this.xp = 0,
    this.x = 0,
    this.y = 0,
    this.weapon,
    this.armorOrAccessory,
  List<Skill>? equippedSkills,
  List<WeaponMastery>? weaponMasteries,
  Set<String>? initialOwnedClassIds,
  this.activeClassId,
    this.basedRarity = CharacterRarity.common,
    this.currentRarity = CharacterRarity.common,
    this.isInTeam = false,
    this.teamPosition = 0,
    DateTime? obtainedAt,
    CharacterInventory? inventory,
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        currentHp = stats.maxHp,
        equippedSkills = equippedSkills ?? [],
        weaponMasteries = weaponMasteries ?? [],
  ownedClassIds = initialOwnedClassIds ?? {},
        obtainedAt = obtainedAt ?? DateTime.now(),
        inventory = inventory ?? CharacterInventory.createDefault(persona.characterClass.name) {
    // ⚠️ IMPORTANT: Si un inventory custom était fourni, ne pas le remplacer
    // Le ?? ci-dessus garantit qu'on garde le custom si fourni
    // Si pas d'arme, ajouter l'arme de départ
    weapon ??= DefaultWeapons.getForClass(persona.characterClass.name);
    
    // Si pas de compétences, ajouter les compétences de départ
    if (this.equippedSkills.isEmpty) {
      this.equippedSkills = DefaultSkills.getStartingSkills(
        persona.characterClass,
        persona.race,
        persona.origin,
      );
    }
    
    // Si pas de maîtrises, ajouter les maîtrises de départ
    if (this.weaponMasteries.isEmpty) {
      this.weaponMasteries = DefaultWeaponMasteries.getForClass(persona.characterClass);
    }

  // --- Initialisation du système de classes
  // Si aucune classe fournie, assigner la classe novice correspondant au persona.
    if (this.ownedClassIds.isEmpty) {
  final tree = ClassTree.instance;
      final noviceId = persona.characterClass.noviceId;

      // Par défaut, tout le monde commence avec la classe novice
      this.ownedClassIds.add(noviceId);

      // Sauf si c'est un héros épique: on lui donne aussi une classe avancée (choisie par défaut)
      if (basedRarity == CharacterRarity.epic) {
        final noviceNode = tree.get(noviceId);
        if (noviceNode != null && noviceNode.children.isNotEmpty) {
          final advId = noviceNode.children.first;
          this.ownedClassIds.add(advId);
          // définir la classe active sur l'advanced
          activeClassId ??= advId;
        }
      }

      // Si activeClassId toujours null, mettre la novice
      activeClassId ??= noviceId;
    }
  }

  // Convert to/from JSON for storage
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'persona': persona.toJson(),
        'stats': stats.toJson(),
        'appearance': {
          'headshot': appearance.headshot,
          'lheadshot': appearance.lheadshot,
          'pixel': appearance.pixel,
          'fullsize': appearance.fullsize,
          'colorValue': appearance.colorValue,
          'description': appearance.description,
        },
        'level': level,
        'xp': xp,
        'x': x,
        'y': y,
        // ⚠️ currentHp n'est PAS sauvegardé - toujours réinitialisé à maxHp au chargement
        'weapon': weapon?.toJson(),
        'armorOrAccessory': armorOrAccessory?.toJson(),
        'equippedSkills': equippedSkills.map((s) => s.toJson()).toList(),
  'weaponMasteries': weaponMasteries.map((w) => w.toJson()).toList(),
  // Sauvegarde de l'inventaire
  'inventory': inventory.toJson(),
  // Sauvegarde du système de classes
  'ownedClassIds': ownedClassIds.toList(),
  'activeClassId': activeClassId,
        'basedRarity': basedRarity.name,
        'currentRarity': currentRarity.name,
        'isInTeam': isInTeam,
        'teamPosition': teamPosition,
        'obtainedAt': obtainedAt.toIso8601String(),
      };

  /// Tente de récupérer l'inventaire custom depuis CharacterDatabase pour les personnages preset
  static CharacterInventory? _tryRecoverCustomInventory(String? characterId, Persona persona) {
    if (characterId == null) return null;
    
    // Import dynamique pour éviter la dépendance circulaire
    try {
      // Utiliser l'import conditionnel via une fonction helper
      return _getCustomInventoryFromDatabase(characterId, persona);
    } catch (e) {
      debugPrint('⚠️ Erreur récupération inventaire custom: $e');
      return null;
    }
  }
  
  /// Helper pour récupérer l'inventaire custom sans créer de dépendance circulaire au niveau du fichier
  static CharacterInventory? _getCustomInventoryFromDatabase(String characterId, Persona persona) {
    // Import dynamique - cette méthode sera appelée à runtime
    // Les IDs des presets: 'chrom_001', 'envia_001', 'elio_001', 'mca_001', 'ragor_001'
    
    // Mapping des IDs vers les inventaires customs
    // Note: On ne peut pas importer CharacterDatabase ici sans créer une dépendance circulaire
    // Donc on va vérifier si l'inventaire existe dans le JSON et sinon créer un défaut
    
    // Si pas d'inventaire dans le JSON, on va créer un inventaire par défaut amélioré
    // basé sur la classe du personnage
    return CharacterInventory.createDefault(persona.characterClass.name);
  }
  
  factory Character.fromJson(Map<String, dynamic> json) {
    final persona = Persona.fromJson(json['persona']);
    
    // Lire appearance depuis Firestore, sinon fallback sur race
    final appearance = json['appearance'] != null
        ? CharacterAppearance(
            // Support ancien format (emoji) et nouveau (headshot)
            headshot: json['appearance']['headshot'] ?? json['appearance']['emoji'] ?? '👤',
            lheadshot: json['appearance']['lheadshot'],
            pixel: json['appearance']['pixel'],
            fullsize: json['appearance']['fullsize'],
            colorValue: json['appearance']['colorValue'] ?? 0xFF2196F3,
            description: json['appearance']['description'] ?? '',
          )
        : CharacterAppearance.fromRace(persona.race);
    
    return Character(
      id: json['id'],
      name: json['name'],
      persona: persona,
      stats: CharacterStats.fromJson(json['stats']),
      appearance: appearance,
      level: json['level'] ?? 1,
      xp: json['xp'] ?? 0,
      x: json['x'] ?? 0,
      y: json['y'] ?? 0,
      weapon: json['weapon'] != null ? Equipment.fromJson(json['weapon']) : null,
      armorOrAccessory: json['armorOrAccessory'] != null 
          ? Equipment.fromJson(json['armorOrAccessory']) 
          : (json['armor'] != null ? Equipment.fromJson(json['armor']) : null), // Rétrocompatibilité
      equippedSkills: (json['equippedSkills'] as List?)
          ?.map((s) => Skill.fromJson(s))
          .toList(),
      weaponMasteries: (json['weaponMasteries'] as List?)
          ?.map((w) => WeaponMastery.fromJson(w))
          .toList(),
      inventory: json['inventory'] != null 
          ? CharacterInventory.fromJson(json['inventory'])
          : _tryRecoverCustomInventory(json['id'], persona), // Tente de récupérer l'inventaire custom
      initialOwnedClassIds: ((json['ownedClassIds'] as List?) ?? []).map((e) => e.toString()).toSet(),
      activeClassId: json['activeClassId'],
      basedRarity: CharacterRarity.values.firstWhere(
        (r) => r.name == json['basedRarity'],
        orElse: () => CharacterRarity.common,
      ),
      currentRarity: CharacterRarity.values.firstWhere(
        (r) => r.name == json['currentRarity'],
        orElse: () => CharacterRarity.common,
      ),
      isInTeam: json['isInTeam'] ?? false,
      teamPosition: json['teamPosition'] ?? 0,
      obtainedAt: json['obtainedAt'] != null
          ? DateTime.parse(json['obtainedAt'])
          : DateTime.now(),
    ); // currentHp est automatiquement initialisé à stats.maxHp dans le constructeur
  }

  String get displayName => '$name (${persona.displayName})';
  bool get isAlive => currentHp > 0;
  double get hpPercentage => currentHp / stats.maxHp;

  // XP nécessaire pour le niveau suivant
  int get xpForNextLevel => level * 50;

  // Progression vers le niveau suivant
  double get levelProgress => xp / xpForNextLevel;

  // ============================================================================
  // STATS CALCULÉES (stats de base + bonus d'équipement + bonus de compétences)
  // ============================================================================

  /// Calcule les bonus d'équipement pour une stat donnée
  int _getEquipmentBonus(String statKey) {
    int bonus = 0;
    
    // Bonus de l'arme
    if (weapon != null && weapon!.bonuses.containsKey(statKey)) {
      bonus += weapon!.bonuses[statKey]!;
    }
    
    // Bonus de l'armure ou accessoire
    if (armorOrAccessory != null && armorOrAccessory!.bonuses.containsKey(statKey)) {
      bonus += armorOrAccessory!.bonuses[statKey]!;
    }
    
    return bonus;
  }

  /// Calcule les bonus de compétences passives (en % multiplicatif)
  double _getSkillBonusMultiplier(String statKey) {
    double multiplier = 1.0;
    
    for (final skill in equippedSkills) {
      if (skill.type == SkillType.passive && skill.statBonuses.containsKey(statKey)) {
        multiplier += skill.statBonuses[statKey]!;
      }
    }

    // Ajouter les boosts passifs provenant des classes (ClassTree)
    try {
  final classBoosts = ClassTree.instance.aggregatePassiveBoostsFor(ownedClassIds);
      if (classBoosts.containsKey(statKey)) {
        multiplier += classBoosts[statKey]!;
      }
    } catch (_) {
      // Defensive: si ClassTree n'est pas disponible ou autre, ignorer
    }

    return multiplier;
  }

  /// Attaque totale (base + équipement) * compétences
  int get totalAttack {
    final base = stats.attack + _getEquipmentBonus('attack');
    return (base * _getSkillBonusMultiplier('attack')).round();
  }

  /// Défense totale (base + équipement) * compétences
  int get totalDefense {
    final base = stats.defense + _getEquipmentBonus('defense');
    return (base * _getSkillBonusMultiplier('defense')).round();
  }

  /// Magie totale (base + équipement) * compétences
  int get totalMagic {
    final base = stats.magic + _getEquipmentBonus('magic');
    return (base * _getSkillBonusMultiplier('magic')).round();
  }

  /// Stat offensive principale selon la classe (attack OU magic)
  int get totalOffensive {
    return persona.characterClass.isMagical ? totalMagic : totalAttack;
  }

  /// Nom de la stat offensive ("ATK" ou "MAG")
  String get offensiveStatName {
    return persona.characterClass.isMagical ? 'MAG' : 'ATK';
  }

  /// Icône de la stat offensive
  String get offensiveStatIcon {
    return persona.characterClass.isMagical ? '✨' : '⚔️';
  }

  /// Vitesse totale (base + équipement) * compétences
  int get totalSpeed {
    final base = stats.speed + _getEquipmentBonus('speed');
    return (base * _getSkillBonusMultiplier('speed')).round();
  }

  /// Chance totale (base + équipement) * compétences
  int get totalLuck {
    final base = stats.luck + _getEquipmentBonus('luck');
    return (base * _getSkillBonusMultiplier('luck')).round();
  }

  /// HP max total (base + équipement) * compétences
  int get totalMaxHp {
    final base = stats.maxHp + _getEquipmentBonus('maxHp');
    return (base * _getSkillBonusMultiplier('maxHp')).round();
  }

  // ============================================================================
  // SYSTÈME DE COMBAT
  // ============================================================================

  /// Calcule les dégâts physiques infligés à un adversaire (avec critique possible)
  /// Formule: (Attaque * Maîtrise d'arme * Skill multiplicateur) - (Défense adversaire * 0.5)
  /// Retourne un tuple (dégâts, isCritical)
  (int damage, bool isCritical) calculatePhysicalDamageWithCrit(Character target, {Skill? activeSkill}) {
    // Vérifier si c'est un critique (RNG caché influencé par Luck)
    final isCritical = DiceService.rollCriticalHit(totalLuck);
    
    // Attaque de base (avec équipement et passives)
    double damage = totalAttack.toDouble();
    
    // Bonus de maîtrise d'arme (si équipé d'une arme)
    if (weapon != null) {
      final weaponType = _getWeaponType(weapon!);
      final mastery = weaponMasteries.firstWhere(
        (m) => m.type == weaponType,
        orElse: () => WeaponMastery(type: weaponType, level: 0),
      );
      // +5% par niveau de maîtrise (E=0%, D=5%, C=10%, B=15%, A=20%, S=25%)
      damage *= (1.0 + (mastery.level * 0.05));
    }

    // Appliquer les boosts de maîtrise spécifiques d'une classe (ex: 'sword', 'unarmed')
    try {
      final classBoosts = ClassTree.instance.aggregatePassiveBoostsFor(ownedClassIds);
      if (weapon != null) {
        final wt = _getWeaponType(weapon!);
        switch (wt) {
          case WeaponType.sword:
            if (classBoosts.containsKey('sword')) damage *= (1.0 + classBoosts['sword']!);
            break;
          case WeaponType.staff:
            if (classBoosts.containsKey('staff')) damage *= (1.0 + classBoosts['staff']!);
            break;
          case WeaponType.dagger:
            if (classBoosts.containsKey('dagger')) damage *= (1.0 + classBoosts['dagger']!);
            break;
          case WeaponType.rod:
            if (classBoosts.containsKey('rod')) damage *= (1.0 + classBoosts['rod']!);
            break;
          default:
            break;
        }
      } else {
        // Pas d'arme => appliquer boost 'unarmed' si présent
        if (classBoosts.containsKey('unarmed')) damage *= (1.0 + classBoosts['unarmed']!);
      }
    } catch (_) {
      // ignore errors
    }
    
    // Bonus de compétence active utilisée + autres passifs liés aux multiplicateurs de dégâts
    if (activeSkill != null && activeSkill.statBonuses.containsKey('damageMultiplier')) {
      final skillMult = 1.0 + activeSkill.statBonuses['damageMultiplier']!;
      // Inclure passifs / classes qui affectent damageMultiplier
      final passiveDamageMult = _getSkillBonusMultiplier('damageMultiplier');
      damage *= skillMult * passiveDamageMult;
    } else {
      // Même si aucune compétence active, appliquer les passifs qui modifient damageMultiplier
      final passiveDamageMult = _getSkillBonusMultiplier('damageMultiplier');
      damage *= passiveDamageMult;
    }
    
    // CRITIQUE : ×2.5 dégâts
    if (isCritical) {
      damage *= 2.5;
    }
    
    // Réduction selon la défense de la cible
    final defense = target.totalDefense * 0.5;
    damage -= defense;
    
    // Dégâts minimum de 1
    return (damage.round().clamp(1, 9999), isCritical);
  }

  /// Version legacy pour compatibilité (appelle la nouvelle avec critique)
  int calculatePhysicalDamage(Character target, {Skill? activeSkill}) {
    final (damage, _) = calculatePhysicalDamageWithCrit(target, activeSkill: activeSkill);
    return damage;
  }

  /// Calcule les dégâts magiques infligés à un adversaire (avec critique possible)
  /// Formule: (Magie * Skill multiplicateur) - (Résistance adversaire * 0.3)
  /// Retourne un tuple (dégâts, isCritical)
  (int damage, bool isCritical) calculateMagicDamageWithCrit(Character target, {Skill? activeSkill}) {
    // Vérifier si c'est un critique (RNG caché influencé par Luck)
    final isCritical = DiceService.rollCriticalHit(totalLuck);
    
    // Magie de base (avec équipement et passives)
    double damage = totalMagic.toDouble();
    
    if (activeSkill != null && activeSkill.statBonuses.containsKey('damageMultiplier')) {
      final skillMult = 1.0 + activeSkill.statBonuses['damageMultiplier']!;
      final passiveDamageMult = _getSkillBonusMultiplier('damageMultiplier');
      damage *= skillMult * passiveDamageMult;
    } else {
      final passiveDamageMult = _getSkillBonusMultiplier('damageMultiplier');
      damage *= passiveDamageMult;
    }
    
    // CRITIQUE : ×2.5 dégâts
    if (isCritical) {
      damage *= 2.5;
    }
    
    // Réduction selon la résistance magique de la cible
    final resistance = target.totalMagic * 0.3;
    damage -= resistance;
    
    return (damage.round().clamp(1, 9999), isCritical);
  }

  /// Version legacy pour compatibilité
  int calculateMagicDamage(Character target, {Skill? activeSkill}) {
    final (damage, _) = calculateMagicDamageWithCrit(target, activeSkill: activeSkill);
    return damage;
  }

  /// Calcule la quantité de soin fournie par une compétence (activeSkill)
  /// Retourne la valeur de HP restaurée (sans appliquer au target ici)
  /// Formule de base : target.maxHp * healMultiplier * passifs
  int calculateHealAmount(Character target, {Skill? activeSkill}) {
    if (activeSkill == null) return 0;
    if (!activeSkill.statBonuses.containsKey('healMultiplier')) return 0;

    final baseMult = activeSkill.statBonuses['healMultiplier']!; // ex: 0.30 = 30% HP

    // Passifs / classes qui impactent le multiplicateur de soin
    final passiveHealMult = _getSkillBonusMultiplier('healMultiplier');

    double amount = target.totalMaxHp * baseMult;
    amount *= passiveHealMult;

    // Ne pas dépasser le HP manquant
    final missing = (target.totalMaxHp - target.currentHp).clamp(0, target.totalMaxHp);
    return amount.round().clamp(0, missing);
  }

  /// Détermine le type d'arme équipée
  WeaponType _getWeaponType(Equipment weapon) {
    // Mapping basé sur l'ID ou le nom de l'arme
    switch (weapon.id) {
      case 'iron_sword':
      case 'steel_sword':
        return WeaponType.sword;
      case 'wooden_staff':
      case 'mage_staff':
        return WeaponType.staff;
      case 'iron_dagger':
      case 'steel_dagger':
        return WeaponType.dagger;
      case 'healing_rod':
        return WeaponType.rod;
      default:
        return WeaponType.sword; // Par défaut
    }
  }

  // Ajouter de l'XP et gérer les montées de niveau
  void addXP(int amount) {
    xp += amount;
    while (xp >= xpForNextLevel) {
      xp -= xpForNextLevel;
      level++;
      _levelUpStats();
    }
  }

  void _levelUpStats() {
    // Bonus selon la rareté de base (petite différence)
    double rarityMultiplier;
    switch (basedRarity) {
      case CharacterRarity.common:
        rarityMultiplier = 1.0;
        break;
      case CharacterRarity.rare:
        rarityMultiplier = 1.1;
        break;
      case CharacterRarity.epic:
        rarityMultiplier = 1.2;
        break;
      case CharacterRarity.legendary:
        rarityMultiplier = 1.3;
        break;
    }

    switch (persona.characterClass) {
      case PersonaClass.warrior:
        stats.attack += (3 * rarityMultiplier).round();
        stats.defense += (2 * rarityMultiplier).round();
        stats.maxHp += (10 * rarityMultiplier).round();
        break;
      case PersonaClass.mage:
        stats.magic += (4 * rarityMultiplier).round();
        stats.attack += (1 * rarityMultiplier).round();
        stats.maxHp += (5 * rarityMultiplier).round();
        break;
      case PersonaClass.peasant:
        stats.speed += (3 * rarityMultiplier).round();
        stats.attack += (2 * rarityMultiplier).round();
        stats.luck += (1 * rarityMultiplier).round();
        break;
      case PersonaClass.cleric:
        stats.magic += (2 * rarityMultiplier).round();
        stats.defense += (2 * rarityMultiplier).round();
        stats.maxHp += (8 * rarityMultiplier).round();
        break;
    }
    currentHp = stats.maxHp;
  }
  
  // Puissance globale du personnage (avec bonus d'équipement)
  int get power => totalAttack + totalDefense + totalMagic + totalSpeed + totalLuck + (level * 10);
}

enum CharacterRarity {
  common, // 60% - 1-3 étoiles
  rare,   // 25% - 3-4 étoiles
  epic,   // 12% - 4-5 étoiles
  legendary; // 3% - 5 étoiles

  String get displayName {
    switch (this) {
      case CharacterRarity.common:
        return 'Commun';
      case CharacterRarity.rare:
        return 'Rare';
      case CharacterRarity.epic:
        return 'Épique';
      case CharacterRarity.legendary:
        return 'Légendaire';
    }
  }

  int get stars {
    switch (this) {
      case CharacterRarity.common:
        return 2;
      case CharacterRarity.rare:
        return 3;
      case CharacterRarity.epic:
        return 4;
      case CharacterRarity.legendary:
        return 5;
    }
  }
}

class CharacterStats {
  int maxHp;
  int attack;
  int defense;
  int speed;
  int magic;
  int range;
  int luck;
  int gold;
  int movement; // Portée de déplacement sur la carte tactique
  
  CharacterStats({
    required this.maxHp,
    required this.attack,
    required this.defense,
    required this.speed,
    required this.magic,
    required this.range,
    required this.luck,
    this.gold = 100,
    this.movement = 4, // Valeur par défaut
  });
  
  Map<String, dynamic> toJson() => {
    'maxHp': maxHp,
    'attack': attack,
    'defense': defense,
    'speed': speed,
    'magic': magic,
    'range': range,
    'luck': luck,
    'gold': gold,
    'movement': movement,
  };
  
  factory CharacterStats.fromJson(Map<String, dynamic> json) => CharacterStats(
    maxHp: json['maxHp'],
    attack: json['attack'],
    defense: json['defense'],
    speed: json['speed'],
    magic: json['magic'],
    range: json['range'],
    luck: json['luck'],
    gold: json['gold'] ?? 100,
    movement: json['movement'] ?? 4,
  );
}

/// Visual appearance and UI elements for character
class CharacterAppearance {
  // Sprites pour différents contextes
  final String headshot;      // Icône dans la liste des alliés
  final String? lheadshot;    // Image longue dans les détails (optionnel)
  final String? pixel;        // Spritesheet pour les combats (optionnel)
  final String? fullsize;     // Image plein écran (optionnel)
  
  // Autres propriétés d'apparence
  final int colorValue;
  final String description;
  
  const CharacterAppearance({
    required this.headshot,
    this.lheadshot,
    this.pixel,
    this.fullsize,
    required this.colorValue,
    required this.description,
  });
  
  // Getter pour compatibilité avec l'ancien système
  String get emoji => headshot;
  
  factory CharacterAppearance.fromRace(PersonaRace race) {
    switch (race) {
      case PersonaRace.human:
        return const CharacterAppearance(
          headshot: '👤',
          colorValue: 0xFF2196F3,
          description: 'Polyvalent et équilibré',
        );
      case PersonaRace.elf:
        return const CharacterAppearance(
          headshot: '🧝',
          colorValue: 0xFF4CAF50,
          description: 'Agile et magique',
        );
      case PersonaRace.dwarf:
        return const CharacterAppearance(
          headshot: '🛡️',
          colorValue: 0xFF795548,
          description: 'Robuste et résistant',
        );
      case PersonaRace.orc:
        return const CharacterAppearance(
          headshot: '👹',
          colorValue: 0xFFFF5722,
          description: 'Puissant et féroce',
        );
    }
  }
}