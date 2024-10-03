// lib/widgets/connection_state_toggle.dart

import 'package:djangoflow_app/djangoflow_app.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'connection_state_provider.dart';

class ConnectionStateToggle extends StatelessWidget {
  const ConnectionStateToggle({super.key});

  @override
  Widget build(BuildContext context) => Consumer<ConnectionStateProvider>(
        builder: (context, provider, child) => SwitchListTile(
          title: const Text('Online Mode'),
          value: provider.isOnline,
          onChanged: (value) {
            provider.isOnline = value;
            DjangoflowAppSnackbar.showInfo(
              'Connection state set to: ${value ? "Online" : "Offline"}',
            );
          },
        ),
      );
}
