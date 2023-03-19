import 'package:flutter/material.dart';

import '../../../configurations/configurations.dart';

class IconCard extends StatelessWidget {
  const IconCard({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) => Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kPadding),
      ),
      elevation: kPadding / 2,
      child: child,
    );
}
