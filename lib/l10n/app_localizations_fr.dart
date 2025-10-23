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

  @override
  String get epicUniverseTagline => 'Plongez dans un univers épique';

  @override
  String get epicUniverseDescription =>
      'où le destin est dicté par les dés cosmiques.\nAffrontez les Rifts et sauvez les mondes !';

  @override
  String get initializingPortal => 'Initialisation du portail...';

  @override
  String get startAdventure => 'Commencer l\'aventure';

  @override
  String get versionInfo => 'Version 1.0.0 • Fait avec Flutter';

  @override
  String connectionError(String error) {
    return 'Erreur de connexion: $error';
  }

  @override
  String get stepYourName => 'VOTRE NOM';

  @override
  String get stepYourRace => 'VOTRE RACE';

  @override
  String get stepYourRegion => 'VOTRE RÉGION';

  @override
  String get stepYourOrigin => 'VOTRE ORIGINE';

  @override
  String get stepYourClass => 'VOTRE CLASSE';

  @override
  String get stepConfirmation => 'CONFIRMATION';

  @override
  String get choicesShapeDestiny => 'Vos choix façonneront votre destin';

  @override
  String get lowercaseOnly => 'Minuscules uniquement : max 11 caractères';

  @override
  String get uppercaseOnly => 'Majuscules uniquement : max 8 caractères';

  @override
  String mixedCase(int max) {
    return 'Mélange : max $max caractères';
  }

  @override
  String get nameInLegends => 'Comment vous nomme-t-on dans les légendes ?';

  @override
  String get yourNameHint => 'Votre nom';

  @override
  String get minimumCharacters => 'Minimum 3 caractères';

  @override
  String get whatIsYourNature => 'Quelle est votre nature ?';

  @override
  String get whereAreYouFrom => 'D\'où venez-vous ?';

  @override
  String get whatIsYourStory => 'Quelle est votre histoire ?';

  @override
  String get whatPathDoYouTake => 'Quelle voie empruntez-vous ?';

  @override
  String get legendReady => 'Votre légende est prête à s\'écrire';

  @override
  String get nameSummary => 'Nom';

  @override
  String get raceSummary => 'Race';

  @override
  String get regionSummary => 'Région';

  @override
  String get originSummary => 'Origine';

  @override
  String get classSummary => 'Classe';

  @override
  String get choicesFinal =>
      'Ces choix sont définitifs et influenceront votre parcours dans les Rifts';

  @override
  String get back => 'Retour';

  @override
  String get forgeDestiny => 'Forger mon destin';

  @override
  String get continueButton => 'Continuer';

  @override
  String get cinematicTitle1 => 'AU COMMENCEMENT';

  @override
  String get cinematicText1 =>
      'Il y avait le Néant.\nUn vide infini où rien n\'existait.';

  @override
  String get cinematicSubtitle1 => 'Puis les Dés Cosmiques apparurent...';

  @override
  String get cinematicTitle2 => 'LES DÉS DU DESTIN';

  @override
  String get cinematicText2 =>
      'Ces artefacts divins façonnèrent\nla réalité elle-même.';

  @override
  String get cinematicSubtitle2 =>
      'Chaque face, chaque lancer créait des mondes.';

  @override
  String get cinematicTitle3 => 'L\'ÉQUILIBRE BRISÉ';

  @override
  String get cinematicText3 => 'Pendant des éons, l\'équilibre régna.';

  @override
  String get cinematicSubtitle3 =>
      'Mais une force obscure convoita leur pouvoir.\nLes Rifts s\'ouvrirent.';

  @override
  String get cinematicTitle4 => 'LES RIFTS';

  @override
  String get cinematicText4 =>
      'Des fissures dans la réalité,\ndévorant tout sur leur passage.';

  @override
  String get cinematicSubtitle4 =>
      'Les mondes s\'effondrent. Les civilisations agonisent.';

  @override
  String get cinematicTitle5 => 'UN DERNIER ESPOIR';

  @override
  String get cinematicText5 => 'Les Dés Cosmiques recherchent\ndes Champions.';

  @override
  String get cinematicSubtitle5 => 'Des âmes capables de manier leur pouvoir.';

  @override
  String get cinematicTitle6 => 'QUI ÊTES-VOUS ?';

  @override
  String get cinematicText6 =>
      'Le destin vous appelle.\nLe pouvoir des Dés coule en vous.';

  @override
  String get cinematicSubtitle6 => 'Votre histoire commence maintenant...';

  @override
  String get skipCinematic => 'Passer';

  @override
  String get nextScene => 'Suivant';

  @override
  String get loginTitle => 'Connexion';

  @override
  String get chooseYourMode => 'Choisissez votre mode';

  @override
  String get emailAndPassword => 'Email & Mot de passe';

  @override
  String get permanentAccount => 'Compte permanent';

  @override
  String get or => 'OU';

  @override
  String get google => 'Google';

  @override
  String get continueWithoutAccount => 'Continuer sans compte';

  @override
  String get connectingInProgress => 'Connexion en cours...';

  @override
  String get linkAccountLater =>
      'Vous pourrez lier votre compte plus tard dans les paramètres';

  @override
  String get createAccount => 'CRÉER UN COMPTE';

  @override
  String get emailLogin => 'CONNEXION EMAIL';

  @override
  String get email => 'Email';

  @override
  String get emailRequired => 'Email requis';

  @override
  String get invalidEmail => 'Email invalide';

  @override
  String get password => 'Mot de passe';

  @override
  String get passwordRequired => 'Mot de passe requis';

  @override
  String get minimumSixCharacters => 'Minimum 6 caractères';

  @override
  String get createAccountButton => 'Créer le compte';

  @override
  String get signIn => 'Se connecter';

  @override
  String get alreadyHaveAccount => 'Déjà un compte ? Se connecter';

  @override
  String get noAccount => 'Pas de compte ? S\'inscrire';

  @override
  String get backToOptions => '← Retour aux options';
}
