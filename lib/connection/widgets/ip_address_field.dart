import 'package:flutter/material.dart' hide ConnectionState;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gyver_lamp/connection/connection.dart';
import 'package:gyver_lamp/l10n/l10n.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';

class IpAddressField extends StatefulWidget {
  const IpAddressField({super.key});

  @override
  State<IpAddressField> createState() => _IpAddressFieldState();
}

class _IpAddressFieldState extends State<IpAddressField> {
  TextEditingController? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_controller == null) {
      final text = context.read<ConnectionBloc>().state.address.value;
      _controller = TextEditingController(text: text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<ConnectionBloc, ConnectionState>(
      buildWhen: (p, c) {
        return p.address.isValid != c.address.isValid ||
            p.address.isPure != c.address.isPure ||
            p.isConnecting ||
            c.isConnecting;
      },
      builder: (context, state) {
        return LabeledInputField(
          controller: _controller,
          label: l10n.ip,
          hintText: 'XXX.XXX.XXX.XXX',
          errorText: state.address.isValid || state.address.isPure
              ? null
              : l10n.ipErrorHint,
          keyboardType: TextInputType.datetime,
          enabled: !state.isConnecting,
          onChanged: (address) {
            context.read<ConnectionBloc>().add(
              IpAddressUpdated(address: address),
            );
          },
        );
      },
    );
  }
}
