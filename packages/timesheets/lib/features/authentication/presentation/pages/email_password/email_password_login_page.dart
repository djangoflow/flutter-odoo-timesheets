import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/authentication/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progress_builder/progress_builder.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../../app/presentation/app_reactive_dropdown.dart';

class EmailPasswordLoginPage extends StatelessWidget {
  const EmailPasswordLoginPage({
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
              Validators.pattern(
                  r'((https?:www\.)|(https?:\/\/)|(www\.))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?')
            ],
            asyncValidators: [_validServer],
            asyncValidatorsDebounceTime: 500,
            value: serverUrl ?? AuthCubit.instance.state.serverUrl ?? 'https://',
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
  Widget build(BuildContext context) {
    if (serverUrl != null) {
      AuthCubit.instance.loadDbList(serverUrl!);
    } else if (AuthCubit.instance.state.serverUrl != null) {
      AuthCubit.instance.loadDbList(AuthCubit.instance.state.serverUrl!);
    }

    return DefaultActionController(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sign in'),
          leading: const AutoLeadingButton(),
        ),
        body: Center(
          child: SingleChildScrollView(
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
                      AutofillGroup(
                        child: ReactiveTextField<String>(
                          autofocus: true,
                          formControlName: serverUrlControlName,
  Widget build(BuildContext context) => DefaultActionController(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Sign in'),
            leading: const AutoLeadingButton(),
          ),
          body: Center(
            child: SingleChildScrollView(
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
                        AutofillGroup(
                          child: ReactiveTextField(
                            autofocus: true,
                            formControlName: serverUrlControlName,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.url,
                            decoration: const InputDecoration(
                              hintText: 'Server Url',
                              helperText: 'https://www.example.com',
                            ),
                            autofillHints: const [AutofillHints.url],
                            validationMessages: {
                              ValidationMessage.required: (_) =>
                                  'Server Url is required',
                            },
                          ),
                        ),
                        const SizedBox(
                          height: kPadding * 3,
                        ),
                        ReactiveTextField(
                          formControlName: dbControlName,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.url,
                          decoration: const InputDecoration(
                            hintText: 'Server Url',
                            hintText: 'Database',
                            helperText: 'example-db',
                          ),
                          onChanged: (control) {
                            final value = control.value;
                            if (control.valid) {
                              AuthCubit.instance.loadDbList(value!);
                            }
                          },
                          autofillHints: const [AutofillHints.url],
                          validationMessages: {
                            ValidationMessage.required: (_) =>
                                'Server Url is required',
                            ValidationMessage.pattern: (_) =>
                                'Invalid url format',
                            'invalid_server': (_) => 'Invalid server url',
                          },
                        ),
                      ),
                      ReactiveStatusListenableBuilder(
                        builder: (context, control, child) {
                          if (control.pending) {
                            return Column(
                              children: const [
                                SizedBox(
                                  height: kPadding * 2,
                                ),
                                Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ],
                            );
                          } else if (control.value != null && control.valid) {
                            return Column(
                              children: [
                                const SizedBox(
                                  height: kPadding * 2,
                                ),
                                BlocBuilder<AuthCubit, AuthState>(
                                  builder: (context, state) =>
                                      AppReactiveDropdown(
                                    itemAsString: (db) => db.toString(),
                                    items: state.availableDbs,
                                    formControlName: dbControlName,
                                    hintText: 'Select DB',
                                    validationMessages: {
                                      ValidationMessage.required: (_) =>
                                          'Please select DB',
                                    },
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return const Offstage();
                          }
                        },
                        formControlName: serverUrlControlName,
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
      ),
    );
  }

  Future<Map<String, dynamic>?> _validServer(
      AbstractControl<dynamic> control) async {
    final error = {'invalid_server': false};

    try {
      final serverUrl = control.value as String;
      await AuthCubit.instance
          .loadDbList(serverUrl.endsWith('/') ? serverUrl : '$serverUrl/');
      return null;
    } catch (e) {
      control.markAsTouched();
      return error;
    }
  }

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
