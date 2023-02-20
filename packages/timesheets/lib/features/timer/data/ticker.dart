// TODO name this to maybe TimeSheetTicker or something to avoid confusion with flutter's ticker
class Ticker {
  const Ticker();

  Stream<int> tick(int goForward) => Stream.periodic(
      const Duration(seconds: 1), (x) => ((goForward - 1) + x + 1));
}
