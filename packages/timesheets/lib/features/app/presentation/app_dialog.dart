import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timesheets/configurations/configurations.dart';

class AppDialog extends StatelessWidget {
  const AppDialog({super.key});

  static Future showSuccessDialog({
    required BuildContext context,
    String? title,
    String? content,
  }) =>
      showCupertinoDialog<void>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text(title ?? 'Success'),
          content: Text(content ?? 'Operation was successful.'),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              onPressed: () {
                context.router.maybePop();
              },
              textStyle: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              child: const Text('OK'),
            ),
          ],
        ),
      );

  static Future<bool?> showConfirmationDialog({
    required BuildContext context,
    String? affirmativeText,
    String? negativeText,
    required String titleText,
    required String contentText,
  }) =>
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text(titleText),
          content: Text(
            contentText,
          ),
          actions: [
            CupertinoDialogAction(
              child: Text(negativeText ?? 'No',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                  )),
              onPressed: () => context.router.maybePop(false),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: Text(affirmativeText ?? 'Yes'),
              onPressed: () {
                context.router.maybePop(true);
              },
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) => const Placeholder();
}
