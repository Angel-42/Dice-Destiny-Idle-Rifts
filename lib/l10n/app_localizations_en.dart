// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class SEn extends S {
  SEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Dice Destiny: Idle Rifts';

  @override
  String get welcome => 'Welcome';

  @override
  String get welcomeMessage =>
      'Welcome! Use the navigation bar below to explore.';

  @override
  String get diceDestiny => 'DICE DESTINY';

  @override
  String get idleRifts => 'IDLE RIFTS';

  @override
  String get navHome => 'Home';

  @override
  String get navBattle => 'Battle';

  @override
  String get navAllies => 'Allies';

  @override
  String get navSummon => 'Summon';

  @override
  String get navShop => 'Shop';

  @override
  String get navMisc => 'Misc.';

  @override
  String get editTeam => 'EDIT TEAM';

  @override
  String get allHeroes => 'ALL HEROES';

  @override
  String get slot => 'Slot';

  @override
  String get cancel => 'Cancel';

  @override
  String error(String message) {
    return 'Error: $message';
  }

  @override
  String get level => 'Lv.';

  @override
  String get hp => 'HP';

  @override
  String get atk => 'Atk';

  @override
  String get mag => 'Mag';

  @override
  String get spd => 'Spd';

  @override
  String get def => 'Def';

  @override
  String get lck => 'Lck';

  @override
  String get res => 'Res';

  @override
  String get rarityCommon => 'Common';

  @override
  String get rarityRare => 'Rare';

  @override
  String get rarityEpic => 'Epic';

  @override
  String get rarityLegendary => 'Legendary';

  @override
  String get equipmentWeapon => 'Weapon';

  @override
  String get equipmentArmor => 'Armor';

  @override
  String get equipmentAccessory => 'Accessory';

  @override
  String get equipmentSkill => 'Skill';

  @override
  String get warrior => 'Warrior';

  @override
  String get mage => 'Mage';

  @override
  String get rogue => 'Rogue';

  @override
  String get cleric => 'Cleric';

  @override
  String get ironSword => 'Iron Sword';

  @override
  String get woodenStaff => 'Wooden Staff';

  @override
  String get ironDagger => 'Iron Dagger';

  @override
  String get healingRod => 'Healing Rod';

  @override
  String get noPlayerData => 'No player data';

  @override
  String get loading => 'Loading...';

  @override
  String get gold => 'Gold';

  @override
  String get gems => 'Gems';

  @override
  String get summonTokens => 'Summon Tokens';

  @override
  String idleIncomeOnline(int amount) {
    return '+$amount gold (idle income)';
  }

  @override
  String idleIncomeOffline(int amount, String hours) {
    return 'Offline income: +$amount gold (${hours}h absence)';
  }

  @override
  String get firstConnection => 'First connection, no offline income';

  @override
  String noOfflineIncome(int seconds) {
    return 'No offline income (last connection: ${seconds}s)';
  }

  @override
  String get stamina => 'Stamina';

  @override
  String get battleTitle => 'BATTLE';

  @override
  String get battleSystem => 'Battle System';

  @override
  String get campaignMode => 'Campaign Mode';

  @override
  String get rifts => 'Rifts';

  @override
  String get dungeons => 'Dungeons';

  @override
  String get arena => 'Arena';

  @override
  String get needCharacterFirst => 'You must create a character first!';

  @override
  String get cannotOpenCampaign => 'Cannot open campaign';

  @override
  String get miscTitle => 'MISC.';

  @override
  String get settings => 'Settings';

  @override
  String get gifts => 'Gifts';

  @override
  String get events => 'Events';

  @override
  String get logout => 'Logout';

  @override
  String get rankings => 'Rankings';

  @override
  String get news => 'News';

  @override
  String get help => 'Help';

  @override
  String get friends => 'Friends';

  @override
  String get logoutConfirm => 'Are you sure you want to logout?';

  @override
  String get confirm => 'Confirm';

  @override
  String get epicUniverseTagline => 'Dive into an epic universe';

  @override
  String get epicUniverseDescription =>
      'where destiny is ruled by cosmic dice.\nFace the Rifts and save the worlds!';

  @override
  String get initializingPortal => 'Initializing portal...';

  @override
  String get startAdventure => 'Start the adventure';

  @override
  String get versionInfo => 'Version 1.0.0 • Made with Flutter';

  @override
  String connectionError(String error) {
    return 'Connection error: $error';
  }

  @override
  String get stepYourName => 'YOUR NAME';

  @override
  String get stepYourRace => 'YOUR RACE';

  @override
  String get stepYourRegion => 'YOUR REGION';

  @override
  String get stepYourOrigin => 'YOUR ORIGIN';

  @override
  String get stepYourClass => 'YOUR CLASS';

  @override
  String get stepConfirmation => 'CONFIRMATION';

  @override
  String get choicesShapeDestiny => 'Your choices will shape your destiny';

  @override
  String get lowercaseOnly => 'Lowercase only: max 11 characters';

  @override
  String get uppercaseOnly => 'Uppercase only: max 8 characters';

  @override
  String mixedCase(int max) {
    return 'Mixed: max $max characters';
  }

  @override
  String get nameInLegends => 'How are you known in legends?';

  @override
  String get yourNameHint => 'Your name';

  @override
  String get minimumCharacters => 'Minimum 3 characters';

  @override
  String get whatIsYourNature => 'What is your nature?';

  @override
  String get whereAreYouFrom => 'Where are you from?';

  @override
  String get whatIsYourStory => 'What is your story?';

  @override
  String get whatPathDoYouTake => 'What path do you take?';

  @override
  String get legendReady => 'Your legend is ready to be written';

  @override
  String get nameSummary => 'Name';

  @override
  String get raceSummary => 'Race';

  @override
  String get regionSummary => 'Region';

  @override
  String get originSummary => 'Origin';

  @override
  String get classSummary => 'Class';

  @override
  String get choicesFinal =>
      'These choices are final and will influence your journey through the Rifts';

  @override
  String get back => 'Back';

  @override
  String get forgeDestiny => 'Forge my destiny';

  @override
  String get continueButton => 'Continue';

  @override
  String get cinematicTitle1 => 'IN THE BEGINNING';

  @override
  String get cinematicText1 =>
      'There was the Void.\nAn infinite emptiness where nothing existed.';

  @override
  String get cinematicSubtitle1 => 'Then the Cosmic Dice appeared...';

  @override
  String get cinematicTitle2 => 'THE DICE OF FATE';

  @override
  String get cinematicText2 => 'These divine artifacts shaped\nreality itself.';

  @override
  String get cinematicSubtitle2 => 'Each face, each roll created worlds.';

  @override
  String get cinematicTitle3 => 'BROKEN BALANCE';

  @override
  String get cinematicText3 => 'For eons, balance reigned.';

  @override
  String get cinematicSubtitle3 =>
      'But a dark force coveted their power.\nThe Rifts opened.';

  @override
  String get cinematicTitle4 => 'THE RIFTS';

  @override
  String get cinematicText4 =>
      'Cracks in reality,\ndevouring everything in their path.';

  @override
  String get cinematicSubtitle4 => 'Worlds collapse. Civilizations are dying.';

  @override
  String get cinematicTitle5 => 'A LAST HOPE';

  @override
  String get cinematicText5 => 'The Cosmic Dice seek\nChampions.';

  @override
  String get cinematicSubtitle5 => 'Souls capable of wielding their power.';

  @override
  String get cinematicTitle6 => 'WHO ARE YOU?';

  @override
  String get cinematicText6 =>
      'Destiny calls you.\nThe power of the Dice flows through you.';

  @override
  String get cinematicSubtitle6 => 'Your story begins now...';

  @override
  String get skipCinematic => 'Skip';

  @override
  String get nextScene => 'Next';

  @override
  String get loginTitle => 'Login';

  @override
  String get chooseYourMode => 'Choose your method';

  @override
  String get emailAndPassword => 'Email & Password';

  @override
  String get permanentAccount => 'Permanent account';

  @override
  String get or => 'OR';

  @override
  String get google => 'Google';

  @override
  String get continueWithoutAccount => 'Continue without account';

  @override
  String get connectingInProgress => 'Connecting...';

  @override
  String get linkAccountLater => 'You can link your account later in settings';

  @override
  String get createAccount => 'CREATE AN ACCOUNT';

  @override
  String get emailLogin => 'EMAIL LOGIN';

  @override
  String get email => 'Email';

  @override
  String get emailRequired => 'Email required';

  @override
  String get invalidEmail => 'Invalid email';

  @override
  String get password => 'Password';

  @override
  String get passwordRequired => 'Password required';

  @override
  String get minimumSixCharacters => 'Minimum 6 characters';

  @override
  String get createAccountButton => 'Create account';

  @override
  String get signIn => 'Sign in';

  @override
  String get alreadyHaveAccount => 'Already have an account? Sign in';

  @override
  String get noAccount => 'No account? Sign up';

  @override
  String get backToOptions => '← Back to options';
}
