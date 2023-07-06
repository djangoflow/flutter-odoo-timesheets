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
  final Widget Function(
    BuildContext context,
    TimerState state,
    AnimationController animationController,
    int tickDurationInSeconds,
  ) builder;
  final int? elapsedTime;
  final TimerStatus? initialTimerStatus;
  final void Function(TimerState timerState, int tickInterval)?
      onTimerStateChange;
  final EdgeInsetsGeometry? padding;
  final bool disabled;
  const _TaskTimer({
    super.key,
    required this.builder,
    this.elapsedTime,
    this.initialTimerStatus,
    this.onTimerStateChange,
    this.padding,
    this.disabled = false,
  });

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

    if (widget.initialTimerStatus == TimerStatus.running) {
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
  Widget build(BuildContext context) => AppLifeCycleListener(
        onLifeCycleStateChanged: (appLifecycleState) {
          if (appLifecycleState == AppLifecycleState.resumed) {
            if (_timerCubit.state.status == TimerStatus.pausedByForce) {
              _timerCubit.resumeTimer();
            }
          } else {
            if (_timerCubit.state.status == TimerStatus.running) {
              _timerCubit.forcePauseTimer();
            }
          }
        },
        child: BlocProvider<TimerCubit>.value(
          value: _timerCubit,
          child: TimerBlocBuilder(
            builder: (context, state) => widget.builder(
              context,
              state,
              controller,
              _timerCubit.tickDuration.inSeconds,
            ),
          ),
        ),
      );
}

class TaskTimer extends _TaskTimer {
  const TaskTimer({
    super.key,
    required super.builder,
    super.elapsedTime,
    super.initialTimerStatus,
    super.onTimerStateChange,
  });

  TaskTimer.small({
    super.key,
    super.elapsedTime,
    super.initialTimerStatus,
    super.onTimerStateChange,
    super.padding,
    super.disabled,
  }) : super(
          builder:
              (context, state, animationController, tickDurationInSeconds) =>
                  _TaskTimerSmall(
            animationController: animationController,
            padding: padding,
            disabled: disabled,
            onTimerStateChange: onTimerStateChange != null
                ? (currentState) =>
                    onTimerStateChange(currentState, tickDurationInSeconds)
                : null,
          ),
        );
}

class _TaskTimerSmall extends StatefulWidget {
  const _TaskTimerSmall({
    required this.animationController,
    this.padding,
    required this.disabled,
    this.onTimerStateChange,
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

  final void Function(TimerState timerState)? onTimerStateChange;
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
      child: TimerBlocListener(
        listenWhen: (prev, current) =>
            prev.duration != current.duration || prev.status != current.status,
        listener: (context, state) => widget.onTimerStateChange?.call(state),
        child: TimerBlocBuilder(
          builder: (context, state) {
            final timerStatus = state.status;

            return AnimatedContainer(
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
                                state.duration.timerString,
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
                              } else if ([
                                TimerStatus.initial,
                                TimerStatus.paused
                              ].contains(timerStatus)) {
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
            );
          },
        ),
      ),
    );
  }
}
