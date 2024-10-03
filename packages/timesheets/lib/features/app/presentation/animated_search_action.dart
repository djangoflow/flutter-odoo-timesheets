import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timesheets/configurations/configurations.dart';

class AnimatedSearchAction extends StatefulWidget {
  final String hintText;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onExpanded;
  final VoidCallback onCollapsed;
  final double? widthToNegate;
  final Duration debounceDuration;

  const AnimatedSearchAction({
    super.key,
    required this.hintText,
    required this.onChanged,
    required this.onSubmitted,
    required this.onExpanded,
    required this.onCollapsed,
    this.widthToNegate,
    this.debounceDuration = const Duration(milliseconds: 500),
  });

  @override
  State<AnimatedSearchAction> createState() => _AnimatedSearchActionState();
}

class _AnimatedSearchActionState extends State<AnimatedSearchAction>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isExpanded = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus && _searchController.text.isEmpty) {
        _collapse();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    _focusNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _expand() {
    widget.onExpanded();
    setState(() {
      _isExpanded = true;
    });
    _animationController.forward();
    _focusNode.requestFocus();
  }

  void _collapse() {
    widget.onCollapsed();
    _animationController.reverse().then((_) {
      setState(() {
        _isExpanded = false;
        _searchController.clear();
      });
      widget.onChanged('');
    });
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(widget.debounceDuration, () {
      widget.onChanged(query);
    });
  }

  @override
  Widget build(BuildContext context) => ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 16.w,
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth = constraints.maxWidth -
                (widget.widthToNegate ??
                    (kPadding.h * 5 * 2) + (kPadding.w * 2));
            return AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                final expandedHeight = kPadding.h * 6;
                final collapsedHeight = kPadding.h * 5;
                final currentHeight = collapsedHeight +
                    (expandedHeight - collapsedHeight) * _animation.value;

                return Container(
                  width: _isExpanded
                      ? (maxWidth * _animation.value + (kPadding.h * 5))
                      : kPadding.h * 5,
                  height: currentHeight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: _isExpanded
                      ? TextField(
                          controller: _searchController,
                          focusNode: _focusNode,
                          decoration: InputDecoration(
                            hintText: widget.hintText,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: kPadding.w * 2,
                              vertical: (currentHeight - (kPadding.h * 3)) / 2,
                            ),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: _collapse,
                            ),
                          ),
                          onChanged: _onSearchChanged,
                          onSubmitted: widget.onSubmitted,
                        )
                      : IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: _expand,
                        ),
                );
              },
            );
          },
        ),
      );
}
