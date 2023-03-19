import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/authentication/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progress_builder/progress_builder.dart';
import 'package:reactive_forms/reactive_forms.dart';

class OdooLoginPage extends StatelessWidget {
  const OdooLoginPage({
    super.key,
    @queryParam this.serverUrl,
    @queryParam this.db,
  });

  final String? serverUrl;
  final String? db;

  FormGroup _formBuilder() => fb.group(
        {
          emailControlName: FormControl<String>(
            validators: [
              Validators.required,
              Validators.email,
            ],
          ),
          passControlName: FormControl<String>(
            validators: [
              Validators.required,
            ],
          ),
          serverUrlControlName: FormControl<String>(
            validators: [
              Validators.required,
            ],
            value: serverUrl ?? AuthCubit.instance.state.serverUrl,
          ),
          dbControlName: FormControl<String>(
            validators: [
              Validators.required,
            ],
            value: db ?? AuthCubit.instance.state.db,
          ),
        },
      );

  @override
  Widget build(BuildContext context) => DefaultActionController(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Odoo Login'),
            centerTitle: true,
            leadingWidth: kPadding * 9,
            leading: Row(
              children: const [
                SizedBox(width: kPadding * 2),
                IconCard(
                  child: AutoLeadingButton(),
                ),
              ],
            ),
          ),
          body: ReactiveFormBuilder(
            form: _formBuilder,
            builder: (context, form, child) => AutofillGroup(
              child: Padding(
                padding: const EdgeInsets.all(
                  kPadding * 2,
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          AutofillGroup(
                            child: ReactiveTextField(
                              autofocus: true,
                              formControlName: serverUrlControlName,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.url,
                              decoration: const InputDecoration(
                                hintText: 'Server Url',
                              ),
                              autofillHints: const [AutofillHints.url],
                              validationMessages: {
                                ValidationMessage.required: (_) =>
                                    'Server Url is required',
                              },
                            ),
                          ),
                          const SizedBox(
                            height: kPadding * 2,
                          ),
                          ReactiveTextField(
                            formControlName: dbControlName,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              hintText: 'Database',
                            ),
                            validationMessages: {
                              ValidationMessage.required: (_) =>
                                  'Database is required',
                            },
                          ),
                          const SizedBox(
                            height: kPadding * 2,
                          ),
                          ReactiveTextField(
                            formControlName: emailControlName,
                            textInputAction: TextInputAction.next,
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
                          ),
                          const SizedBox(
                            height: kPadding * 2,
                          ),
                          ReactiveTextField(
                            formControlName: passControlName,
                            textInputAction: TextInputAction.done,
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
                            onSubmitted: (_) {
                              if (!form.valid) {
                                form.markAsTouched();
                              } else {
                                DefaultActionController.of(context)
                                    ?.add(ActionType.start);
                              }
                            },
                          ),
                        ],
                      ),
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
      );

  Future<void> _signIn(BuildContext context, FormGroup form) async {
    final email = form.control(emailControlName).value as String;
    final pass = form.control(passControlName).value as String;
    String serverUrl = form.control(serverUrlControlName).value as String;
    final db = form.control(dbControlName).value as String;
    if (!serverUrl.endsWith('/')) {
      serverUrl += '/';
    }

    await context.read<AuthCubit>().loginWithEmailPassword(
          email: email,
          password: pass,
          serverUrl: serverUrl,
          db: db,
        );
  }
}
