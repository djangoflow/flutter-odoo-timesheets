// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:timesheets/configurations/configurations.dart';
// import 'package:timesheets/features/app/app.dart';

// class FilterSelector<T> extends StatefulWidget {
//   const FilterSelector({
//     super.key,
//     required this.onFilterChanged,
//     required this.initialFilter,
//     required this.availableFilters,
//   });

//   final void Function(OrderingFilter<T> filter) onFilterChanged;
//   final OrderingFilter<T> initialFilter;
//   final List<OrderingFilter<T>> availableFilters;

//   @override
//   State<FilterSelector<T>> createState() => _FilterSelectorState<T>();
// }

// class _FilterSelectorState<T> extends State<FilterSelector<T>> {
//   OrderingFilter<T>? _filter;

//   @override
//   void initState() {
//     super.initState();
//     _filter = widget.initialFilter;
//   }

//   @override
//   Widget build(BuildContext context) => SafeArea(
//         bottom: true,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(
//               height: kPadding.h * 2,
//             ),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: kPadding.w * 2),
//               child: Text(
//                 'Sort by',
//                 style: Theme.of(context).textTheme.bodySmall,
//               ),
//             ),
//             ListView.separated(
//               shrinkWrap: true,
//               padding: EdgeInsets.only(
//                 left: kPadding.w * 2,
//                 right: kPadding.w * 2,
//                 top: kPadding.h * 2,
//               ),
//               itemCount: widget.availableFilters.length,
//               separatorBuilder: (context, index) => const Divider(),
//               itemBuilder: (context, index) {
//                 final filter = widget.availableFilters[index];

//                 return InkWell(
//                   onTap: () => setState(() {
//                     _filter = filter;
//                     widget.onFilterChanged(filter);
//                   }),
//                   child: Padding(
//                     padding: EdgeInsets.symmetric(
//                       vertical: kPadding.h,
//                     ),
//                     child: Row(
//                       children: [
//                         if (_filter?.slug == filter.slug) ...[
//                           const Icon(CupertinoIcons.check_mark),
//                           SizedBox(
//                             width: kPadding.w / 4,
//                           ),
//                         ],
//                         if (_filter?.slug != filter.slug)
//                           SizedBox(
//                             width: kPadding.w * 1.5,
//                           ),
//                         Text(filter.label),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//             Divider(
//               endIndent: kPadding.w * 2,
//               indent: kPadding.w * 2,
//             ),
//           ],
//         ),
//       );
// }
