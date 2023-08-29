import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
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
          menuProps: const MenuProps(
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          showSearchBox: true,
          isFilterOnline: true,
          fit: FlexFit.loose,
          loadingBuilder: (context, searchKey) =>
              const LinearProgressIndicator(),
          searchDelay: const Duration(milliseconds: searchDelayMs),
          emptyBuilder: emptyBuilder,
          itemBuilder: (context, item, isSelected) => Padding(
            padding: EdgeInsets.symmetric(vertical: kPadding.h / 2),
            child: Column(
              children: [
                Divider(
                  height: kPadding.h / 8,
                ),
                ListTile(
                  tileColor: Colors.transparent,
                  title: Text(
                    itemAsString?.call(item) ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  selected: isSelected,
                ),
              ],
            ),
          ),
          containerBuilder: (context, popupWidget) => GlassContainer(
            blur: kDefaultBlur,
            shadowStrength: 0,
            shape: BoxShape.rectangle,
            color: AppColors.getTintedSurfaceColor(
                Theme.of(context).colorScheme.surfaceTint),
            borderRadius: BorderRadius.all(
              Radius.circular(kPadding.r * 1),
            ),
            child: popupWidget,
          ),
          searchFieldProps: const TextFieldProps(
            decoration: InputDecoration(
              hintText: 'Search',
              label: Text('Search'),
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
