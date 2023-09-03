import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';

class InitialTimesheetOrderingFilterWrapper extends StatelessWidget {
  const InitialTimesheetOrderingFilterWrapper({
    super.key,
    required this.builder,
  });

  final Widget Function(OrderingFilter<$TimesheetsTable>? initialOrderingFilter)
      builder;

  @override
  Widget build(BuildContext context) {
    final tabsRouter = context.tabsRouter;

    final initialOrdering = context
        .read<TabbedOrderingFilterCubit<$TimesheetsTable>>()
        .getFilterForTab(tabsRouter.activeIndex);
    return builder(initialOrdering);
  }
}
