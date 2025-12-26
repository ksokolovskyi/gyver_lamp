// ignore_for_file: document_ignores

import 'package:gyver_lamp_client/src/src.dart';
import 'package:meta/meta.dart';

/// {@template gyver_lamp_response_parse_exception}
/// Exception thrown when lamp response parsing failed.
///
/// Check [cause] and [stackTrace] for specific details.
/// {@endtemplate}
class GyverLampResponseParseException implements Exception {
  /// {@macro gyver_lamp_response_parse_exception}
  const GyverLampResponseParseException(this.cause, this.stackTrace);

  /// The cause of the exception.
  final dynamic cause;

  /// The stack trace of the exception.
  final StackTrace stackTrace;
}

@visibleForTesting
// ignore: public_member_api_docs
const currentPrefix = 'CURR';

@visibleForTesting
// ignore: public_member_api_docs
const brightnessPrefix = 'BRI';

@visibleForTesting
// ignore: public_member_api_docs
const speedPrefix = 'SPD';

@visibleForTesting
// ignore: public_member_api_docs
const scalePrefix = 'SCA';

@visibleForTesting
// ignore: public_member_api_docs
const okPrefix = 'OK';

/// Returns an [GyverLampResponse] based on a parsed [data].
GyverLampResponse parseResponse(String data) {
  try {
    final values = data.split(' ').skip(1).toList();

    if (data.startsWith(currentPrefix)) {
      return GyverLampCurrentResponse(
        mode: int.parse(values[0]),
        brightness: int.parse(values[1]),
        speed: int.parse(values[2]),
        scale: int.parse(values[3]),
        isOn: int.parse(values[4]) == 1,
      );
    }

    if (data.startsWith(brightnessPrefix)) {
      return GyverLampBrightnessResponse(
        brightness: int.parse(values[0]),
      );
    }

    if (data.startsWith(speedPrefix)) {
      return GyverLampSpeedResponse(
        speed: int.parse(values[0]),
      );
    }

    if (data.startsWith(scalePrefix)) {
      return GyverLampScaleResponse(
        scale: int.parse(values[0]),
      );
    }

    if (data.startsWith(okPrefix)) {
      return GyverLampOkResponse(
        timestamp: values[0],
      );
    }

    return GyverLampUnknownResponse(data: data);
  } catch (e, t) {
    throw GyverLampResponseParseException(e, t);
  }
}
