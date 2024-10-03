import 'package:djangoflow_odoo_auth/djangoflow_odoo_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:timesheets/features/authentication/authentication.dart';

class LoginListenerWrapper extends StatefulWidget {
  const LoginListenerWrapper({
    super.key,
    this.onLogin,
    this.onLogout,
    required this.child,
  });
  final Function(BuildContext context, OdooSession? odooSession)? onLogin;
  final Function(BuildContext context)? onLogout;
  final Widget child;

  @override
  State<LoginListenerWrapper> createState() => _LoginListenerWrapperState();
}

class _LoginListenerWrapperState extends State<LoginListenerWrapper> {
  @override
  void initState() {
    super.initState();
    final currentSession =
        context.read<DjangoflowOdooAuthCubit>().state.session;
    if (currentSession != null) {
      widget.onLogin?.call(context, currentSession);
    }
  }

  @override
  Widget build(BuildContext context) => LoginListener(
        onLogin: widget.onLogin,
        onLogout: widget.onLogout,
        child: widget.child,
      );
}
