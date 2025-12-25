import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide DropdownButton, DropdownMenuItem;
import 'package:gyver_lamp_icons/gyver_lamp_icons.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';

// The minimal height of menu item.
const _kMenuItemHeight = 48.0;

// The height of divider between menu items.
const _kMenuDividerHeight = 2.0;

// The max height of the menu item including divider.
const _kMaxMenuItemHeight = _kMenuItemHeight + _kMenuDividerHeight;

// The size of the icons.
const _kIconSize = 24.0;

// The default corner radius of dropdown elements.
const _kBorderRadius = BorderRadius.all(Radius.circular(8));

// The distance from bottom of the button to the menu.
const _kDropdownOffset = GyverLampSpacings.xs;

// The space around menu.
const _kDropdownPadding = GyverLampSpacings.sm;

/// {@template custom_dropdown_menu_item}
/// An item in a menu created by [CustomDropdownButton].
/// {@endtemplate}
class CustomDropdownMenuItem<T extends Object> {
  /// {@macro custom_dropdown_menu_item}
  const CustomDropdownMenuItem({
    required this.value,
    required this.label,
  });

  /// The value of this item.
  final T value;

  /// The string representation of the value.
  final String label;
}

/// {@template custom_dropdown_button}
/// Gyver Lamp Custom Dropdown Button.
/// {@endtemplate}
class CustomDropdownButton<T extends Object> extends StatefulWidget {
  /// {@macro custom_dropdown_button}
  CustomDropdownButton({
    required this.items,
    required this.selected,
    required this.onChanged,
    this.menuMaxHeight,
    super.key,
  }) : assert(
         items.isEmpty || items.where((i) => i.value == selected).length == 1,
         'There should be exactly one item with value: $selected.\n'
         'Either zero or 2 or more [DropdownMenuItem]s were detected '
         'with the same value.',
       );

  /// The list of items the user can select.
  final List<CustomDropdownMenuItem<T>> items;

  /// The selected item.
  final T selected;

  /// Called when the user selects an item.
  final ValueChanged<T> onChanged;

  /// The maximum height of the menu.
  final double? menuMaxHeight;

  @override
  State<CustomDropdownButton<T>> createState() =>
      _CustomDropdownButtonState<T>();
}

