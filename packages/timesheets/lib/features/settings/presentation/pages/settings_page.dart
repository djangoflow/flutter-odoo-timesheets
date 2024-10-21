import 'package:djangoflow_odoo_auth/djangoflow_odoo_auth.dart';
import 'package:drift_db_viewer/drift_db_viewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';

import 'package:progress_builder/progress_builder.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:djangoflow_app/djangoflow_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/sync/sync.dart';
import 'package:timesheets/features/timesheet/timesheet.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../setction_title.dart';

@RoutePage()
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) => GradientScaffold(
        appBar: AppBar(
          title: const Text('Settings'),
          centerTitle: false,
        ),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: kPadding * 2,
              vertical: kPadding * 2,
            ),
            children: [
              if (kDebugMode) ...[
                const SectionTitle(title: 'Connection'),
                const ConnectionStateToggle(),
                const SizedBox(
                  height: kPadding,
                ),
              ],
              const _ThemeSection(),
              const _AccountSection(),
              const SizedBox(
                height: kPadding * 2,
              ),
              const SectionTitle(title: 'Legal'),
              ListTile(
                onTap: () {},
                title: const Text('Terms and Conditions'),
                trailing: const Icon(
                  Icons.chevron_right,
                ),
              ),
              const SizedBox(
                height: kPadding,
              ),
              ListTile(
                onTap: () {},
                title: const Text('Privacy Policy'),
                trailing: const Icon(
                  Icons.chevron_right,
                ),
              ),
              const _MadeByApexiveWidget(),
            ],
          ),
        ),
      );
}

class _ThemeSection extends StatelessWidget {
  const _ThemeSection();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: 'Theme'),
        ListTile(
          title: const Text('Dark theme'),
          trailing: BlocBuilder<AppCubit, AppState>(
            builder: (context, state) => Switch(
              trackColor: WidgetStateProperty.all(
                colorScheme.onSurfaceVariant.withOpacity(0.2),
              ),
              thumbColor: WidgetStateProperty.all(
                colorScheme.primary,
              ),
              thumbIcon: WidgetStateProperty.all(
                Icon(
                  state.themeMode == ThemeMode.dark
                      ? CupertinoIcons.moon_fill
                      : CupertinoIcons.sun_min_fill,
                  color: colorScheme.onPrimary,
                ),
              ),
              value: state.themeMode == ThemeMode.dark,
              onChanged: (value) {
                final isDarkTheme = state.themeMode == ThemeMode.dark;
                AppCubit.instance.updateThemeMode(
                    isDarkTheme ? ThemeMode.light : ThemeMode.dark);
              },
            ),
          ),
        ),
        const SizedBox(
          height: kPadding,
        ),
        if (kDebugMode) ...[
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                context.router.pushNativeRoute(
                  MaterialPageRoute(
                    builder: (context) => DriftDbViewer(
                      context.read<AppDatabase>(),
                    ),
                  ),
                );
              },
              child: const Text('Check DB'),
            ),
          ),
          const SizedBox(
            height: kPadding,
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                verifyIndexes(context.read<AppDatabase>());
              },
              child: const Text('Check DB Index'),
            ),
          ),
        ],
      ],
    );
  }

  /// Only for testing
  Future<void> verifyIndexes(AppDatabase db) async {
    if (kDebugMode) {
// List of tables to check
      final tables = ['analytic_lines', 'project_projects', 'project_tasks'];

      for (final table in tables) {
        print('Indexes for $table:');
        // Query the index list for each table
        final indexList =
            await db.customSelect('PRAGMA index_list($table);').get();

        // Print index information
        for (final row in indexList) {
          final indexName = row.read<String>('name');
          print('Index Name: $indexName');

          // Get detailed index info
          final indexInfo =
              await db.customSelect('PRAGMA index_info($indexName);').get();
          for (final infoRow in indexInfo) {
            print('Column Indexed: ${infoRow.read<String>('name')}');
          }
        }
      }
    }
  }
}

class _AccountSection extends StatelessWidget {
  const _AccountSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: 'Account'),
        const SizedBox(
          height: kPadding,
        ),
        LinearProgressBuilder(
          action: (_) async {
            final result = await AppModalSheet.show<_BackendSyncOptionsEnum>(
              context: context,
              child: const SafeArea(
                bottom: true,
                child: _BackendSyncOptions(),
              ),
            );
            if (context.mounted) {
              switch (result) {
                case _BackendSyncOptionsEnum.unlink:
                  await _disconnectBackend(context);
                  break;
                case _BackendSyncOptionsEnum.resync:
                  await context.read<SyncCubit<TimesheetModel>>().sync();
                  break;
                default:
                  break;
              }
            }
          },
          builder: (context, action, error) {
            final authState = context.read<DjangoflowOdooAuthCubit>().state;
            final session = authState.session;
            final baseUrl = authState.baseUrl;
            return ListTile(
              title: RichText(
                text: TextSpan(
                  text: session?.userName ?? '',
                  style: theme.listTileTheme.titleTextStyle,
                  children: [
                    if (baseUrl != null)
                      TextSpan(
                        text: ' ($baseUrl)',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      )
                  ],
                ),
              ),
              subtitle: Text(session?.dbName ?? authState.database ?? ''),

              trailing: Icon(
                Icons.chevron_right,
                size: kPadding * 4,
                color: theme.colorScheme.onSurface,
              ),
              // Logout
              onTap: action,
            );
          },
        )
      ],
    );
  }
}

enum _BackendSyncOptionsEnum {
  unlink,
  resync,
}

class _BackendSyncOptions extends StatelessWidget {
  const _BackendSyncOptions();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTileTheme(
      data: theme.listTileTheme.copyWith(
        titleTextStyle: theme.textTheme.labelLarge,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(CupertinoIcons.delete),
            title: const Text(
              'Unlink the Account',
            ),
            onTap: () =>
                context.router.maybePop(_BackendSyncOptionsEnum.unlink),
          ),
          const Divider(
            height: 1,
          ),
          ListTile(
            leading: const Icon(CupertinoIcons.arrow_2_circlepath),
            title: const Text(
              'Re-sync the account',
            ),
            onTap: () =>
                context.router.maybePop(_BackendSyncOptionsEnum.resync),
          ),
        ],
      ),
    );
  }
}

Future<void> _disconnectBackend(BuildContext context) async {
  final authCubit = context.read<DjangoflowOdooAuthCubit>();

  final result = await showCupertinoDialog<bool?>(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: const Text('Disconnect from Odoo?'),
      content: const Text(
        'You will be logged out from Odoo, but your offline data will be kept safe.',
      ),
      actions: [
        CupertinoDialogAction(
          child: Text('Cancel',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
              )),
          onPressed: () => context.router.maybePop(false),
        ),
        CupertinoDialogAction(
          isDestructiveAction: true,
          child: const Text('Disconnect'),
          onPressed: () {
            context.router.maybePop(true);
          },
        ),
      ],
    ),
  );
  if (result == true) {
    await authCubit.logout();
  }
}

class _MadeByApexiveWidget extends StatelessWidget {
  const _MadeByApexiveWidget();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SizedBox(
      width: double.infinity,
      child: Material(
        color: Colors.transparent,
        child: Card(
          margin: const EdgeInsets.symmetric(vertical: kPadding * 2),
          color: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(kPadding * 2),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'Made with ♥ by ',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      children: [
                        TextSpan(
                          text: 'Apexive',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface,
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
                  if (AppCubit.packageInfo != null)
                    Text(
                      '${AppCubit.packageInfo?.version}('
                      '${AppCubit.packageInfo?.buildNumber})',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
