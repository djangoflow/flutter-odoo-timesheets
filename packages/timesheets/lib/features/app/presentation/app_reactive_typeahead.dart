import 'dart:async';

import 'package:flutter/material.dart';

import 'package:reactive_flutter_typeahead/reactive_flutter_typeahead.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';

class AppReactiveTypeAhead<T, V> extends StatefulWidget {
  const AppReactiveTypeAhead({
    super.key,
    required this.formControlName,
    this.validationMessages,
    this.inputDecoration = const InputDecoration(),
    this.emptyBuilder,
    required this.stringify,
    required this.suggestionsCallback,
    required this.itemBuilder,
    this.suggestionsBoxController,
  });
  final String formControlName;
  final Map<String, String Function(Object)>? validationMessages;
  final InputDecoration inputDecoration;
  final Widget Function(
          BuildContext context, TextEditingController textEditingController)?
      emptyBuilder;
  final String Function(V) stringify;
  final FutureOr<Iterable<V>> Function(String) suggestionsCallback;
  final Widget Function(BuildContext, V) itemBuilder;
  final SuggestionsBoxController? suggestionsBoxController;
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
            Radius.circular(kPadding * 1),
          ),
          child: ListView.separated(
            controller: scrollController,
            separatorBuilder: (_, __) => const Divider(
              height: 1,
            ),
            itemBuilder: (context, index) => suggestions.elementAt(index),
            itemCount: suggestions.length,
            shrinkWrap: true,
          ),
        ),
        suggestionsBoxController: widget.suggestionsBoxController,
        hideOnEmpty: false,
        hideOnLoading: false,
        keepSuggestionsOnLoading: true,
        textFieldConfiguration: TextFieldConfiguration(
          controller: _textEditingController,
          decoration: widget.inputDecoration,
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
