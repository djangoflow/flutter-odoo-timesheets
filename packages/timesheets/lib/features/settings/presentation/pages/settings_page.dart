import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:progress_builder/progress_builder.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:djangoflow_app/djangoflow_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timesheets/features/authentication/authentication.dart';
import 'package:timesheets/features/external/external.dart';
import 'package:timesheets/features/sync/blocs/sync_cubit/sync_cubit.dart';
import 'package:timesheets/features/sync/presentation/sync_cubit_provider.dart';
import 'package:timesheets/utils/utils.dart';

import 'package:url_launcher/url_launcher_string.dart';

import '../../setction_title.dart';

@RoutePage()
class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final schemeColors = theme.colorScheme;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leadingWidth: kPadding * 9,
        leading: const Row(
          children: [
            SizedBox(width: kPadding * 2),
            AutoLeadingButton(),
          ],
        ),
        title: const Text('Settings'),
      ),
      body: SafeArea(
        bottom: true,
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: kPadding * 2,
                    vertical: kPadding * 2,
                  ),
                  children: [
                    const SectionTitle(title: 'Theme'),
                    ListTile(
                      title: const Text('Dark theme'),
                      trailing: BlocBuilder<AppCubit, AppState>(
                        builder: (context, state) => Switch(
                          trackColor: MaterialStateProperty.all(
                            schemeColors.onSurfaceVariant.withOpacity(0.2),
                          ),
                          thumbColor: MaterialStateProperty.all(
                            schemeColors.primary,
                          ),
                          thumbIcon: MaterialStateProperty.all(
                            Icon(
                              state.themeMode == ThemeMode.dark
                                  ? CupertinoIcons.moon_fill
                                  : CupertinoIcons.sun_min_fill,
                              color: schemeColors.onPrimary,
                            ),
                          ),
                          value: state.themeMode == ThemeMode.dark,
                          onChanged: (value) {
                            final isDarkTheme =
                                state.themeMode == ThemeMode.dark;
                            AppCubit.instance.updateThemeMode(
                                isDarkTheme ? ThemeMode.light : ThemeMode.dark);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: kPadding,
                    ),
                    const SectionTitle(title: 'Synchronizations'),
                    BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        final children = state.connectedBackends
                            .getBackendsFilteredByType(BackendTypeEnum.odoo)
                            .map((backend) => ListTile(
                                  title: const Text('Odoo'),
                                  subtitle: Text(backend.email ?? ''),
                                  leading: SyncCubitProvider(
                                    context: context,
                                    child: Builder(builder: (context) {
                                      return CircularProgressBuilder(
                                        action: (_) async {
                                          await context
                                              .read<SyncCubit>()
                                              .syncData(backend.id);
                                        },
                                        builder: (context, action, error) =>
                                            IconButton(
                                          icon: const Icon(Icons.sync),
                                          onPressed: action,
                                        ),
                                      );
                                    }),
                                  ),
                                  trailing: Icon(
                                    Icons.chevron_right,
                                    size: kPadding.w * 4,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                  // Logout
                                  onTap: () => showCupertinoDialog<bool?>(
                                    context: context,
                                    builder: (context) => CupertinoAlertDialog(
                                      title:
                                          const Text('Disconnect from Odoo?'),
                                      content: const Text(
                                        'You will be logged out from Odoo and lose synchronization.',
                                      ),
                                      actions: [
                                        CupertinoDialogAction(
                                          child: const Text('Cancel'),
                                          onPressed: () =>
                                              context.router.pop(false),
                                        ),
                                        CupertinoDialogAction(
                                          isDestructiveAction: true,
                                          child: const Text('Disconnect'),
                                          onPressed: () {
                                            context.router.pop(true);
                                          },
                                        ),
                                      ],
                                    ),
                                  ).then((value) async {
                                    if (value == true) {
                                      context.read<AuthCubit>().logout(backend);
                                    }
                                  }),
                                ))
                            .toList();

                        return Column(
                          children: [
                            ...children,
                            const SizedBox(
                              height: kPadding,
                            ),
                          ],
                        );
                      },
                    ),
                    ListTile(
                      title: const Text('Add Odoo account'),
                      trailing: Icon(
                        Icons.chevron_right,
                        size: kPadding.w * 4,
                        color: theme.colorScheme.onSurface,
                      ),
                      onTap: () => context.router.push(
                        OdooLoginRoute(),
                      ),
                    ),
                    const SizedBox(
                      height: kPadding,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Card(
                  elevation: kPadding / 8,
                  margin: const EdgeInsets.all(kPadding * 2),
                  color: schemeColors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(kPadding),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(kPadding * 2),
                    child: Center(
                      child: RichText(
                        text: TextSpan(
                          text: 'Made with ♥ by ',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: schemeColors.onSurfaceVariant,
                          ),
                          children: [
                            TextSpan(
                              text: 'Apexive',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: schemeColors.onSurface,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => launchUrlString(
                                      apexiveUrl,
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
