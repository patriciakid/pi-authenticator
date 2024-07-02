/*
  privacyIDEA Authenticator

  Authors: Timo Sturm <timo.sturm@netknights.it>
           Frank Merkel <frank.merkel@netknights.it>

  Copyright (c) 2017-2023 NetKnights GmbH

  Licensed under the Apache License, Version 2.0 (the 'License');
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an 'AS IS' BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
*/

import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import '../model/enums/app_feature.dart';
import '../utils/globals.dart';
import '../utils/riverpod_providers.dart';
import '../views/add_token_manually_view/add_token_manually_view.dart';
import '../views/feedback_view/feedback_view.dart';
import '../views/import_tokens_view/import_tokens_view.dart';
import '../views/license_view/license_view.dart';
import '../views/main_view/main_view.dart';
import '../views/push_token_view/push_tokens_view.dart';
import '../views/qr_scanner_view/qr_scanner_view.dart';
import '../views/settings_view/settings_view.dart';
import '../views/splash_screen/splash_screen.dart';
import '../widgets/app_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AppWrapper(child: CustomizationAuthenticator()));
}

class CustomizationAuthenticator extends ConsumerWidget {
  const CustomizationAuthenticator({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsFlutterBinding.ensureInitialized();
    final locale = ref.watch(settingsProvider).currentLocale;
    final applicationCustomizer = ref.watch(applicationCustomizerProvider);
    return LayoutBuilder(
      builder: (context, constraints) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          ref.read(appConstraintsProvider.notifier).state = constraints;
        });
        return MaterialApp(
          scrollBehavior: ScrollConfiguration.of(context).copyWith(
            physics: const ClampingScrollPhysics(),
            overscroll: false,
            dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch, PointerDeviceKind.stylus, PointerDeviceKind.unknown},
          ),
          debugShowCheckedModeBanner: true,
          navigatorKey: globalNavigatorKey,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: locale,
          title: applicationCustomizer.appName,
          theme: applicationCustomizer.generateLightTheme(),
          darkTheme: applicationCustomizer.generateDarkTheme(),
          scaffoldMessengerKey: globalSnackbarKey,
          themeMode: EasyDynamicTheme.of(context).themeMode,
          initialRoute: SplashScreen.routeName,
          routes: {
            AddTokenManuallyView.routeName: (context) => const AddTokenManuallyView(),
            FeedbackView.routeName: (context) => const FeedbackView(),
            ImportTokensView.routeName: (context) => const ImportTokensView(),
            LicenseView.routeName: (context) => LicenseView(
                  appImage: applicationCustomizer.appImage,
                  appName: applicationCustomizer.appName,
                  websiteLink: applicationCustomizer.websiteLink,
                ),
            MainView.routeName: (context) => MainView(
                  appIcon: applicationCustomizer.appIcon,
                  appName: applicationCustomizer.appName,
                  disablePatchNotes: applicationCustomizer.disabledFeatures.contains(AppFeature.patchNotes),
                ),
            PushTokensView.routeName: (context) => const PushTokensView(),
            SettingsView.routeName: (context) => const SettingsView(),
            SplashScreen.routeName: (context) => SplashScreen(customization: applicationCustomizer),
            QRScannerView.routeName: (context) => const QRScannerView(),
          },
        );
      },
    );
  }
}
