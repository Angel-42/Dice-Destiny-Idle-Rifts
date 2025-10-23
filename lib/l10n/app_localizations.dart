import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of S
/// returned by `S.of(context)`.
///
/// Applications need to include `S.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: S.localizationsDelegates,
///   supportedLocales: S.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the S.supportedLocales
/// property.
abstract class S {
  S(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static S? of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  static const LocalizationsDelegate<S> delegate = _SDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('fr')
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Dice Destiny: Idle Rifts'**
  String get appTitle;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @welcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome! Use the navigation bar below to explore.'**
  String get welcomeMessage;

  /// No description provided for @diceDestiny.
  ///
  /// In en, this message translates to:
  /// **'DICE DESTINY'**
  String get diceDestiny;

  /// No description provided for @idleRifts.
  ///
  /// In en, this message translates to:
  /// **'IDLE RIFTS'**
  String get idleRifts;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navBattle.
  ///
  /// In en, this message translates to:
  /// **'Battle'**
  String get navBattle;

  /// No description provided for @navAllies.
  ///
  /// In en, this message translates to:
  /// **'Allies'**
  String get navAllies;

  /// No description provided for @navSummon.
  ///
  /// In en, this message translates to:
  /// **'Summon'**
  String get navSummon;

  /// No description provided for @navShop.
  ///
  /// In en, this message translates to:
  /// **'Shop'**
  String get navShop;

  /// No description provided for @navMisc.
  ///
  /// In en, this message translates to:
  /// **'Misc.'**
  String get navMisc;

  /// No description provided for @editTeam.
  ///
  /// In en, this message translates to:
  /// **'EDIT TEAM'**
  String get editTeam;

  /// No description provided for @allHeroes.
  ///
  /// In en, this message translates to:
  /// **'ALL HEROES'**
  String get allHeroes;

  /// No description provided for @slot.
  ///
  /// In en, this message translates to:
  /// **'Slot'**
  String get slot;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String error(String message);

  /// No description provided for @level.
  ///
  /// In en, this message translates to:
  /// **'Lv.'**
  String get level;

  /// No description provided for @hp.
  ///
  /// In en, this message translates to:
  /// **'HP'**
  String get hp;

  /// No description provided for @atk.
  ///
  /// In en, this message translates to:
  /// **'Atk'**
  String get atk;

  /// No description provided for @mag.
  ///
  /// In en, this message translates to:
  /// **'Mag'**
  String get mag;

  /// No description provided for @spd.
  ///
  /// In en, this message translates to:
  /// **'Spd'**
  String get spd;

  /// No description provided for @def.
  ///
  /// In en, this message translates to:
  /// **'Def'**
  String get def;

  /// No description provided for @lck.
  ///
  /// In en, this message translates to:
  /// **'Lck'**
  String get lck;

  /// No description provided for @res.
  ///
  /// In en, this message translates to:
  /// **'Res'**
  String get res;

  /// No description provided for @rarityCommon.
  ///
  /// In en, this message translates to:
  /// **'Common'**
  String get rarityCommon;

  /// No description provided for @rarityRare.
  ///
  /// In en, this message translates to:
  /// **'Rare'**
  String get rarityRare;

  /// No description provided for @rarityEpic.
  ///
  /// In en, this message translates to:
  /// **'Epic'**
  String get rarityEpic;

  /// No description provided for @rarityLegendary.
  ///
  /// In en, this message translates to:
  /// **'Legendary'**
  String get rarityLegendary;

  /// No description provided for @equipmentWeapon.
  ///
  /// In en, this message translates to:
  /// **'Weapon'**
  String get equipmentWeapon;

  /// No description provided for @equipmentArmor.
  ///
  /// In en, this message translates to:
  /// **'Armor'**
  String get equipmentArmor;

  /// No description provided for @equipmentAccessory.
  ///
  /// In en, this message translates to:
  /// **'Accessory'**
  String get equipmentAccessory;

  /// No description provided for @equipmentSkill.
  ///
  /// In en, this message translates to:
  /// **'Skill'**
  String get equipmentSkill;

  /// No description provided for @warrior.
  ///
  /// In en, this message translates to:
  /// **'Warrior'**
  String get warrior;

  /// No description provided for @mage.
  ///
  /// In en, this message translates to:
  /// **'Mage'**
  String get mage;

  /// No description provided for @rogue.
  ///
  /// In en, this message translates to:
  /// **'Rogue'**
  String get rogue;

  /// No description provided for @cleric.
  ///
  /// In en, this message translates to:
  /// **'Cleric'**
  String get cleric;

  /// No description provided for @ironSword.
  ///
  /// In en, this message translates to:
  /// **'Iron Sword'**
  String get ironSword;

  /// No description provided for @woodenStaff.
  ///
  /// In en, this message translates to:
  /// **'Wooden Staff'**
  String get woodenStaff;

  /// No description provided for @ironDagger.
  ///
  /// In en, this message translates to:
  /// **'Iron Dagger'**
  String get ironDagger;

  /// No description provided for @healingRod.
  ///
  /// In en, this message translates to:
  /// **'Healing Rod'**
  String get healingRod;

  /// No description provided for @noPlayerData.
  ///
  /// In en, this message translates to:
  /// **'No player data'**
  String get noPlayerData;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @gold.
  ///
  /// In en, this message translates to:
  /// **'Gold'**
  String get gold;

  /// No description provided for @gems.
  ///
  /// In en, this message translates to:
  /// **'Gems'**
  String get gems;

  /// No description provided for @summonTokens.
  ///
  /// In en, this message translates to:
  /// **'Summon Tokens'**
  String get summonTokens;

  /// No description provided for @idleIncomeOnline.
  ///
  /// In en, this message translates to:
  /// **'+{amount} gold (idle income)'**
  String idleIncomeOnline(int amount);

  /// No description provided for @idleIncomeOffline.
  ///
  /// In en, this message translates to:
  /// **'Offline income: +{amount} gold ({hours}h absence)'**
  String idleIncomeOffline(int amount, String hours);

  /// No description provided for @firstConnection.
  ///
  /// In en, this message translates to:
  /// **'First connection, no offline income'**
  String get firstConnection;

  /// No description provided for @noOfflineIncome.
  ///
  /// In en, this message translates to:
  /// **'No offline income (last connection: {seconds}s)'**
  String noOfflineIncome(int seconds);

  /// No description provided for @stamina.
  ///
  /// In en, this message translates to:
  /// **'Stamina'**
  String get stamina;

  /// No description provided for @battleTitle.
  ///
  /// In en, this message translates to:
  /// **'BATTLE'**
  String get battleTitle;

  /// No description provided for @battleSystem.
  ///
  /// In en, this message translates to:
  /// **'Battle System'**
  String get battleSystem;

  /// No description provided for @campaignMode.
  ///
  /// In en, this message translates to:
  /// **'Campaign Mode'**
  String get campaignMode;

  /// No description provided for @rifts.
  ///
  /// In en, this message translates to:
  /// **'Rifts'**
  String get rifts;

  /// No description provided for @dungeons.
  ///
  /// In en, this message translates to:
  /// **'Dungeons'**
  String get dungeons;

  /// No description provided for @arena.
  ///
  /// In en, this message translates to:
  /// **'Arena'**
  String get arena;

  /// No description provided for @needCharacterFirst.
  ///
  /// In en, this message translates to:
  /// **'You must create a character first!'**
  String get needCharacterFirst;

  /// No description provided for @cannotOpenCampaign.
  ///
  /// In en, this message translates to:
  /// **'Cannot open campaign'**
  String get cannotOpenCampaign;

  /// No description provided for @miscTitle.
  ///
  /// In en, this message translates to:
  /// **'MISC.'**
  String get miscTitle;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @gifts.
  ///
  /// In en, this message translates to:
  /// **'Gifts'**
  String get gifts;

  /// No description provided for @events.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get events;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @rankings.
  ///
  /// In en, this message translates to:
  /// **'Rankings'**
  String get rankings;

  /// No description provided for @news.
  ///
  /// In en, this message translates to:
  /// **'News'**
  String get news;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @friends.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get friends;

  /// No description provided for @logoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutConfirm;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;
}

class _SDelegate extends LocalizationsDelegate<S> {
  const _SDelegate();

  @override
  Future<S> load(Locale locale) {
    return SynchronousFuture<S>(lookupS(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_SDelegate old) => false;
}

S lookupS(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return SEn();
    case 'es':
      return SEs();
    case 'fr':
      return SFr();
  }

  throw FlutterError(
      'S.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
