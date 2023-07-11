import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/task/task.dart';

@RoutePage(name: 'TimesheetsRouter')
class TimesheetsRouterPage extends AutoRouter with AutoRouteWrapper {
  final int timesheetId;

  const TimesheetsRouterPage({super.key, @pathParam required this.timesheetId});

  @override
  Widget wrappedRoute(BuildContext context) => BlocProvider<TimesheetDataCubit>(
        create: (context) => TimesheetDataCubit(
          context.read<TimesheetsRepository>(),
          context.read<TasksRepository>(),
        )..load(
            TimesheetRetrieveFilter(timesheetId: timesheetId),
          ),
        child: this,
      );
}
