import 'dart:ui';

import 'package:flutter/material.dart';

class DefaultDialog extends StatelessWidget {
  final bool? scrollable;
  final Widget? title;
  final List<Widget>? actions;
  final MainAxisAlignment? actionsAlignment;
  final Widget? content;
  final bool hasCloseButton;
  final double closeButtonSize = 22;

  const DefaultDialog({
    this.scrollable,
    this.title,
    this.actions,
    this.actionsAlignment,
    this.content,
    this.hasCloseButton = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Theme.of(context).dividerColor,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          actionsAlignment: actionsAlignment ?? MainAxisAlignment.end,
          scrollable: scrollable ?? false,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          actionsPadding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
          buttonPadding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
          insetPadding: const EdgeInsets.fromLTRB(16, 32, 16, 12),
          titlePadding: const EdgeInsets.all(12),
          contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          contentTextStyle: Theme.of(context).textTheme.bodyMedium,
          elevation: 2,
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: title ?? const SizedBox()),
              if (hasCloseButton)
                SizedBox(
                  width: closeButtonSize,
                  height: closeButtonSize,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(Icons.close, size: closeButtonSize),
                    splashRadius: closeButtonSize,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
            ],
          ),
          actions: actions,
          content: content,
        ),
      );
}
