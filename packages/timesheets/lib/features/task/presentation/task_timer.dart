import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/timer/blocs/timer_cubit/timer_cubit.dart';
import 'package:timesheets/features/timer/presentation/timer_bloc_builder.dart';
import 'package:timesheets/features/timer/presentation/timer_bloc_listener.dart';
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
  final TimerStatus? initialTimerStatus;

  /// onTimerStateChange is used to notify the parent widget about the timer state change.
  final void Function(TimerState timerState, int tickInterval)?
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
              status: widget.initialTimerStatus ?? TimerStatus.initial)
          : TimerState.initial(),
    );
    controller = AnimationController(
      vsync: this,
      duration: animationDurationDefault,
    );

    if ([TimerStatus.running, TimerStatus.pausedByForce]
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
                          TimerStatus.pausedByForce) {
                        widget.onTimerResume?.call(context);
                        _timerCubit.resumeTimer();
                      }
                    } else {
                      if (_timerCubit.state.status == TimerStatus.running) {
                        _timerCubit.forcePauseTimer();
                      }
                    }
                  },
                  child: TimerBlocListener(
                    listenWhen: (prev, current) =>
                        prev.duration != current.duration ||
                        prev.status != current.status,
                    listener: (context, state) => widget.onTimerStateChange
                        ?.call(state, _timerCubit.tickDuration.inSeconds),
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
          begin: theme.colorScheme.primary,
          end: theme.colorScheme.onPrimary,
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
        if (timerStatus == TimerStatus.running) {
          widget.animationController.forward();
        } else if ([
          TimerStatus.initial,
          TimerStatus.paused,
          TimerStatus.pausedByForce
        ].contains(timerStatus)) {
          widget.animationController.reverse();
        }
      },
      child: AnimatedContainer(
        duration: animationDurationDefault,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kPadding.r * 8),
          color: timerStatus == TimerStatus.running
              ? theme.colorScheme.primary
              : ElevationOverlay.applySurfaceTint(
                  theme.colorScheme.primaryContainer,
                  theme.colorScheme.surfaceTint,
                  4,
                ),
        ),
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
                onPressed: widget.disabled
                    ? null
                    : () {
                        final timerCubit = context.read<TimerCubit>();
                        if (timerStatus == TimerStatus.running) {
                          timerCubit.pauseTimer();
                        } else if ([TimerStatus.initial, TimerStatus.paused]
                            .contains(timerStatus)) {
                          if (timerStatus == TimerStatus.initial) {
                            timerCubit.startTimer();
                          } else if (timerStatus == TimerStatus.paused) {
                            timerCubit.resumeTimer();
                          }
                        }
                      },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TaskTimerLarge extends StatefulWidget {
  const _TaskTimerLarge(
      {super.key,
      required this.animationController,
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
        if (timerStatus == TimerStatus.running) {
          widget.animationController.forward();
        } else if ([
          TimerStatus.initial,
          TimerStatus.paused,
          TimerStatus.pausedByForce
        ].contains(timerStatus)) {
          widget.animationController.reverse();
        }
      },
      child: Column(
        children: [
          Text(
            widget.state.duration
                .timerString(DurationFormat.hoursMinutesSeconds),
            style: textTheme.displaySmall,
          ),
          SizedBox(
            height: kPadding.h,
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
                  style: IconButton.styleFrom(
                    backgroundColor: ElevationOverlay.applySurfaceTint(
                      theme.colorScheme.primaryContainer,
                      theme.colorScheme.surfaceTint,
                      2,
                    ),
                    shape: const StadiumBorder(),
                    maximumSize: Size(64.w, 44.h),
                    minimumSize: Size(64.w, 44.h),
                    padding: const EdgeInsets.all(kPadding),
                  ),
                  icon: AnimatedIcon(
                    icon: AnimatedIcons.play_pause,
                    size: 32.w,
                    progress: animation,
                    color: theme.colorScheme.primary,
                  ),
                  onPressed: widget.disabled
                      ? null
                      : () {
                          final timerCubit = context.read<TimerCubit>();
                          if (timerStatus == TimerStatus.running) {
                            timerCubit.pauseTimer();
                          } else if ([TimerStatus.initial, TimerStatus.paused]
                              .contains(timerStatus)) {
                            if (timerStatus == TimerStatus.initial) {
                              timerCubit.startTimer();
                            } else if (timerStatus == TimerStatus.paused) {
                              timerCubit.resumeTimer();
                            }
                          }
                        },
                ),
                SizedBox(
                  width: kPadding.w * 2,
                ),
                IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: ElevationOverlay.applySurfaceTint(
                      theme.colorScheme.primaryContainer,
                      theme.colorScheme.surfaceTint,
                      2,
                    ),
                    shape: const StadiumBorder(),
                    maximumSize: Size(64.w, 44.h),
                    minimumSize: Size(64.w, 44.h),
                    padding: const EdgeInsets.all(kPadding),
                  ),
                  icon: Icon(
                    Icons.stop,
                    size: kPadding.w * 4,
                    color: theme.colorScheme.primary,
                  ),
                  onPressed: widget.disabled
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
    );
  }
}
