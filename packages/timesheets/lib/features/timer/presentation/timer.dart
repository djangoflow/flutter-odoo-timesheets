import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/timer/timer.dart';
import 'package:timesheets/utils/utils.dart';

abstract class _Timer extends StatefulWidget {
  const _Timer({
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
  final void Function(
          BuildContext context, TimerState timerState, int tickInterval)?
      onTimerStateChange;

  /// padding is used to set the padding of the timer widget.
  final EdgeInsetsGeometry? padding;

  /// disabled is used to disable the timer widget.
  final bool disabled;

  final void Function(BuildContext context)? onTimerResume;

  @override
  State<_Timer> createState() => __TimerState();
}

class __TimerState extends State<_Timer> with TickerProviderStateMixin {
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

class Timer extends _Timer {
  const Timer({
    super.key,
    required super.builder,
    super.elapsedTime,
    super.initialTimerStatus,
  });

  Timer.small({
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
                  _TimerSmall(
            animationController: animationController,
            padding: padding,
            disabled: disabled,
            state: state,
          ),
        );

  Timer.large({
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
                  _TimerLarge(
            animationController: animationController,
            padding: padding,
            disabled: disabled,
            state: state,
          ),
        );
}

class _TimerSmall extends StatefulWidget {
  const _TimerSmall({
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
  State<_TimerSmall> createState() => __TimerSmallState();
}

class __TimerSmallState extends State<_TimerSmall> {
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
      if (mounted) {
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
      }
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

  void _onPressed(TimerStatus timerStatus) {
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
  }
}

class _TimerLarge extends StatefulWidget {
  const _TimerLarge(
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
  State<_TimerLarge> createState() => __TimerLargeState();
}

class __TimerLargeState extends State<_TimerLarge> {
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
          TimerStatus.pausedByForce,
          TimerStatus.stopped,
        ].contains(timerStatus)) {
          widget.animationController.reverse();
        }
      },
      child: IconButtonTheme(
        data: IconButtonThemeData(
          style: AppTheme.getFilledIconButtonTheme(theme).style?.copyWith(
                shape: const MaterialStatePropertyAll(StadiumBorder()),
                maximumSize: MaterialStatePropertyAll(Size(64.w, 60.h)),
                minimumSize: MaterialStatePropertyAll(Size(64.w, 44.h)),
                padding:
                    const MaterialStatePropertyAll(EdgeInsets.all(kPadding)),
              ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.state.duration
                  .timerString(DurationFormat.hoursMinutesSeconds),
              style: textTheme.displaySmall,
            ),
            Row(
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
                          if (timerStatus == TimerStatus.running) {
                            timerCubit.pauseTimer();
                          } else if ([
                            TimerStatus.initial,
                            TimerStatus.paused,
                            TimerStatus.pausedByForce,
                            TimerStatus.stopped
                          ].contains(timerStatus)) {
                            if (timerStatus == TimerStatus.initial) {
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
                  onPressed:
                      widget.disabled || timerStatus == TimerStatus.initial
                          ? null
                          : () {
                              final timerCubit = context.read<TimerCubit>();
                              timerCubit.stopTimer();
                            },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
