import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/authentication/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progress_builder/progress_builder.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:timesheets/features/odoo/data/repositories/odoo_information_repository.dart';
import 'package:timesheets/features/odoo/odoo.dart';
import 'package:timesheets/features/sync/blocs/sync_cubit/sync_cubit.dart';
import 'package:timesheets/features/sync/presentation/sync_cubit_provider.dart';

@RoutePage()
class OdooLoginPage extends StatefulWidget implements AutoRouteWrapper {
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

  @override
  Widget wrappedRoute(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) {
              final cubit = OdooInformationCubit(
                OdooInformationRepository(
                  context.read<OdooXmlRpcClient>(),
                ),
              );

              final providedServerUrl = serverUrl ??
                  context.read<AuthCubit>().state.lastConnectedOdooServerUrl;
              if (providedServerUrl != null) {
                cubit.getDbList(providedServerUrl);
              }
              return cubit;
            },
          ),
          SyncCubitProvider(),
        ],
        child: this,
      );
}

class _OdooLoginPageState extends State<OdooLoginPage> {
  final _showPassword = ValueNotifier<bool>(false);
  FormGroup _formBuilder(BuildContext context) => fb.group(
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
            asyncValidators: [
              _ValidServerAsyncValidator(
                  context.read<OdooInformationCubit>().getDbList)
            ],
            asyncValidatorsDebounceTime: 500,
            value: widget.serverUrl ??
                context.read<AuthCubit>().state.lastConnectedOdooServerUrl ??
                'https://',
          ),
          dbControlName: FormControl<String>(
            validators: [
              Validators.required,
            ],
            value: widget.db ??
                context.read<AuthCubit>().state.lastConnectedOdooDb,
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
                  padding: EdgeInsets.symmetric(
                    horizontal: kPadding.w * 2,
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: ScrollableColumn(
                          children: [
                            SizedBox(
                              height: kPadding.h * 3,
                            ),
                            ReactiveTextField<String>(
                              autofocus: true,
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
                                  context
                                      .read<OdooInformationCubit>()
                                      .getDbList(value!);
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
                            ReactiveStatusListenableBuilder(
                              builder: (context, control, child) {
                                if (control.pending) {
                                  return Column(
                                    children: [
                                      SizedBox(
                                        height: kPadding.h * 2,
                                      ),
                                      const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    ],
                                  );
                                } else if (control.value != null &&
                                    control.valid) {
                                  return Column(
                                    children: [
                                      SizedBox(
                                        height: kPadding.h * 2,
                                      ),
                                      BlocBuilder<OdooInformationCubit,
                                          OdooInformationState>(
                                        builder: (context, state) =>
                                            AppReactiveTypeAhead<String,
                                                String>(
                                          stringify: (db) => db.toString(),
                                          suggestionsCallback: (searchTerm) =>
                                              state
                                                  .dbList
                                                  .where((db) => db
                                                      .toLowerCase()
                                                      .contains(searchTerm
                                                          .toLowerCase()))
                                                  .toList(),
                                          formControlName: dbControlName,
                                          inputDecoration:
                                              const InputDecoration(
                                            hintText: 'Select database',
                                            labelText: 'Database',
                                          ),
                                          validationMessages: {
                                            ValidationMessage.required: (_) =>
                                                'Please select DB',
                                          },
                                          itemBuilder: (BuildContext context,
                                                  String dbName) =>
                                              ListTile(
                                            tileColor: Colors.transparent,
                                            title: Text(dbName),
                                          ),
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
                            SizedBox(
                              height: kPadding.h * 3,
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
                                ValidationMessage.email: (_) =>
                                    'Invalid format',
                              },
                            ),
                            SizedBox(
                              height: kPadding.h * 3,
                            ),
                            ValueListenableBuilder<bool>(
                                valueListenable: _showPassword,
                                builder: (context, showPassword, child) =>
                                    ReactiveTextField(
                                      formControlName: passControlName,
                                      textInputAction: TextInputAction.done,
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      textCapitalization:
                                          TextCapitalization.none,
                                      autofillHints: const [
                                        AutofillHints.password
                                      ],
                                      obscureText: !_showPassword.value,
                                      decoration: InputDecoration(
                                        hintText: 'Password',
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            _showPassword.value =
                                                !_showPassword.value;
                                          },
                                          icon: Icon(
                                            !showPassword
                                                ? CupertinoIcons.eye
                                                : CupertinoIcons.eye_slash,
                                          ),
                                        ),
                                      ),
                                      validationMessages: {
                                        ValidationMessage.required: (_) =>
                                            'Password is required',
                                      },
                                      onSubmitted: (_) {
                                        if (!form.valid) {
                                          form.markAsTouched();
                                        } else {
                                          DefaultActionController.of(context)
                                              ?.add(ActionType.start);
                                        }
                                      },
                                    )),
                          ],
                        ),
                      ),
                      SafeArea(
                        bottom: true,
                        child: LinearProgressBuilder(
                          builder: (context, action, error) => ElevatedButton(
                            onPressed:
                                (ReactiveForm.of(context)?.valid ?? false)
                                    ? action
                                    : null,
                            child: const Center(child: Text('Login')),
                          ),
                          action: (_) => _signIn(context, form),
                          onSuccess: () {
                            if (widget.onLoginSuccess != null) {
                              widget.onLoginSuccess!(true);
                            } else {
                              context.router.pop(true);
                            }
                          },
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

  Future<void> _signIn(BuildContext context, FormGroup form) async {
    final syncCubit = context.read<SyncCubit>();
    final email = form.control(emailControlName).value as String;
    final pass = form.control(passControlName).value as String;
    String serverUrl = form.control(serverUrlControlName).value as String;
    final db = form.control(dbControlName).value as String;
    if (!serverUrl.endsWith('/')) {
      serverUrl += '/';
    }
    TextInput.finishAutofillContext();
    final backendId = await context.read<AuthCubit>().loginWithOdoo(
          email: email,
          password: pass,
          serverUrl: serverUrl,
          db: db,
        );
    await syncCubit.syncData(backendId);
  }
}

class _ValidServerAsyncValidator extends AsyncValidator<dynamic> {
  final Future<void> Function(String) getDbListMethod;

  _ValidServerAsyncValidator(this.getDbListMethod);
  @override
  Future<Map<String, dynamic>?> validate(
      AbstractControl<dynamic> control) async {
    final error = {'invalid_server': true};

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
