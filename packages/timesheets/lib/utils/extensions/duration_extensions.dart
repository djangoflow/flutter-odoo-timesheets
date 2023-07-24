extension DurationExtension on Duration {
  String timerString(DurationFormat format) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final hours = inHours;
    final minutes = format == DurationFormat.minutesSeconds
        ? inMinutes
        : inMinutes.remainder(60);
    final seconds = inSeconds.remainder(60);

    String twoDigitHours = twoDigits(hours);
    String twoDigitMinutes = twoDigits(minutes);
    String twoDigitSeconds = twoDigits(seconds);

    if (format == DurationFormat.hoursMinutesSeconds) {
      return '$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds';
    } else if (format == DurationFormat.minutesSeconds) {
      return '$twoDigitMinutes:$twoDigitSeconds';
    } else {
      throw ArgumentError('Invalid format provided.');
    }
  }
}

enum DurationFormat {
  hoursMinutesSeconds,
  minutesSeconds,
}
