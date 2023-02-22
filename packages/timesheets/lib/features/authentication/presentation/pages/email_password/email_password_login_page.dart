import 'package:timesheets/configurations/theme/size_constants.dart';
import 'package:timesheets/features/authentication/authentication.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progress_builder/progress_builder.dart';
import 'package:reactive_forms/reactive_forms.dart';

class EmailPasswordLoginPage extends StatelessWidget {
  const EmailPasswordLoginPage({super.key, @pathParam this.serverUrl});

  final String? serverUrl;

  final _emailControlName = 'email';
  final _passControlName = 'pass';
  final _serverUrlControlName = 'serverUrl';

  FormGroup _formBuilder() => fb.group(
        {
          _emailControlName: FormControl<String>(
            validators: [
              Validators.required,
              Validators.email,
            ],
          ),
          _passControlName: FormControl<String>(
            validators: [
              Validators.required,
            ],
          ),
          _serverUrlControlName: FormControl<String>(
            validators: [
              Validators.required,
            ],
            value: serverUrl,
          ),
        },
      );

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
                        formControlName: _emailControlName,
                        textInputAction: TextInputAction.next,
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
                        formControlName: _passControlName,
                        textInputAction: TextInputAction.next,
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
                        height: kPadding * 3,
                      ),
                      AutofillGroup(
                        child: ReactiveTextField(
                          formControlName: _serverUrlControlName,
                          textInputAction: TextInputAction.done,
                          textCapitalization: TextCapitalization.none,
                          keyboardType: TextInputType.url,
                          decoration: const InputDecoration(
                            hintText: 'Server Url',
                          ),
                          autofillHints: const [AutofillHints.url],
                          validationMessages: {
                            ValidationMessage.required: (_) =>
                                'Server Url is required',
                          },
                          onSubmitted: (_) => form.valid
                              ? DefaultActionController.of(context)
                                  ?.add(ActionType.start)
                              : form.markAsTouched(),
                        ),
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
    final email = form.control(_emailControlName).value as String;
    final pass = form.control(_passControlName).value as String;
    String serverUrl = form.control(_serverUrlControlName).value as String;
    if(!serverUrl.endsWith('/')){
      serverUrl += '/';
    }

    await context.read<AuthCubit>().loginWithEmailPassword(
          email: email,
          password: pass,
          serverUrl: serverUrl,
        );
  }
}
