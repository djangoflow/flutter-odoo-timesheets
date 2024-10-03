import 'package:djangoflow_odoo_auth/djangoflow_odoo_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

class LoginListener
    extends BlocListener<DjangoflowOdooAuthCubit, DjangoflowOdooAuthState> {
  LoginListener({
    super.key,
    void Function(BuildContext context, OdooSession? odooSession)? onLogin,
    void Function(BuildContext context)? onLogout,
    super.child,
  }) : super(
          listener: (context, authState) =>
              authState.status == AuthStatus.authenticated
                  ? onLogin?.call(context, authState.session)
                  : onLogout?.call(context),
          // Since AutoLogin will trigger a state change for isLoading
          // we need to listen to it as well as
          // And user state is preserverd in HydratedBloc
          // and only it will not trigger listener when autologin used
          listenWhen: (prev, next) => (next.session != prev.session),
        );
}
