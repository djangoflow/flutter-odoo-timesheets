import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/timer/timer.dart';
import 'package:timesheets/utils/utils.dart';

class TaskTimer extends StatefulWidget {
  /// Builder is used to build the timer widget.
  final Widget Function(
    BuildContext context,
    TimerState state,
    AnimationController animationController,
    int tickDurationInSeconds,
  ) builder;

  /// ElapsedTime is used to set the initial duration of the timer.
  final int? elapsedTime;

  /// InitialTimerStatus is used to set the initial status of the timer.
  final TimerStatus? initialTimerStatus;

  /// OnTimerStateChange is used to notify the parent widget about the timer state change.
  final void Function(
          BuildContext context, TimerState timerState, int tickInterval)?
      onTimerStateChange;

  /// Padding is used to set the padding of the timer widget.
  final EdgeInsetsGeometry? padding;

  /// Disabled is used to disable the timer widget.
  final bool disabled;

  /// OnTimerResume is called when the timer is resumed after being forcibly paused.
  final void Function(BuildContext context)? onTimerResume;

  const TaskTimer({
    super.key,
    required this.builder,
    this.elapsedTime,
    this.initialTimerStatus,
    this.onTimerStateChange,
    this.padding,
    this.disabled = false,
    this.onTimerResume,
  });

  static TaskTimer _createTimer({
    Key? key,
    required Widget Function(BuildContext, TimerState, AnimationController, int)
        builder,
    int? elapsedTime,
    TimerStatus? initialTimerStatus,
    EdgeInsetsGeometry? padding,
    bool disabled = false,
    void Function(BuildContext)? onTimerResume,
    void Function(BuildContext, TimerState, int)? onTimerStateChange,
  }) =>
      TaskTimer(
        key: key,
        elapsedTime: elapsedTime,
        initialTimerStatus: initialTimerStatus,
        padding: padding,
        disabled: disabled,
        onTimerResume: onTimerResume,
        onTimerStateChange: onTimerStateChange,
        builder: builder,
      );

  factory TaskTimer.small({
    Key? key,
    int? elapsedTime,
    TimerStatus? initialTimerStatus,
    EdgeInsetsGeometry? padding,
    bool disabled = false,
    void Function(BuildContext context)? onTimerResume,
    void Function(
            BuildContext context, TimerState timerState, int tickInterval)?
        onTimerStateChange,
  }) =>
      _createTimer(
        key: key,
        elapsedTime: elapsedTime,
        initialTimerStatus: initialTimerStatus,
        padding: padding,
        disabled: disabled,
        onTimerResume: onTimerResume,
        onTimerStateChange: onTimerStateChange,
        builder: (context, state, animationController, tickDurationInSeconds) =>
            TaskTimerSmall(
          animationController: animationController,
          padding: padding,
          disabled: disabled,
          state: state,
        ),
      );

  factory TaskTimer.large({
    Key? key,
    int? elapsedTime,
    TimerStatus? initialTimerStatus,
    EdgeInsetsGeometry? padding,
    bool disabled = false,
    void Function(BuildContext context)? onTimerResume,
    void Function(
            BuildContext context, TimerState timerState, int tickInterval)?
        onTimerStateChange,
  }) =>
      _createTimer(
        key: key,
        elapsedTime: elapsedTime,
        initialTimerStatus: initialTimerStatus,
        padding: padding,
        disabled: disabled,
        onTimerResume: onTimerResume,
        onTimerStateChange: onTimerStateChange,
        builder: (context, state, animationController, tickDurationInSeconds) =>
            TaskTimerLarge(
          animationController: animationController,
          padding: padding,
          disabled: disabled,
          state: state,
        ),
      );

  @override
  State<TaskTimer> createState() => _TaskTimerState();
}

class _TaskTimerState extends State<TaskTimer> with TickerProviderStateMixin {
  late final TimerCubit _timerCubit;
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _timerCubit = TimerCubit(
      initialState: widget.elapsedTime != null
          ? TimerState(
              duration: Duration(seconds: widget.elapsedTime!),
              status: widget.initialTimerStatus ?? TimerStatus.initial)
          : TimerState.initial(),
    );
    _controller = AnimationController(
      vsync: this,
      duration: animationDurationDefault,
    );

    if ([TimerStatus.running, TimerStatus.pausedByForce]
        .contains(widget.initialTimerStatus)) {
      _controller.forward();
      _timerCubit.startTimer();
    }
  }

  @override
  void dispose() {
    print('Disposing TaskTimer');
    _timerCubit.close();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocProvider<TimerCubit>.value(
        value: _timerCubit,
        child: Builder(
          builder: (context) => AppLifeCycleListener(
            onLifeCycleStateChanged: (lifecycleState) =>
                _handleAppLifecycleState(context, lifecycleState),
            child: TimerBlocListener(
              listenWhen: (prev, current) =>
                  prev.duration != current.duration ||
                  prev.status != current.status,
              listener: (context, state) => widget.onTimerStateChange
                  ?.call(context, state, _timerCubit.tickDuration.inSeconds),
              child: TimerBlocBuilder(
                builder: (context, state) => widget.builder(context, state,
                    _controller, _timerCubit.tickDuration.inSeconds),
              ),
            ),
          ),
        ),
      );

  void _handleAppLifecycleState(BuildContext context, AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (_timerCubit.state.status == TimerStatus.pausedByForce) {
        widget.onTimerResume?.call(context);
        _timerCubit.resumeTimer();
      }
    } else {
      if (_timerCubit.state.status == TimerStatus.running) {
        _timerCubit.forcePauseTimer();
      }
    }
  }
}

