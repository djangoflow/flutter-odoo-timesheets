import 'package:djangoflow_scrollable_column/djangoflow_scrollable_column.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progress_builder/progress_builder.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:djangoflow_odoo_auth/djangoflow_odoo_auth.dart';
import 'package:timesheets/features/sync/sync.dart';

@RoutePage()
class OdooLoginPage extends StatefulWidget {
  const OdooLoginPage({
    super.key,
    @queryParam this.serverUrl,
    @queryParam this.db,
    this.onLoginSuccess,
  });

  final String? serverUrl;
  final String? db;
  final void Function(bool success)? onLoginSuccess;

  @override
  State<OdooLoginPage> createState() => _OdooLoginPageState();
}

class _OdooLoginPageState extends State<OdooLoginPage> {
  final _showPassword = ValueNotifier<bool>(false);

  FormGroup _formBuilder(BuildContext context) => fb.group(
        {
          emailControlName: FormControl<String>(
            validators: [Validators.required, Validators.email],
          ),
          passControlName: FormControl<String>(
            validators: [Validators.required],
          ),
          serverUrlControlName: FormControl<String>(
            validators: [
              Validators.required,
              Validators.pattern(
                  r'((https?:www\.)|(https?:\/\/)|(www\.))[-a-zA-Z0-9@:%._\+~#=]{1,256}(\.[a-zA-Z0-9]{1,6})?|localhost|(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})(:\d+)?(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?')
            ],
            asyncValidators: [
              _ValidServerAsyncValidator(
                getDbListMethod: (url) {
                  context.read<DjangoflowOdooAuthCubit>().setBaseUrl(url);
                  return context.read<DjangoflowOdooAuthCubit>().fetchDbList();
                },
              )
            ],
            asyncValidatorsDebounceTime: 500,
            value: widget.serverUrl ??
                context.read<DjangoflowOdooAuthCubit>().state.baseUrl ??
                'https://',
          ),
          dbControlName: FormControl<String>(
            validators: [Validators.required],
            value: widget.db ??
                context.read<DjangoflowOdooAuthCubit>().state.database,
          ),
        },
      );

