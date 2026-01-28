import 'package:dice_destiny_idle_rifts/src/models/campaign_data.dart';

/// Base de données complète des chapitres et stages de la campagne
class CampaignDatabase {
  
  /// Détermine le chemin initial selon la persona du joueur
  static StoryPath getInitialPath(String personaOrigin, String personaClass) {
    // Le path initial est déterminé par le PREMIER CHOIX du joueur, pas par son origine
    // On retourne order par défaut, mais il sera immédiatement remplacé par le choix
    return StoryPath.order;
  }

  /// Détermine la région de spawn selon la région de la persona
  static String getSpawnRegion(String personaRegion) {
    // West -> Aethelgard, East -> Flux Céleste, North -> Forêt, South -> Désert
    switch (personaRegion.toLowerCase()) {
      case 'west':
        return 'aethelgard';
      case 'east':
        return 'flux_celeste';
      case 'north':
        return 'foret_murmures';
      case 'south':
        return 'desert_osiris';
      default:
        return 'aethelgard'; // Par défaut
    }
  }

  static final List<CampaignChapter> chapters = [
    // ========================================================================
    // CHAPITRE 1 : PREMIER RÉVEIL (Varie selon la persona)
    // ========================================================================
    
    // 1A - AETHELGARD (Noble/Ordre)
    CampaignChapter(
      chapterNumber: 1,
      chapterName: 'Aethelgard - L\'Éveil du Noble',
      description: 'Dans les geôles du royaume déchu, un noble doit choisir entre l\'ordre et la rébellion.',
      theme: 'aethelgard',
      chapterEvents: [
        StoryEvent(
          id: 'aethelgard_intro',
          type: DialogueType.intro,
          speaker: 'narrator',
          text: 'Tu te réveilles dans une cellule froide. Des barreaux de fer rouillé. '
                'Elio, un garde aux intentions pures, t\'observe depuis le couloir.',
        ),
        StoryEvent(
          id: 'elio_greeting',
          type: DialogueType.intro,
          speaker: 'elio',
          speakerAvatar: 'assets/characters/Elio/headshot.png',
          text: 'Enfin réveillé ? Tu as dormi trois jours. Quelque chose de terrible se prépare dehors. '
                'Des Ombres de Négation attaquent les remparts.',
          choices: [
            StoryChoice(
              id: 'help_elio',
              text: 'Je vais t\'aider à les repousser.',
              description: 'Suivre la voie de l\'ORDRE avec Elio',
              path: StoryPath.order,
              rewards: {'reputation': 10},
            ),
            StoryChoice(
              id: 'rebel',
              text: 'C\'est l\'occasion parfaite pour m\'échapper.',
              description: 'Embrasser le CHAOS et la rébellion',
              path: StoryPath.chaos,
              rewards: {'gold': 50},
            ),
          ],
        ),
      ],
      stages: [
        CampaignStage(
          chapter: 1,
          stage: 1,
          baseName: 'Les Geôles',
          baseDescription: 'Le premier choix déterminera ton destin.',
          variants: [
            StageVariant(
              path: StoryPath.order,
              name: 'Les Geôles - Alliance',
              description: 'Tu aides Elio à repousser l\'Ombre de Négation qui s\'infiltre.',
              mapTheme: 'dungeon',
              enemies: [
                EnemySpawn(enemyId: 'shadow_negation', x: 6, y: 3, level: 1),
                EnemySpawn(enemyId: 'robber', x: 7, y: 5, level: 1),
              ],
              rewards: {'gold': 100, 'xp': 50, 'reputation': 5},
              events: [
                StoryEvent(
                  id: 'elio_gratitude',
                  type: DialogueType.outro,
                  speaker: 'elio',
                  text: 'Merci ! Prends cette épée, tu en auras besoin. '
                        'Ensemble, nous restaurerons l\'ordre dans ce monde.',
                ),
              ],
            ),
            StageVariant(
              path: StoryPath.chaos,
              name: 'Les Geôles - Évasion',
              description: 'Tu voles les clés et frappes le garde pour t\'échapper.',
              mapTheme: 'dungeon',
              enemies: [
                EnemySpawn(enemyId: 'robber', x: 5, y: 3, level: 1),
                EnemySpawn(enemyId: 'robber', x: 7, y: 4, level: 1),
                EnemySpawn(enemyId: 'iron_sentinel', x: 6, y: 6, level: 1),
              ],
              rewards: {'gold': 150, 'xp': 40, 'notoriety': 5},
              events: [
                StoryEvent(
                  id: 'escape_success',
                  type: DialogueType.outro,
                  speaker: 'narrator',
                  text: 'Tu t\'enfuis dans la nuit. Une dague ensanglantée dans ta main. '
                        'Le chaos t\'appelle...',
                ),
              ],
            ),
          ],
        ),
        
        CampaignStage(
          chapter: 1,
          stage: 2,
          baseName: 'Le Passage',
          baseDescription: 'Deux routes s\'offrent à toi selon tes choix passés.',
          variants: [
            StageVariant(
              path: StoryPath.order,
              name: 'La Grand-Place',
              description: 'Tu marches aux côtés des gardes dans la lumière du jour.',
              mapTheme: 'town',
              enemies: [
                EnemySpawn(enemyId: 'wolf', x: 4, y: 2, level: 2), // Loups comme dans la lore
                EnemySpawn(enemyId: 'wolf', x: 6, y: 4, level: 2),
              ],
              rewards: {'gold': 120, 'xp': 70, 'equipment': 1},
            ),
            StageVariant(
              path: StoryPath.chaos,
              name: 'Les Bas-Fonds',
              description: 'Tu fuis par les égouts sombres, évitant les patrouilles.',
              mapTheme: 'dungeon',
              enemies: [
                EnemySpawn(enemyId: 'shadow_negation', x: 3, y: 3, level: 2), // Ombres dans les égouts
                EnemySpawn(enemyId: 'shadow_negation', x: 5, y: 5, level: 2),
                EnemySpawn(enemyId: 'shadow_negation', x: 7, y: 2, level: 2),
              ],
              rewards: {'gold': 80, 'xp': 90, 'rare_components': 2},
            ),
          ],
        ),
        
        CampaignStage(
          chapter: 1,
          stage: 3,
          baseName: 'La Brèche',
          baseDescription: 'L\'affrontement final du premier chapitre.',
          variants: [
            StageVariant(
              path: StoryPath.order,
              name: 'Siège de l\'Ordre',
              description: 'Tu défends la porte avec une armée aux côtés d\'Elio.',
              mapTheme: 'breach',
              enemies: [
                EnemySpawn(enemyId: 'crystal_wolf', x: 6, y: 3, level: 3),
                EnemySpawn(enemyId: 'robber', x: 4, y: 5, level: 2),
                EnemySpawn(enemyId: 'robber', x: 8, y: 5, level: 2),
              ],
              rewards: {'gold': 200, 'xp': 100, 'reputation': 10},
              events: [
                StoryEvent(
                  id: 'elio_victory',
                  type: DialogueType.outro,
                  speaker: 'elio',
                  text: 'Nous avons repoussé l\'attaque ! Mais ce n\'est que le début. '
                        'Des forces plus sombres s\'agitent au cœur du Rift.',
                ),
              ],
            ),
            StageVariant(
              path: StoryPath.chaos,
              name: 'Évasion Sanglante',
              description: 'Coincé entre les gardes et la Brèche, tu dois affronter Elio.',
              mapTheme: 'breach',
              enemies: [
                EnemySpawn(enemyId: 'iron_sentinel', x: 5, y: 3, level: 4), // Boss: ELIO (Capitaine de la Garde)
                EnemySpawn(enemyId: 'robber', x: 4, y: 2, level: 2),
                EnemySpawn(enemyId: 'robber', x: 6, y: 2, level: 2),
                EnemySpawn(enemyId: 'shadow_negation', x: 7, y: 4, level: 2),
              ],
              rewards: {'gold': 250, 'xp': 120, 'notoriety': 10},
              events: [
                StoryEvent(
                  id: 'elio_defeated',
                  type: DialogueType.outro,
                  speaker: 'narrator',
                  text: 'Elio s\'effondre, vaincu. Ses derniers mots résonnent : '
                        '"Tu as choisi le chaos... Ce monde te le fera payer."',
                ),
              ],
            ),
          ],
        ),
      ],
    ),

    // 1B - FLUX CÉLESTE (Scholar/Connaissance)  
    CampaignChapter(
      chapterNumber: 1, // Tous les chapitres de départ sont "chapitre 1"
      chapterName: 'Flux Céleste - L\'Éveil du Sage',
      description: 'Dans les jardins de méditation, un érudit explore les mystères du Rift.',
      theme: 'flux_celeste',
      chapterEvents: [
        StoryEvent(
          id: 'celestial_intro',
          type: DialogueType.intro,
          speaker: 'narrator',
          text: 'Tu t\'éveilles dans un pavillon de jade entouré d\'encens. '
                'Aria, une jeune mage, médite près de toi.',
        ),
        StoryEvent(
          id: 'aria_greeting',
          type: DialogueType.intro,
          speaker: 'aria',
          speakerAvatar: 'assets/characters/MCA/headshot.png',
          text: 'Tu sens l\'énergie du Rift, n\'est-ce pas ? Les probabilités dansent autour de nous. '
                'Je peux t\'enseigner à les voir... ou tu peux tout détruire.',
          choices: [
            StoryChoice(
              id: 'meditate',
              text: 'Apprends-moi à méditer avec toi.',
              description: 'Voie de la CONNAISSANCE avec Aria',
              path: StoryPath.knowledge,
              rewards: {'predict_dice': 1}, // Capacité spéciale
            ),
            StoryChoice(
              id: 'break_incense',
              text: 'Ces superstitions m\'énervent !',
              description: 'Voie de la DESTRUCTION nihiliste',
              path: StoryPath.chaos,
              rewards: {'terror_aura': 1}, // Capacité spéciale
            ),
          ],
        ),
      ],
      stages: [
        CampaignStage(
          chapter: 1,
          stage: 1,
          baseName: 'Le Pavillon',
          baseDescription: 'Premier contact avec les mystères du Rift.',
          variants: [
            StageVariant(
              path: StoryPath.knowledge,
              name: 'Le Pavillon - Méditation',
              description: 'Tu médites avec Aria et acquiers le don de prédiction.',
              mapTheme: 'celestial',
              enemies: [
                EnemySpawn(enemyId: 'calligraphy_specter', x: 5, y: 3, level: 1),
              ],
              rewards: {'gold': 80, 'xp': 80, 'predict_dice': 1},
            ),
            StageVariant(
              path: StoryPath.chaos,
              name: 'Le Pavillon - Profanation',
              description: 'Tu brises les encensoirs sacrés et acquiers l\'aura de terreur.',
              mapTheme: 'celestial',
              enemies: [
                EnemySpawn(enemyId: 'calligraphy_specter', x: 4, y: 2, level: 1),
                EnemySpawn(enemyId: 'jade_golem', x: 6, y: 4, level: 1),
              ],
              rewards: {'gold': 100, 'xp': 60, 'terror_aura': 1},
            ),
          ],
        ),
        
        CampaignStage(
          chapter: 1,
          stage: 2,
          baseName: 'L\'Archive',
          baseDescription: 'Les connaissances anciennes t\'attendent.',
          variants: [
            StageVariant(
              path: StoryPath.knowledge,
              name: 'Bibliothèque de Jade',
              description: 'Un niveau de puzzle avec peu de combat mais beaucoup d\'expérience.',
              mapTheme: 'celestial',
              enemies: [
                EnemySpawn(enemyId: 'calligraphy_specter', x: 6, y: 3, level: 2),
              ],
              rewards: {'gold': 60, 'xp': 150}, // Plus d'XP, moins de combat
            ),
            StageVariant(
              path: StoryPath.chaos,
              name: 'Ruines de Papier',
              description: 'Les parchemins brûlent. Combat intense contre des golems.',
              mapTheme: 'celestial',
              enemies: [
                EnemySpawn(enemyId: 'jade_golem', x: 4, y: 2, level: 2),
                EnemySpawn(enemyId: 'jade_golem', x: 6, y: 4, level: 2),
                EnemySpawn(enemyId: 'calligraphy_specter', x: 5, y: 5, level: 2),
              ],
              rewards: {'gold': 120, 'xp': 80},
            ),
          ],
        ),
        
        CampaignStage(
          chapter: 1,
          stage: 3,
          baseName: 'Le Pont',
          baseDescription: 'Le passage vers la Confluence.',
          variants: [
            StageVariant(
              path: StoryPath.knowledge,
              name: 'Stabilisation',
              description: 'Tu répares le pont magiquement.',
              mapTheme: 'celestial',
              enemies: [
                EnemySpawn(enemyId: 'calligraphy_specter', x: 5, y: 3, level: 3), // Boss: Spectre de Probabilité
                EnemySpawn(enemyId: 'calligraphy_specter', x: 3, y: 4, level: 2),
              ],
              rewards: {'gold': 180, 'xp': 120},
            ),
            StageVariant(
              path: StoryPath.chaos,
              name: 'Surcharge',
              description: 'Tu fais exploser le pont pour passer de force.',
              mapTheme: 'celestial',
              enemies: [
                EnemySpawn(enemyId: 'threshold_guardian', x: 5, y: 3, level: 2), // Boss: Gardien du Seuil (Élite)
              ],
              rewards: {'gold': 250, 'xp': 100},
            ),
          ],
        ),
      ],
    ),

    // 1C - FORÊT DES MURMURES (Peasant/Équilibre vs Puissance)
    CampaignChapter(
      chapterNumber: 1, // Tous les chapitres de départ sont "chapitre 1"
      chapterName: 'Forêt des Murmures - L\'Éveil Sauvage',
      description: 'Dans la nature corrompue, un vagabond doit choisir entre l\'harmonie et la domination.',
      theme: 'foret_murmures',
      chapterEvents: [
        StoryEvent(
          id: 'forest_intro',
          type: DialogueType.intro,
          speaker: 'narrator',
          text: 'Tu t\'éveilles sur la mousse humide. Ragor, un archer solitaire, '
                'soigne un loup blessé dont les yeux brillent d\'un éclat cristallin.',
        ),
        StoryEvent(
          id: 'ragor_dilemma',
          type: DialogueType.intro,
          speaker: 'ragor',
          speakerAvatar: 'assets/characters/Elio/headshot.png', // TODO: Ragor assets
          text: 'Cette créature est infectée par la Négation, mais elle souffre encore. '
                'Je peux essayer de la soigner... ou l\'achever pour récupérer son cristal.',
          choices: [
            StoryChoice(
              id: 'heal_wolf',
              text: 'Aidons-la à guérir.',
              description: 'Voie de l\'ÉQUILIBRE et de la compassion',
              path: StoryPath.balance,
              rewards: {'wolf_ally': 1}, // Allié temporaire
            ),
            StoryChoice(
              id: 'consume_crystal',
              text: 'Son cristal me rendra plus fort.',
              description: 'Voie de la PUISSANCE par la consommation',
              path: StoryPath.chaos,
              rewards: {'attack': 5}, // Boost permanent
            ),
          ],
        ),
      ],
      stages: [
        CampaignStage(
          chapter: 1,
          stage: 1,
          baseName: 'Le Fourré',
          baseDescription: 'Premier contact avec la corruption de la Négation.',
          variants: [
            StageVariant(
              path: StoryPath.balance,
              name: 'Le Fourré - Compassion',
              description: 'Tu soignes le loup qui devient ton allié temporaire.',
              mapTheme: 'forest',
              enemies: [
                EnemySpawn(enemyId: 'sap_scout', x: 6, y: 3, level: 1),
              ],
              rewards: {'gold': 90, 'xp': 60, 'wolf_ally': 2}, // Allié dure plus longtemps
            ),
            StageVariant(
              path: StoryPath.chaos,
              name: 'Le Fourré - Absorption',
              description: 'Tu absorbes le cristal et ressens une puissance sombre.',
              mapTheme: 'forest',
              enemies: [
                EnemySpawn(enemyId: 'sap_scout', x: 5, y: 3, level: 1),
                EnemySpawn(enemyId: 'wolf', x: 7, y: 4, level: 1),
              ],
              rewards: {'gold': 110, 'xp': 50, 'attack': 5}, // Boost permanent
            ),
          ],
        ),
        
        CampaignStage(
          chapter: 1,
          stage: 2,
          baseName: 'Le Sentier',
          baseDescription: 'La nature répond à tes choix précédents.',
          variants: [
            StageVariant(
              path: StoryPath.balance,
              name: 'Chemin des Esprits',
              description: 'La flore lumineuse pacifie les ennemis. Tu ramasses des herbes.',
              mapTheme: 'forest',
              enemies: [
                EnemySpawn(enemyId: 'sap_scout', x: 4, y: 4, level: 2), // Ennemis pacifiés, moins agressifs
              ],
              rewards: {'gold': 70, 'xp': 80, 'healing_herbs': 3},
            ),
            StageVariant(
              path: StoryPath.chaos,
              name: 'Sentier du Prédateur',
              description: 'La flore flétrie rend les ennemis plus agressifs.',
              mapTheme: 'forest',
              enemies: [
                EnemySpawn(enemyId: 'sap_scout', x: 4, y: 3, level: 2),
                EnemySpawn(enemyId: 'wolf', x: 6, y: 3, level: 2),
                EnemySpawn(enemyId: 'corrupt_ent', x: 5, y: 5, level: 2),
              ],
              rewards: {'gold': 130, 'xp': 70, 'chaos_shards': 2},
            ),
          ],
        ),
        
        CampaignStage(
          chapter: 1,
          stage: 3,
          baseName: 'L\'Arbre Mère',
          baseDescription: 'Le cœur corrompu de la forêt.',
          variants: [
            StageVariant(
              path: StoryPath.balance,
              name: 'Rituel de Calme',
              description: 'Tu dois survivre 2 minutes sans tuer pour apaiser l\'Arbre.',
              mapTheme: 'forest',
              enemies: [
                EnemySpawn(enemyId: 'sap_scout', x: 3, y: 3, level: 3), // Boss: Manifestation de l'Angoisse
                EnemySpawn(enemyId: 'wolf', x: 7, y: 3, level: 2),
                EnemySpawn(enemyId: 'wolf', x: 5, y: 6, level: 2),
              ],
              rewards: {'gold': 180, 'xp': 130, 'nature_blessing': 1},
            ),
            StageVariant(
              path: StoryPath.chaos,
              name: 'Abattage',
              description: 'Tu détruis le cœur de l\'arbre et provoques sa colère.',
              mapTheme: 'forest',
              enemies: [
                EnemySpawn(enemyId: 'corrupt_ent', x: 5, y: 3, level: 3), // Boss: Avatar de la Nature Vengeresse
                EnemySpawn(enemyId: 'sap_scout', x: 3, y: 4, level: 2),
                EnemySpawn(enemyId: 'sap_scout', x: 7, y: 4, level: 2),
              ],
              rewards: {'gold': 250, 'xp': 110, 'tree_heart': 1},
            ),
          ],
        ),
      ],
    ),

    // 1D - DÉSERT D'OSIRIS (Merchant/Balance/Richesse)
    CampaignChapter(
      chapterNumber: 1, // Tous les chapitres de départ sont "chapitre 1"
      chapterName: 'Désert d\'Osiris - L\'Éveil du Marchand',
      description: 'Dans les sables dorés, un marchand découvre que richesse et pouvoir sont deux faces du même dé.',
      theme: 'desert_osiris',
      chapterEvents: [
        StoryEvent(
          id: 'desert_intro',
          type: DialogueType.intro,
          speaker: 'narrator',
          text: 'Tu t\'éveilles dans une oasis entourée de dunes. '
                'Skar, un marchand nomade, compte des pièces d\'or près d\'un caravan endommagé.',
        ),
        StoryEvent(
          id: 'skar_proposal',
          type: DialogueType.choice,
          speaker: 'skar',
          speakerAvatar: 'assets/characters/Skar/headshot.png',
          text: 'Enfin conscient ! Mon carvan a été attaqué par des Spectres de Calligraphie. '
                'Aidez-moi à récupérer mes marchandises et nous partagerons le butin.',
          choices: [
            StoryChoice(
              id: 'fair_trade',
              text: 'Partageons équitablement les profits.',
              description: 'Suivre la voie de l\'ÉQUILIBRE',
              path: StoryPath.balance,
              rewards: {'gold': 75, 'reputation': 5},
            ),
            StoryChoice(
              id: 'seize_all',
              text: 'Prendre tout le butin pour moi.',
              description: 'Embrasser la CONVOITISE',
              path: StoryPath.chaos,
              rewards: {'gold': 150},
              unlocksEnemies: ['jade_goblin'], // Ajoute des ennemis plus agressifs
            ),
          ],
        ),
      ],
      stages: [
        CampaignStage(
          chapter: 1,
          stage: 1,
          baseName: 'L\'Oasis Perdue',
          baseDescription: 'Récupérer les marchandises dans les ruines.',
          variants: [
            StageVariant(
              path: StoryPath.balance,
              name: 'Commerce Équitable',
              description: 'Négocier avec les habitants du désert pour récupérer les biens.',
              mapTheme: 'canyon',
              enemies: [
                EnemySpawn(enemyId: 'specter_calligraphy', x: 4, y: 2, level: 2),
                EnemySpawn(enemyId: 'specter_calligraphy', x: 6, y: 3, level: 2),
              ],
              rewards: {'gold': 80, 'xp': 45},
            ),
            StageVariant(
              path: StoryPath.chaos,
              name: 'Pillage du Désert',
              description: 'S\'emparer de force des trésors cachés.',
              mapTheme: 'canyon',
              enemies: [
                EnemySpawn(enemyId: 'specter_calligraphy', x: 4, y: 2, level: 2),
                EnemySpawn(enemyId: 'jade_goblin', x: 6, y: 3, level: 3), // Ennemi bonus
                EnemySpawn(enemyId: 'specter_calligraphy', x: 5, y: 4, level: 2),
              ],
              rewards: {'gold': 120, 'xp': 40},
            ),
          ],
        ),
      ],
    ),
    
    // ========================================================================
    // CHAPITRE 2 : CONFLUENCE - Où tous les chemins se rejoignent
    // ========================================================================
    
    CampaignChapter(
      chapterNumber: 2,
      chapterName: 'Confluence',
      description: 'Tous les chemins mènent ici. Quatre voies s\'offrent maintenant à toi.',
      theme: 'confluence',
      chapterEvents: [
        StoryEvent(
          id: 'confluence_intro',
          type: DialogueType.intro,
          speaker: 'narrator',
          text: 'Les Marches Grises. Un point de convergence où les failles de réalité '
                'se chevauchent. Quatre héros t\'attendent : Elio l\'Ordonné, '
                'Envia la Chaotique, Ragor l\'Équilibré, et Aria la Savante.',
        ),
      ],
      stages: [
        CampaignStage(
          chapter: 2,
          stage: 1,
          baseName: 'Les Marches Grises',
          baseDescription: 'Un convoi de vivres est attaqué. Quatre approches possibles.',
          variants: [
            StageVariant(
              path: StoryPath.order,
              name: 'Escorte Royale',
              description: 'Tu protèges le convoi avec Elio et ses gardes.',
              mapTheme: 'stairs',
              enemies: [
                EnemySpawn(enemyId: 'robber', x: 4, y: 3, level: 4),
                EnemySpawn(enemyId: 'robber', x: 6, y: 5, level: 4),
                EnemySpawn(enemyId: 'shadow_negation', x: 7, y: 2, level: 4),
              ],
              rewards: {'gold': 200, 'xp': 100, 'defense_bonus': 20}, // +20% défense
            ),
            StageVariant(
              path: StoryPath.chaos,
              name: 'Pillage Brutal',
              description: 'Tu attaques le convoi avec Envia et Skar pour les ressources.',
              mapTheme: 'stairs',
              enemies: [
                EnemySpawn(enemyId: 'iron_sentinel', x: 4, y: 3, level: 4),
                EnemySpawn(enemyId: 'iron_sentinel', x: 6, y: 3, level: 4),
                EnemySpawn(enemyId: 'robber', x: 5, y: 5, level: 4),
              ],
              rewards: {'gold': 350, 'xp': 100}, // +50% or
            ),
            StageVariant(
              path: StoryPath.balance,
              name: 'Médiation',
              description: 'Tu négocies avec Ragor pour partager les ressources.',
              mapTheme: 'stairs',
              enemies: [
                EnemySpawn(enemyId: 'robber', x: 5, y: 3, level: 4),
                EnemySpawn(enemyId: 'wolf', x: 6, y: 4, level: 4),
              ],
              rewards: {'gold': 200, 'xp': 100, 'reputation_neutral': 1},
            ),
            StageVariant(
              path: StoryPath.knowledge,
              name: 'Étude de Faille',
              description: 'Tu ignores le conflit pour analyser une brèche rare avec Aria.',
              mapTheme: 'stairs',
              enemies: [
                EnemySpawn(enemyId: 'calligraphy_specter', x: 5, y: 3, level: 4),
              ],
              rewards: {'gold': 200, 'xp': 160}, // +30% XP
            ),
          ],
        ),
        
        CampaignStage(
          chapter: 2,
          stage: 2,
          baseName: 'Relais d\'Oméga',
          baseDescription: 'Un serveur central corrompu menace la stabilité locale.',
          variants: [
            StageVariant(
              path: StoryPath.order,
              name: 'Sceau de Fer',
              description: 'Tu verrouilles les serveurs pour empêcher toute fuite.',
              mapTheme: 'relay',
              enemies: [
                EnemySpawn(enemyId: 'ticking_golem', x: 5, y: 3, level: 5),
                EnemySpawn(enemyId: 'furnace_wraith', x: 4, y: 5, level: 5),
              ],
              rewards: {'gold': 250, 'xp': 120},
            ),
            StageVariant(
              path: StoryPath.chaos,
              name: 'Surcharge',
              description: 'Tu provoques une explosion pour absorber l\'énergie.',
              mapTheme: 'relay',
              enemies: [
                EnemySpawn(enemyId: 'furnace_wraith', x: 4, y: 3, level: 5),
                EnemySpawn(enemyId: 'furnace_wraith', x: 6, y: 3, level: 5),
                EnemySpawn(enemyId: 'ticking_golem', x: 5, y: 5, level: 5),
              ],
              rewards: {'gold': 280, 'xp': 110, 'energy_absorption': 1},
            ),
            StageVariant(
              path: StoryPath.balance,
              name: 'Synchronisation',
              description: 'Tu harmonises le système pour stabiliser la zone.',
              mapTheme: 'relay',
              enemies: [
                EnemySpawn(enemyId: 'ticking_golem', x: 5, y: 3, level: 5),
              ],
              rewards: {'gold': 220, 'xp': 140, 'system_harmony': 1},
            ),
            StageVariant(
              path: StoryPath.knowledge,
              name: 'Extraction',
              description: 'Tu télécharges les schémas de construction de ton propre corps.',
              mapTheme: 'relay',
              enemies: [
                EnemySpawn(enemyId: 'furnace_wraith', x: 5, y: 3, level: 5),
              ],
              rewards: {'gold': 200, 'xp': 130, 'self_blueprints': 1},
            ),
          ],
        ),
        
        CampaignStage(
          chapter: 2,
          stage: 3,
          baseName: 'Canyon des Murmures',
          baseDescription: 'Deux armées s\'affrontent. Ton intervention changera tout.',
          variants: [
            StageVariant(
              path: StoryPath.order,
              name: 'Jugement',
              description: 'Tu exécutes un traître devant tes troupes pour maintenir l\'ordre.',
              mapTheme: 'canyon',
              enemies: [
                EnemySpawn(enemyId: 'robber', x: 3, y: 3, level: 6), // Traître
                EnemySpawn(enemyId: 'iron_sentinel', x: 5, y: 5, level: 5),
                EnemySpawn(enemyId: 'shadow_negation', x: 7, y: 3, level: 5),
              ],
              rewards: {'gold': 300, 'xp': 150, 'army_loyalty': 1},
            ),
            StageVariant(
              path: StoryPath.chaos,
              name: 'Duel de Sang',
              description: 'Tu provoques le chef ennemi en combat singulier.',
              mapTheme: 'canyon',
              enemies: [
                EnemySpawn(enemyId: 'iron_sentinel', x: 5, y: 3, level: 7), // Chef ennemi
                EnemySpawn(enemyId: 'robber', x: 4, y: 5, level: 5),
                EnemySpawn(enemyId: 'robber', x: 6, y: 5, level: 5),
              ],
              rewards: {'gold': 350, 'xp': 140, 'blood_pact': 1},
            ),
            StageVariant(
              path: StoryPath.balance,
              name: 'Trêve',
              description: 'Tu forces les deux armées à baisser les armes.',
              mapTheme: 'canyon',
              enemies: [
                EnemySpawn(enemyId: 'shadow_negation', x: 5, y: 3, level: 6), // Manifestation de la Guerre
              ],
              rewards: {'gold': 280, 'xp': 160, 'peace_treaty': 1},
            ),
            StageVariant(
              path: StoryPath.knowledge,
              name: 'Illusion',
              description: 'Tu rends ton groupe invisible pour passer sans combat.',
              mapTheme: 'canyon',
              enemies: [
                // Pas d'ennemis - passage furtif
              ],
              rewards: {'gold': 150, 'xp': 200, 'illusion_mastery': 1}, // Beaucoup d'XP, peu d'or
            ),
          ],
        ),
      ],
    ),
    
    // ========================================================================
    // CHAPITRE 3 : LE PUITS - L'ascension finale vers la vérité
    // ========================================================================
    
    CampaignChapter(
      chapterNumber: 3,
      chapterName: 'Le Puits',
      description: 'L\'ascension finale vers le cœur du Rift. Tes choix détermineront le destin du monde.',
      theme: 'void',
      chapterEvents: [
        StoryEvent(
          id: 'void_intro',
          type: DialogueType.intro,
          speaker: 'narrator',
          text: 'Au cœur du Rift, la réalité se désagrège. L\'Escalier du Vide s\'élève '
                'vers une lumière impossible. Ici, tes choix passés détermineront '
                'ton approche de l\'ascension finale.',
        ),
      ],
      stages: [
        CampaignStage(
          chapter: 3,
          stage: 1,
          baseName: 'Escalier du Vide',
          baseDescription: 'L\'ascension vers le cœur du Rift. Chaque méthode révèle ta nature.',
          variants: [
            StageVariant(
              path: StoryPath.order,
              name: 'Marche Sacrée',
              description: 'Des plateformes de lumière apparaissent sous tes pas bénis.',
              mapTheme: 'void',
              enemies: [
                EnemySpawn(enemyId: 'calligraphy_specter', x: 4, y: 3, level: 8),
                EnemySpawn(enemyId: 'shadow_negation', x: 6, y: 5, level: 8),
              ],
              rewards: {'gold': 350, 'xp': 180, 'divine_blessing': 1},
            ),
            StageVariant(
              path: StoryPath.chaos,
              name: 'Saut de la Foi',
              description: 'Tu te propulses de débris en débris par la force brute.',
              mapTheme: 'void',
              enemies: [
                EnemySpawn(enemyId: 'shadow_negation', x: 3, y: 3, level: 8),
                EnemySpawn(enemyId: 'shadow_negation', x: 5, y: 4, level: 8),
                EnemySpawn(enemyId: 'calligraphy_specter', x: 7, y: 5, level: 8),
              ],
              rewards: {'gold': 400, 'xp': 160, 'void_strength': 1},
            ),
            StageVariant(
              path: StoryPath.balance,
              name: 'Flottaison',
              description: 'Tu lévites en suivant les courants du Prima-Chaos.',
              mapTheme: 'void',
              enemies: [
                EnemySpawn(enemyId: 'threshold_guardian', x: 5, y: 3, level: 7), // Manifestation mineure
              ],
              rewards: {'gold': 300, 'xp': 200, 'chaos_mastery': 1},
            ),
            StageVariant(
              path: StoryPath.knowledge,
              name: 'Calcul Spatial',
              description: 'Tu téléportes directement ton groupe au sommet.',
              mapTheme: 'void',
              enemies: [
                // Combat minimal - la connaissance évite les dangers
              ],
              rewards: {'gold': 250, 'xp': 250, 'spatial_mastery': 1},
            ),
          ],
        ),
        
        CampaignStage(
          chapter: 3,
          stage: 2,
          baseName: 'Miroir de Négation',
          baseDescription: 'Tu affrontes ton double sombre. Chaque voie offre une résolution différente.',
          variants: [
            StageVariant(
              path: StoryPath.order,
              name: 'Confrontation',
              description: 'Tu combats ton double pour purifier ton âme.',
              mapTheme: 'void',
              enemies: [
                EnemySpawn(enemyId: 'shadow_negation', x: 5, y: 3, level: 10), // Ton double sombre
              ],
              rewards: {'gold': 400, 'xp': 200, 'purified_soul': 1},
            ),
            StageVariant(
              path: StoryPath.chaos,
              name: 'Fusion',
              description: 'Tu dévores ton double et doubles ta puissance.',
              mapTheme: 'void',
              enemies: [
                EnemySpawn(enemyId: 'shadow_negation', x: 5, y: 3, level: 8), // Plus faible car tu l'absorbes
              ],
              rewards: {'gold': 350, 'xp': 150, 'doubled_power': 1},
            ),
            StageVariant(
              path: StoryPath.balance,
              name: 'Acceptation',
              description: 'Tu discutes avec ton double. Il devient ton familier.',
              mapTheme: 'void',
              enemies: [
                // Pas de combat - négociation
              ],
              rewards: {'gold': 300, 'xp': 180, 'shadow_familiar': 1},
            ),
            StageVariant(
              path: StoryPath.knowledge,
              name: 'Analyse',
              description: 'Tu découvres que ton double n\'est qu\'un bug informatique.',
              mapTheme: 'void',
              enemies: [
                EnemySpawn(enemyId: 'calligraphy_specter', x: 5, y: 3, level: 9), // Bug manifesté
              ],
              rewards: {'gold': 380, 'xp': 220, 'debug_mastery': 1},
            ),
          ],
        ),
        
        CampaignStage(
          chapter: 3,
          stage: 3,
          baseName: 'Cœur du Rift',
          baseDescription: 'L\'affrontement final. Ton choix déterminera le sort de toute la réalité.',
          variants: [
            StageVariant(
              path: StoryPath.order,
              name: 'Restauration',
              description: 'Tu tentes de réactiver le Projet Oméga et restaurer l\'ordre.',
              mapTheme: 'void',
              enemies: [
                EnemySpawn(enemyId: 'threshold_guardian', x: 5, y: 3, level: 12), // Boss final - Gardien corrompu
                EnemySpawn(enemyId: 'shadow_negation', x: 3, y: 4, level: 10),
                EnemySpawn(enemyId: 'shadow_negation', x: 7, y: 4, level: 10),
              ],
              rewards: {'gold': 500, 'xp': 300, 'omega_restored': 1},
            ),
            StageVariant(
              path: StoryPath.chaos,
              name: 'Annihilation',
              description: 'Tu brises le Dé de Réalité pour libérer le néant primordial.',
              mapTheme: 'void',
              enemies: [
                EnemySpawn(enemyId: 'threshold_guardian', x: 5, y: 3, level: 15), // Boss final renforcé
                EnemySpawn(enemyId: 'calligraphy_specter', x: 4, y: 2, level: 10),
                EnemySpawn(enemyId: 'calligraphy_specter', x: 6, y: 2, level: 10),
                EnemySpawn(enemyId: 'shadow_negation', x: 3, y: 5, level: 10),
                EnemySpawn(enemyId: 'shadow_negation', x: 7, y: 5, level: 10),
              ],
              rewards: {'gold': 600, 'xp': 250, 'void_unleashed': 1},
            ),
            StageVariant(
              path: StoryPath.balance,
              name: 'Stabilisation',
              description: 'Tu deviens le nouveau pilier central stabilisant le monde.',
              mapTheme: 'void',
              enemies: [
                EnemySpawn(enemyId: 'threshold_guardian', x: 5, y: 3, level: 10), // Boss pacifié par l'équilibre
              ],
              rewards: {'gold': 450, 'xp': 280, 'world_pillar': 1},
            ),
            StageVariant(
              path: StoryPath.knowledge,
              name: 'Transcendance',
              description: 'Tu transformes le monde en une simulation pure et parfaite.',
              mapTheme: 'void',
              enemies: [
                EnemySpawn(enemyId: 'threshold_guardian', x: 5, y: 3, level: 8), // Transformé en allié
              ],
              rewards: {'gold': 400, 'xp': 350, 'reality_transcended': 1},
            ),
          ],
        ),
      ],
    ),
  ];

