import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timesheets/features/timer/blocs/timer_cubit/timer_cubit.dart';

class TimerBlocBuilder extends BlocBuilder<TimerCubit, TimerState> {
  const TimerBlocBuilder({super.key, required super.builder});
}
