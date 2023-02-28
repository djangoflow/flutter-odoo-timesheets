import 'package:flutter/material.dart';
import 'package:reactive_dropdown_search/reactive_dropdown_search.dart';

class AppReactiveDropdown<T, V> extends StatelessWidget {
  const AppReactiveDropdown({
    super.key,
    this.items,
    required this.itemAsString,
    this.onBeforeChange,
    this.formControlName,
    this.validationMessages,
    this.hintText,
    this.asyncItems,
  });

  final List<V>? items;
  final String Function(V)? itemAsString;
  final Future<bool?> Function(V?, V?)? onBeforeChange;
  final String? formControlName;
  final Map<String, String Function(Object)>? validationMessages;
  final String? hintText;
  final Future<List<V>> Function(String)? asyncItems;

  @override
  Widget build(BuildContext context) => ReactiveDropdownSearch<T, V>(
        dropdownDecoratorProps: DropDownDecoratorProps(
          baseStyle: Theme.of(context).textTheme.bodyLarge,
          dropdownSearchDecoration: InputDecoration(
            hintText: hintText,
          ),
        ),
        popupProps: const PopupProps.menu(
          showSearchBox: true,
          isFilterOnline: true,
          menuProps: MenuProps(
              // backgroundColor: Colors.white,

              ),
        ),
        itemAsString: itemAsString,
        items: items ?? [],
        formControlName: formControlName,
        onBeforeChange: onBeforeChange,
        validationMessages: validationMessages,
        asyncItems: asyncItems,
      );
}
