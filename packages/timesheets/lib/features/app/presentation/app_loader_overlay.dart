import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../sync/presentation/sync_animation.dart';

class AppGlobalLoaderOverlay extends StatelessWidget {
  const AppGlobalLoaderOverlay({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => GlobalLoaderOverlay(
        closeOnBackButton: false,
        disableBackButton: true,
        overlayColor: Colors.black.withOpacity(.84),
        overlayWholeScreen: true,
        useBackButtonInterceptor: false,
        overlayWidgetBuilder: (progress) => const SyncAnimation(),
        child: child,
      );
}
