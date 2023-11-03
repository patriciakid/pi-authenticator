import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'tooltip_box.dart';

import '../utils/text_size.dart';

class FocusedItem extends StatelessWidget {
  final bool isFocused;
  final Widget child;
  final String? tooltipWhenFocused;

  final void Function() onTap;

  const FocusedItem({
    super.key,
    required this.isFocused,
    required this.child,
    this.tooltipWhenFocused,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) => isFocused
      ? _FocusedItemBackdrop(
          onTap: onTap,
          tooltipWhenFocused: tooltipWhenFocused,
          child: child,
        )
      : child;
}

class _FocusedItemBackdrop extends StatefulWidget {
  final Widget child;
  final String? tooltipWhenFocused;
  final void Function()? onTap;
  const _FocusedItemBackdrop({required this.child, super.key, this.tooltipWhenFocused, this.onTap});

  @override
  State<_FocusedItemBackdrop> createState() => _FocusedItemBackdropState();
}

class _FocusedItemBackdropState extends State<_FocusedItemBackdrop> {
  static const tooltipPadding = EdgeInsets.all(8);
  static const tooltipMargin = EdgeInsets.all(4);
  static const tooltipBorder = 2.0;

  OverlayEntry? _overlayEntry;

  @override
  Widget build(BuildContext context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        child: widget.child,
      );

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _showOverlay();
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    log('didChangeDependencies');
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant _FocusedItemBackdrop oldWidget) {
    log('didUpdateWidget');
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _updateOverlay();
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _disposeOverlay();
    });
    super.dispose();
  }

  void _showOverlay() {
    if (widget.tooltipWhenFocused != null) {
      final textSize = textSizeOf(widget.tooltipWhenFocused!, Theme.of(context).textTheme.bodyLarge!);

      final overlaySize = Size(
        textSize.width + tooltipPadding.left + tooltipPadding.right + tooltipMargin.left + tooltipMargin.right + tooltipBorder * 2,
        textSize.height + tooltipPadding.bottom + tooltipPadding.top + tooltipMargin.bottom + tooltipMargin.top + tooltipBorder * 2,
      );
      final clampedOffset = getClampedOffset(overlaySize: overlaySize, context: context);
      _overlayEntry = OverlayEntry(
        builder: (overlayContext) => Positioned(
          left: clampedOffset.dx,
          top: clampedOffset.dy,
          width: overlaySize.width,
          height: overlaySize.height,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: TooltipBox(
              widget.tooltipWhenFocused!,
              padding: tooltipPadding,
              margin: tooltipMargin,
              border: tooltipBorder,
              textStyle: Theme.of(context).textTheme.bodyLarge!,
            ),
          ),
        ),
      );
    } else {
      _overlayEntry = OverlayEntry(
        builder: (overlayContext) => const SizedBox(),
      );
    }

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _updateOverlay() {
    _overlayEntry?.remove();
    _showOverlay();
  }

  void _disposeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}

Size getTextSize(BuildContext context, {required String tooltip}) {
  return textSizeOf(tooltip, Theme.of(context).textTheme.bodyLarge!);
}

Offset getClampedOffset({required Size overlaySize, required BuildContext context}) {
  final screenSize = MediaQuery.of(context).size;
  final renderBox = context.findRenderObject() as RenderBox;
  final offset = renderBox.localToGlobal(Offset.zero);
  final preferredOffset = Offset(
    offset.dx + renderBox.size.width / 2 - overlaySize.width / 2,
    offset.dy - renderBox.size.height / 2 - overlaySize.height - 12,
  );
  const minOffset = Offset(0, 0);
  final maxOffset = Offset(
    screenSize.width - overlaySize.width,
    screenSize.height - overlaySize.height,
  );
  return Offset(
    preferredOffset.dx.clamp(minOffset.dx, maxOffset.dx),
    preferredOffset.dy.clamp(minOffset.dy, maxOffset.dy),
  );
}