class _CustomDropdownButtonState<T extends Object>
    extends State<CustomDropdownButton<T>>
    with WidgetsBindingObserver {
  final ValueNotifier<bool> _isOpen = ValueNotifier<bool>(false);

  late int _selectedIndex;

  _CustomDropdownRoute<T>? _dropdownRoute;

  Orientation? _lastOrientation;

  @override
  void initState() {
    super.initState();
    _updateSelectedIndex();
  }

  @override
  void didUpdateWidget(CustomDropdownButton<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateSelectedIndex();
  }

  @override
  void dispose() {
    _removeDropdownRoute();

    WidgetsBinding.instance.removeObserver(this);

    _isOpen.dispose();

    super.dispose();
  }

  void _updateSelectedIndex() {
    // coverage:ignore-start
    assert(
      widget.items.where((item) => item.value == widget.selected).length == 1,
      'There should be exactly one item with value: ${widget.selected}.',
    );
    // coverage:ignore-end

    for (var itemIndex = 0; itemIndex < widget.items.length; itemIndex++) {
      if (widget.items[itemIndex].value == widget.selected) {
        _selectedIndex = itemIndex;
        return;
      }
    }
  }

  void _removeDropdownRoute() {
    _dropdownRoute?._dismiss();
    _dropdownRoute = null;
    _lastOrientation = null;
  }

  void _onTap() {
    final navigator = Navigator.of(context);

    assert(
      _dropdownRoute == null,
      'Dropdown menu is already shown. Close it before showing another one.',
    );

    final buttonBox = context.findRenderObject()! as RenderBox;
    final navigatorBox = navigator.context.findRenderObject()! as RenderBox;

    final localOffset = navigatorBox.globalToLocal(
      buttonBox.localToGlobal(Offset.zero),
    );
    final buttonLocalRect = localOffset & buttonBox.size;

    _dropdownRoute = _CustomDropdownRoute<T>(
      items: widget.items,
      buttonRect: buttonLocalRect,
      selectedIndex: _selectedIndex,
      capturedThemes: InheritedTheme.capture(
        from: context,
        to: navigator.context,
      ),
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      menuMaxHeight: widget.menuMaxHeight,
    );

    _isOpen.value = true;

    navigator.push(_dropdownRoute!).then<void>(
      (T? result) {
        _isOpen.value = false;

        _removeDropdownRoute();

        if (!mounted || result == null || result == widget.selected) {
          return;
        }

        widget.onChanged.call(result);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    assert(
      debugCheckHasMaterialLocalizations(context),
      'No MaterialLocalizations found.',
    );

    final newOrientation = MediaQuery.orientationOf(context);
    _lastOrientation ??= newOrientation;

    if (newOrientation != _lastOrientation) {
      _removeDropdownRoute();
      _lastOrientation = newOrientation;
    }

    final theme = Theme.of(context).extension<GyverLampAppTheme>()!;

    return Semantics(
      button: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.surfacePrimary,
          boxShadow: [theme.shadows.shadow1],
          borderRadius: _kBorderRadius,
          border: Border.all(color: theme.borderPrimary),
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            splashFactory: InkRipple.splashFactory,
            mouseCursor: MaterialStateMouseCursor.clickable,
            borderRadius: _kBorderRadius,
            onTap: _onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: GyverLampSpacings.md,
                horizontal: GyverLampSpacings.lg,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      switchInCurve: Curves.easeInOut,
                      switchOutCurve: Curves.easeInOut,
                      transitionBuilder: (child, animation) {
                        final isNewStatus =
                            child.key == ValueKey(widget.selected);

                        final yOffset = isNewStatus ? 0.5 : -0.5;

                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: Offset(0, yOffset),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          ),
                        );
                      },
                      layoutBuilder:
                          (
                            Widget? currentChild,
                            List<Widget> previousChildren,
                          ) {
                            final Widget? previousChild;

                            if (previousChildren.isEmpty) {
                              previousChild = null;
                            } else {
                              previousChild = previousChildren.first;
                            }

                            return Stack(
                              clipBehavior: Clip.antiAlias,
                              alignment: AlignmentDirectional.centerStart,
                              children: <Widget>[
                                if (previousChild != null) previousChild,
                                if (currentChild != null) currentChild,
                              ],
                            );
                          },
                      child: Text(
                        widget.items[_selectedIndex].label,
                        key: ValueKey(widget.selected),
                        style: GyverLampTextStyles.subtitle1.copyWith(
                          color: theme.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const SizedBox(width: GyverLampSpacings.lg),
                  ValueListenableBuilder(
                    valueListenable: _isOpen,
                    builder: (context, isOpen, _) {
                      return Icon(
                        key: ValueKey(isOpen),
                        isOpen
                            ? GyverLampIcons.chevron_up
                            : GyverLampIcons.chevron_down,
                        color: theme.textSecondary,
                        size: _kIconSize,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuLimits {
  const _MenuLimits(
    this.top,
    this.bottom,
    this.height,
    this.scrollOffset,
  );

  final double top;

  final double bottom;

  final double height;

  final double scrollOffset;
}

class _CustomDropdownRoute<T extends Object> extends PopupRoute<T> {
  _CustomDropdownRoute({
    required this.items,
    required this.buttonRect,
    required this.selectedIndex,
    required this.capturedThemes,
    this.barrierLabel,
    this.menuMaxHeight,
  });

  final List<CustomDropdownMenuItem<T>> items;

  final int selectedIndex;

  final Rect buttonRect;

  final CapturedThemes capturedThemes;

  final double? menuMaxHeight;

  ScrollController? scrollController;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  bool get barrierDismissible => true;

  @override
  Color? get barrierColor => null;

  @override
  final String? barrierLabel;

  @override
  void dispose() {
    scrollController?.dispose();
    scrollController = null;
    super.dispose();
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return LayoutBuilder(
      builder:
          (
            BuildContext context,
            BoxConstraints constraints,
          ) {
            if (scrollController == null) {
              final menuLimits = getMenuLimits(
                constraints.maxHeight,
                selectedIndex,
              );

              scrollController = ScrollController(
                initialScrollOffset: menuLimits.scrollOffset,
              );
            }

            return _CustomDropdownRoutePage<T>(
              route: this,
              menuConstraints: constraints,
              selectedIndex: selectedIndex,
              capturedThemes: capturedThemes,
            );
          },
    );
  }

  void _dismiss() {
    if (isActive) {
      navigator?.removeRoute(this);
    }
  }

  double getItemOffset(int index) {
    return index * _kMenuItemHeight;
  }

  double getMenuMaxHeight(double viewHeight) {
    // The maximum height of a simple menu should be one row less than the view
    // height under the button. This ensures a tappable area outside of the
    // menu with which to dismiss the menu.
    return math.max(
      0,
      viewHeight - buttonRect.bottom - _kDropdownOffset - _kMenuItemHeight,
    );
  }

  double getMenuWidth(double maxWidth) {
    return math.min(maxWidth, buttonRect.width);
  }

  // Returns the vertical extent of the menu and the initial scrollOffset
  // for the ListView that contains the menu items.
  _MenuLimits getMenuLimits(
    double availableHeight,
    int index,
  ) {
    final top = buttonRect.bottom + _kDropdownOffset;
    final height = availableHeight - _kDropdownOffset;
    final bottom = top + height;

    var computedMaxHeight = getMenuMaxHeight(availableHeight);

    if (menuMaxHeight != null) {
      computedMaxHeight = math.min(computedMaxHeight, menuMaxHeight!);
    }

    final preferredMenuHeight =
        _kDropdownPadding * 2 + items.length * _kMaxMenuItemHeight;

    final menuHeight = math.min(computedMaxHeight, preferredMenuHeight);

    final selectedItemOffset = getItemOffset(index);

    var scrollOffset = 0.0;

    // If all of the menu items will not fit within availableHeight then
    // compute the scroll offset that will position the selected menu item in
    // the center of the menu.
    if (preferredMenuHeight > computedMaxHeight) {
      // The offset should be zero if the selected item is in view at the
      // beginning of the menu. Otherwise, the scroll offset should center the
      // item if possible.
      scrollOffset = math.max(
        0,
        selectedItemOffset - menuHeight / 2 + _kMenuItemHeight,
      );

      // If the selected item's scroll offset is greater than the maximum scroll
      // offset, set it instead to the maximum allowed scroll offset.
      scrollOffset = math.min(
        scrollOffset,
        preferredMenuHeight - menuHeight,
      );
    }

    return _MenuLimits(
      top,
      bottom,
      menuHeight,
      scrollOffset,
    );
  }
}

class _CustomDropdownRoutePage<T extends Object> extends StatelessWidget {
  const _CustomDropdownRoutePage({
    required this.route,
    required this.menuConstraints,
    required this.selectedIndex,
    required this.capturedThemes,
    super.key,
  });

  final _CustomDropdownRoute<T> route;

  final BoxConstraints menuConstraints;

  final int selectedIndex;

  final CapturedThemes capturedThemes;

  @override
  Widget build(BuildContext context) {
    assert(
      debugCheckHasDirectionality(context),
      'No Directionality widget found.',
    );

    final textDirection = Directionality.of(context);

    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      removeLeft: true,
      removeRight: true,
      child: CustomSingleChildLayout(
        delegate: _DropdownMenuRouteLayout<T>(
          route: route,
          textDirection: textDirection,
        ),
        child: capturedThemes.wrap(
          CustomDropdownMenu<T>(
            route: route,
            menuConstraints: menuConstraints,
          ),
        ),
      ),
    );
  }
}

class _DropdownMenuRouteLayout<T extends Object>
    extends SingleChildLayoutDelegate {
  _DropdownMenuRouteLayout({
    required this.route,
    required this.textDirection,
  });

  final _CustomDropdownRoute<T> route;

  final TextDirection textDirection;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    final menuLimits = route.getMenuLimits(
      constraints.maxHeight,
      route.selectedIndex,
    );

    var maxHeight = menuLimits.height;

    if (route.menuMaxHeight != null && route.menuMaxHeight! <= maxHeight) {
      maxHeight = route.menuMaxHeight!;
    }

    // The width of a menu should be at most the view width. This ensures that
    // the menu does not extend past the left and right edges of the screen.
    final width = route.getMenuWidth(constraints.maxWidth);

    return BoxConstraints(
      minWidth: width,
      maxWidth: width,
      maxHeight: maxHeight,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final buttonRect = route.buttonRect;

    final menuLimits = route.getMenuLimits(
      size.height,
      route.selectedIndex,
    );

    final double left;

    switch (textDirection) {
      case TextDirection.rtl:
        left = clampDouble(buttonRect.right, 0, size.width) - childSize.width;

      case TextDirection.ltr:
        left = clampDouble(buttonRect.left, 0, size.width - childSize.width);
    }

    return Offset(left, menuLimits.top);
  }

  @override
  bool shouldRelayout(_DropdownMenuRouteLayout<T> oldDelegate) {
    return route.buttonRect != oldDelegate.route.buttonRect ||
        textDirection != oldDelegate.textDirection;
  }
}

/// {@template custom_dropdown_menu}
/// Gyver Lamp Custom Dropdown Menu.
/// {@endtemplate}
@visibleForTesting
class CustomDropdownMenu<T extends Object> extends StatefulWidget {
  /// {@macro custom_dropdown_menu}
  const CustomDropdownMenu({
    // ignore: library_private_types_in_public_api
    required this.route,
    required this.menuConstraints,
    super.key,
  });

  /// The route in which this menu is shown.
  // ignore: library_private_types_in_public_api
  final _CustomDropdownRoute<T> route;

  /// The constraints for the menu.
  final BoxConstraints menuConstraints;

  @override
  // ignore: library_private_types_in_public_api
  _CustomDropdownMenuState<T> createState() => _CustomDropdownMenuState<T>();
}

class _CustomDropdownMenuState<T extends Object>
    extends State<CustomDropdownMenu<T>> {
  late CurvedAnimation _fadeOpacity;

  late CurvedAnimation _resize;

  @override
  void initState() {
    super.initState();

    // The menu is shown in three stages:
    // [0 - 0.25] - Fade in menu items.
    // [0.25 - 0.5] - Grow the menu from the top until it is big enough for as
    // many items as we are going to show.
    //
    // When the menu is dismissed we just fade the entire thing out
    // in the first 0.25.

    _fadeOpacity = CurvedAnimation(
      parent: widget.route.animation!,
      curve: const Interval(0, 0.25, curve: Curves.easeIn),
      reverseCurve: const Interval(0.75, 1, curve: Curves.easeOut),
    );

    _resize = CurvedAnimation(
      parent: widget.route.animation!,
      curve: const Interval(0, 0.5, curve: Curves.easeInOut),
      reverseCurve: const Threshold(0),
    );
  }

  @override
  void dispose() {
    _fadeOpacity.dispose();
    _resize.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    assert(
      debugCheckHasMaterialLocalizations(context),
      'No MaterialLocalizations found.',
    );

    final theme = Theme.of(context).extension<GyverLampAppTheme>()!;

    final route = widget.route;

    return RepaintBoundary(
      child: FadeTransition(
        opacity: _fadeOpacity,
        child: Semantics(
          scopesRoute: true,
          namesRoute: true,
          explicitChildNodes: true,
          label: MaterialLocalizations.of(context).popupMenuLabel,
          child: CustomPaint(
            painter: _CustomDropdownMenuBackgroundPainter(
              color: theme.surfacePrimary,
              shadow: theme.shadows.shadow1,
              resize: _resize,
            ),
            child: ClipRect(
              clipper: _CustomDropdownMenuClipper(resize: _resize),
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(
                  scrollbars: false,
                  overscroll: false,
                  physics: const ClampingScrollPhysics(),
                  platform: Theme.of(context).platform,
                ),
                child: PrimaryScrollController(
                  controller: widget.route.scrollController!,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: _kDropdownPadding,
                    ),
                    child: Scrollbar(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: _kDropdownPadding,
                        ),
                        child: ListView.builder(
                          primary: true,
                          padding: EdgeInsets.zero,
                          itemExtent: _kMaxMenuItemHeight,
                          itemCount: route.items.length,
                          itemBuilder: (context, index) {
                            return _CustomDropdownMenuItemButton<T>(
                              item: route.items[index],
                              itemIndex: index,
                              route: route,
                              menuConstraints: widget.menuConstraints,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CustomDropdownMenuBackgroundPainter extends CustomPainter {
  _CustomDropdownMenuBackgroundPainter({
    required this.color,
    required this.shadow,
    required this.resize,
  }) : _painter = BoxDecoration(
         color: color,
         borderRadius: _kBorderRadius,
         boxShadow: [shadow],
       ).createBoxPainter(),
       super(repaint: resize);

  final Color color;

  final BoxShadow shadow;

  final Animation<double> resize;

  final BoxPainter _painter;

  @override
  void paint(Canvas canvas, Size size) {
    final bottom = Tween<double>(
      begin: _kMaxMenuItemHeight,
      end: size.height,
    );

    final rect = Rect.fromLTRB(
      0,
      0,
      size.width,
      bottom.evaluate(resize),
    );

    _painter.paint(
      canvas,
      rect.topLeft,
      ImageConfiguration(size: rect.size),
    );
  }

  @override
  bool shouldRepaint(_CustomDropdownMenuBackgroundPainter oldPainter) {
    return oldPainter.color != color ||
        oldPainter.shadow != shadow ||
        oldPainter.resize != resize;
  }
}

class _CustomDropdownMenuClipper extends CustomClipper<Rect> {
  _CustomDropdownMenuClipper({
    required this.resize,
  }) : super(reclip: resize);

  final Animation<double> resize;

  @override
  Rect getClip(Size size) {
    final bottom = Tween<double>(
      begin: _kMaxMenuItemHeight,
      end: size.height,
    );

    return Rect.fromLTRB(
      0,
      0,
      size.width,
      bottom.evaluate(resize),
    );
  }

  @override
  bool shouldReclip(_CustomDropdownMenuClipper oldClipper) {
    return oldClipper.resize != resize;
  }
}

class _CustomDropdownMenuItemButton<T extends Object> extends StatefulWidget {
  const _CustomDropdownMenuItemButton({
    required this.item,
    required this.route,
    required this.menuConstraints,
    required this.itemIndex,
    super.key,
  });

  final CustomDropdownMenuItem<T> item;

  final _CustomDropdownRoute<T> route;

  final BoxConstraints menuConstraints;

  final int itemIndex;

  @override
  _CustomDropdownMenuItemButtonState<T> createState() =>
      _CustomDropdownMenuItemButtonState<T>();
}

class _CustomDropdownMenuItemButtonState<T extends Object>
    extends State<_CustomDropdownMenuItemButton<T>> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GyverLampAppTheme>()!;

    final itemIndex = widget.itemIndex;
    final selectedIndex = widget.route.selectedIndex;

    final selected = selectedIndex == itemIndex;
    final showDivider =
        itemIndex != 0 && !selected && itemIndex - 1 != selectedIndex;

    final style = selected
        ? GyverLampTextStyles.subtitle2.copyWith(
            color: theme.textPrimary,
          )
        : GyverLampTextStyles.subtitle2.copyWith(
            color: theme.textSecondary,
          );

    return RepaintBoundary(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (showDivider)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: GyverLampSpacings.sm),
              child: Divider(
                height: _kMenuDividerHeight,
                thickness: _kMenuDividerHeight,
              ),
            ),
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: _kMenuItemHeight),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: selected ? theme.surfaceSecondary : theme.surfacePrimary,
                borderRadius: _kBorderRadius,
              ),
              child: Material(
                type: MaterialType.transparency,
                child: InkWell(
                  splashFactory: InkRipple.splashFactory,
                  borderRadius: _kBorderRadius,
                  onTap: () {
                    Navigator.of(context).pop(widget.item.value);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: GyverLampSpacings.md,
                      bottom: GyverLampSpacings.md,
                      left: GyverLampSpacings.sm,
                      right: GyverLampSpacings.lg,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.item.label,
                            style: style,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (selected) ...[
                          GyverLampGaps.sm,
                          Icon(
                            GyverLampIcons.done,
                            color: theme.textPrimary,
                            size: _kIconSize,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