mixin TimerAnimationMixin<T extends StatefulWidget> on State<T> {
  late Animation<double> animation;
  late Animation<TextStyle> textStyleAnimation;
  late Animation<Color?> colorAnimation;
  bool _animationsInitialized = false;

  void initializeAnimations(
      AnimationController controller, BuildContext context) {
    if (_animationsInitialized) return;

    final theme = Theme.of(context);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(controller);
    textStyleAnimation = TextStyleTween(
      begin: theme.textTheme.titleSmall,
      end: theme.primaryTextTheme.titleSmall,
    ).animate(controller);
    colorAnimation = ColorTween(
      begin: theme.colorScheme.onSecondaryContainer,
      end: theme.colorScheme.onPrimaryContainer,
    ).animate(controller);

    _animationsInitialized = true;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final animationController = getAnimationController();
    if (animationController != null) {
      initializeAnimations(animationController, context);
    }
  }

  AnimationController? getAnimationController();
}

mixin TimerLogicMixin<T extends StatefulWidget> on State<T> {
  void handleTimerStatusChange(
      TimerStatus status, AnimationController controller) {
    if (status == TimerStatus.running) {
      controller.forward();
    } else if ([
      TimerStatus.initial,
      TimerStatus.paused,
      TimerStatus.pausedByForce
    ].contains(status)) {
      controller.reverse();
    }
  }

  void onTimerPressed(TimerStatus timerStatus, TimerCubit timerCubit) {
    if (timerStatus == TimerStatus.running) {
      timerCubit.pauseTimer();
    } else if ([TimerStatus.initial, TimerStatus.paused]
        .contains(timerStatus)) {
      timerStatus == TimerStatus.initial
          ? timerCubit.startTimer()
          : timerCubit.resumeTimer();
    }
  }
}

class TaskTimerSmall extends StatefulWidget {
  final AnimationController animationController;
  final EdgeInsetsGeometry? padding;
  final bool disabled;
  final TimerState state;

  const TaskTimerSmall({
    super.key,
    required this.animationController,
    this.padding,
    required this.disabled,
    required this.state,
  });

  @override
  State<TaskTimerSmall> createState() => _TaskTimerSmallState();
}

class _TaskTimerSmallState extends State<TaskTimerSmall>
    with TimerAnimationMixin, TimerLogicMixin {
  @override
  AnimationController? getAnimationController() => widget.animationController;

  @override
  Widget build(BuildContext context) {
    final timerStatus = widget.state.status;

    return TimerBlocListener(
      listenWhen: (prev, current) => prev.status != current.status,
      listener: (context, state) =>
          handleTimerStatusChange(state.status, widget.animationController),
      child: buildTimerContainer(
        context: context,
        timerStatus: timerStatus,
        disabled: widget.disabled,
        padding: widget.padding,
        onTap: () => onTimerPressed(timerStatus, context.read<TimerCubit>()),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ConfigurableTimerText(
              textStyleAnimation: textStyleAnimation,
              duration: widget.state.duration,
            ),
            TimerIconButton(
              animation: animation,
              colorAnimation: colorAnimation,
              disabled: widget.disabled,
              onPressed: () => onTimerPressed(
                  widget.state.status, context.read<TimerCubit>()),
            ),
          ],
        ),
      ),
    );
  }
}

class TaskTimerLarge extends StatefulWidget {
  final AnimationController animationController;
  final EdgeInsetsGeometry? padding;
  final bool disabled;
  final TimerState state;

  const TaskTimerLarge({
    super.key,
    required this.animationController,
    this.padding,
    required this.disabled,
    required this.state,
  });

  @override
  State<TaskTimerLarge> createState() => _TaskTimerLargeState();
}

