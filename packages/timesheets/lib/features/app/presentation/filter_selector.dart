import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';

class FilterSelector<T> extends StatefulWidget {
  const FilterSelector({
    super.key,
    required this.onFilterChanged,
    required this.initialFilter,
    required this.availableFilters,
  });

  final void Function(OrderingFilter<T> filter) onFilterChanged;
  final OrderingFilter<T> initialFilter;
  final List<OrderingFilter<T>> availableFilters;

  @override
  State<FilterSelector<T>> createState() => _FilterSelectorState<T>();
}

class _FilterSelectorState<T> extends State<FilterSelector<T>> {
  OrderingFilter<T>? _filter;

  @override
  void initState() {
    super.initState();
    _filter = widget.initialFilter;
  }

  @override
  Widget build(BuildContext context) => AdaptiveSafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: kPadding * 2,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kPadding * 2),
              child: Text(
                'Sort by',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.only(
                left: kPadding * 2,
                right: kPadding * 2,
                top: kPadding * 2,
              ),
              itemCount: widget.availableFilters.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final filter = widget.availableFilters[index];

                return InkWell(
                  onTap: () => setState(() {
                    _filter = filter;
                    widget.onFilterChanged(filter);
                  }),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: kPadding,
                    ),
                    child: Row(
                      children: [
                        if (_filter?.slug == filter.slug) ...[
                          const Icon(CupertinoIcons.check_mark),
                          const SizedBox(
                            width: kPadding / 4,
                          ),
                        ],
                        if (_filter?.slug != filter.slug)
                          const SizedBox(
                            width: kPadding * 1.5,
                          ),
                        Text(filter.label),
                      ],
                    ),
                  ),
                );
              },
            ),
            const Divider(
              endIndent: kPadding * 2,
              indent: kPadding * 2,
            ),
          ],
        ),
      );
}
