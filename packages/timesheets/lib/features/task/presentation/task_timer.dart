import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/timer/blocs/timer_cubit/timer_cubit.dart';
import 'package:timesheets/features/timer/presentation/timer_bloc_builder.dart';
import 'package:timesheets/features/timer/presentation/timer_bloc_listener.dart';
import 'package:timesheets/features/timesheet/timesheet.dart';
import 'package:timesheets/utils/utils.dart';

abstract class _TaskTimer extends StatefulWidget {
  const _TaskTimer({
    super.key,
    required this.builder,
    this.elapsedTime,
    this.initialTimerStatus,
    this.onTimerStateChange,
    this.padding,
    this.disabled = false,
    this.onTimerResume,
  });

  /// builder is used to build the timer widget.
  final Widget Function(
    BuildContext context,
    TimerState state,
    AnimationController animationController,
    int tickDurationInSeconds,
  ) builder;

  /// elapsedTime is used to set the initial duration of the timer.
  final int? elapsedTime;

  /// initialTimerStatus is used to set the initial status of the timer.
  final TimesheetStatusEnum? initialTimerStatus;

  /// onTimerStateChange is used to notify the parent widget about the timer state change.
  final void Function(
          BuildContext context, TimerState timerState, int tickInterval)?
      onTimerStateChange;

  /// padding is used to set the padding of the timer widget.
  final EdgeInsetsGeometry? padding;

  /// disabled is used to disable the timer widget.
  final bool disabled;

  final void Function(BuildContext context)? onTimerResume;

  @override
  State<_TaskTimer> createState() => __TaskTimerState();
}

class __TaskTimerState extends State<_TaskTimer> with TickerProviderStateMixin {
  /// TimerCubit is used to manage the timer state.
  late final TimerCubit _timerCubit;

  /// AnimationController is used to animate the timer widget.
  /// It is to orchestrate different animations of the timer widget.
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();
    // can initiate with different values later
    _timerCubit = TimerCubit(
      initialState: widget.elapsedTime != null
          ? TimerState(
              duration: Duration(seconds: widget.elapsedTime!),
              status: widget.initialTimerStatus ?? TimesheetStatusEnum.initial)
          : TimerState.initial(),
    );
    controller = AnimationController(
      vsync: this,
      duration: animationDurationDefault,
    );

    if ([TimesheetStatusEnum.running, TimesheetStatusEnum.pausedByForce]
        .contains(widget.initialTimerStatus)) {
      controller.forward();
      _timerCubit.startTimer();
    }
  }

  @override
  void dispose() {
    _timerCubit.close();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocProvider<TimerCubit>.value(
        value: _timerCubit,
        child: Builder(
            builder: (context) => AppLifeCycleListener(
                  onLifeCycleStateChanged: (appLifecycleState) {
                    if (appLifecycleState == AppLifecycleState.resumed) {
                      if (_timerCubit.state.status ==
                          TimesheetStatusEnum.pausedByForce) {
                        widget.onTimerResume?.call(context);
                        _timerCubit.resumeTimer();
                      }
                    } else {
                      if (_timerCubit.state.status ==
                          TimesheetStatusEnum.running) {
                        _timerCubit.forcePauseTimer();
                      }
                    }
                  },
                  child: TimerBlocListener(
                    listenWhen: (prev, current) =>
                        prev.duration != current.duration ||
                        prev.status != current.status,
                    listener: (context, state) => widget.onTimerStateChange
                        ?.call(
                            context, state, _timerCubit.tickDuration.inSeconds),
                    child: TimerBlocBuilder(
                      builder: (context, state) => widget.builder(
                        context,
                        state,
                        controller,
                        _timerCubit.tickDuration.inSeconds,
                      ),
                    ),
                  ),
                )),
      );
}

class TaskTimer extends _TaskTimer {
  const TaskTimer({
    super.key,
    required super.builder,
    super.elapsedTime,
    super.initialTimerStatus,
  });

  TaskTimer.small({
    super.key,
    super.elapsedTime,
    super.initialTimerStatus,
    super.padding,
    super.disabled,
    super.onTimerResume,
    super.onTimerStateChange,
  }) : super(
          builder:
              (context, state, animationController, tickDurationInSeconds) =>
                  _TaskTimerSmall(
            animationController: animationController,
            padding: padding,
            disabled: disabled,
            state: state,
          ),
        );

