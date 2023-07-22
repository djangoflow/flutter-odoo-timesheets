import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    this.emptyBuilder,
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
  final Widget Function(BuildContext, String)? emptyBuilder;

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
          emptyBuilder: emptyBuilder,
          itemBuilder: (context, item, isSelected) => Padding(
            padding: EdgeInsets.symmetric(vertical: kPadding.h / 2),
            child: ListTile(
              title: Text(
                itemAsString?.call(item) ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              selected: isSelected,
            ),
          ),
          containerBuilder: (context, popupWidget) => Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            elevation: 0,
            child: popupWidget,
          ),
          searchFieldProps: TextFieldProps(
            decoration: InputDecoration(
              hintText: 'Search',
              label: const Text('Search'),
              border: const OutlineInputBorder(),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface,
            ),
          ),
        ),
        itemAsString: itemAsString,
        asyncItems: asyncItems,
        items: items ?? [],
        formControlName: formControlName,
        onBeforeChange: onBeforeChange,
        validationMessages: validationMessages,
      );
}
