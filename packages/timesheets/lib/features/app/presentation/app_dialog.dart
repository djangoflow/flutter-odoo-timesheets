import 'package:flutter/cupertino.dart';
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
                context.router.pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) => const Placeholder();
}
