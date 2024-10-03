import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/timesheet/timesheet.dart';

@RoutePage(name: 'TimesheetsRouter')
class TimesheetsRouterPage extends AutoRouter implements AutoRouteWrapper {
  final int timesheetId;

  const TimesheetsRouterPage({super.key, @pathParam required this.timesheetId});

  @override
  Widget wrappedRoute(BuildContext context) =>
      BlocProvider<TimesheetRelationalDataCubit>(
        create: (context) => TimesheetRelationalDataCubit(
          context.read<TimesheetRelationalRepository>(),
        )..load(
            TimesheetRetrieveFilter(id: timesheetId),
          ),
        child: this,
      );
}
