import 'package:timesheets/configurations/configurations.dart';
import 'package:flutter/material.dart';
import 'package:timesheets/features/app/presentation/app_logo.dart';

class SplashPage extends StatefulWidget {
  final Color backgroundColor;

  const SplashPage({Key? key, required this.backgroundColor}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  static const _kDuration = Duration(milliseconds: 700);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(_kDuration).then((value) {
        context.router.replace(const TasksRouterRoute());
      });
    });
  }

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: Center(
          child: AppLogoWidget(
            size: kPadding * 28,
          ),
        ),
      );
}
