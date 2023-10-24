import 'package:formz/formz.dart';

enum PortInputValidationError { invalid }

class PortInput extends FormzInput<int, PortInputValidationError>
    with FormzInputErrorCacheMixin {
  PortInput.pure([super.value = -1]) : super.pure();

  PortInput.dirty([super.value = -1]) : super.dirty();

  @override
  PortInputValidationError? validator(int value) {
    if (value < 0 || value > 65535) {
      return PortInputValidationError.invalid;
    }

    return null;
  }
}
