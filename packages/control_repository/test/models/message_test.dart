// ignore_for_file: prefer_const_constructors

import 'package:control_repository/control_repository.dart';
import 'package:test/test.dart';

void main() {
  group('GyverLampStateChangedMessage', () {
    test('can be instantiated', () {
      expect(
        GyverLampStateChangedMessage(
          mode: GyverLampMode.fire,
          brightness: 1,
          speed: 2,
          scale: 3,
          isOn: true,
        ),
        isNotNull,
      );
    });

    test('supports equality', () {
      expect(
        GyverLampStateChangedMessage(
          mode: GyverLampMode.fire,
          brightness: 1,
          speed: 2,
          scale: 3,
          isOn: true,
        ),
        equals(
          GyverLampStateChangedMessage(
            mode: GyverLampMode.fire,
            brightness: 1,
            speed: 2,
            scale: 3,
            isOn: true,
          ),
        ),
      );

      expect(
        GyverLampStateChangedMessage(
          mode: GyverLampMode.fire,
          brightness: 1,
          speed: 2,
          scale: 3,
          isOn: true,
        ),
        isNot(
          equals(
            GyverLampStateChangedMessage(
              mode: GyverLampMode.cloud,
              brightness: 1,
              speed: 2,
              scale: 3,
              isOn: true,
            ),
          ),
        ),
      );

      expect(
        GyverLampStateChangedMessage(
          mode: GyverLampMode.fire,
          brightness: 1,
          speed: 2,
          scale: 3,
          isOn: true,
        ),
        isNot(
          equals(
            GyverLampStateChangedMessage(
              mode: GyverLampMode.fire,
              brightness: 4,
              speed: 2,
              scale: 3,
              isOn: true,
            ),
          ),
        ),
      );

      expect(
        GyverLampStateChangedMessage(
          mode: GyverLampMode.fire,
          brightness: 1,
          speed: 2,
          scale: 3,
          isOn: true,
        ),
        isNot(
          equals(
            GyverLampStateChangedMessage(
              mode: GyverLampMode.fire,
              brightness: 1,
              speed: 4,
              scale: 3,
              isOn: true,
            ),
          ),
        ),
      );

      expect(
        GyverLampStateChangedMessage(
          mode: GyverLampMode.fire,
          brightness: 1,
          speed: 2,
          scale: 3,
          isOn: true,
        ),
        isNot(
          equals(
            GyverLampStateChangedMessage(
              mode: GyverLampMode.fire,
              brightness: 1,
              speed: 2,
              scale: 4,
              isOn: true,
            ),
          ),
        ),
      );

      expect(
        GyverLampStateChangedMessage(
          mode: GyverLampMode.fire,
          brightness: 1,
          speed: 2,
          scale: 3,
          isOn: true,
        ),
        isNot(
          equals(
            GyverLampStateChangedMessage(
              mode: GyverLampMode.fire,
              brightness: 1,
              speed: 2,
              scale: 2,
              isOn: false,
            ),
          ),
        ),
      );
    });
  });

  group('GyverLampBrightnessChangedMessage', () {
    test('can be instantiated', () {
      expect(
        GyverLampBrightnessChangedMessage(brightness: 1),
        isNotNull,
      );
    });

    test('supports equality', () {
      expect(
        GyverLampBrightnessChangedMessage(brightness: 1),
        equals(GyverLampBrightnessChangedMessage(brightness: 1)),
      );

      expect(
        GyverLampBrightnessChangedMessage(brightness: 1),
        isNot(
          equals(GyverLampBrightnessChangedMessage(brightness: 2)),
        ),
      );
    });
  });

  group('GyverLampSpeedChangedMessage', () {
    test('can be instantiated', () {
      expect(
        GyverLampSpeedChangedMessage(speed: 1),
        isNotNull,
      );
    });

    test('supports equality', () {
      expect(
        GyverLampSpeedChangedMessage(speed: 1),
        equals(GyverLampSpeedChangedMessage(speed: 1)),
      );

      expect(
        GyverLampSpeedChangedMessage(speed: 1),
        isNot(
          equals(GyverLampSpeedChangedMessage(speed: 2)),
        ),
      );
    });
  });

  group('GyverLampScaleChangedMessage', () {
    test('can be instantiated', () {
      expect(
        GyverLampScaleChangedMessage(scale: 1),
        isNotNull,
      );
    });

    test('supports equality', () {
      expect(
        GyverLampScaleChangedMessage(scale: 1),
        equals(GyverLampScaleChangedMessage(scale: 1)),
      );

      expect(
        GyverLampScaleChangedMessage(scale: 1),
        isNot(
          equals(GyverLampScaleChangedMessage(scale: 2)),
        ),
      );
    });
  });
}
