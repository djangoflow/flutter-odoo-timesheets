import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/authentication/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progress_builder/progress_builder.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:countdown_widget/countdown_widget.dart';

class EmailOTPLoginPage extends StatelessWidget {
  final String email;
  final Duration cooldown;
  final VoidCallback onBack;
  final VoidCallback onLogin;

  const EmailOTPLoginPage({
    Key? key,
    required this.email,
    required this.cooldown,
    required this.onBack,
    required this.onLogin,
  }) : super(key: key);

  FormGroup _formBuilder() => fb.group({
        'otp': FormControl<String>(
          validators: [
            Validators.required,
            Validators.minLength(6),
            Validators.maxLength(6),
          ],
        ),
      });

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async {
          onBack();
          return true;
        },
        child: DefaultActionController(
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Sign in'),
              leading: const AutoLeadingButton(
                showIfParentCanPop: true,
                showIfChildCanPop: true,
                ignorePagelessRoutes: true,
              ),
            ),
            body: ReactiveFormBuilder(
              form: _formBuilder,
              builder: (context, form, child) => AutofillGroup(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: kPadding * 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: kPadding * 3),
                      Text(
                        'Enter your otp',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: kPadding * 3),
                      ReactiveTextField(
                        autofocus: true,
                        formControlName: 'otp',
                        textInputAction: TextInputAction.done,
                        textCapitalization: TextCapitalization.characters,
                        decoration: const InputDecoration(
                          hintText: 'One-time code',
                        ),
                        keyboardType: TextInputType.number,
                        autofillHints: const [AutofillHints.oneTimeCode],
                        validationMessages: {
                          ValidationMessage.required: (_) =>
                              'This field is required',
                          ValidationMessage.minLength: (_) =>
                              'Please provide 6 digit OTP',
                          ValidationMessage.maxLength: (_) =>
                              'Please provide 6 digit OTP',
                        },
                        onSubmitted: (_) => form.valid
                            ? DefaultActionController.of(context)
                                ?.add(ActionType.start)
                            : form.markAsTouched(),
                      ),
                      const SizedBox(height: kPadding * 3),
                      CountDownWidget(
                        duration: cooldown,
                        builder: (context, duration) => duration.inSeconds > 0
                            ? ElevatedButton(
                                onPressed: null,
                                child: Center(
                                    child: Text(
                                        'Request new code in ${duration.inSeconds}')))
                            : ElevatedButton(
                                onPressed: onBack,
                                child: const Center(
                                    child: Text('Request new code')),
                              ),
                      ),
                      const SizedBox(height: kPadding * 3),
                      LinearProgressBuilder(
                        onSuccess: onLogin,
                        builder: (context, action, error) => ElevatedButton(
                          onPressed: (ReactiveForm.of(context)?.valid ?? false)
                              ? action
                              : null,
                          child: const Center(child: Text('Sign in')),
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
    final otp = form.control('otp').value as String;
    await context.read<AuthCubit>().loginWithEmailOTP(email: email, otp: otp);
  }
}