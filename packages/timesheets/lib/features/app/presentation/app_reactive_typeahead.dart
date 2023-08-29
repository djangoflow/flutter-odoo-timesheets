import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reactive_flutter_typeahead/reactive_flutter_typeahead.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';

class AppReactiveTypeAhead<T, V> extends StatefulWidget {
  const AppReactiveTypeAhead({
    super.key,
    required this.formControlName,
    this.validationMessages,
    this.hintText,
    this.helperText,
    this.labelText,
    this.emptyBuilder,
    required this.stringify,
    required this.suggestionsCallback,
    required this.itemBuilder,
  });
  final String formControlName;
  final Map<String, String Function(Object)>? validationMessages;
  final String? hintText;
  final String? helperText;
  final String? labelText;
  final Widget Function(
          BuildContext context, TextEditingController textEditingController)?
      emptyBuilder;
  final String Function(V) stringify;
  final FutureOr<Iterable<V>> Function(String) suggestionsCallback;
  final Widget Function(BuildContext, V) itemBuilder;
  @override
  State<AppReactiveTypeAhead<T, V>> createState() =>
      _AppReactiveTypeAheadState<T, V>();
}

class _AppReactiveTypeAheadState<T, V>
    extends State<AppReactiveTypeAhead<T, V>> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ReactiveTypeAhead<T, V>(
        formControlName: widget.formControlName,
        layoutArchitecture: (suggestions, scrollController) =>
            AppGlassContainer(
          borderRadius: BorderRadius.all(
            Radius.circular(kPadding.r * 1),
          ),
          child: ListView.separated(
            controller: scrollController,
            separatorBuilder: (_, __) => const Divider(
              height: 1,
            ),
            itemBuilder: (context, index) => suggestions.elementAt(index),
            itemCount: suggestions.length,
          ),
        ),
        hideOnEmpty: false,
        hideOnLoading: false,
        keepSuggestionsOnLoading: true,
        textFieldConfiguration: TextFieldConfiguration(
          controller: _textEditingController,
          decoration: InputDecoration(
            labelText: widget.labelText,
            hintText: widget.helperText,
          ),
        ),
        getImmediateSuggestions: true,
        noItemsFoundBuilder: widget.emptyBuilder != null
            ? (context) => widget.emptyBuilder!(context, _textEditingController)
            : null,
        validationMessages: widget.validationMessages,
        stringify: widget.stringify,
        suggestionsCallback: widget.suggestionsCallback,
        debounceDuration: const Duration(milliseconds: searchDelayMs),
        itemBuilder: widget.itemBuilder,
        suggestionsBoxDecoration: SuggestionsBoxDecoration(
          color: Colors.transparent,
          constraints: BoxConstraints.loose(kSuggestionBoxSize),
          elevation: 0,
        ),
      );
}
