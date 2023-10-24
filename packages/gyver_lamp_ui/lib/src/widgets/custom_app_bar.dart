import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';

/// The preferred size of the custom app bar.
const kCustomAppBarSize = Size.fromHeight(GyverLampSpacings.xxxlg);

/// {@template custom_app_bar}
/// Gyver Lamp Custom App Bar.
/// {@endtemplate}
class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  /// {@macro custom_app_bar}
  const CustomAppBar({
    this.leading,
    this.title,
    this.actions,
    this.padding = const EdgeInsets.symmetric(
      horizontal: GyverLampSpacings.xs,
    ),
    super.key,
  });

  /// The widget to show before title.
  final Widget? leading;

  /// The text of the title in the center of the app bar.
  final String? title;

  /// The list of widgets to show after the title.
  final List<Widget>? actions;

  /// The padding around app bar components.
  final EdgeInsets padding;

  @override
  Size get preferredSize => kCustomAppBarSize;

  @override
  State<CustomAppBar> createState() => CustomAppBarState();
}

/// Gyver Lamp Custom App Bar state.
class CustomAppBarState extends State<CustomAppBar> {
  /// Whether the list content is scrolled under the app bar.
  bool isScrolledUnder = false;

  ScrollNotificationObserverState? _scrollNotificationObserver;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _scrollNotificationObserver?.removeListener(_handleScrollNotification);
    _scrollNotificationObserver = ScrollNotificationObserver.maybeOf(context);
    _scrollNotificationObserver?.addListener(_handleScrollNotification);
  }

  @override
  void dispose() {
    if (_scrollNotificationObserver != null) {
      _scrollNotificationObserver!.removeListener(_handleScrollNotification);
      _scrollNotificationObserver = null;
    }

    super.dispose();
  }

  void _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification && notification.depth == 0) {
      final oldIsScrolledUnder = isScrolledUnder;
      final metrics = notification.metrics;

      switch (metrics.axisDirection) {
        case AxisDirection.up:
          // Scroll view is reversed
          isScrolledUnder = metrics.extentAfter > 0;

        case AxisDirection.down:
          isScrolledUnder = metrics.extentBefore > 0;

        case AxisDirection.right:
        case AxisDirection.left:
        // Scrolled under is only supported in the vertical axis, and should
        // not be altered based on horizontal notifications of the same
        // predicate since it could be a 2D scroller.
      }

      if (isScrolledUnder != oldIsScrolledUnder) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GyverLampAppTheme>()!;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.background,
        boxShadow: isScrolledUnder ? [theme.shadows.shadow1] : null,
      ),
      child: SafeArea(
        bottom: false,
        child: ConstrainedBox(
          constraints: BoxConstraints.tightFor(
            height: widget.preferredSize.height,
          ),
          child: Padding(
            padding: widget.padding,
            child: CustomMultiChildLayout(
              delegate: _CustomAppBarLayout(),
              children: <Widget>[
                if (widget.leading != null)
                  LayoutId(
                    id: _CustomAppBarSlot.leading,
                    child: widget.leading!,
                  ),
                if (widget.title != null)
                  LayoutId(
                    id: _CustomAppBarSlot.title,
                    child: Text(
                      widget.title!,
                      style: GyverLampTextStyles.subtitle1.copyWith(
                        color: theme.textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                if (widget.actions != null)
                  LayoutId(
                    id: _CustomAppBarSlot.actions,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: widget.actions!
                          .intersperse(GyverLampGaps.xs)
                          .toList(),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum _CustomAppBarSlot {
  leading,
  title,
  actions,
}

/// Layout delegate that positions 3 widgets along a horizontal axis in order to
/// keep the title widget centered and leading and actions in the left and
/// right side of the screen respectively.
class _CustomAppBarLayout extends MultiChildLayoutDelegate {
  /// The default spacing around the middle widget.
  static const kTitleSpacing = GyverLampSpacings.sm;

  @override
  void performLayout(Size size) {
    var leadingWidth = 0.0;
    var actionsWidth = 0.0;

    if (hasChild(_CustomAppBarSlot.leading)) {
      final constraints = BoxConstraints.loose(size);
      final leadingSize = layoutChild(_CustomAppBarSlot.leading, constraints);

      const leadingX = 0.0;
      final leadingY = (size.height - leadingSize.height) / 2;

      leadingWidth = leadingSize.width;

      positionChild(
        _CustomAppBarSlot.leading,
        Offset(leadingX, leadingY),
      );
    }

    if (hasChild(_CustomAppBarSlot.actions)) {
      final constraints = BoxConstraints.loose(size);
      final actionsSize = layoutChild(_CustomAppBarSlot.actions, constraints);

      final actionsX = size.width - actionsSize.width;
      final actionsY = (size.height - actionsSize.height) / 2;

      actionsWidth = actionsSize.width;

      positionChild(
        _CustomAppBarSlot.actions,
        Offset(actionsX, actionsY),
      );
    }

    if (hasChild(_CustomAppBarSlot.title)) {
      final side = math.max(leadingWidth, actionsWidth);
      final maxWidth = math.max<double>(
        size.width - side * 2 - kTitleSpacing * 2.0,
        0,
      );

      final constraints = BoxConstraints.loose(size).copyWith(
        maxWidth: maxWidth,
      );
      final titleSize = layoutChild(_CustomAppBarSlot.title, constraints);

      final titleX = (size.width - titleSize.width) / 2.0;
      final titleY = (size.height - titleSize.height) / 2;

      positionChild(
        _CustomAppBarSlot.title,
        Offset(titleX, titleY),
      );
    }
  }

  @override
  bool shouldRelayout(_CustomAppBarLayout oldDelegate) {
    return false;
  }
}
