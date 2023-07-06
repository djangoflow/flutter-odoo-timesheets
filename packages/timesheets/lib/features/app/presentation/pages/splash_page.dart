import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:flutter/material.dart';
import 'package:timesheets/features/app/app.dart';

@RoutePage()
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
        context.router.replace(const TasksRouter());
      });
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppLogo(
                width: 134.w,
                height: 128.h,
              ),
              SizedBox(
                height: (kPadding * 4).h,
              ),
              Text(
                'Time management without obstacles',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      );
}
