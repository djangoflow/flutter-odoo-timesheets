import 'package:flutter/material.dart';
import 'package:timesheets/features/odoo/odoo.dart';

import 'login_listener.dart';

/// Checks for intialUser, if available then triggers onLogin callback,
/// as `BlocListener` doesn't listen to intial state
class LoginListenerWrapper extends StatefulWidget {
  const LoginListenerWrapper({
    super.key,
    this.onLogin,
    this.onLogout,
    required this.child,
    required this.initialUser,
  });
  final OdooUser? initialUser;
  final void Function(BuildContext context, OdooUser user)? onLogin;
  final void Function(BuildContext context)? onLogout;
  final Widget child;
  @override
  State<LoginListenerWrapper> createState() => _LoginListenerWrapperState();
}

class _LoginListenerWrapperState extends State<LoginListenerWrapper> {
  @override
  void initState() {
    super.initState();
    if (widget.initialUser != null) {
      widget.onLogin?.call(context, widget.initialUser!);
    }
  }

  @override
  Widget build(BuildContext context) => LoginListener(
        onLogin: widget.onLogin,
        onLogout: widget.onLogout,
        child: widget.child,
      );
}
