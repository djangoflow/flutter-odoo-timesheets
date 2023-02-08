import 'package:timesheets/configurations/theme/size_constants.dart';
import 'package:timesheets/features/authentication/authentication.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progress_builder/progress_builder.dart';
import 'package:reactive_forms/reactive_forms.dart';

class EmailOTPRequestPage extends StatelessWidget {
  final String? email;
  final Function(String email) onSubmit;
  const EmailOTPRequestPage({
    Key? key,
    this.email,
    required this.onSubmit,
  }) : super(key: key);

  FormGroup _formBuilder() => fb.group({
        'email': FormControl<String>(
          validators: [
            Validators.required,
            Validators.email,
          ],
          value: email,
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const SizedBox(
                        height: kPadding * 3,
                      ),
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
                      LinearProgressBuilder(
                        builder: (context, action, error) => ElevatedButton(
                          onPressed: (ReactiveForm.of(context)?.valid ?? false)
                              ? action
                              : null,
                          child:
                              const Center(child: Text('Request login code')),
                        ),
                        action: (_) async {
                          final email = form.control('email').value as String;
                          // await request the code
                          await context.read<AuthCubit>().requestOTP(
                                email: email,
                              );
                          onSubmit(email);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}