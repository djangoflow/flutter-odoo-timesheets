import 'package:drift/drift.dart';

import 'package:timesheets/features/app/data/models/filter.dart';
import 'package:timesheets/features/sync/data/database/database.dart';

class TimesheetRecentFirstFilter extends OrderingFilter<$AnalyticLinesTable> {
  TimesheetRecentFirstFilter()
      : super(
          slug: 'recent',
          label: 'Recent',
          orderingTermBuilder: (b) => OrderingTerm(
            expression: b.lastTicked,
            mode: OrderingMode.desc,
          ),
        );
}

class TimesheetOldestFirstFilter extends OrderingFilter<$AnalyticLinesTable> {
  TimesheetOldestFirstFilter()
      : super(
          slug: 'oldest',
          label: 'Oldest',
          orderingTermBuilder: (b) => OrderingTerm(
            expression: b.lastTicked,
            mode: OrderingMode.asc,
          ),
        );
}