  /// Récupère le chapitre selon l'origine du joueur et le numéro
  static CampaignChapter? getChapter(int chapterNumber, {String? theme}) {
    // Pour le chapitre 1, sélectionner selon le thème
    if (chapterNumber == 1 && theme != null) {
      try {
        return chapters.firstWhere((c) => c.theme == theme && c.chapterNumber == 1);
      } catch (e) {
        // Fallback sur le premier chapitre si le thème n'existe pas
        return chapters.firstWhere((c) => c.chapterNumber == 1);
      }
    }
    
    // Pour les autres chapitres, sélection normale
    try {
      return chapters.firstWhere((c) => c.chapterNumber == chapterNumber);
    } catch (e) {
      return null;
    }
  }

  /// Récupère tous les événements d'un chapitre pour un chemin donné
  static List<StoryEvent> getStoryEvents(int chapter, int stage, StoryPath path, {String? theme}) {
    final chapterData = getChapter(chapter, theme: theme);
    if (chapterData == null) return [];
    
    final stageData = chapterData.getStage(stage);
    if (stageData == null) return [];
    
    final variant = stageData.getVariant(path);
    return [
      ...chapterData.chapterEvents,
      ...stageData.commonEvents,
      ...(variant?.events ?? []),
    ];
  }

  /// Retourne tous les stages de tous les chapitres
  static List<CampaignStage> getAllStages() {
    final allStages = <CampaignStage>[];
    for (final chapter in chapters) {
      allStages.addAll(chapter.stages);
    }
    return allStages;
  }

