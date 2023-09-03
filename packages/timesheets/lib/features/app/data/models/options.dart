import 'package:flutter/cupertino.dart';

enum Options {
  delete(label: 'Delete', icon: CupertinoIcons.delete),
  favorite(label: 'Mark as Favorite', icon: CupertinoIcons.star_fill),
  unFavorite(label: 'Unmark as Favorite', icon: CupertinoIcons.star);

  final String label;
  final IconData icon;

  const Options({required this.label, required this.icon});
}
