/// Player's character persona choices
class Persona {
  final PersonaRace race;
  final PersonaRegion region;
  final PersonaOrigin origin;
  final PersonaClass characterClass;
  
  const Persona({
    required this.race,
    required this.region,
    required this.origin,
    required this.characterClass,
  });
  
  // Convert to/from JSON for storage
  Map<String, dynamic> toJson() => {
    'race': race.name,
    'region': region.name,
    'origin': origin.name,
    'class': characterClass.name,
  };
  
  factory Persona.fromJson(Map<String, dynamic> json) => Persona(
    race: PersonaRace.values.byName(json['race']),
    region: PersonaRegion.values.byName(json['region']),
    origin: PersonaOrigin.values.byName(json['origin']),
    characterClass: PersonaClass.values.byName(json['class']),
  );
  
  String get displayName => '${race.displayName} ${characterClass.displayName}';
  String get description => '${race.description}\n${origin.description}\n${characterClass.description}';
}

enum PersonaRace {
  human('Humain', 'Polyvalent et adaptable, les humains excellent dans tous les domaines sans spécialisation particulière.', '👤'),
  elf('Elfe', 'Agile et intelligent, les elfes maîtrisent la magie et ont une affinité naturelle avec la nature.', '🧝'),
  dwarf('Nain', 'Robuste et tenace, les nains sont d\'excellents combattants et artisans, résistants à la magie.', '🎯'),
  orc('Orc', 'Puissant et sauvage, les orcs possèdent une force brute exceptionnelle mais manquent de finesse magique.', '👹');
  
  const PersonaRace(this.displayName, this.description, this.emoji);
  final String displayName;
  final String description;
  final String emoji;
}

enum PersonaOrigin {
  noble('Noble', 'Né dans les hautes sphères, vous maîtrisez l\'étiquette et disposez de ressources importantes.', '👑'),
  merchant('Marchand', 'Forgé par le commerce, vous excellez dans les négociations et connaissez les routes du monde.', '💰'),
  peasant('Paysan', 'Issu du peuple, vous possédez une endurance naturelle et une connaissance pratique de la survie.', '🌾'),
  scholar('Érudit', 'Passé dans les livres, vous possédez une vaste connaissance magique et historique.', '📚');
  
  const PersonaOrigin(this.displayName, this.description, this.emoji);
  final String displayName;
  final String description;
  final String emoji;
}

enum PersonaRegion {
  west('Occident', 'Terres médiévales de chevaliers et de châteaux, où l\'honneur et la foi guident les actions. Les croisades et la magie divine y sont courantes.', '🏰'),
  east('Orient', 'Contrées mystiques inspirées de l\'Asie, où la sagesse ancestrale et les arts martiaux se mélangent à la magie élémentaire.', '🏯'),
  north('Nord', 'Territoire nordique des Vikings et des clans, où la force brute et l\'endurance sont vénérées. Les runes et les esprits ancestraux y règnent.', '🛡️'),
  south('Sud', 'Déserts et pyramides mystérieuses de l\'ancienne Égypte, où la magie nécromantique et les secrets des pharaons perdurent.', '🏜️');
  
  const PersonaRegion(this.displayName, this.description, this.emoji);
  final String displayName;
  final String description;
  final String emoji;
}

enum PersonaClass {
  warrior('Guerrier', 'Combattant au corps à corps, spécialisé dans l\'attaque et la défense physique.', '⚔️'),
  mage('Mage', 'Maître des arcanes, capable de lancer des sorts dévastateurs à distance.', '🧙‍♂️'),
  rogue('Voleur', 'Expert en discrétion, excelle dans les attaques surprises et les mouvements tactiques.', '🗡️'),
  cleric('Clerc', 'Guérisseur divin, capable de soigner ses alliés et de repousser les forces du mal.', '⚕️');
  
  const PersonaClass(this.displayName, this.description, this.emoji);
  final String displayName;
  final String description;
  final String emoji;
}
