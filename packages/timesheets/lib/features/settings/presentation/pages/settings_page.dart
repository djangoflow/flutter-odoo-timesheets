import 'package:drift_db_viewer/drift_db_viewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:progress_builder/progress_builder.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:djangoflow_app/djangoflow_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/authentication/authentication.dart';
import 'package:timesheets/features_refactored/project/data/entities/project_entity.dart';
import 'package:timesheets/features_refactored/project/data/repositories/project_repository.dart';

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
    return GradientScaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: false,
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
                    SizedBox(
                      height: kPadding.h,
                    ),
                    if (kDebugMode)
                      ElevatedButton(
                        onPressed: () {
                          context.router.pushNativeRoute(MaterialPageRoute(
                              builder: (context) =>
                                  DriftDbViewer(context.read<AppDatabase>())));
                        },
                        child: const Text('Check DB'),
                      ),
                    SizedBox(
                      height: kPadding.h,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          final projectRepository =
                              context.read<ProjectRepository>();

                          projectRepository.insert(ProjectEntity(
                            active: true,
                            color: 1,
                            isFavorite: true,
                            name: 'Test Project',
                            taskCount: 0,
                            taskIds: [],
                          ));
                        },
                        child: Text('Test')),
                    const SectionTitle(title: 'Synchronizations'),
                    // SyncCubitProvider(
                    //   child: BlocBuilder<AuthCubit, AuthState>(
                    //     builder: (context, state) {
                    //       final children = state.connectedBackends
                    //           .getBackendsFilteredByType(BackendTypeEnum.odoo)
                    //           .map((backend) => DefaultActionController(
                    //                 child: LinearProgressBuilder(
                    //                   action: (_) async {
                    //                     final result = await AppModalSheet.show<
                    //                         _BackendSyncOptionsEnum>(
                    //                       context: context,
                    //                       child: SafeArea(
                    //                         bottom: true,
                    //                         child: _BackendSyncOptions(
                    //                           backend: backend,
                    //                         ),
                    //                       ),
                    //                     );
                    //                     if (context.mounted) {
                    //                       final syncCubit =
                    //                           context.read<SyncCubit>();
                    //                       switch (result) {
                    //                         case _BackendSyncOptionsEnum.unlink:
                    //                           await _disconnectBackend(
                    //                               context, backend);
                    //                           break;
                    //                         case _BackendSyncOptionsEnum.resync:
                    //                           await syncCubit
                    //                               .syncData(backend.id);
                    //                           break;
                    //                         default:
                    //                           break;
                    //                       }
                    //                     }
                    //                   },
                    //                   builder: (context, action, error) =>
                    //                       ListTile(
                    //                     key: ValueKey(backend.id),
                    //                     title: RichText(
                    //                       text: TextSpan(
                    //                         text: 'Odoo',
                    //                         style: theme
                    //                             .listTileTheme.titleTextStyle,
                    //                         children: [
                    //                           if (backend.serverUrl != null)
                    //                             TextSpan(
                    //                               text:
                    //                                   ' (${backend.serverUrl})',
                    //                               style: theme
                    //                                   .textTheme.labelSmall
                    //                                   ?.copyWith(
                    //                                 color: theme.colorScheme
                    //                                     .onSurfaceVariant,
                    //                               ),
                    //                             )
                    //                         ],
                    //                       ),
                    //                     ),
                    //                     subtitle: Text(backend.email ?? ''),
                    //                     // TODO Enable later with proper testing
                    //                     // leading: Builder(
                    //                     //   builder: (context) =>
                    //                     //       CircularProgressBuilder(
                    //                     //     action: (_) async {
                    //                     //       await context
                    //                     //           .read<SyncCubit>()
                    //                     //           .syncData(backend.id);
                    //                     //     },
                    //                     //     builder: (context, action, error) =>
                    //                     //         IconButton(
                    //                     //       icon: const Icon(Icons.sync),
                    //                     //       onPressed: action,
                    //                     //     ),
                    //                     //   ),
                    //                     // ),
                    //                     trailing: Icon(
                    //                       Icons.chevron_right,
                    //                       size: kPadding.w * 4,
                    //                       color: theme.colorScheme.onSurface,
                    //                     ),
                    //                     // Logout
                    //                     onTap: action,
                    //                   ),
                    //                 ),
                    //               ))
                    //           .toList();

                    //       return Column(
                    //         children: [
                    //           ...children,
                    //           const SizedBox(
                    //             height: kPadding,
                    //           ),
                    //         ],
                    //       );
                    //     },
                    //   ),
                    // ),
                    // ListTile(
                    //   title: const Text('Add Odoo account'),
                    //   trailing: Icon(
                    //     Icons.chevron_right,
                    //     size: kPadding.w * 4,
                    //     color: theme.colorScheme.onSurface,
                    //   ),
                    //   onTap: () => context.router.push(
                    //     OdooLoginRoute(),
                    //   ),
                    // ),
                    SizedBox(
                      height: kPadding.h * 2,
                    ),
                    const SectionTitle(title: 'Legal'),
                    ListTile(
                      onTap: () {},
                      title: const Text('Terms and Conditions'),
                      trailing: Icon(
                        Icons.chevron_right,
                        size: kPadding.w * 4,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(
                      height: kPadding.h,
                    ),
                    ListTile(
                      onTap: () {},
                      title: const Text('Privacy Policy'),
                      trailing: Icon(
                        Icons.chevron_right,
                        size: kPadding.w * 4,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Card(
                  margin: const EdgeInsets.all(kPadding * 2),
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
                          if (AppCubit.packageInfo != null)
                            Text(
                              '${AppCubit.packageInfo?.version}('
                              '${AppCubit.packageInfo?.buildNumber})',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: schemeColors.onSurfaceVariant,
                              ),
                            ),
                        ],
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

  // Future<void> _disconnectBackend(BuildContext context, Backend backend) async {
  //   final authCubit = context.read<AuthCubit>();
  //   final syncCubit = context.read<SyncCubit>();
  //   final router = context.router;
  //   final result = await showCupertinoDialog<bool?>(
  //     context: context,
  //     builder: (context) => CupertinoAlertDialog(
  //       title: const Text('Disconnect from Odoo?'),
  //       content: const Text(
  //         'You will be logged out from Odoo and lose synchronization.',
  //       ),
  //       actions: [
  //         CupertinoDialogAction(
  //           child: Text('Cancel',
  //               style: TextStyle(
  //                 color: Theme.of(context).colorScheme.onPrimary,
  //               )),
  //           onPressed: () => context.router.pop(false),
  //         ),
  //         CupertinoDialogAction(
  //           isDestructiveAction: true,
  //           child: const Text('Disconnect'),
  //           onPressed: () {
  //             context.router.pop(true);
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  //   if (result == true) {
  //     await syncCubit.removeData(backend.id);
  //     await authCubit.logout(backend);
  //     router.pop();
  //   }
  // }
}

class _BackendSyncOptions extends StatelessWidget {
  const _BackendSyncOptions({super.key, required this.backend});
  final Backend backend;

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
            onTap: () => context.router.pop(_BackendSyncOptionsEnum.unlink),
          ),
          const Divider(
            height: 1,
          ),
          ListTile(
            leading: const Icon(CupertinoIcons.arrow_2_circlepath),
            title: const Text(
              'Re-sync the account',
            ),
            // TODO fix bug with re-sync
            onTap: () => context.router.pop(_BackendSyncOptionsEnum.resync),
          ),
        ],
      ),
    );
  }
}

enum _BackendSyncOptionsEnum {
  unlink,
  resync,
}
