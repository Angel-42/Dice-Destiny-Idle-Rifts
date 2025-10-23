// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class SFr extends S {
  SFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Dice Destiny: Idle Rifts';

  @override
  String get welcome => 'Bienvenue';

  @override
  String get welcomeMessage =>
      'Bienvenue ! Utilisez la barre de navigation ci-dessous pour explorer.';

  @override
  String get diceDestiny => 'DICE DESTINY';

  @override
  String get idleRifts => 'IDLE RIFTS';

  @override
  String get navHome => 'Accueil';

  @override
  String get navBattle => 'Combat';

  @override
  String get navAllies => 'Alliés';

  @override
  String get navSummon => 'Invocation';

  @override
  String get navShop => 'Boutique';

  @override
  String get navMisc => 'Divers';

  @override
  String get editTeam => 'MODIFIER L\'ÉQUIPE';

  @override
  String get allHeroes => 'TOUS LES HÉROS';

  @override
  String get slot => 'Emplacement';

  @override
  String get cancel => 'Annuler';

  @override
  String error(String message) {
    return 'Erreur : $message';
  }

  @override
  String get level => 'Niv.';

  @override
  String get hp => 'PV';

  @override
  String get atk => 'Att';

  @override
  String get mag => 'Mag';

  @override
  String get spd => 'Vit';

  @override
  String get def => 'Déf';

  @override
  String get lck => 'Cha';

  @override
  String get res => 'Rés';

  @override
  String get rarityCommon => 'Commun';

  @override
  String get rarityRare => 'Rare';

  @override
  String get rarityEpic => 'Épique';

  @override
  String get rarityLegendary => 'Légendaire';

  @override
  String get equipmentWeapon => 'Arme';

  @override
  String get equipmentArmor => 'Armure';

  @override
  String get equipmentAccessory => 'Accessoire';

  @override
  String get equipmentSkill => 'Compétence';

  @override
  String get warrior => 'Guerrier';

  @override
  String get mage => 'Mage';

  @override
  String get rogue => 'Voleur';

  @override
  String get cleric => 'Clerc';

  @override
  String get ironSword => 'Épée de Fer';

  @override
  String get woodenStaff => 'Bâton de Bois';

  @override
  String get ironDagger => 'Dague de Fer';

  @override
  String get healingRod => 'Bâton de Soin';

  @override
  String get noPlayerData => 'Aucune donnée joueur';

  @override
  String get loading => 'Chargement...';

  @override
  String get gold => 'Or';

  @override
  String get gems => 'Gemmes';

  @override
  String get summonTokens => 'Jetons d\'Invocation';

  @override
  String idleIncomeOnline(int amount) {
    return '+$amount or (revenu passif)';
  }

  @override
  String idleIncomeOffline(int amount, String hours) {
    return 'Revenus offline : +$amount or (${hours}h d\'absence)';
  }

  @override
  String get firstConnection => 'Première connexion, pas de revenus offline';

  @override
  String noOfflineIncome(int seconds) {
    return 'Pas de revenus offline (dernière connexion : ${seconds}s)';
  }

  @override
  String get stamina => 'Endurance';

  @override
  String get battleTitle => 'COMBAT';

  @override
  String get battleSystem => 'Système de Combat';

  @override
  String get campaignMode => 'Mode Campagne';

  @override
  String get rifts => 'Failles';

  @override
  String get dungeons => 'Donjons';

  @override
  String get arena => 'Arène';

  @override
  String get needCharacterFirst => 'Vous devez créer un personnage d\'abord !';

  @override
  String get cannotOpenCampaign => 'Impossible d\'ouvrir la campagne';

  @override
  String get miscTitle => 'DIVERS';

  @override
  String get settings => 'Paramètres';

  @override
  String get gifts => 'Cadeaux';

  @override
  String get events => 'Événements';

  @override
  String get logout => 'Déconnexion';

  @override
  String get rankings => 'Classements';

  @override
  String get news => 'Actualités';

  @override
  String get help => 'Aide';

  @override
  String get friends => 'Amis';

  @override
  String get logoutConfirm => 'Êtes-vous sûr de vouloir vous déconnecter ?';

  @override
  String get confirm => 'Confirmer';
}
