class Ticker {
  const Ticker();

  Stream<int> tick(int goForward) => Stream.periodic(
      const Duration(seconds: 1), (x) => ((goForward - 1) + x + 1));
}
