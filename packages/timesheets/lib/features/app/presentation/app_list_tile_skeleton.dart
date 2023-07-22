import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ListTileSkeleton extends StatelessWidget {
  const ListTileSkeleton({super.key, this.effect});
  final PaintingEffect? effect;

  @override
  Widget build(BuildContext context) => Skeletonizer(
        effect: effect,
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
