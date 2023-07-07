typedef ListLoader<T, F> = Future<List<T>> Function([F? filter]);
typedef DataLoader<T, F> = Future<T> Function([F? filter]);

class ListBlocUtil {
  static ListLoader<T, F> listLoader<T, F>(
          {required Future<List<T>> Function([F? filter]) loader}) =>
      loader;

  static DataLoader<T, F> dataLoader<T, F>(
          {required Future<T> Function([F? filter]) loader}) =>
      loader;
}
