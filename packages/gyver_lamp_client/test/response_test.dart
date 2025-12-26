// ignore_for_file: prefer_const_constructors, document_ignores

import 'package:gyver_lamp_client/gyver_lamp_client.dart';
import 'package:test/test.dart';

void main() {
  group('GyverLampCurrentResponse', () {
    test('can be instantiated', () {
      expect(
        GyverLampCurrentResponse(
          mode: 1,
          brightness: 2,
          speed: 3,
          scale: 4,
          isOn: true,
        ),
        isNotNull,
      );
    });

    test('supports equality', () {
      expect(
        GyverLampCurrentResponse(
          mode: 1,
          brightness: 2,
          speed: 3,
          scale: 4,
          isOn: true,
        ),
        equals(
          GyverLampCurrentResponse(
            mode: 1,
            brightness: 2,
            speed: 3,
            scale: 4,
            isOn: true,
          ),
        ),
      );

      expect(
        GyverLampCurrentResponse(
          mode: 1,
          brightness: 2,
          speed: 3,
          scale: 4,
          isOn: true,
        ),
        isNot(
          equals(
            GyverLampCurrentResponse(
              mode: 11,
              brightness: 2,
              speed: 3,
              scale: 4,
              isOn: true,
            ),
          ),
        ),
      );

      expect(
        GyverLampCurrentResponse(
          mode: 1,
          brightness: 2,
          speed: 3,
          scale: 4,
          isOn: true,
        ),
        isNot(
          equals(
            GyverLampCurrentResponse(
              mode: 1,
              brightness: 22,
              speed: 3,
              scale: 4,
              isOn: true,
            ),
          ),
        ),
      );

      expect(
        GyverLampCurrentResponse(
          mode: 1,
          brightness: 2,
          speed: 3,
          scale: 4,
          isOn: true,
        ),
        isNot(
          equals(
            GyverLampCurrentResponse(
              mode: 1,
              brightness: 2,
              speed: 33,
              scale: 4,
              isOn: true,
            ),
          ),
        ),
      );

      expect(
        GyverLampCurrentResponse(
          mode: 1,
          brightness: 2,
          speed: 3,
          scale: 4,
          isOn: true,
        ),
        isNot(
          equals(
            GyverLampCurrentResponse(
              mode: 1,
              brightness: 2,
              speed: 3,
              scale: 44,
              isOn: true,
            ),
          ),
        ),
      );

      expect(
        GyverLampCurrentResponse(
          mode: 1,
          brightness: 2,
          speed: 3,
          scale: 4,
          isOn: true,
        ),
        isNot(
          equals(
            GyverLampCurrentResponse(
              mode: 1,
              brightness: 2,
              speed: 3,
              scale: 4,
              isOn: false,
            ),
          ),
        ),
      );
    });
  });

  group('GyverLampOkResponse', () {
    test('can be instantiated', () {
      expect(
        GyverLampOkResponse(timestamp: '11.22.63'),
        isNotNull,
      );
    });

    test('supports equality', () {
      expect(
        GyverLampOkResponse(timestamp: '11.22.63'),
        GyverLampOkResponse(timestamp: '11.22.63'),
      );

      expect(
        GyverLampOkResponse(timestamp: '11.22.63'),
        isNot(
          equals(
            GyverLampOkResponse(timestamp: '11.22.64'),
          ),
        ),
      );
    });
  });

  group('GyverLampBrightnessResponse', () {
    test('can be instantiated', () {
      expect(
        GyverLampBrightnessResponse(brightness: 1),
        isNotNull,
      );
    });

    test('supports equality', () {
      expect(
        GyverLampBrightnessResponse(brightness: 1),
        GyverLampBrightnessResponse(brightness: 1),
      );

      expect(
        GyverLampBrightnessResponse(brightness: 1),
        isNot(
          equals(
            GyverLampBrightnessResponse(brightness: 2),
          ),
        ),
      );
    });
  });

  group('GyverLampSpeedResponse', () {
    test('can be instantiated', () {
      expect(
        GyverLampSpeedResponse(speed: 1),
        isNotNull,
      );
    });

    test('supports equality', () {
      expect(
        GyverLampSpeedResponse(speed: 1),
        GyverLampSpeedResponse(speed: 1),
      );

      expect(
        GyverLampSpeedResponse(speed: 1),
        isNot(
          equals(
            GyverLampSpeedResponse(speed: 2),
          ),
        ),
      );
    });
  });

  group('GyverLampScaleResponse', () {
    test('can be instantiated', () {
      expect(
        GyverLampScaleResponse(scale: 1),
        isNotNull,
      );
    });

    test('supports equality', () {
      expect(
        GyverLampScaleResponse(scale: 1),
        GyverLampScaleResponse(scale: 1),
      );

      expect(
        GyverLampScaleResponse(scale: 1),
        isNot(
          equals(
            GyverLampScaleResponse(scale: 2),
          ),
        ),
      );
    });
  });

  group('GyverLampUnknownResponse', () {
    test('can be instantiated', () {
      expect(
        GyverLampUnknownResponse(data: 'data'),
        isNotNull,
      );
    });

    test('supports equality', () {
      expect(
        GyverLampUnknownResponse(data: 'data'),
        GyverLampUnknownResponse(data: 'data'),
      );

      expect(
        GyverLampUnknownResponse(data: 'data'),
        isNot(
          equals(
            GyverLampUnknownResponse(data: 'data-data'),
          ),
        ),
      );
    });
  });
}
