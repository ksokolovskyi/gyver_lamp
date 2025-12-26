// ignore_for_file: prefer_const_literals_to_create_immutables, document_ignores

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gyver_lamp_effects/src/models/frame.dart';

void main() {
  group('Frame', () {
    test('can be instantiated', () {
      expect(
        Frame(
          dimension: 1,
          data: [Colors.black],
        ),
        isNotNull,
      );
    });

    test('throws AssertionError when dimension is lower that 1', () {
      expect(
        () => Frame(
          dimension: 0,
          data: [Colors.black],
        ),
        throwsA(
          isA<AssertionError>().having(
            (e) => e.message,
            'message',
            equals('dimension must be greater that 0'),
          ),
        ),
      );
    });

    test('throws AssertionError when data length is not valid', () {
      expect(
        () => Frame(
          dimension: 2,
          data: [Colors.black],
        ),
        throwsA(
          isA<AssertionError>().having(
            (e) => e.message,
            'message',
            equals('data length must be equal to dimension^2'),
          ),
        ),
      );
    });

    test('supports equality', () {
      expect(
        Frame(dimension: 1, data: [Colors.black]),
        equals(Frame(dimension: 1, data: [Colors.black])),
      );

      expect(
        Frame(dimension: 1, data: [Colors.black]),
        isNot(equals(Frame(dimension: 1, data: [Colors.white]))),
      );

      expect(
        Frame(dimension: 1, data: [Colors.black]),
        isNot(
          equals(
            Frame(
              dimension: 2,
              data: [
                Colors.black,
                Colors.white,
                Colors.black,
                Colors.white,
              ],
            ),
          ),
        ),
      );
    });
  });
}
