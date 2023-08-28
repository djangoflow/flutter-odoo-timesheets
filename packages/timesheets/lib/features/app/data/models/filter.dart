enum FilterEnum {
  newest(label: 'Newest'),
  oldest(label: 'Oldest');

  final String label;
  const FilterEnum({required this.label});
}
