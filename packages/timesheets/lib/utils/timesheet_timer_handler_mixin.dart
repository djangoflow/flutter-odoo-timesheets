import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timesheets/features/sync/sync.dart';
import 'package:timesheets/features/timer/timer.dart';
import 'package:timesheets/features/timesheet/timesheet.dart';
import 'package:timesheets/utils/utils.dart';

mixin TimesheetTimerHandlerMixin<
    C extends SyncableListCubit<TimesheetModel, dynamic>> {
  void onTimerResume(BuildContext context, TimesheetModel timesheet) {
    final cubit = context.read<C>();
    final currentlyElapsedTime = timesheet.elapsedTime;
    context.read<TimerCubit>().elapsedTime = Duration(
      seconds: currentlyElapsedTime,
    );
    cubit.update(
      cubit.state.data!
          .map(
            (t) => t.id == timesheet.id
                ? timesheet.copyWith(
                    unitAmount: currentlyElapsedTime.toUnitAmount(),
                    lastTicked: DateTime.timestamp(),
                  )
                : t,
          )
          .toList(),
    );
  }

  Future<TimesheetModel> onTimerStateChange(
    BuildContext context,
    TimesheetModel timesheet,
    TimerState timerState,
    int tickDurationInSeconds,
  ) async {
    final cubit = context.read<C>();
    final effectiveTimeSheet = cubit.state.data?.firstWhere(
      (element) => element.id == timesheet.id,
    );
    if (effectiveTimeSheet == null) {
      throw Exception('Timesheet not found');
    }

    final isRunning = timerState.status == TimerStatus.running;
    final lastTickedValue =
        isRunning ? DateTime.timestamp() : effectiveTimeSheet.lastTicked;

    // Use the elapsedTime getter to get the most up-to-date elapsed time
    final totalElapsedSeconds =
        effectiveTimeSheet.elapsedTime + tickDurationInSeconds;
    final updatedUnitAmount = totalElapsedSeconds.toUnitAmount();

    TimesheetModel updatableTimesheet = effectiveTimeSheet.copyWith(
      unitAmount: updatedUnitAmount,
      currentStatus: timerState.status,
      lastTicked: lastTickedValue,
    );

    final updatedTimesheet = await cubit.updateItem(
      updatableTimesheet,
      shouldUpdateSecondaryOnly: true,
    );

    return updatedTimesheet;
  }
}