  TaskTimer.large({
    super.key,
    super.elapsedTime,
    super.initialTimerStatus,
    super.padding,
    super.disabled,
    super.onTimerResume,
    super.onTimerStateChange,
  }) : super(
          builder:
              (context, state, animationController, tickDurationInSeconds) =>
                  _TaskTimerLarge(
            animationController: animationController,
            padding: padding,
            disabled: disabled,
            state: state,
          ),
        );
}

class _TaskTimerSmall extends StatefulWidget {
  const _TaskTimerSmall({
    required this.animationController,
    this.padding,
    required this.disabled,
    required this.state,
  });
  final AnimationController animationController;

  /// Default is
  /// ```dart
  ///EdgeInsets.fromLTRB(
  ///   kPadding.w * 2,
  ///   kPadding.h,
  ///   kPadding.w,
  ///   kPadding.h,
  /// ),
  /// ```
  final EdgeInsetsGeometry? padding;

  final bool disabled;

  final TimerState state;

  @override
  State<_TaskTimerSmall> createState() => __TaskTimerSmallState();
}

class __TaskTimerSmallState extends State<_TaskTimerSmall> {
  late Animation<double> animation;
  Animation<TextStyle>? textStyleAnimation;
  Animation<Color?>? colorAnimation;

  @override
  void initState() {
    super.initState();
    animation =
        Tween<double>(begin: 0.0, end: 1.0).animate(widget.animationController);

    // To access proper context
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final theme = Theme.of(context);
      setState(() {
        textStyleAnimation = TextStyleTween(
          begin: theme.textTheme.titleSmall,
          end: theme.primaryTextTheme.titleSmall,
        ).animate(widget.animationController);

        colorAnimation = ColorTween(
          begin: theme.colorScheme.onSecondaryContainer,
          end: theme.colorScheme.onPrimaryContainer,
        ).animate(widget.animationController);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timerStatus = widget.state.status;
    return TimerBlocListener(
      listenWhen: (prev, current) => prev.status != current.status,
      listener: (context, state) {
        // Listen to status change and trigger animations
        final timerStatus = state.status;
        if (timerStatus == TimesheetStatusEnum.running) {
          widget.animationController.forward();
        } else if ([
          TimesheetStatusEnum.initial,
          TimesheetStatusEnum.paused,
          TimesheetStatusEnum.pausedByForce
        ].contains(timerStatus)) {
          widget.animationController.reverse();
        }
      },
      child: AnimatedContainer(
        duration: animationDurationDefault,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kPadding.r * 8),
          color: timerStatus == TimesheetStatusEnum.running
              ? theme.colorScheme.primaryContainer
              : AppColors.getTintedSurfaceColor(
                  theme.colorScheme.surfaceTint,
                ),
        ),
        child: InkWell(
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kPadding.r * 8),
          ),
          onTap: widget.disabled ? null : () => _onPressed(timerStatus),
          child: Padding(
            padding: widget.padding ??
                EdgeInsets.fromLTRB(
                  kPadding.w * 2,
                  kPadding.h,
                  kPadding.w,
                  kPadding.h,
                ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: kPadding.w * 6,
                  child: textStyleAnimation != null
                      ? ValueListenableBuilder<TextStyle>(
                          valueListenable: textStyleAnimation!,
                          builder: (context, value, child) => Text(
                            widget.state.duration
                                .timerString(DurationFormat.minutesSeconds),
                            style: value,
                          ),
                        )
                      : const SizedBox(),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  icon: colorAnimation != null
                      ? ValueListenableBuilder<Color?>(
                          valueListenable: colorAnimation!,
                          builder: (context, value, child) => AnimatedIcon(
                            icon: AnimatedIcons.play_pause,
                            size: 32.w,
                            progress: animation,
                            // animated color based on controller's value, and it should be animated as well
                            color: value,
                          ),
                        )
                      : const SizedBox(),
                  color: theme.colorScheme.onPrimary,
                  onPressed:
                      widget.disabled ? null : () => _onPressed(timerStatus),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onPressed(TimesheetStatusEnum timerStatus) {
    final timerCubit = context.read<TimerCubit>();
    if (timerStatus == TimesheetStatusEnum.running) {
      timerCubit.pauseTimer();
    } else if ([TimesheetStatusEnum.initial, TimesheetStatusEnum.paused]
        .contains(timerStatus)) {
      if (timerStatus == TimesheetStatusEnum.initial) {
        timerCubit.startTimer();
      } else if (timerStatus == TimesheetStatusEnum.paused) {
        timerCubit.resumeTimer();
      }
    }
  }
}

class _TaskTimerLarge extends StatefulWidget {
  const _TaskTimerLarge(
      {required this.animationController,
      this.padding,
      required this.disabled,
      required this.state});

  final AnimationController animationController;

  /// Default is
  /// ```dart
  ///EdgeInsets.fromLTRB(
  ///   kPadding.w * 2,
  ///   kPadding.h,
  ///   kPadding.w,
  ///   kPadding.h,
  /// ),
  /// ```
  final EdgeInsetsGeometry? padding;

  final bool disabled;

  final TimerState state;

  @override
  State<_TaskTimerLarge> createState() => __TaskTimerLargeState();
}

class __TaskTimerLargeState extends State<_TaskTimerLarge> {
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    animation =
        Tween<double>(begin: 0.0, end: 1.0).animate(widget.animationController);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final timerStatus = widget.state.status;

    return TimerBlocListener(
      listenWhen: (prev, current) => prev.status != current.status,
      listener: (context, state) {
        // Listen to status change and trigger animations
        final timerStatus = state.status;
        if (timerStatus == TimesheetStatusEnum.running) {
          widget.animationController.forward();
        } else if ([
          TimesheetStatusEnum.initial,
          TimesheetStatusEnum.paused,
          TimesheetStatusEnum.pausedByForce,
          TimesheetStatusEnum.stopped,
        ].contains(timerStatus)) {
          widget.animationController.reverse();
        }
      },
      child: Theme(
        data: theme.copyWith(
          iconButtonTheme: IconButtonThemeData(
              style: theme.iconButtonTheme.style?.copyWith(
            backgroundColor: MaterialStatePropertyAll(
              ElevationOverlay.applySurfaceTint(
                theme.colorScheme.primaryContainer,
                theme.colorScheme.surfaceTint,
                2,
              ),
            ),
            shape: const MaterialStatePropertyAll(StadiumBorder()),
            maximumSize: MaterialStatePropertyAll(Size(64.w, 60.h)),
            minimumSize: MaterialStatePropertyAll(Size(64.w, 44.h)),
            padding: const MaterialStatePropertyAll(EdgeInsets.all(kPadding)),
          )),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.state.duration
                  .timerString(DurationFormat.hoursMinutesSeconds),
              style: textTheme.displaySmall,
            ),
            Padding(
              padding: widget.padding ??
                  EdgeInsets.symmetric(
                    horizontal: kPadding.w * 2,
                  ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: AnimatedIcon(
                      icon: AnimatedIcons.play_pause,
                      size: kPadding.w * 3,
                      progress: animation,
                      color: theme.colorScheme.primary,
                    ),
                    onPressed: widget.disabled
                        ? null
                        : () {
                            final timerCubit = context.read<TimerCubit>();
                            if (timerStatus == TimesheetStatusEnum.running) {
                              timerCubit.pauseTimer();
                            } else if ([
                              TimesheetStatusEnum.initial,
                              TimesheetStatusEnum.paused,
                              TimesheetStatusEnum.pausedByForce,
                              TimesheetStatusEnum.stopped
                            ].contains(timerStatus)) {
                              if (timerStatus == TimesheetStatusEnum.initial) {
                                timerCubit.startTimer();
                              } else {
                                timerCubit.resumeTimer();
                              }
                            }
                          },
                  ),
                  SizedBox(
                    width: kPadding.w * 2,
                  ),
                  IconButton(
                    disabledColor: theme.colorScheme.primary.withOpacity(0.5),
                    color: theme.colorScheme.primary,
                    icon: Icon(
                      Icons.stop,
                      size: kPadding.w * 3,
                    ),
                    onPressed: widget.disabled ||
                            timerStatus == TimesheetStatusEnum.initial
                        ? null
                        : () {
                            final timerCubit = context.read<TimerCubit>();
                            timerCubit.stopTimer();
                          },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
