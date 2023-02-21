import 'package:timesheets/configurations/theme/size_constants.dart';
import 'package:timesheets/features/authentication/authentication.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progress_builder/progress_builder.dart';
import 'package:reactive_forms/reactive_forms.dart';

class EmailPasswordLoginPage extends StatelessWidget {

  const EmailPasswordLoginPage({
    Key? key,
  }) : super(key: key);

  FormGroup _formBuilder() => fb.group({
        'email': FormControl<String>(
          validators: [
            Validators.required,
            Validators.email,
          ],
        ),
        'pass': FormControl<String>(
          validators: [
            Validators.required,
          ],
        ),
      });

  @override
  Widget build(BuildContext context) => DefaultActionController(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Sign in'),
            leading: const AutoLeadingButton(
              showIfParentCanPop: true,
              showIfChildCanPop: true,
              ignorePagelessRoutes: true,
            ),
          ),
          body: Center(
            child: ReactiveFormBuilder(
              form: _formBuilder,
              builder: (context, form, child) => AutofillGroup(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: kPadding * 2,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ReactiveTextField(
                        autofocus: true,
                        formControlName: 'email',
                        textInputAction: TextInputAction.done,
                        textCapitalization: TextCapitalization.none,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: 'Email',
                        ),
                        autofillHints: const [AutofillHints.email],
                        validationMessages: {
                          ValidationMessage.required: (_) =>
                              'Email is required',
                          ValidationMessage.email: (_) => 'Invalid format',
                        },
                        onSubmitted: (_) => form.valid
                            ? DefaultActionController.of(context)
                                ?.add(ActionType.start)
                            : form.markAsTouched(),
                      ),
                      const SizedBox(
                        height: kPadding * 3,
                      ),
                      ReactiveTextField(
                        autofocus: true,
                        formControlName: 'pass',
                        textInputAction: TextInputAction.done,
                        textCapitalization: TextCapitalization.none,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: const InputDecoration(
                          hintText: 'Password',
                        ),
                        autofillHints: const [AutofillHints.password],
                        validationMessages: {
                          ValidationMessage.required: (_) =>
                              'Password is required',
                        },
                        obscureText: true,
                        onSubmitted: (_) => form.valid
                            ? DefaultActionController.of(context)
                                ?.add(ActionType.start)
                            : form.markAsTouched(),
                      ),
                      const SizedBox(
                        height: kPadding * 5,
                      ),
                      LinearProgressBuilder(
                        builder: (context, action, error) => ElevatedButton(
                          onPressed: (ReactiveForm.of(context)?.valid ?? false)
                              ? action
                              : null,
                          child: const Center(child: Text('Login')),
                        ),
                        action: (_) => _signIn(context, form),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );

  Future<void> _signIn(BuildContext context, FormGroup form) async {
    final email = form.control('email').value as String;
    final pass = form.control('pass').value as String;
    await context
        .read<AuthCubit>()
        .loginWithEmailPassword(email: email, password: pass);
  }
}
