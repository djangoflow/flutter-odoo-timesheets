/// Timer state enum. If you add a new state, make sure to add it to the end of the list.
enum TimerStateEnum {
  initial,
  running,
  pausedByForce,
  paused,
  stopped,
}
