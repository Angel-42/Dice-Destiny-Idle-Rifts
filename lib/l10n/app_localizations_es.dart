// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class SEs extends S {
  SEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Dice Destiny: Idle Rifts';

  @override
  String get welcome => 'Bienvenido';

  @override
  String get welcomeMessage =>
      '¡Bienvenido! Use la barra de navegación a continuación para explorar.';

  @override
  String get diceDestiny => 'DICE DESTINY';

  @override
  String get idleRifts => 'IDLE RIFTS';

  @override
  String get navHome => 'Inicio';

  @override
  String get navBattle => 'Batalla';

  @override
  String get navAllies => 'Aliados';

  @override
  String get navSummon => 'Invocar';

  @override
  String get navShop => 'Tienda';

  @override
  String get navMisc => 'Misc.';

  @override
  String get editTeam => 'EDITAR EQUIPO';

  @override
  String get allHeroes => 'TODOS LOS HÉROES';

  @override
  String get slot => 'Ranura';

  @override
  String get cancel => 'Cancelar';

  @override
  String error(String message) {
    return 'Error: $message';
  }

  @override
  String get level => 'Nv.';

  @override
  String get hp => 'PV';

  @override
  String get atk => 'Atq';

  @override
  String get mag => 'Mag';

  @override
  String get spd => 'Vel';

  @override
  String get def => 'Def';

  @override
  String get lck => 'Sue';

  @override
  String get res => 'Res';

  @override
  String get rarityCommon => 'Común';

  @override
  String get rarityRare => 'Raro';

  @override
  String get rarityEpic => 'Épico';

  @override
  String get rarityLegendary => 'Legendario';

  @override
  String get equipmentWeapon => 'Arma';

  @override
  String get equipmentArmor => 'Armadura';

  @override
  String get equipmentAccessory => 'Accesorio';

  @override
  String get equipmentSkill => 'Habilidad';

  @override
  String get warrior => 'Guerrero';

  @override
  String get mage => 'Mago';

  @override
  String get rogue => 'Pícaro';

  @override
  String get cleric => 'Clérigo';

  @override
  String get ironSword => 'Espada de Hierro';

  @override
  String get woodenStaff => 'Bastón de Madera';

  @override
  String get ironDagger => 'Daga de Hierro';

  @override
  String get healingRod => 'Vara de Curación';

  @override
  String get noPlayerData => 'Sin datos de jugador';

  @override
  String get loading => 'Cargando...';

  @override
  String get gold => 'Oro';

  @override
  String get gems => 'Gemas';

  @override
  String get summonTokens => 'Fichas de Invocación';

  @override
  String idleIncomeOnline(int amount) {
    return '+$amount oro (ingreso pasivo)';
  }

  @override
  String idleIncomeOffline(int amount, String hours) {
    return 'Ingreso sin conexión: +$amount oro (${hours}h de ausencia)';
  }

  @override
  String get firstConnection => 'Primera conexión, sin ingreso sin conexión';

  @override
  String noOfflineIncome(int seconds) {
    return 'Sin ingreso sin conexión (última conexión: ${seconds}s)';
  }

  @override
  String get stamina => 'Resistencia';

  @override
  String get battleTitle => 'BATALLA';

  @override
  String get battleSystem => 'Sistema de Batalla';

  @override
  String get campaignMode => 'Modo Campaña';

  @override
  String get rifts => 'Fisuras';

  @override
  String get dungeons => 'Mazmorras';

  @override
  String get arena => 'Arena';

  @override
  String get needCharacterFirst => '¡Primero debes crear un personaje!';

  @override
  String get cannotOpenCampaign => 'No se puede abrir la campaña';

  @override
  String get miscTitle => 'MISC.';

  @override
  String get settings => 'Configuración';

  @override
  String get gifts => 'Regalos';

  @override
  String get events => 'Eventos';

  @override
  String get logout => 'Cerrar sesión';

  @override
  String get rankings => 'Clasificaciones';

  @override
  String get news => 'Noticias';

  @override
  String get help => 'Ayuda';

  @override
  String get friends => 'Amigos';

  @override
  String get logoutConfirm => '¿Está seguro de que desea cerrar sesión?';

  @override
  String get confirm => 'Confirmar';

  @override
  String get epicUniverseTagline => 'Sumérgete en un universo épico';

  @override
  String get epicUniverseDescription =>
      'donde el destino está gobernado por dados cósmicos.\n¡Enfrenta las Fisuras y salva los mundos!';

  @override
  String get initializingPortal => 'Inicializando portal...';

  @override
  String get startAdventure => 'Comenzar la aventura';

  @override
  String get versionInfo => 'Versión 1.0.0 • Hecho con Flutter';

  @override
  String connectionError(String error) {
    return 'Error de conexión: $error';
  }

  @override
  String get stepYourName => 'TU NOMBRE';

  @override
  String get stepYourRace => 'TU RAZA';

  @override
  String get stepYourRegion => 'TU REGIÓN';

  @override
  String get stepYourOrigin => 'TU ORIGEN';

  @override
  String get stepYourClass => 'TU CLASE';

  @override
  String get stepConfirmation => 'CONFIRMACIÓN';

  @override
  String get choicesShapeDestiny => 'Tus elecciones darán forma a tu destino';

  @override
  String get lowercaseOnly => 'Solo minúsculas: máx. 11 caracteres';

  @override
  String get uppercaseOnly => 'Solo mayúsculas: máx. 8 caracteres';

  @override
  String mixedCase(int max) {
    return 'Mixto: máx. $max caracteres';
  }

  @override
  String get nameInLegends => '¿Cómo eres conocido en las leyendas?';

  @override
  String get yourNameHint => 'Tu nombre';

  @override
  String get minimumCharacters => 'Mínimo 3 caracteres';

  @override
  String get whatIsYourNature => '¿Cuál es tu naturaleza?';

  @override
  String get whereAreYouFrom => '¿De dónde eres?';

  @override
  String get whatIsYourStory => '¿Cuál es tu historia?';

  @override
  String get whatPathDoYouTake => '¿Qué camino tomas?';

  @override
  String get legendReady => 'Tu leyenda está lista para ser escrita';

  @override
  String get nameSummary => 'Nombre';

  @override
  String get raceSummary => 'Raza';

  @override
  String get regionSummary => 'Región';

  @override
  String get originSummary => 'Origen';

  @override
  String get classSummary => 'Clase';

  @override
  String get choicesFinal =>
      'Estas elecciones son definitivas e influirán en tu viaje a través de las Fisuras';

  @override
  String get back => 'Atrás';

  @override
  String get forgeDestiny => 'Forjar mi destino';

  @override
  String get continueButton => 'Continuar';

  @override
  String get cinematicTitle1 => 'EN EL PRINCIPIO';

  @override
  String get cinematicText1 =>
      'Existía el Vacío.\nUn vacío infinito donde nada existía.';

  @override
  String get cinematicSubtitle1 => 'Entonces aparecieron los Dados Cósmicos...';

  @override
  String get cinematicTitle2 => 'LOS DADOS DEL DESTINO';

  @override
  String get cinematicText2 =>
      'Estos artefactos divinos moldearon\nla realidad misma.';

  @override
  String get cinematicSubtitle2 => 'Cada cara, cada tirada creó mundos.';

  @override
  String get cinematicTitle3 => 'EQUILIBRIO ROTO';

  @override
  String get cinematicText3 => 'Durante eones, reinó el equilibrio.';

  @override
  String get cinematicSubtitle3 =>
      'Pero una fuerza oscura codició su poder.\nLas Fisuras se abrieron.';

  @override
  String get cinematicTitle4 => 'LAS FISURAS';

  @override
  String get cinematicText4 =>
      'Grietas en la realidad,\ndevorando todo a su paso.';

  @override
  String get cinematicSubtitle4 =>
      'Los mundos colapsan. Las civilizaciones mueren.';

  @override
  String get cinematicTitle5 => 'UNA ÚLTIMA ESPERANZA';

  @override
  String get cinematicText5 => 'Los Dados Cósmicos buscan\nCampeones.';

  @override
  String get cinematicSubtitle5 => 'Almas capaces de empuñar su poder.';

  @override
  String get cinematicTitle6 => '¿QUIÉN ERES TÚ?';

  @override
  String get cinematicText6 =>
      'El destino te llama.\nEl poder de los Dados fluye a través de ti.';

  @override
  String get cinematicSubtitle6 => 'Tu historia comienza ahora...';

  @override
  String get skipCinematic => 'Saltar';

  @override
  String get nextScene => 'Siguiente';

  @override
  String get loginTitle => 'Iniciar sesión';

  @override
  String get chooseYourMode => 'Elige tu método';

  @override
  String get emailAndPassword => 'Correo y Contraseña';

  @override
  String get permanentAccount => 'Cuenta permanente';

  @override
  String get or => 'O';

  @override
  String get google => 'Google';

  @override
  String get continueWithoutAccount => 'Continuar sin cuenta';

  @override
  String get connectingInProgress => 'Conectando...';

  @override
  String get linkAccountLater =>
      'Puedes vincular tu cuenta más tarde en la configuración';

  @override
  String get createAccount => 'CREAR UNA CUENTA';

  @override
  String get emailLogin => 'INICIO CON CORREO';

  @override
  String get email => 'Correo electrónico';

  @override
  String get emailRequired => 'Correo requerido';

  @override
  String get invalidEmail => 'Correo inválido';

  @override
  String get password => 'Contraseña';

  @override
  String get passwordRequired => 'Contraseña requerida';

  @override
  String get minimumSixCharacters => 'Mínimo 6 caracteres';

  @override
  String get createAccountButton => 'Crear cuenta';

  @override
  String get signIn => 'Iniciar sesión';

  @override
  String get alreadyHaveAccount => '¿Ya tienes una cuenta? Iniciar sesión';

  @override
  String get noAccount => '¿Sin cuenta? Registrarse';

  @override
  String get backToOptions => '← Volver a opciones';

  @override
  String get settingsAudio => 'Audio';

  @override
  String get settingsMusic => 'Música';

  @override
  String get settingsMusicSubtitle => 'Activar música de fondo';

  @override
  String get settingsMusicVolume => 'Volumen Música';

  @override
  String get settingsSfx => 'Efectos de Sonido';

  @override
  String get settingsSfxSubtitle => 'Activar efectos de sonido del juego';

  @override
  String get settingsSfxVolume => 'Volumen Efectos';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsLanguageTitle => 'Idioma';

  @override
  String get settingsSelectLanguage => 'Seleccionar Idioma';

  @override
  String get settingsResetDefaults => 'Restaurar Valores';

  @override
  String get settingsResetTitle => '¿Restablecer Configuración?';

  @override
  String get settingsResetMessage =>
      'Esto restablecerá todas las configuraciones a sus valores predeterminados.';

  @override
  String get settingsResetSuccess => 'Configuración restablecida';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageSpanish => 'Español';

  @override
  String get languageGerman => 'Deutsch';

  @override
  String get settingsAccount => 'Cuenta';

  @override
  String get settingsLinkEmail => 'Vincular Email';

  @override
  String get settingsLinkEmailSubtitle => 'Agregar autenticación por email';

  @override
  String get settingsLinkGoogle => 'Vincular Google';

  @override
  String get settingsLinkGoogleSubtitle => 'Agregar autenticación de Google';

  @override
  String get settingsDeleteAccount => 'Eliminar cuenta';

  @override
  String get settingsDeleteAccountTitle => '¿Eliminar cuenta?';

  @override
  String get settingsDeleteAccountMessage =>
      'Esto eliminará permanentemente su cuenta y todos los datos asociados. Esta acción no se puede deshacer.';

  @override
  String get settingsDeleteAccountSuccess => 'Cuenta eliminada con éxito';

  @override
  String get settingsLinkSuccess => 'Cuenta vinculada con éxito';

  @override
  String get settingsAlreadyLinked => 'Ya vinculado';

  @override
  String get settingsAnonymous => 'Cuenta anónima';
}
