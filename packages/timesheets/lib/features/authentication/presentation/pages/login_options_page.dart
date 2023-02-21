import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/authentication/authentication.dart';
import 'package:djangoflow_app/djangoflow_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginOptionsPage extends StatelessWidget {
  const LoginOptionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: kPadding * 2,
            ),
            child: BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) => Column(
                children: [
                  const SizedBox(
                    height: kPadding * 3,
                  ),
                  const Spacer(),
                  GestureDetector(
                    onLongPress: () =>
                        context.read<AppCubit>().toggleEnvironment(),
                    child: const FlutterLogo(size: kPadding * 20),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        context.router.push(
                          const EmailPasswordLoginRoute(),
                        );
                      },
                      child: const Text('Sign in'),
                    ),
                  ),
                  const SizedBox(
                    height: kPadding * 6,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
