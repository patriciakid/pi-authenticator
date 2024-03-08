import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mockito/mockito.dart';
import 'package:privacyidea_authenticator/l10n/app_localizations_en.dart';
import 'package:privacyidea_authenticator/main.dart';
import 'package:privacyidea_authenticator/model/enums/introduction.dart';
import 'package:privacyidea_authenticator/model/states/introduction_state.dart';
import 'package:privacyidea_authenticator/model/states/settings_state.dart';
import 'package:privacyidea_authenticator/state_notifiers/settings_notifier.dart';
import 'package:privacyidea_authenticator/state_notifiers/token_folder_notifier.dart';
import 'package:privacyidea_authenticator/state_notifiers/token_notifier.dart';
import 'package:privacyidea_authenticator/utils/app_customizer.dart';
import 'package:privacyidea_authenticator/utils/logger.dart';
import 'package:privacyidea_authenticator/utils/riverpod_providers.dart';
import 'package:privacyidea_authenticator/utils/version.dart';
import 'package:privacyidea_authenticator/views/main_view/main_view.dart';
import 'package:privacyidea_authenticator/views/main_view/main_view_widgets/token_widgets/hotp_token_widgets/hotp_token_widget_tile.dart';
import 'package:privacyidea_authenticator/views/main_view/main_view_widgets/token_widgets/totp_token_widgets/totp_token_widget_tile.dart';
import 'package:privacyidea_authenticator/widgets/widget_keys.dart';

import '../test/tests_app_wrapper.dart';
import '../test/tests_app_wrapper.mocks.dart';

/*

// qr codes:
const String URI_TYPE = 'URI_TYPE';
const String URI_LABEL = 'URI_LABEL';
const String URI_ALGORITHM = 'URI_ALGORITHM';
const String URI_DIGITS = 'URI_DIGITS';
const String URI_SECRET = 'URI_SECRET';
const String URI_COUNTER = 'URI_COUNTER';
const String URI_PERIOD = 'URI_PERIOD';
const String URI_ISSUER = 'URI_ISSUER';
const String URI_PIN = 'URI_PIN';
const String URI_IMAGE = 'URI_IMAGE';

// 2 step:
const String URI_SALT_LENGTH = 'URI_SALT_LENGTH';
const String URI_OUTPUT_LENGTH_IN_BYTES = 'URI_OUTPUT_LENGTH_IN_BYTES';
const String URI_ITERATIONS = 'URI_ITERATIONS';

 */
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  late final MockSettingsRepository mockSettingsRepository;
  late final MockTokenRepository mockTokenRepository;
  late final MockTokenFolderRepository mockTokenFolderRepository;
  late final MockIntroductionRepository mockIntroductionRepository;
  setUp(() {
    mockSettingsRepository = MockSettingsRepository();
    when(mockSettingsRepository.loadSettings()).thenAnswer((_) async =>
        SettingsState(isFirstRun: false, useSystemLocale: false, localePreference: const Locale('en'), latestVersion: Version.parse('999.999.999')));
    when(mockSettingsRepository.saveSettings(any)).thenAnswer((_) async => true);
    mockTokenRepository = MockTokenRepository();
    when(mockTokenRepository.loadTokens()).thenAnswer((_) async => []);
    when(mockTokenRepository.saveOrReplaceTokens(any)).thenAnswer((_) async => []);
    when(mockTokenRepository.deleteTokens(any)).thenAnswer((_) async => []);
    mockTokenFolderRepository = MockTokenFolderRepository();
    when(mockTokenFolderRepository.loadFolders()).thenAnswer((_) async => []);
    when(mockTokenFolderRepository.saveOrReplaceFolders(any)).thenAnswer((_) async => []);
    mockIntroductionRepository = MockIntroductionRepository();
    final introductions = {...Introduction.values}..remove(Introduction.introductionScreen);
    when(mockIntroductionRepository.loadCompletedIntroductions()).thenAnswer((_) async => IntroductionState(completedIntroductions: introductions));
  });
  testWidgets(
    '2step rollout test',
    (tester) async {
      await tester.pumpWidget(TestsAppWrapper(
        overrides: [
          settingsProvider.overrideWith((ref) => SettingsNotifier(repository: mockSettingsRepository)),
          tokenProvider.overrideWith((ref) => TokenNotifier(repository: mockTokenRepository)),
          tokenFolderProvider.overrideWith((ref) => TokenFolderNotifier(repository: mockTokenFolderRepository)),
        ],
        child: PrivacyIDEAAuthenticator(customization: ApplicationCustomization.defaultCustomization),
      ));
      await _addTwoStepHotpTokenTest(tester);
      await _addTwoStepTotpTokenTest(tester);
    },
    timeout: const Timeout(Duration(minutes: 10)),
  );
}

