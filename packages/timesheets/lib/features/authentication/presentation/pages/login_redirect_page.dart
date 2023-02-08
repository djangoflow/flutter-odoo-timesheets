import 'dart:async';

import 'package:timesheets/features/authentication/authentication.dart';
import 'package:auto_route/auto_route.dart';
import 'package:djangoflow_app/djangoflow_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginRedirectPage extends StatefulWidget {
  final String token;

  const LoginRedirectPage({
    Key? key,
    @pathParam required this.token,
  }) : super(key: key);

  @override
  State<LoginRedirectPage> createState() => _LoginRedirectPageState();
}

class _LoginRedirectPageState extends State<LoginRedirectPage> {
  Future<void> _tryLogin() async {
    final router = context.router.root;
    final guardInProgress = router.activeGuardObserver.guardInProgress;
    final authCubit = context.read<AuthCubit>();
    try {
      await authCubit.loginWithMagicLink(
        magiclink: widget.token,
      );
      if (mounted) {
        if (!guardInProgress) {
          await router.replaceNamed('/home');
        }
      }
    } catch (e) {
      if (mounted && router.canNavigateBack) {
        router.navigateBack();
      }
      if (e is FormatException || e is RangeError) {
        DjangoflowAppSnackbar.showError('Wrong or expired secret link');
      } else {
        rethrow;
      }
    }
  }

  @override
  void initState() {
    _tryLogin();

    super.initState();
  }

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: Center(
          child: Text('Logging you in...'),
        ),
      );
}