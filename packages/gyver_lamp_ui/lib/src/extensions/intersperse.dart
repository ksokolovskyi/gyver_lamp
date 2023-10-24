import 'package:flutter/material.dart';

/// Extension on [Iterable] of widgets to insert `element` between each pair.
extension ChildrenIntersperse on Iterable<Widget> {
  /// Inserts `element` between each pair of [Iterable] elements.
  Iterable<Widget> intersperse(Widget element) sync* {
    final iterator = this.iterator;
    if (iterator.moveNext()) {
      yield iterator.current;
      while (iterator.moveNext()) {
        yield element;
        yield iterator.current;
      }
    }
  }
}