  /// Retourne le stage suivant après celui avec l'ID donné
  static CampaignStage? getNextStage(double currentStageId) {
    // Trouver le stage actuel pour déterminer son chapitre
    CampaignChapter? currentChapter;
    CampaignStage? currentStage;
    
    for (final chapter in chapters) {
      for (final stage in chapter.stages) {
        if (stage.stageId == currentStageId) {
          currentChapter = chapter;
          currentStage = stage;
          break;
        }
      }
      if (currentStage != null) break;
    }
    
    if (currentChapter == null || currentStage == null) return null;
    
    // Chercher le stage suivant dans le même chapitre
    final stagesInChapter = currentChapter.stages;
    stagesInChapter.sort((a, b) => a.stage.compareTo(b.stage));
    
    final currentIndex = stagesInChapter.indexWhere((s) => s.stage == currentStage!.stage);
    if (currentIndex >= 0 && currentIndex < stagesInChapter.length - 1) {
      return stagesInChapter[currentIndex + 1]; // Stage suivant dans le même chapitre
    }
    
    // Si c'est le dernier stage du chapitre, chercher le chapitre suivant
    final nextChapter = chapters.firstWhere(
      (c) => c.chapterNumber == currentChapter!.chapterNumber + 1,
      orElse: () => chapters.first, // Si pas trouvé, retourner null plus tard
    );
    
    if (nextChapter.chapterNumber == currentChapter.chapterNumber + 1) {
      return nextChapter.stages.isNotEmpty ? nextChapter.stages.first : null;
    }
    
    return null; // Pas de stage suivant (fin de la campagne)
  }

