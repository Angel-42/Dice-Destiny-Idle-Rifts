// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class SDe extends S {
  SDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Dice Destiny: Idle Rifts';

  @override
  String get welcome => 'Willkommen';

  @override
  String get welcomeMessage =>
      'Willkommen! Nutze die untere Navigationsleiste zum Erkunden.';

  @override
  String get diceDestiny => 'DICE DESTINY';

  @override
  String get idleRifts => 'IDLE RIFTS';

  @override
  String get navHome => 'Start';

  @override
  String get navBattle => 'Kampf';

  @override
  String get navAllies => 'Verbündete';

  @override
  String get navSummon => 'Beschwörung';

  @override
  String get navShop => 'Laden';

  @override
  String get navMisc => 'Sonstiges';

  @override
  String get editTeam => 'TEAM BEARBEITEN';

  @override
  String get allHeroes => 'ALLE HELDEN';

  @override
  String get slot => 'Platz';

  @override
  String get cancel => 'Abbrechen';

  @override
  String error(String message) {
    return 'Fehler: $message';
  }

  @override
  String get level => 'Lv.';

  @override
  String get hp => 'LP';

  @override
  String get atk => 'Ang';

  @override
  String get mag => 'Mag';

  @override
  String get spd => 'Ges';

  @override
  String get def => 'Def';

  @override
  String get lck => 'Glk';

  @override
  String get res => 'Res';

  @override
  String get rarityCommon => 'Gewöhnlich';

  @override
  String get rarityRare => 'Selten';

  @override
  String get rarityEpic => 'Episch';

  @override
  String get rarityLegendary => 'Legendär';

  @override
  String get equipmentWeapon => 'Waffe';

  @override
  String get equipmentArmor => 'Rüstung';

  @override
  String get equipmentAccessory => 'Accessoire';

  @override
  String get equipmentSkill => 'Fähigkeit';

  @override
  String get warrior => 'Krieger';

  @override
  String get mage => 'Magier';

  @override
  String get rogue => 'Schurke';

  @override
  String get cleric => 'Kleriker';

  @override
  String get ironSword => 'Eisenschwert';

  @override
  String get woodenStaff => 'Holzstab';

  @override
  String get ironDagger => 'Eisendolch';

  @override
  String get healingRod => 'Heilstab';

  @override
  String get noPlayerData => 'Keine Spielerdaten';

  @override
  String get loading => 'Lädt...';

  @override
  String get gold => 'Gold';

  @override
  String get gems => 'Edelsteine';

  @override
  String get summonTokens => 'Beschwörungsmarken';

  @override
  String idleIncomeOnline(int amount) {
    return '+$amount Gold (Idle-Einkommen)';
  }

  @override
  String idleIncomeOffline(int amount, String hours) {
    return 'Offline-Einkommen: +$amount Gold (${hours}h Abwesenheit)';
  }

  @override
  String get firstConnection => 'Erste Verbindung, kein Offline-Einkommen';

  @override
  String noOfflineIncome(int seconds) {
    return 'Kein Offline-Einkommen (letzte Verbindung: ${seconds}s)';
  }

  @override
  String get stamina => 'Ausdauer';

  @override
  String get battleTitle => 'KAMPF';

  @override
  String get battleSystem => 'Kampfsystem';

  @override
  String get campaignMode => 'Kampagnenmodus';

  @override
  String get rifts => 'Risse';

  @override
  String get dungeons => 'Verliese';

  @override
  String get arena => 'Arena';

  @override
  String get needCharacterFirst => 'Du musst zuerst einen Charakter erstellen!';

  @override
  String get cannotOpenCampaign => 'Kampagne kann nicht geöffnet werden';

  @override
  String get miscTitle => 'SONSTIGES';

  @override
  String get settings => 'Einstellungen';

  @override
  String get gifts => 'Geschenke';

  @override
  String get events => 'Ereignisse';

  @override
  String get logout => 'Abmelden';

  @override
  String get rankings => 'Ranglisten';

  @override
  String get news => 'Neuigkeiten';

  @override
  String get help => 'Hilfe';

  @override
  String get friends => 'Freunde';

  @override
  String get logoutConfirm => 'Möchtest du dich wirklich abmelden?';

  @override
  String get confirm => 'Bestätigen';

  @override
  String get epicUniverseTagline => 'Tauche ein in ein episches Universum';

  @override
  String get epicUniverseDescription =>
      'wo das Schicksal von kosmischen Würfeln bestimmt wird.\nStelle dich den Rissen und rette die Welten!';

  @override
  String get initializingPortal => 'Portal wird initialisiert...';

  @override
  String get startAdventure => 'Abenteuer starten';

  @override
  String get versionInfo => 'Version 1.0.0 • Erstellt mit Flutter';

  @override
  String connectionError(String error) {
    return 'Verbindungsfehler: $error';
  }

  @override
  String get stepYourName => 'DEIN NAME';

  @override
  String get stepYourRace => 'DEINE RASSE';

  @override
  String get stepYourRegion => 'DEINE REGION';

  @override
  String get stepYourOrigin => 'DEINE HERKUNFT';

  @override
  String get stepYourClass => 'DEINE KLASSE';

  @override
  String get stepConfirmation => 'BESTÄTIGUNG';

  @override
  String get choicesShapeDestiny =>
      'Deine Entscheidungen werden dein Schicksal prägen';

  @override
  String get lowercaseOnly => 'Nur Kleinbuchstaben: max. 11 Zeichen';

  @override
  String get uppercaseOnly => 'Nur Großbuchstaben: max. 8 Zeichen';

  @override
  String mixedCase(int max) {
    return 'Gemischt: max. $max Zeichen';
  }

  @override
  String get nameInLegends => 'Wie bist du in Legenden bekannt?';

  @override
  String get yourNameHint => 'Dein Name';

  @override
  String get minimumCharacters => 'Mindestens 3 Zeichen';

  @override
  String get whatIsYourNature => 'Was ist deine Natur?';

  @override
  String get whereAreYouFrom => 'Woher kommst du?';

  @override
  String get whatIsYourStory => 'Was ist deine Geschichte?';

  @override
  String get whatPathDoYouTake => 'Welchen Weg schlägst du ein?';

  @override
  String get legendReady => 'Deine Legende ist bereit, geschrieben zu werden';

  @override
  String get nameSummary => 'Name';

  @override
  String get raceSummary => 'Rasse';

  @override
  String get regionSummary => 'Region';

  @override
  String get originSummary => 'Herkunft';

  @override
  String get classSummary => 'Klasse';

  @override
  String get choicesFinal =>
      'Diese Entscheidungen sind endgültig und werden deine Reise durch die Risse beeinflussen';

  @override
  String get back => 'Zurück';

  @override
  String get forgeDestiny => 'Mein Schicksal schmieden';

  @override
  String get continueButton => 'Weiter';

  @override
  String get cinematicTitle1 => 'AM ANFANG';

  @override
  String get cinematicText1 =>
      'War die Leere.\nEine unendliche Leere, in der nichts existierte.';

  @override
  String get cinematicSubtitle1 => 'Dann erschienen die Kosmischen Würfel...';

  @override
  String get cinematicTitle2 => 'DIE WÜRFEL DES SCHICKSALS';

  @override
  String get cinematicText2 =>
      'Diese göttlichen Artefakte formten\ndie Realität selbst.';

  @override
  String get cinematicSubtitle2 => 'Jede Seite, jeder Wurf erschuf Welten.';

  @override
  String get cinematicTitle3 => 'ZERBROCHENES GLEICHGEWICHT';

  @override
  String get cinematicText3 => 'Äonen lang herrschte Gleichgewicht.';

  @override
  String get cinematicSubtitle3 =>
      'Doch eine dunkle Macht begehrte ihre Kraft.\nDie Risse öffneten sich.';

  @override
  String get cinematicTitle4 => 'DIE RISSE';

  @override
  String get cinematicText4 =>
      'Risse in der Realität,\ndie alles auf ihrem Weg verschlingen.';

  @override
  String get cinematicSubtitle4 =>
      'Welten kollabieren. Zivilisationen sterben.';

  @override
  String get cinematicTitle5 => 'EINE LETZTE HOFFNUNG';

  @override
  String get cinematicText5 => 'Die Kosmischen Würfel suchen\nChampions.';

  @override
  String get cinematicSubtitle5 => 'Seelen, die ihre Macht ausüben können.';

  @override
  String get cinematicTitle6 => 'WER BIST DU?';

  @override
  String get cinematicText6 =>
      'Das Schicksal ruft dich.\nDie Macht der Würfel fließt durch dich.';

  @override
  String get cinematicSubtitle6 => 'Deine Geschichte beginnt jetzt...';

  @override
  String get skipCinematic => 'Überspringen';

  @override
  String get nextScene => 'Weiter';

  @override
  String get loginTitle => 'Anmeldung';

  @override
  String get chooseYourMode => 'Wähle deine Methode';

  @override
  String get emailAndPassword => 'E-Mail & Passwort';

  @override
  String get permanentAccount => 'Dauerhaftes Konto';

  @override
  String get or => 'ODER';

  @override
  String get google => 'Google';

  @override
  String get continueWithoutAccount => 'Ohne Konto fortfahren';

  @override
  String get connectingInProgress => 'Verbinde...';

  @override
  String get linkAccountLater =>
      'Du kannst dein Konto später in den Einstellungen verknüpfen';

  @override
  String get createAccount => 'KONTO ERSTELLEN';

  @override
  String get emailLogin => 'E-MAIL ANMELDUNG';

  @override
  String get email => 'E-Mail';

  @override
  String get emailRequired => 'E-Mail erforderlich';

  @override
  String get invalidEmail => 'Ungültige E-Mail';

  @override
  String get password => 'Passwort';

  @override
  String get passwordRequired => 'Passwort erforderlich';

  @override
  String get minimumSixCharacters => 'Mindestens 6 Zeichen';

  @override
  String get createAccountButton => 'Konto erstellen';

  @override
  String get signIn => 'Anmelden';

  @override
  String get alreadyHaveAccount => 'Bereits ein Konto? Anmelden';

  @override
  String get noAccount => 'Kein Konto? Registrieren';

  @override
  String get backToOptions => '← Zurück zu den Optionen';

  @override
  String get settingsAudio => 'Audio';

  @override
  String get settingsMusic => 'Musik';

  @override
  String get settingsMusicSubtitle => 'Hintergrundmusik aktivieren';

  @override
  String get settingsMusicVolume => 'Musiklautstärke';

  @override
  String get settingsSfx => 'Soundeffekte';

  @override
  String get settingsSfxSubtitle => 'Spiel-Soundeffekte aktivieren';

  @override
  String get settingsSfxVolume => 'Effektlautstärke';

  @override
  String get settingsLanguage => 'Sprache';

  @override
  String get settingsLanguageTitle => 'Sprache';

  @override
  String get settingsSelectLanguage => 'Sprache Auswählen';

  @override
  String get settingsResetDefaults => 'Zurücksetzen';

  @override
  String get settingsResetTitle => 'Einstellungen Zurücksetzen?';

  @override
  String get settingsResetMessage =>
      'Dies setzt alle Einstellungen auf ihre Standardwerte zurück.';

  @override
  String get settingsResetSuccess => 'Einstellungen zurückgesetzt';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageSpanish => 'Español';

  @override
  String get languageGerman => 'Deutsch';

  @override
  String get settingsAccount => 'Konto';

  @override
  String get settingsLinkEmail => 'E-Mail verknüpfen';

  @override
  String get settingsLinkEmailSubtitle => 'E-Mail-Authentifizierung hinzufügen';

  @override
  String get settingsLinkGoogle => 'Google verknüpfen';

  @override
  String get settingsLinkGoogleSubtitle =>
      'Google-Authentifizierung hinzufügen';

  @override
  String get settingsDeleteAccount => 'Konto löschen';

  @override
  String get settingsDeleteAccountTitle => 'Konto löschen?';

  @override
  String get settingsDeleteAccountMessage =>
      'Dies löscht Ihr Konto und alle zugehörigen Daten dauerhaft. Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get settingsDeleteAccountSuccess => 'Konto erfolgreich gelöscht';

  @override
  String get settingsLinkSuccess => 'Konto erfolgreich verknüpft';

  @override
  String get settingsAlreadyLinked => 'Bereits verknüpft';

  @override
  String get settingsAnonymous => 'Anonymes Konto';
}
