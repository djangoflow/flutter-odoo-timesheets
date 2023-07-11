import 'package:flutter/material.dart';
import 'package:reactive_dropdown_search/reactive_dropdown_search.dart';
import 'package:timesheets/configurations/configurations.dart';

class AppReactiveDropdown<T, V> extends StatelessWidget {
  const AppReactiveDropdown({
    super.key,
    this.items,
    required this.itemAsString,
    this.onBeforeChange,
    this.formControlName,
    this.validationMessages,
    this.hintText,
    this.helperText,
    this.asyncItems,
    this.labelText,
  });

  final List<V>? items;
  final Future<List<V>> Function(String)? asyncItems;
  final String Function(V)? itemAsString;
  final Future<bool?> Function(V?, V?)? onBeforeChange;
  final String? formControlName;
  final Map<String, String Function(Object)>? validationMessages;
  final String? hintText;
  final String? helperText;
  final String? labelText;

  @override
  Widget build(BuildContext context) => ReactiveDropdownSearch<T, V>(
        dropdownDecoratorProps: DropDownDecoratorProps(
          baseStyle: Theme.of(context).textTheme.bodyLarge,
          dropdownSearchDecoration: InputDecoration(
            hintText: hintText,
            helperText: helperText,
            labelText: labelText,
          ),
        ),
        popupProps: PopupProps.menu(
          showSearchBox: true,
          isFilterOnline: true,
          loadingBuilder: (context, searchKey) =>
              const LinearProgressIndicator(),
          searchDelay: const Duration(milliseconds: searchDelayMs),
        ),
        itemAsString: itemAsString,
        asyncItems: asyncItems,
        items: items ?? [],
        formControlName: formControlName,
        onBeforeChange: onBeforeChange,
        validationMessages: validationMessages,
      );
}
