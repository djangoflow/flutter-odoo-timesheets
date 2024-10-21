import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timesheets/configurations/configurations.dart';

class SmallSyncOverlay extends StatelessWidget {
  const SmallSyncOverlay({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        children: [
          child,
          Consumer<SmallSyncOverlayController>(
            builder: (context, controller, _) => AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              top: controller.isVisible ? 0 : -100, // Slide in/out from top
              left: 0,
              right: 0,
              child: SafeArea(
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: kPadding * 1.5, vertical: kPadding / 2),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onSurface.withOpacity(0.8),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(kPadding),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: kPadding * 2,
                          height: kPadding * 2,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                theme.colorScheme.primary),
                          ),
                        ),
                        const SizedBox(width: kPadding),
                        Text(
                          'Syncing',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.surface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SmallSyncOverlayController extends ChangeNotifier {
  bool _isVisible = false;

  bool get isVisible => _isVisible;

  void show() {
    _isVisible = true;
    notifyListeners();
  }

  void hide() {
    _isVisible = false;
    notifyListeners();
  }
}
