import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../model/enums/introduction_enum.dart';
import '../../../../utils/riverpod_providers.dart';
import '../../../../widgets/focused_item_as_overlay.dart';
import '../../../license_view/license_view.dart';
import '../../../push_token_view/push_tokens_view.dart';
import '../app_bar_item.dart';

class LicensePushViewButton extends ConsumerWidget {
  const LicensePushViewButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => ref.watch(settingsProvider).hidePushTokens
      ? FocusedItemAsOverlay(
          isFocused: ref.watch(introductionProvider).isHidePushTokenConditionFulfilled(hidePushTokens: ref.watch(settingsProvider).hidePushTokens),
          tooltipWhenFocused: 'Push Tokens',
          onTap: () => ref.read(introductionProvider.notifier).complete(Introduction.hidePushTokens),
          child: AppBarItem(
            onPressed: () => Navigator.pushNamed(context, PushTokensView.routeName),
            icon: const Icon(Icons.notifications),
          ),
        )
      : AppBarItem(
          onPressed: () => Navigator.of(context).pushNamed(LicenseView.routeName),
          icon: const Icon(Icons.info_outline),
        );
}
