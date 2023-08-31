import 'package:drift/drift.dart';
import 'package:timesheets/features/app/data/db/app_database.dart';
import 'package:timesheets/features/app/data/models/filter.dart';

class TimesheetRecentFirstFilter extends OrderingFilter<$TimesheetsTable> {
  TimesheetRecentFirstFilter()
      : super(
          slug: 'recent',
          label: 'Recent',
          orderingTermBuilder: (b) => OrderingTerm(
            expression: b.updatedAt,
            mode: OrderingMode.desc,
          ),
        );
}

class TimesheetOldestFirstFilter extends OrderingFilter<$TimesheetsTable> {
  TimesheetOldestFirstFilter()
      : super(
          slug: 'oldest',
          label: 'Oldest',
          orderingTermBuilder: (b) => OrderingTerm(
            expression: b.updatedAt,
            mode: OrderingMode.asc,
          ),
        );
}
