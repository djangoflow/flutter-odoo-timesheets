import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timesheets/configurations/router/router.dart';
import 'package:timesheets/features/activity/activity.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/timer/timer.dart';

class ActivityRouterPage extends StatelessWidget implements AutoRouteWrapper {
  const ActivityRouterPage({super.key});

  @override
  Widget build(BuildContext context) => const AutoRouter();

  @override
  Widget wrappedRoute(BuildContext context) => RepositoryProvider(
        create: (context) => ActivityRepository(
          context.read<AppXmlRpcClient>(),
        ),
        child: MultiBlocProvider(
          providers: [
            BlocProvider<TimerBloc>(
              create: (context) => TimerBloc(
                timeSheetTicker: const TimeSheetTicker(),
              ),
            ),
            BlocProvider<ActivityCubit>(
              create: (context) => ActivityCubit(
                context.read<ActivityRepository>(),
              ),
            ),
          ],
          child: this,
        ),
      );
}
