enum FilterEnum {
  newest(label: 'Recent'),
  oldest(label: 'Oldest');

  final String label;
  const FilterEnum({required this.label});
}