Future<void> _addTwoStepHotpTokenTest(WidgetTester tester) async {
  await pumpUntilFindNWidgets(tester, find.byType(MainView), 1, const Duration(seconds: 10));
  globalRef!.read(tokenProvider.notifier).handleQrCode(
      'otpauth://hotp/OATH0001DBD0?secret=AALIBQJMOGEE7SAVEZ5D3K2ADO7MVFQD&counter=1&digits=6&issuer=privacyIDEA&2step_salt=8&2step_output=20&2step_difficulty=10000');
  Logger.info('Finding phone part dialog');
  await pumpUntilFindNWidgets(tester, find.text(AppLocalizationsEn().phonePart), 1, const Duration(seconds: 20));
  expect(find.text(AppLocalizationsEn().phonePart), findsOneWidget);
  final finder = find.byKey(twoStepDialogContent);
  expect(finder, findsOneWidget);
  final text = finder.evaluate().single.widget as Text;
  final phonePart = text.data;
  Logger.info('Checking phone part exists and has correct length');
  expect(phonePart, isNotNull);
  expect(phonePart, isNotEmpty);
  // step_output=20
  expect(phonePart!.replaceAll(' ', '').length, 20);
  expect(find.text(AppLocalizationsEn().dismiss), findsOneWidget);
  Logger.info('Dismissing dialog');
  await tester.tap(find.text(AppLocalizationsEn().dismiss));
  await pumpUntilFindNWidgets(tester, find.byType(HOTPTokenWidgetTile), 1, const Duration(seconds: 10));
}

Future<void> _addTwoStepTotpTokenTest(WidgetTester tester) async {
  await pumpUntilFindNWidgets(tester, find.byType(MainView), 1, const Duration(seconds: 10));
  globalRef!.read(tokenProvider.notifier).handleQrCode(
      'otpauth://totp/TOTP00009D5F?secret=NZ4OPONKAAGDFN2QHV26ZWYVTLFER4C6&period=30&digits=6&issuer=privacyIDEA&2step_salt=8&2step_output=20&2step_difficulty=10000');
  Logger.info('Finding phone part dialog');
  await pumpUntilFindNWidgets(tester, find.text(AppLocalizationsEn().phonePart), 1, const Duration(seconds: 20));
  expect(find.text(AppLocalizationsEn().phonePart), findsOneWidget);
  final finder = find.byKey(twoStepDialogContent);
  expect(finder, findsOneWidget);
  final text = finder.evaluate().single.widget as Text;
  final phonePart = text.data;
  Logger.info('Checking phone part exists and has correct length');
  expect(phonePart, isNotNull);
  expect(phonePart, isNotEmpty);
  // step_output=20
  expect(phonePart!.replaceAll(' ', '').length, 20);
  expect(find.text(AppLocalizationsEn().dismiss), findsOneWidget);
  Logger.info('Dismissing dialog');
  await tester.tap(find.text(AppLocalizationsEn().dismiss));
  await pumpUntilFindNWidgets(tester, find.byType(TOTPTokenWidgetTile), 1, const Duration(seconds: 10));
  //cannot "await tester.pumpAndSettle();" because of the infinite TOTP animation.
}
