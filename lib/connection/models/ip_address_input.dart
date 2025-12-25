import 'package:formz/formz.dart';

enum IpAddressInputValidationError { invalid }

class IpAddressInput extends FormzInput<String, IpAddressInputValidationError>
    with FormzInputErrorCacheMixin {
  IpAddressInput.pure([super.value = '']) : super.pure();

  IpAddressInput.dirty([super.value = '']) : super.dirty();

  static final _ipRegExp = RegExp(
    r'^((25[0-5]|(2[0-4]|1\d|[1-9]|)\d)\.?\b){4}$',
  );

  @override
  IpAddressInputValidationError? validator(String value) {
    return _ipRegExp.hasMatch(value)
        ? null
        : IpAddressInputValidationError.invalid;
  }
}
