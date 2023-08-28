import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';

class FilterSelector extends StatefulWidget {
  const FilterSelector({
    super.key,
    required this.onFilterChanged,
    this.initialFilter = FilterEnum.newest,
  });

  final void Function(FilterEnum filter) onFilterChanged;
  final FilterEnum initialFilter;

  @override
  State<FilterSelector> createState() => _FilterSelectorState();
}

class _FilterSelectorState extends State<FilterSelector> {
  FilterEnum? _filter;

  @override
  void initState() {
    super.initState();
    _filter = widget.initialFilter;
  }

  @override
  Widget build(BuildContext context) => SafeArea(
        bottom: true,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: kPadding.h * 2,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: kPadding.w * 2),
              child: Text(
                'Sort by',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.only(
                left: kPadding.w * 2,
                right: kPadding.w * 2,
                top: kPadding.h * 2,
              ),
              itemCount: FilterEnum.values.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final filter = FilterEnum.values[index];

                return InkWell(
                  onTap: () => setState(() {
                    _filter = filter;
                    widget.onFilterChanged(filter);
                  }),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: kPadding.h,
                    ),
                    child: Row(
                      children: [
                        if (_filter == filter) ...[
                          const Icon(CupertinoIcons.check_mark),
                          SizedBox(
                            width: kPadding.w / 4,
                          ),
                        ],
                        if (_filter != filter)
                          SizedBox(
                            width: kPadding.w * 1.5,
                          ),
                        Text(filter.label),
                      ],
                    ),
                  ),
                );
              },
            ),
            Divider(
              endIndent: kPadding.w * 2,
              indent: kPadding.w * 2,
            ),
          ],
        ),
      );
}
