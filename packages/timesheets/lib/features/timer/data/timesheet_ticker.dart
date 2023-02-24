class TimeSheetTicker {
  const TimeSheetTicker();

  Stream<int> tick(int goForward) => Stream.periodic(
      const Duration(seconds: 1), (x) => ((goForward - 1) + x + 1));
}
