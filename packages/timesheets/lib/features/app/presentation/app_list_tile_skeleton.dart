import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ListTileSkeleton extends StatelessWidget {
  const ListTileSkeleton({super.key});

  @override
  Widget build(BuildContext context) => Skeletonizer(
        ignoreContainers: true,
        child: ListTile(
          tileColor:
              Theme.of(context).colorScheme.primaryContainer.withOpacity(.24),
          title: const Text('Some text'),
          subtitle: const Text('Some subtitle but longer'),
          trailing: const Icon(Icons.chevron_right),
        ),
      );
}
