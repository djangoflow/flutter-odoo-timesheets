import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timesheets/features/timer/blocs/timer_cubit/timer_cubit.dart';

class TimerWidgetBuilder extends StatelessWidget {
  const TimerWidgetBuilder({super.key, required this.builder});

  final Widget Function(BuildContext context, TimerState state) builder;

  @override
  Widget build(BuildContext context) => BlocBuilder<TimerCubit, TimerState>(
        builder: builder,
      );
}
