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
}