  @override
  void dispose() {
    _showPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => DefaultActionController(
        child: GradientScaffold(
          appBar: AppBar(
            title: const Text('Odoo Login'),
            leading: const AutoLeadingButton(),
          ),
          body: ReactiveFormBuilder(
            form: () => _formBuilder(context),
            builder: (context, form, child) => GestureDetector(
              onTap: () => form.unfocus(),
              child: AutofillGroup(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: kPadding * 2),
                  child: Column(
                    children: [
                      Expanded(
                        child: DjangoflowScrollableColumn(
                          children: [
                            const SizedBox(height: kPadding * 3),
                            _buildServerUrlField(context, form),
                            _buildDbField(context, form),
                            ReactiveValueListenableBuilder(
                              formControlName: dbControlName,
                              builder: (context, formControl, child) {
                                if (formControl.value == null) {
                                  return const SizedBox.shrink();
                                } else {
                                  context
                                      .read<DjangoflowOdooAuthCubit>()
                                      .setDatabase(formControl.value as String);
                                  return Column(
                                    children: [
                                      _buildEmailField(form),
                                      _buildPasswordField(form),
                                    ],
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      SafeArea(
                        bottom: true,
                        child: ReactiveFormConsumer(
                          builder: (context, form, _) =>
                              _buildLoginButton(context, form),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );

  Widget _buildServerUrlField(BuildContext context, FormGroup form) =>
      ReactiveTextField<String>(
        formControlName: serverUrlControlName,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.url,
        autocorrect: false,
        decoration: const InputDecoration(
          hintText: 'Server Url',
          helperText: 'https://www.example.com',
        ),
        onChanged: (control) {
          final value = control.value;
          if (control.valid) {
            context.read<DjangoflowOdooAuthCubit>().setBaseUrl(value!);
          }
        },
        autofillHints: const [AutofillHints.url],
        validationMessages: {
          ValidationMessage.required: (_) => 'Server url is required',
          ValidationMessage.pattern: (_) => 'Invalid url format',
          _ValidServerAsyncValidator.validationMessage: (_) =>
              'Invalid server url',
        },
      );

  Widget _buildDbField(BuildContext context, FormGroup form) =>
      BlocBuilder<DjangoflowOdooAuthCubit, DjangoflowOdooAuthState>(
        builder: (context, state) {
          if (state.baseUrl == null || state.dbList == null) {
            return const SizedBox.shrink();
          }
          return Column(
            children: [
              const SizedBox(height: kPadding * 2),
              AppReactiveTypeAhead<String, String>(
                stringify: (db) => db.toString(),
                suggestionsCallback: (searchTerm) => state.dbList!
                    .where((db) =>
                        db.toLowerCase().contains(searchTerm.toLowerCase()))
                    .toList(),
                formControlName: dbControlName,
                inputDecoration: const InputDecoration(
                  hintText: 'Select database',
                ),
                validationMessages: {
                  ValidationMessage.required: (_) => 'Please select DB',
                },
                itemBuilder: (BuildContext context, String dbName) =>
                    TextFieldTapRegion(
                  child: ListTile(
                    tileColor: Colors.transparent,
                    title: Text(dbName),
                  ),
                ),
              ),
            ],
          );
        },
      );

  Widget _buildEmailField(FormGroup form) =>
      BlocBuilder<DjangoflowOdooAuthCubit, DjangoflowOdooAuthState>(
        builder: (context, state) {
          if (state.baseUrl == null || state.database == null) {
            return const SizedBox.shrink();
          }
          return Column(
            children: [
              const SizedBox(height: kPadding * 3),
              ReactiveTextField(
                formControlName: emailControlName,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'Email',
                ),
                autofillHints: const [AutofillHints.email],
                validationMessages: {
                  ValidationMessage.required: (_) => 'Email is required',
                  ValidationMessage.email: (_) => 'Invalid format',
                },
              ),
            ],
          );
        },
      );

  Widget _buildPasswordField(FormGroup form) =>
      BlocBuilder<DjangoflowOdooAuthCubit, DjangoflowOdooAuthState>(
        builder: (context, state) {
          if (state.baseUrl == null || state.database == null) {
            return const SizedBox.shrink();
          }
          return Column(
            children: [
              const SizedBox(height: kPadding * 3),
              ValueListenableBuilder<bool>(
                valueListenable: _showPassword,
                builder: (context, showPassword, child) => ReactiveTextField(
                  formControlName: passControlName,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.visiblePassword,
                  textCapitalization: TextCapitalization.none,
                  autofillHints: const [AutofillHints.password],
                  obscureText: !_showPassword.value,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    suffixIcon: IconButton(
                      onPressed: () {
                        _showPassword.value = !_showPassword.value;
                      },
                      icon: Icon(
                        !showPassword
                            ? CupertinoIcons.eye
                            : CupertinoIcons.eye_slash,
                      ),
                    ),
                  ),
                  validationMessages: {
                    ValidationMessage.required: (_) => 'Password is required',
                  },
                  onSubmitted: (_) {
                    if (!form.valid) {
                      form.markAsTouched();
                    } else {
                      DefaultActionController.of(context)
                          ?.add(ActionType.start);
                    }
                  },
                ),
              ),
            ],
          );
        },
      );

  Widget _buildLoginButton(BuildContext context, FormGroup form) =>
      LinearProgressBuilder(
        builder: (context, action, error) => ElevatedButton(
          onPressed: (form.valid) ? action : null,
          child: const Center(child: Text('Login')),
        ),
        action: (_) => _signIn(context, form),
        onSuccess: () {
          if (widget.onLoginSuccess != null) {
            widget.onLoginSuccess!(true);
          } else {
            context.router.maybePop(true);
          }
        },
      );

  Future<void> _signIn(BuildContext context, FormGroup form) async {
    final authCubit = context.read<DjangoflowOdooAuthCubit>();
    final syncBackendCubit = context.read<SyncBackendCubit>();
    final email = form.control(emailControlName).value as String;
    final pass = form.control(passControlName).value as String;

    TextInput.finishAutofillContext();

    await authCubit.login(email, pass);
    final backends = [SyncBackendTypes.drift, SyncBackendTypes.odoo];
    final dbName = authCubit.state.database;
    final baseUrl = authCubit.state.baseUrl;
    if (dbName != null && baseUrl != null) {
      for (final backend in backends) {
        final backendId = syncBackendCubit.getBackendId(
          baseUrl,
          backend.name,
        );
        if (backendId == null) {
          final newBackendId =
              backend == SyncBackendTypes.odoo ? dbName : 'drift-$dbName';

          await syncBackendCubit.addOrUpdateBackend(
            authCubit.state.baseUrl!,
            backend.name,
            newBackendId,
          );
        }
      }
    }
  }
}

class _ValidServerAsyncValidator extends AsyncValidator<dynamic> {
  final Future<void> Function(String) getDbListMethod;

  _ValidServerAsyncValidator({required this.getDbListMethod});

  static const String validationMessage = 'invalid_server';

  @override
  Future<Map<String, dynamic>?> validate(
      AbstractControl<dynamic> control) async {
    final error = {validationMessage: true};

    try {
      final serverUrl = control.value as String;
      await getDbListMethod(
          serverUrl.endsWith('/') ? serverUrl : '$serverUrl/');
      return null;
    } catch (e) {
      control.markAsTouched();
      return error;
    }
  }
}
