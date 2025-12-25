import 'package:flutter/material.dart' hide ConnectionState;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gyver_lamp/connection/connection.dart';
import 'package:gyver_lamp/l10n/l10n.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';

class PortField extends StatefulWidget {
  const PortField({super.key});

  @override
  State<PortField> createState() => _PortFieldState();
}

class _PortFieldState extends State<PortField> {
  TextEditingController? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_controller == null) {
      final port = context.read<ConnectionBloc>().state.port;
      final text = port.isPure ? '' : port.value.toString();
      _controller = TextEditingController(text: text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<ConnectionBloc, ConnectionState>(
      buildWhen: (p, c) {
        return p.port.isValid != c.port.isValid ||
            p.port.isPure != c.port.isPure ||
            p.isConnecting ||
            c.isConnecting;
      },
      builder: (context, state) {
        return LabeledInputField(
          controller: _controller,
          label: l10n.port,
          hintText: 'XXXX',
          errorText: state.port.isValid || state.port.isPure
              ? null
              : l10n.portErrorHint,
          keyboardType: TextInputType.number,
          enabled: !state.isConnecting,
          onChanged: (port) {
            context.read<ConnectionBloc>().add(
              PortUpdated(port: int.tryParse(port)),
            );
          },
        );
      },
    );
  }
}