class _TaskTimerLargeState extends State<TaskTimerLarge>
    with TimerAnimationMixin, TimerLogicMixin {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  AnimationController? getAnimationController() => widget.animationController;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final timerStatus = widget.state.status;

    return TimerBlocListener(
      listenWhen: (prev, current) => prev.status != current.status,
      listener: (context, state) =>
          handleTimerStatusChange(state.status, widget.animationController),
      child: IconButtonTheme(
        data: _getIconButtonThemeData(theme),
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
                PlayPauseButton(
                  animation: animation,
                  disabled: widget.disabled,
                  timerStatus: timerStatus,
                  onPressed: (status) =>
                      onTimerPressed(status, context.read<TimerCubit>()),
                ),
                SizedBox(width: kPadding.w * 2),
                StopButton(
                  disabled: widget.disabled,
                  timerStatus: timerStatus,
                  onPressed: () => context.read<TimerCubit>().stopTimer(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconButtonThemeData _getIconButtonThemeData(ThemeData theme) =>
      IconButtonThemeData(
        style: AppTheme.getFilledIconButtonTheme(theme).style?.copyWith(
              shape: const WidgetStatePropertyAll(StadiumBorder()),
              maximumSize: WidgetStatePropertyAll(Size(64.w, 60.h)),
              minimumSize: WidgetStatePropertyAll(Size(64.w, 44.h)),
              padding: const WidgetStatePropertyAll(EdgeInsets.all(kPadding)),
            ),
      );
}

class ConfigurableTimerText extends StatelessWidget {
  final Duration duration;
  final Animation<TextStyle>? textStyleAnimation;
  final double digitWidth;
  final double colonWidth;
  final double colonVerticalOffset;

  const ConfigurableTimerText({
    super.key,
    required this.duration,
    required this.textStyleAnimation,
    this.digitWidth = 14.0,
    this.colonWidth = 10.0,
    this.colonVerticalOffset = -2.0,
  });

  @override
  Widget build(BuildContext context) => textStyleAnimation == null
      ? const SizedBox()
      : ValueListenableBuilder<TextStyle>(
          valueListenable: textStyleAnimation!,
          builder: (context, textStyle, child) {
            final formattedParts = _getFormattedTimerParts();
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: formattedParts.map((part) {
                final isColon = part == ':';
                return SizedBox(
                  width: isColon ? colonWidth : digitWidth,
                  child: Center(
                    child: Transform.translate(
                      offset: isColon
                          ? Offset(0, colonVerticalOffset)
                          : Offset.zero,
                      child: Text(
                        part,
                        style: textStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        );

  List<String> _getFormattedTimerParts() {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return [
        ...hours.toString().padLeft(2, '0').split(''),
        ':',
        ...minutes.toString().padLeft(2, '0').split(''),
        ':',
        ...seconds.toString().padLeft(2, '0').split(''),
      ];
    } else if (minutes >= 100) {
      return [
        ...minutes.toString().padLeft(3, '0').split(''),
        ':',
        ...seconds.toString().padLeft(2, '0').split(''),
      ];
    } else {
      return [
        ...minutes.toString().padLeft(2, '0').split(''),
        ':',
        ...seconds.toString().padLeft(2, '0').split(''),
      ];
    }
  }
}

class TimerIconButton extends StatelessWidget {
  final Animation<double> animation;
  final Animation<Color?>? colorAnimation;
  final bool disabled;
  final VoidCallback onPressed;

  const TimerIconButton({
    super.key,
    required this.animation,
    required this.colorAnimation,
    required this.disabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return IconButton(
      padding: EdgeInsets.zero,
      icon: colorAnimation != null
          ? ValueListenableBuilder<Color?>(
              valueListenable: colorAnimation!,
              builder: (context, value, child) => AnimatedIcon(
                icon: AnimatedIcons.play_pause,
                size: 32.w,
                progress: animation,
                color: value ?? theme.colorScheme.onPrimary,
              ),
            )
          : const SizedBox(),
      color: theme.colorScheme.onPrimary,
      onPressed: disabled ? null : onPressed,
    );
  }
}

class PlayPauseButton extends StatelessWidget {
  final Animation<double> animation;
  final bool disabled;
  final TimerStatus timerStatus;
  final Function(TimerStatus) onPressed;

  const PlayPauseButton({
    super.key,
    required this.animation,
    required this.disabled,
    required this.timerStatus,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.play_pause,
        size: kPadding.w * 3,
        progress: animation,
        color: theme.colorScheme.primary,
      ),
      onPressed: disabled ? null : () => onPressed(timerStatus),
    );
  }
}

class StopButton extends StatelessWidget {
  final bool disabled;
  final TimerStatus timerStatus;
  final VoidCallback onPressed;

  const StopButton({
    super.key,
    required this.disabled,
    required this.timerStatus,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return IconButton(
      disabledColor: theme.colorScheme.primary.withOpacity(0.5),
      color: theme.colorScheme.primary,
      icon: Icon(Icons.stop, size: kPadding.w * 3),
      onPressed:
          disabled || timerStatus == TimerStatus.initial ? null : onPressed,
    );
  }
}

Widget buildTimerContainer({
  required BuildContext context,
  required TimerStatus timerStatus,
  required Widget child,
  required VoidCallback onTap,
  required bool disabled,
  EdgeInsetsGeometry? padding,
}) {
  final theme = Theme.of(context);
  return AnimatedContainer(
    duration: animationDurationDefault,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(kPadding.r * 8),
      color: timerStatus == TimerStatus.running
          ? theme.colorScheme.primaryContainer
          : AppColors.getTintedSurfaceColor(theme.colorScheme.surfaceTint),
    ),
    child: InkWell(
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kPadding.r * 8),
      ),
      onTap: disabled ? null : onTap,
      child: Padding(
        padding: padding ??
            EdgeInsets.fromLTRB(
                kPadding.w * 2, kPadding.h, kPadding.w, kPadding.h),
        child: child,
      ),
    ),
  );
}
