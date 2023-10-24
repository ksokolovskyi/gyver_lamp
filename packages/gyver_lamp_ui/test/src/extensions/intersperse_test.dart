import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';

void main() {
  group('ChildrenIntersperse', () {
    test(
      'inserts element between list of widgets',
      () {
        const a = SizedBox(width: 1);
        const b = SizedBox(width: 2);
        const c = SizedBox(width: 3);
        const d = SizedBox(width: 4);

        final original = <Widget>[a, b, c];

        final interspersed = original.intersperse(d);
        final expected = [a, d, b, d, c];

        expect(interspersed.length, equals(expected.length));
        expect(interspersed, containsAllInOrder(expected));
      },
    );

    test(
      'inserts nothing if array is empty',
      () {
        final original = <Widget>[];

        final interspersed = original.intersperse(const SizedBox(width: 1));

        expect(interspersed, isEmpty);
      },
    );

    test(
      'inserts nothing if array contains one element',
      () {
        const a = SizedBox(width: 1);
        const d = SizedBox(width: 4);

        final original = <Widget>[a];

        final interspersed = original.intersperse(d);

        expect(interspersed.length, equals(1));
        expect(interspersed.first, equals(a));
      },
    );
  });
}
