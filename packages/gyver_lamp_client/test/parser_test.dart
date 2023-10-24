import 'package:gyver_lamp_client/src/src.dart';
import 'package:test/test.dart';

void main() {
  group('parseResponse', () {
    test('can parse GyverLampCurrentResponse', () {
      expect(
        parseResponse('$currentPrefix 1 2 3 4 0'),
        equals(
          const GyverLampCurrentResponse(
            mode: 1,
            brightness: 2,
            speed: 3,
            scale: 4,
            isOn: false,
          ),
        ),
      );

      expect(
        parseResponse('$currentPrefix 1 2 3 4 1'),
        equals(
          const GyverLampCurrentResponse(
            mode: 1,
            brightness: 2,
            speed: 3,
            scale: 4,
            isOn: true,
          ),
        ),
      );
    });

    test(
        'throws GyverLampResponseParseException '
        'when GyverLampCurrentResponse is malformed', () {
      expect(
        () => parseResponse('$currentPrefix xxx 2 3 4 0'),
        throwsA(
          isA<GyverLampResponseParseException>(),
        ),
      );
    });

    test('can parse GyverLampOkResponse', () {
      expect(
        parseResponse('$okPrefix 11.22.63'),
        equals(
          const GyverLampOkResponse(timestamp: '11.22.63'),
        ),
      );
    });

    test(
        'throws GyverLampResponseParseException '
        'when GyverLampOkResponse is malformed', () {
      expect(
        () => parseResponse(okPrefix),
        throwsA(
          isA<GyverLampResponseParseException>(),
        ),
      );
    });

    test('can parse GyverLampBrightnessResponse', () {
      expect(
        parseResponse('$brightnessPrefix 1'),
        equals(
          const GyverLampBrightnessResponse(brightness: 1),
        ),
      );
    });

    test(
        'throws GyverLampResponseParseException '
        'when GyverLampBrightnessResponse is malformed', () {
      expect(
        () => parseResponse('$brightnessPrefix xxx'),
        throwsA(
          isA<GyverLampResponseParseException>(),
        ),
      );
    });

    test('can parse GyverLampSpeedResponse', () {
      expect(
        parseResponse('$speedPrefix 1'),
        equals(
          const GyverLampSpeedResponse(speed: 1),
        ),
      );
    });

    test(
        'throws GyverLampResponseParseException '
        'when GyverLampSpeedResponse is malformed', () {
      expect(
        () => parseResponse('$speedPrefix xxx'),
        throwsA(
          isA<GyverLampResponseParseException>(),
        ),
      );
    });

    test('can parse GyverLampScaleResponse', () {
      expect(
        parseResponse('$scalePrefix 1'),
        equals(
          const GyverLampScaleResponse(scale: 1),
        ),
      );
    });

    test(
        'throws GyverLampResponseParseException '
        'when GyverLampScaleResponse is malformed', () {
      expect(
        () => parseResponse('$scalePrefix xxx'),
        throwsA(
          isA<GyverLampResponseParseException>(),
        ),
      );
    });

    test(
        'returns GyverLampUnknownResponse '
        'when unknown prefix is specified', () {
      expect(
        parseResponse('X 1'),
        const GyverLampUnknownResponse(data: 'X 1'),
      );
    });
  });
}
