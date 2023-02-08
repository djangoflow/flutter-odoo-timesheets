import 'package:timesheets/configurations/constants.dart';
import 'package:timesheets/configurations/router/router.dart';
import 'package:timesheets/utils/utils.dart';
import 'package:flutter/material.dart';

class EmailOTPLoginWrapperPage extends StatefulWidget {
  const EmailOTPLoginWrapperPage({
    Key? key,
  }) : super(key: key);

  @override
  State<EmailOTPLoginWrapperPage> createState() =>
      _EmailOTPLoginWrapperPageState();
}

class _EmailOTPLoginWrapperPageState extends State<EmailOTPLoginWrapperPage>
    with MountedSetState {
  String _email = '';
  bool _otpRequested = false;

  @override
  Widget build(context) => AutoRouter.declarative(
        routes: (handler) => [
          EmailOTPRequestRoute(
            email: _email,
            onSubmit: (email) {
              mountedSetState(() {
                _email = email;
                _otpRequested = true;
              });
            },
          ),
          if (_otpRequested)
            EmailOTPLoginRoute(
                email: _email,
                cooldown: const Duration(seconds: kCodeResendDuration),
                onLogin: () async {
                  if (mounted) {
                    final router = context.router.root;
                    if (!router.activeGuardObserver.guardInProgress) {
                      await router.replaceNamed('/home');
                    }
                  }
                },
                onBack: () {
                  mountedSetState(() {
                    _otpRequested = false;
                  });
                }),
        ],
      );
}