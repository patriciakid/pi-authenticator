import 'app_localizations.dart';

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get accept => 'Potwierdzam';

  @override
  String get decline => 'Odrzucam';

  @override
  String get name => 'Nazwa';

  @override
  String get secret => 'Sekret';

  @override
  String get encoding => 'Kodowanie';

  @override
  String get algorithm => 'Algorytm';

  @override
  String get digits => 'Ilość cyfr';

  @override
  String get type => 'Typ';

  @override
  String get period => 'Cykl';

  @override
  String get rename => 'Zmień nazwę';

  @override
  String get cancel => 'Anuluj';

  @override
  String get delete => 'Usuń';

  @override
  String get dismiss => 'Odrzuć';

  @override
  String get addToken => 'Dodaj token';

  @override
  String get scanQrCode => 'Zeskanuj kod QR';

  @override
  String get enterDetailsForToken => 'Wprowadź szczegóły dla tokenu';

  @override
  String get pleaseEnterANameForThisToken => 'Wprowadź nazwę dla tokenu';

  @override
  String get pleaseEnterASecretForThisToken => 'Wprowadź sekret dla tokenu';

  @override
  String get theSecretDoesNotFitTheCurrentEncoding => 'Sekret nie odpowiada wybranemu sposobowi kodowania.';

  @override
  String get renameToken => 'Zmień nazwę tokenu';

  @override
  String get confirmDeletion => 'Potwierdź usunięcie';

  @override
  String confirmDeletionOf(Object name) {
    return 'Jesteś pewien, że chcesz usunąć token: $name?';
  }

  @override
  String get generatingPhonePart => 'Generowanie sekretu po stronie telefonu...';

  @override
  String get phonePart => 'Sekret po stronie telefonu:';

  @override
  String otpValueCopiedMessage(Object otpValue) {
    return 'Jednorazowe hasło \"$otpValue\" skopiowane do schowka.';
  }

  @override
  String get settings => 'Ustawienia';

  @override
  String get pushToken => 'Push token';

  @override
  String get theme => 'Motyw';

  @override
  String get lightTheme => 'Jasny';

  @override
  String get darkTheme => 'Ciemny';

  @override
  String get systemTheme => 'Motyw systemu';

  @override
  String get enablePolling => 'Włącz autentykację przez wiadomość push.';

  @override
  String get requestPushChallengesPeriodically => 'Wysyłaj zapytanie o push challenge cyklicznie. Włącz, jeśli push nie przychodzi normalnie.';

  @override
  String get synchronizePushTokens => 'Synchronizuj tokeny push.';

  @override
  String get synchronizesTokensWithServer => 'Synchronizuje tokeny push z serwerem privacyIDEA.';

  @override
  String get sync => 'Synchronizuj';

  @override
  String get synchronizingTokens => 'Synchronizacja tokenów.';

  @override
  String get allTokensSynchronized => 'Wszystkie tokeny są zsynchronizowane.';

  @override
  String get synchronizationFailed => 'Synchronizacja dla poniższych tokenów się nie udała, spróbuj ponownie:';

  @override
  String get tokensDoNotSupportSynchronization => 'Następujące tokeny nie wspierają synchronizacji i muszą zostać wdrożone od nowa:';

  @override
  String errorRollOutFailed(Object name, Object errorCode) {
    return 'Wdrażanie tokenu $name nieudane. Kod błędu: $errorCode';
  }

  @override
  String get errorSynchronizationNoNetworkConnection => 'Synchronizacja tokenów push nieudana, ponieważ serwer privacyIDEA jest nieosiągalny.';

  @override
  String errorRollOutNoConnectionToServer(Object name) {
    return 'Brak połączenia z serwerem';
  }

  @override
  String errorRollOutUnknownError(Object e) {
    return 'Napotkano nieznany błąd. Wdrożenie tokenu niemożliwe: $e';
  }

  @override
  String get rollingOut => 'Wdrażanie';

  @override
  String get pollingChallenges => 'Sprawdzanie nowych wyzwań';

  @override
  String get unexpectedError => 'Wystąpił nieoczekiwany błąd.';

  @override
  String get pollingFailNoNetworkConnection => 'Serwer jest nieosiągalny.';

  @override
  String get useDeviceLocaleTitle => 'Użyj języka urządzenia.';

  @override
  String get useDeviceLocaleDescription => 'Użyj języka urządzenia, jeśli jest wspierany. W innym wypadku zostanie ustawiony domyślny język angielski.';

  @override
  String get language => 'Język';

  @override
  String get authenticateToShowOtp => 'Zweryfikuj tożsamość, by pokazać hasło jednorazowe.';

  @override
  String get authenticateToUnLockToken => 'Zweryfikuj tożsamość, aby odblokować / zablokować token.';

  @override
  String get biometricRequiredTitle => 'Uwierzytelnianie biometryczne nie jest skonfigurowane.';

  @override
  String get biometricHint => 'Wymagana autentykacja';

  @override
  String get biometricNotRecognized => 'Nie rozpoznano. Spróbuj ponownie.';

  @override
  String get biometricSuccess => 'Autentykacja zakończona sukcesem!';

  @override
  String get deviceCredentialsRequiredTitle => 'Ustawienia zabezpieczeń urządzenia nie zostały skonfigurowane.';

  @override
  String get deviceCredentialsSetupDescription => 'Skonfiguruj ustawienia zabezpieczeń w ustawieniach urządzenia.';

  @override
  String get signInTitle => 'Wymagana autentykacja';

  @override
  String get goToSettingsButton => 'Idź do ustawień';

  @override
  String get goToSettingsDescription => 'Ustawienia zabezpieczeń, bądź uwierzytelnianie biometryczne nie są skonfigurowane w twoim urządzeniu. Skonfiguruj je w ustawieniach urządzenia.';

  @override
  String get lockOut => 'Uwierzytelnianie biometryczne jest wyłączone. Zablokuj i odblokuj ponownie ekran, żeby je włączyć.';

  @override
  String get authNotSupportedTitle => 'Skonfigurowane ustawienia zabezpieczeń albo uwierzytelnianie biometryczne jest wymagane.';

  @override
  String get authNotSupportedBody => 'To działanie wymaga skonfigurowania ustawień zabezpieczeń albo uwierzytelniania biometrycznego.';

  @override
  String get lock => 'Zablokuj';

  @override
  String get unlock => 'Odblokuj';

  @override
  String get noResultTitle => 'Nie zainstalowano jeszcze żadnego tokenu.';

  @override
  String get noResultText1 => 'Dotknij ';

  @override
  String get noResultText2 => ' przycisku, żeby zacząć!';

  @override
  String onBoardingTitle1(String appName) {
    return '$appName';
  }

  @override
  String get onBoardingText1 => 'Uwierzytelnianie dwuskładnikowe\nuczynione prostym';

  @override
  String get onBoardingTitle2 => 'Maksymalne Bezpieczeństwo';

  @override
  String get onBoardingText2 => 'Przechowuj tokeny w swoim urządzeniu\nzabezpieczone biometrycznie';

  @override
  String get onBoardingTitle3 => 'Odwiedź nas na Github';

  @override
  String get onBoardingText3 => 'Ta aplikacja jest w open source';

  @override
  String get errorLogTitle => 'Error logs';

  @override
  String get sendErrorHint => 'Wyślij nam dziennik błędów pocztą e-mail';

  @override
  String get enableVerboseLogging => 'Włącz szczegółowe rejestrowanie';

  @override
  String get clearErrorLogHint => 'Czyści lokalny plik dziennika błędów';

  @override
  String get logMenu => 'LogMenu';

  @override
  String get sendErrorDialogHeader => 'Wyślij przez e-mail';

  @override
  String get ok => 'Ok';

  @override
  String get noLogToSend => 'There is log to send.';

  @override
  String get errorLogFileAttached => 'Plik dziennika błędów jest dołączony';

  @override
  String get errorLogCleared => 'Wyczyszczono dzienniki błędów';

  @override
  String get showDetails => 'Pokaż szczegóły';

  @override
  String get open => 'Otwórz';

  @override
  String get sendErrorDialogBody => 'Napotkano nieoczekiwany błąd w aplikacji. Poniższa wiadomość może zostać wysłana do deweloperów poprzez email, żeby pomóc uniknąć tego problemu w przyszłości.';

  @override
  String get noFbToken => 'Brak dostępnego tokena Firebase';

  @override
  String get firebaseToken => 'Token Firebase';

  @override
  String get noPublicKey => 'Brak dostępnego klucza publicznego';

  @override
  String get publicKey => 'Klucz publiczny';

  @override
  String get editToken => 'Edytuj token';

  @override
  String get edit => 'Edytuj';

  @override
  String get save => 'Zapisz';

  @override
  String get validFor => 'Ważny przez';

  @override
  String get validUntil => 'Ważny do';

  @override
  String get deleteLockedToken => 'Uwierzytelnij, aby usunąć zablokowany token.';

  @override
  String get editLockedToken => 'Aby edytować zablokowany token, należy się uwierzytelnić.';

  @override
  String get uncollapseLockedFolder => 'Uwierzytelnij, aby otworzyć zablokowany folder.';

  @override
  String get renameTokenFolder => 'Zmiana nazwy folderu';

  @override
  String get addANewFolder => 'Utwórz nowy folder';

  @override
  String get folderName => 'Nazwa folderu';

  @override
  String get retryRollout => 'Ponowne uruchomienie';

  @override
  String get generatingRSAKeyPair => 'Generowanie pary kluczy RSA';

  @override
  String get generatingRSAKeyPairFailed => 'Generowanie pary kluczy RSA nieudane';

  @override
  String get sendingRSAPublicKey => 'Wysyłanie publicznego klucza RSA';

  @override
  String get sendingRSAPublicKeyFailed => 'Wysyłanie publicznego klucza RSA nieudane';

  @override
  String get parsingResponse => 'Analizowanie odpowiedzi';

  @override
  String get parsingResponseFailed => 'Analizowanie odpowiedzi nieudane';

  @override
  String get rolloutCompleted => 'Wdrożenie zakończone';

  @override
  String get authToAcceptPushRequest => 'Uwierzytelnij, aby zaakceptować żądanie push.';

  @override
  String get authToDeclinePushRequest => 'Uwierzytelnij, aby odrzucić żądanie push.';

  @override
  String get incomingAuthRequestError => 'Wiadomość nie zawierała wymaganych danych lub dane były zniekształcone.';

  @override
  String get imageUrl => 'Adres URL obrazu';

  @override
  String get errorRollOutSSLHandshakeFailed => 'Uścisk dłoni SSL nie powiódł się. Rozwijanie nie jest możliwe.';

  @override
  String errorWhenPullingChallenges(String name) {
    return 'Wystąpił błąd podczas odpytywania o wyzwania $name';
  }

  @override
  String errorRollOutTokenExpired(Object name) {
    return 'Wstać z łóżka tego tokena nie jest już możliwe.\nToken $name wygasł.';
  }

  @override
  String get yes => 'Tak';

  @override
  String get no => 'Nie';

  @override
  String get butDiscardIt => 'ale odrzucić go';

  @override
  String get declineIt => 'odrzuć go';

  @override
  String get requestTriggerdByUserQuestion => 'Czy ta prośba została wywołana przez Ciebie?';
}
