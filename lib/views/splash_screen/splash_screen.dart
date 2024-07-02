import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/enums/app_feature.dart';
import '../../utils/app_info_utils.dart';
import '../../utils/customization/application_customization.dart';
import '../../utils/home_widget_utils.dart';
import '../../utils/logger.dart';
import '../../utils/riverpod_providers.dart';
import '../main_view/main_view.dart';
import '../view_interface.dart';

class SplashScreen extends ConsumerStatefulWidget {
  static const routeName = '/';
  final ApplicationCustomization customization;
  const SplashScreen({required this.customization, super.key});
  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  var _appIconIsVisible = false;
  final _splashScreenDuration = const Duration(milliseconds: 400);
  final _splashScreenDelay = const Duration(milliseconds: 250);
  late final ApplicationCustomization _customization;

  @override
  void initState() {
    super.initState();
    _customization = widget.customization;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_customization.disabledFeatures.contains(AppFeature.introductions)) {
        ref.read(introductionProvider.notifier).completeAll();
      }
    });

    Logger.info('Starting app.', name: 'main.dart#initState');
    Future.delayed(_splashScreenDelay, () {
      if (mounted) setState(() => _appIconIsVisible = true);

      Future.wait(
        <Future>[
          Future.delayed(_splashScreenDuration),
          ref.read(settingsProvider.notifier).loadingRepo,
          ref.read(tokenProvider.notifier).initState,
          ref.read(introductionProvider.notifier).loadingRepo,
          AppInfoUtils.init(),
          HomeWidgetUtils().homeWidgetInit(),
        ],
        eagerError: true,
        cleanUp: (_) {
          _navigate();
        },
      ).catchError((error) async {
        Logger.error('Error while loading the app.', error: error, stackTrace: StackTrace.current, name: 'main.dart#initState');
        return [];
      }).then((values) async {
        if (!mounted) return;
        return _navigate();
      });
    });
  }

  @override
  void dispose() {
    Logger.info('Disposing Splash Screen', name: 'main.dart#dispose');
    super.dispose();
  }

  void _navigate() async {
    if (_customization.disabledFeatures.isNotEmpty) {
      Logger.info('Disabled features: ${_customization.disabledFeatures}', name: 'main.dart#_pushReplace');
    }
    final ViewWidget nextView = MainView(
      appName: _customization.appName,
      appIcon: _customization.appIcon,
      disablePatchNotes: _customization.disabledFeatures.contains(AppFeature.patchNotes),
    );
    final routeBuilder = PageRouteBuilder(pageBuilder: (_, __, ___) => nextView);
    // Idle until the splash screen is the top route.
    // By default it is the top route, but it can be overridden by pushing a new route before initializing the app, e.g. by a deep link.
    await Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 100));
      if (!mounted) return false;
      return (ModalRoute.of(context)?.isCurrent == false);
    });
    if (!mounted) return;
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.pushReplacement(context, routeBuilder);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: AnimatedOpacity(
          opacity: _appIconIsVisible ? 1.0 : 0.0,
          duration: _splashScreenDuration,
          curve: Curves.easeOut,
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: _customization.appImage,
          ),
        ),
      ),
    );
  }
}
