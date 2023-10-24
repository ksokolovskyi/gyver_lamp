import 'package:flutter/material.dart';
import 'package:gallery/story_scaffold.dart';
import 'package:gallery/theme/theme.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';

String _label(ConnectionStatus status) {
  return switch (status) {
    (ConnectionStatus.connected) => 'Connected',
    (ConnectionStatus.connecting) => 'Connecting',
    (ConnectionStatus.notConnected) => 'Not Connected',
  };
}

class ConnectionStatusBadgeStory extends StatelessWidget {
  const ConnectionStatusBadgeStory({super.key});

  @override
  Widget build(BuildContext context) {
    return StoryScaffold(
      title: 'Connection Status Badge',
      body: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Theme(
              data: GyverLampTheme.lightThemeData,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 64,
                  vertical: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Light Mode',
                      style: GalleryTextStyles.headlineMedium,
                    ),
                    const SizedBox(height: 32),
                    Wrap(
                      spacing: 24,
                      runSpacing: 48,
                      children: [
                        ConnectionStatusBadge(
                          status: ConnectionStatus.connected,
                          label: _label,
                          onPressed: () {},
                        ),
                        const ConnectionStatusBadge(
                          status: ConnectionStatus.connected,
                          label: _label,
                          onPressed: null,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Wrap(
                      spacing: 24,
                      runSpacing: 48,
                      children: [
                        ConnectionStatusBadge(
                          status: ConnectionStatus.connecting,
                          label: _label,
                          onPressed: () {},
                        ),
                        const ConnectionStatusBadge(
                          status: ConnectionStatus.connecting,
                          label: _label,
                          onPressed: null,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Wrap(
                      spacing: 24,
                      runSpacing: 48,
                      children: [
                        ConnectionStatusBadge(
                          status: ConnectionStatus.notConnected,
                          label: _label,
                          onPressed: () {},
                        ),
                        const ConnectionStatusBadge(
                          status: ConnectionStatus.notConnected,
                          label: _label,
                          onPressed: null,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const _InteractiveConnectionStatusBadge(),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            Theme(
              data: GyverLampTheme.darkThemeData,
              child: ColoredBox(
                color: GyverLampColors.darkBackground,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 64,
                    vertical: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Dark Mode',
                        style: GalleryTextStyles.headlineMedium.copyWith(
                          color: GyverLampColors.darkTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Wrap(
                        spacing: 24,
                        runSpacing: 48,
                        children: [
                          ConnectionStatusBadge(
                            status: ConnectionStatus.connected,
                            label: _label,
                            onPressed: () {},
                          ),
                          const ConnectionStatusBadge(
                            status: ConnectionStatus.connected,
                            label: _label,
                            onPressed: null,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Wrap(
                        spacing: 24,
                        runSpacing: 48,
                        children: [
                          ConnectionStatusBadge(
                            status: ConnectionStatus.connecting,
                            label: _label,
                            onPressed: () {},
                          ),
                          const ConnectionStatusBadge(
                            status: ConnectionStatus.connecting,
                            label: _label,
                            onPressed: null,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Wrap(
                        spacing: 24,
                        runSpacing: 48,
                        children: [
                          ConnectionStatusBadge(
                            status: ConnectionStatus.notConnected,
                            label: _label,
                            onPressed: () {},
                          ),
                          const ConnectionStatusBadge(
                            status: ConnectionStatus.notConnected,
                            label: _label,
                            onPressed: null,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const _InteractiveConnectionStatusBadge(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InteractiveConnectionStatusBadge extends StatefulWidget {
  const _InteractiveConnectionStatusBadge();

  @override
  State<_InteractiveConnectionStatusBadge> createState() =>
      __InteractiveConnectionStatusBadgeState();
}

class __InteractiveConnectionStatusBadgeState
    extends State<_InteractiveConnectionStatusBadge> {
  var _index = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: ConnectionStatusBadge(
            status: ConnectionStatus.values[_index],
            label: _label,
            onPressed: () {
              setState(() {
                _index += 1;
                _index %= ConnectionStatus.values.length;
              });
            },
          ),
        ),
      ],
    );
  }
}