  /// Retourne un stage spécifique par son ID
  static CampaignStage? getStageById(double stageId) {
    for (final chapter in chapters) {
      for (final stage in chapter.stages) {
        if (stage.stageId == stageId) {
          return stage;
        }
      }
    }
    return null;
  }

  /// Retourne les chapitres dans l'ordre de progression pour une région donnée
  static List<CampaignChapter> getChaptersForRegion(String personaRegion) {
    final result = <CampaignChapter>[];
    
    // Trouver le chapitre de départ selon la région (par thème)
    String startingTheme;
    switch (personaRegion.toLowerCase()) {
      case 'west':
        startingTheme = 'aethelgard';
        break;
      case 'east':
        startingTheme = 'flux_celeste';
        break;
      case 'north':
        startingTheme = 'foret_murmures';
        break;
      case 'south':
        startingTheme = 'desert_osiris';
        break;
      default:
        startingTheme = 'aethelgard';
    }
    
    // Ajouter le chapitre de départ spécifique à la région
    final startChapter = chapters.firstWhere(
      (chapter) => chapter.theme == startingTheme,
      orElse: () => chapters.first,
    );
    result.add(startChapter);
    
    // Ajouter les chapitres suivants (2, 3, etc.)
    for (final chapter in chapters) {
      if (chapter.chapterNumber >= 2 && chapter.chapterNumber < 10) {
        result.add(chapter);
      }
    }
    
    return result;
  }
}