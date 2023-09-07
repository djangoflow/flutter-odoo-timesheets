abstract class ByIdFilter<IdType> {
  final IdType id;

  ByIdFilter({required this.id});

  copyWithId(int id);
}
