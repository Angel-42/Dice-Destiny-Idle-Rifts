import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
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
    Locale('de'),
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

  /// No description provided for @epicUniverseTagline.
  ///
  /// In en, this message translates to:
  /// **'Dive into an epic universe'**
  String get epicUniverseTagline;

  /// No description provided for @epicUniverseDescription.
  ///
  /// In en, this message translates to:
  /// **'where destiny is ruled by cosmic dice.\nFace the Rifts and save the worlds!'**
  String get epicUniverseDescription;

  /// No description provided for @initializingPortal.
  ///
  /// In en, this message translates to:
  /// **'Initializing portal...'**
  String get initializingPortal;

  /// No description provided for @startAdventure.
  ///
  /// In en, this message translates to:
  /// **'Start the adventure'**
  String get startAdventure;

  /// No description provided for @versionInfo.
  ///
  /// In en, this message translates to:
  /// **'Version 1.0.0 • Made with Flutter'**
  String get versionInfo;

  /// No description provided for @connectionError.
  ///
  /// In en, this message translates to:
  /// **'Connection error: {error}'**
  String connectionError(String error);

  /// No description provided for @stepYourName.
  ///
  /// In en, this message translates to:
  /// **'YOUR NAME'**
  String get stepYourName;

  /// No description provided for @stepYourRace.
  ///
  /// In en, this message translates to:
  /// **'YOUR RACE'**
  String get stepYourRace;

  /// No description provided for @stepYourRegion.
  ///
  /// In en, this message translates to:
  /// **'YOUR REGION'**
  String get stepYourRegion;

  /// No description provided for @stepYourOrigin.
  ///
  /// In en, this message translates to:
  /// **'YOUR ORIGIN'**
  String get stepYourOrigin;

  /// No description provided for @stepYourClass.
  ///
  /// In en, this message translates to:
  /// **'YOUR CLASS'**
  String get stepYourClass;

  /// No description provided for @stepConfirmation.
  ///
  /// In en, this message translates to:
  /// **'CONFIRMATION'**
  String get stepConfirmation;

  /// No description provided for @choicesShapeDestiny.
  ///
  /// In en, this message translates to:
  /// **'Your choices will shape your destiny'**
  String get choicesShapeDestiny;

  /// No description provided for @lowercaseOnly.
  ///
  /// In en, this message translates to:
  /// **'Lowercase only: max 11 characters'**
  String get lowercaseOnly;

  /// No description provided for @uppercaseOnly.
  ///
  /// In en, this message translates to:
  /// **'Uppercase only: max 8 characters'**
  String get uppercaseOnly;

  /// No description provided for @mixedCase.
  ///
  /// In en, this message translates to:
  /// **'Mixed: max {max} characters'**
  String mixedCase(int max);

  /// No description provided for @nameInLegends.
  ///
  /// In en, this message translates to:
  /// **'How are you known in legends?'**
  String get nameInLegends;

  /// No description provided for @yourNameHint.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get yourNameHint;

  /// No description provided for @minimumCharacters.
  ///
  /// In en, this message translates to:
  /// **'Minimum 3 characters'**
  String get minimumCharacters;

  /// No description provided for @whatIsYourNature.
  ///
  /// In en, this message translates to:
  /// **'What is your nature?'**
  String get whatIsYourNature;

  /// No description provided for @whereAreYouFrom.
  ///
  /// In en, this message translates to:
  /// **'Where are you from?'**
  String get whereAreYouFrom;

  /// No description provided for @whatIsYourStory.
  ///
  /// In en, this message translates to:
  /// **'What is your story?'**
  String get whatIsYourStory;

  /// No description provided for @whatPathDoYouTake.
  ///
  /// In en, this message translates to:
  /// **'What path do you take?'**
  String get whatPathDoYouTake;

  /// No description provided for @legendReady.
  ///
  /// In en, this message translates to:
  /// **'Your legend is ready to be written'**
  String get legendReady;

  /// No description provided for @nameSummary.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameSummary;

  /// No description provided for @raceSummary.
  ///
  /// In en, this message translates to:
  /// **'Race'**
  String get raceSummary;

  /// No description provided for @regionSummary.
  ///
  /// In en, this message translates to:
  /// **'Region'**
  String get regionSummary;

  /// No description provided for @originSummary.
  ///
  /// In en, this message translates to:
  /// **'Origin'**
  String get originSummary;

  /// No description provided for @classSummary.
  ///
  /// In en, this message translates to:
  /// **'Class'**
  String get classSummary;

  /// No description provided for @choicesFinal.
  ///
  /// In en, this message translates to:
  /// **'These choices are final and will influence your journey through the Rifts'**
  String get choicesFinal;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @forgeDestiny.
  ///
  /// In en, this message translates to:
  /// **'Forge my destiny'**
  String get forgeDestiny;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @cinematicTitle1.
  ///
  /// In en, this message translates to:
  /// **'IN THE BEGINNING'**
  String get cinematicTitle1;

  /// No description provided for @cinematicText1.
  ///
  /// In en, this message translates to:
  /// **'There was the Void.\nAn infinite emptiness where nothing existed.'**
  String get cinematicText1;

  /// No description provided for @cinematicSubtitle1.
  ///
  /// In en, this message translates to:
  /// **'Then the Cosmic Dice appeared...'**
  String get cinematicSubtitle1;

  /// No description provided for @cinematicTitle2.
  ///
  /// In en, this message translates to:
  /// **'THE DICE OF FATE'**
  String get cinematicTitle2;

  /// No description provided for @cinematicText2.
  ///
  /// In en, this message translates to:
  /// **'These divine artifacts shaped\nreality itself.'**
  String get cinematicText2;

  /// No description provided for @cinematicSubtitle2.
  ///
  /// In en, this message translates to:
  /// **'Each face, each roll created worlds.'**
  String get cinematicSubtitle2;

  /// No description provided for @cinematicTitle3.
  ///
  /// In en, this message translates to:
  /// **'BROKEN BALANCE'**
  String get cinematicTitle3;

  /// No description provided for @cinematicText3.
  ///
  /// In en, this message translates to:
  /// **'For eons, balance reigned.'**
  String get cinematicText3;

  /// No description provided for @cinematicSubtitle3.
  ///
  /// In en, this message translates to:
  /// **'But a dark force coveted their power.\nThe Rifts opened.'**
  String get cinematicSubtitle3;

  /// No description provided for @cinematicTitle4.
  ///
  /// In en, this message translates to:
  /// **'THE RIFTS'**
  String get cinematicTitle4;

  /// No description provided for @cinematicText4.
  ///
  /// In en, this message translates to:
  /// **'Cracks in reality,\ndevouring everything in their path.'**
  String get cinematicText4;

  /// No description provided for @cinematicSubtitle4.
  ///
  /// In en, this message translates to:
  /// **'Worlds collapse. Civilizations are dying.'**
  String get cinematicSubtitle4;

  /// No description provided for @cinematicTitle5.
  ///
  /// In en, this message translates to:
  /// **'A LAST HOPE'**
  String get cinematicTitle5;

  /// No description provided for @cinematicText5.
  ///
  /// In en, this message translates to:
  /// **'The Cosmic Dice seek\nChampions.'**
  String get cinematicText5;

  /// No description provided for @cinematicSubtitle5.
  ///
  /// In en, this message translates to:
  /// **'Souls capable of wielding their power.'**
  String get cinematicSubtitle5;

  /// No description provided for @cinematicTitle6.
  ///
  /// In en, this message translates to:
  /// **'WHO ARE YOU?'**
  String get cinematicTitle6;

  /// No description provided for @cinematicText6.
  ///
  /// In en, this message translates to:
  /// **'Destiny calls you.\nThe power of the Dice flows through you.'**
  String get cinematicText6;

  /// No description provided for @cinematicSubtitle6.
  ///
  /// In en, this message translates to:
  /// **'Your story begins now...'**
  String get cinematicSubtitle6;

  /// No description provided for @skipCinematic.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skipCinematic;

  /// No description provided for @nextScene.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get nextScene;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginTitle;

  /// No description provided for @chooseYourMode.
  ///
  /// In en, this message translates to:
  /// **'Choose your method'**
  String get chooseYourMode;

  /// No description provided for @emailAndPassword.
  ///
  /// In en, this message translates to:
  /// **'Email & Password'**
  String get emailAndPassword;

  /// No description provided for @permanentAccount.
  ///
  /// In en, this message translates to:
  /// **'Permanent account'**
  String get permanentAccount;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// No description provided for @google.
  ///
  /// In en, this message translates to:
  /// **'Google'**
  String get google;

  /// No description provided for @continueWithoutAccount.
  ///
  /// In en, this message translates to:
  /// **'Continue without account'**
  String get continueWithoutAccount;

  /// No description provided for @connectingInProgress.
  ///
  /// In en, this message translates to:
  /// **'Connecting...'**
  String get connectingInProgress;

  /// No description provided for @linkAccountLater.
  ///
  /// In en, this message translates to:
  /// **'You can link your account later in settings'**
  String get linkAccountLater;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'CREATE AN ACCOUNT'**
  String get createAccount;

  /// No description provided for @emailLogin.
  ///
  /// In en, this message translates to:
  /// **'EMAIL LOGIN'**
  String get emailLogin;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email required'**
  String get emailRequired;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email'**
  String get invalidEmail;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password required'**
  String get passwordRequired;

  /// No description provided for @minimumSixCharacters.
  ///
  /// In en, this message translates to:
  /// **'Minimum 6 characters'**
  String get minimumSixCharacters;

  /// No description provided for @createAccountButton.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccountButton;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign in'**
  String get alreadyHaveAccount;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'No account? Sign up'**
  String get noAccount;

  /// No description provided for @backToOptions.
  ///
  /// In en, this message translates to:
  /// **'← Back to options'**
  String get backToOptions;

  /// No description provided for @settingsAudio.
  ///
  /// In en, this message translates to:
  /// **'Audio'**
  String get settingsAudio;

  /// No description provided for @settingsMusic.
  ///
  /// In en, this message translates to:
  /// **'Music'**
  String get settingsMusic;

  /// No description provided for @settingsMusicSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enable background music'**
  String get settingsMusicSubtitle;

  /// No description provided for @settingsMusicVolume.
  ///
  /// In en, this message translates to:
  /// **'Music Volume'**
  String get settingsMusicVolume;

  /// No description provided for @settingsSfx.
  ///
  /// In en, this message translates to:
  /// **'Sound Effects'**
  String get settingsSfx;

  /// No description provided for @settingsSfxSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enable game sound effects'**
  String get settingsSfxSubtitle;

  /// No description provided for @settingsSfxVolume.
  ///
  /// In en, this message translates to:
  /// **'SFX Volume'**
  String get settingsSfxVolume;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguageTitle;

  /// No description provided for @settingsSelectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get settingsSelectLanguage;

  /// No description provided for @settingsResetDefaults.
  ///
  /// In en, this message translates to:
  /// **'Reset to Defaults'**
  String get settingsResetDefaults;

  /// No description provided for @settingsResetTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Settings?'**
  String get settingsResetTitle;

  /// No description provided for @settingsResetMessage.
  ///
  /// In en, this message translates to:
  /// **'This will reset all settings to their default values.'**
  String get settingsResetMessage;

  /// No description provided for @settingsResetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Settings reset to defaults'**
  String get settingsResetSuccess;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageFrench.
  ///
  /// In en, this message translates to:
  /// **'Français'**
  String get languageFrench;

  /// No description provided for @languageSpanish.
  ///
  /// In en, this message translates to:
  /// **'Español'**
  String get languageSpanish;

  /// No description provided for @languageGerman.
  ///
  /// In en, this message translates to:
  /// **'Deutsch'**
  String get languageGerman;

  /// No description provided for @settingsAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get settingsAccount;

  /// No description provided for @settingsLinkEmail.
  ///
  /// In en, this message translates to:
  /// **'Link Email'**
  String get settingsLinkEmail;

  /// No description provided for @settingsLinkEmailSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add email authentication'**
  String get settingsLinkEmailSubtitle;

  /// No description provided for @settingsLinkGoogle.
  ///
  /// In en, this message translates to:
  /// **'Link Google'**
  String get settingsLinkGoogle;

  /// No description provided for @settingsLinkGoogleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add Google authentication'**
  String get settingsLinkGoogleSubtitle;

  /// No description provided for @settingsDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get settingsDeleteAccount;

  /// No description provided for @settingsDeleteAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Account?'**
  String get settingsDeleteAccountTitle;

  /// No description provided for @settingsDeleteAccountMessage.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete your account and all associated data. This action cannot be undone.'**
  String get settingsDeleteAccountMessage;

  /// No description provided for @settingsDeleteAccountSuccess.
  ///
  /// In en, this message translates to:
  /// **'Account deleted successfully'**
  String get settingsDeleteAccountSuccess;

  /// No description provided for @settingsLinkSuccess.
  ///
  /// In en, this message translates to:
  /// **'Account linked successfully'**
  String get settingsLinkSuccess;

  /// No description provided for @settingsAlreadyLinked.
  ///
  /// In en, this message translates to:
  /// **'Already linked'**
  String get settingsAlreadyLinked;

  /// No description provided for @settingsAnonymous.
  ///
  /// In en, this message translates to:
  /// **'Anonymous Account'**
  String get settingsAnonymous;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'CLOSE'**
  String get close;

  /// No description provided for @attack.
  ///
  /// In en, this message translates to:
  /// **'ATTACK'**
  String get attack;

  /// No description provided for @targetOutOfRange.
  ///
  /// In en, this message translates to:
  /// **'Target out of range! (Distance: {distance}, Range: {range})'**
  String targetOutOfRange(int distance, int range);

  /// No description provided for @chooseAttack.
  ///
  /// In en, this message translates to:
  /// **'Choose an attack'**
  String get chooseAttack;

  /// No description provided for @basicAttack.
  ///
  /// In en, this message translates to:
  /// **'Basic attack'**
  String get basicAttack;

  /// No description provided for @damage.
  ///
  /// In en, this message translates to:
  /// **'Damage'**
  String get damage;

  /// No description provided for @victory.
  ///
  /// In en, this message translates to:
  /// **'🎉 VICTORY!'**
  String get victory;

  /// No description provided for @allEnemiesDefeated.
  ///
  /// In en, this message translates to:
  /// **'You have defeated all enemies!'**
  String get allEnemiesDefeated;

  /// No description provided for @returnButton.
  ///
  /// In en, this message translates to:
  /// **'RETURN'**
  String get returnButton;

  /// No description provided for @defeat.
  ///
  /// In en, this message translates to:
  /// **'💀 DEFEAT'**
  String get defeat;

  /// No description provided for @allCharactersDefeated.
  ///
  /// In en, this message translates to:
  /// **'All your characters have been defeated...'**
  String get allCharactersDefeated;

  /// No description provided for @turnEnded.
  ///
  /// In en, this message translates to:
  /// **'Turn ended!'**
  String get turnEnded;

  /// No description provided for @endTurn.
  ///
  /// In en, this message translates to:
  /// **'END TURN'**
  String get endTurn;

  /// No description provided for @combatLog.
  ///
  /// In en, this message translates to:
  /// **'COMBAT LOG'**
  String get combatLog;

  /// No description provided for @combatFinished.
  ///
  /// In en, this message translates to:
  /// **'COMBAT FINISHED'**
  String get combatFinished;

  /// No description provided for @combatVictorious.
  ///
  /// In en, this message translates to:
  /// **'Combat victorious!'**
  String get combatVictorious;

  /// No description provided for @enemyDefeated.
  ///
  /// In en, this message translates to:
  /// **'{name} defeated!'**
  String enemyDefeated(String name);

  /// No description provided for @forgeMyDestiny.
  ///
  /// In en, this message translates to:
  /// **'Forge my destiny'**
  String get forgeMyDestiny;

  /// No description provided for @tapToContinue.
  ///
  /// In en, this message translates to:
  /// **'Tap to continue'**
  String get tapToContinue;

  /// No description provided for @soundSettings.
  ///
  /// In en, this message translates to:
  /// **'🎵 Sound Settings'**
  String get soundSettings;

  /// No description provided for @music.
  ///
  /// In en, this message translates to:
  /// **'Music'**
  String get music;

  /// No description provided for @sfx.
  ///
  /// In en, this message translates to:
  /// **'SFX'**
  String get sfx;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @expMax.
  ///
  /// In en, this message translates to:
  /// **'EXP MAX'**
  String get expMax;

  /// No description provided for @exp.
  ///
  /// In en, this message translates to:
  /// **'EXP {current}/{max}'**
  String exp(int current, int max);

  /// No description provided for @emptySlot.
  ///
  /// In en, this message translates to:
  /// **'Empty slot'**
  String get emptySlot;

  /// No description provided for @noBonus.
  ///
  /// In en, this message translates to:
  /// **'No bonus'**
  String get noBonus;

  /// No description provided for @notLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'Not logged in'**
  String get notLoggedIn;

  /// No description provided for @summonError.
  ///
  /// In en, this message translates to:
  /// **'Error during summoning: {error}'**
  String summonError(String error);
}

class _SDelegate extends LocalizationsDelegate<S> {
  const _SDelegate();

  @override
  Future<S> load(Locale locale) {
    return SynchronousFuture<S>(lookupS(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'es', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_SDelegate old) => false;
}

S lookupS(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return SDe();
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
