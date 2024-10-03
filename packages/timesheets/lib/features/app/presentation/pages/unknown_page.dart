import 'package:timesheets/configurations/router/router.dart';
import 'package:timesheets/configurations/theme/size_constants.dart';
import 'package:flutter/material.dart';
import 'package:timesheets/features/app/app.dart';

@RoutePage()
class UnknownRoutePage extends StatelessWidget {
  const UnknownRoutePage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GradientScaffold(
      appBar: AppBar(
        title: const Text('Unknown Route'),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(kPadding * 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Whoops!',
              style: textTheme.titleMedium,
            ),
            const Text(
                'Looks like we could not find what you are looking for!'),
            TextButton(
              onPressed: () {
                final router = context.router;

                if (router.canNavigateBack) {
                  router.back();
                } else {
                  router.replace(const HomeTabRouter());
                }
              },
              child: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
