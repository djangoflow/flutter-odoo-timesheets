import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class LoginSheet extends StatelessWidget {
  const LoginSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const SafeArea(
        bottom: true,
        child: Scaffold(
          body: AutoRouter(),
        ),
      );
}
