import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class AppVisiblityBuilder extends StatefulWidget {
  const AppVisiblityBuilder({
    super.key,
    required this.appVisibilityKey,
    required this.child,
    this.onVisibilityChanged,
  });
  final ValueKey appVisibilityKey;
  final Widget child;
  final void Function(bool? isVisible)? onVisibilityChanged;

  @override
  State<AppVisiblityBuilder> createState() => _AppVisiblityBuilderState();
}

class _AppVisiblityBuilderState extends State<AppVisiblityBuilder> {
  ValueNotifier<bool>? _isPageVisible;

  @override
  void initState() {
    super.initState();
    _isPageVisible = ValueNotifier<bool>(true);
    _isPageVisible?.addListener(_listener);
  }

  void _listener() {
    widget.onVisibilityChanged?.call(_isPageVisible?.value);
  }

  @override
  void dispose() {
    _isPageVisible?.removeListener(_listener);
    _isPageVisible?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => VisibilityDetector(
        key: widget.appVisibilityKey,
        onVisibilityChanged: (info) {
          if (info.visibleFraction == 0) {
            _isPageVisible?.value = false;
          } else {
            _isPageVisible?.value = true;
          }
        },
        child: _isPageVisible == null
            ? const SizedBox()
            : ValueListenableBuilder(
                valueListenable: _isPageVisible!,
                builder: (context, isVisible, child) => Visibility(
                  maintainState: false,
                  visible: isVisible,
                  child: widget.child,
                ),
              ),
      );
}
