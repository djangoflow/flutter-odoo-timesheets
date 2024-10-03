import 'package:djangoflow_odoo_auth/djangoflow_odoo_auth.dart';
import 'package:djangoflow_sync_foundation/djangoflow_sync_foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/sync/sync.dart';
import 'package:timesheets/features/timesheet/timesheet.dart';

@RoutePage(name: 'HomeTabRouter')
class HomeTabRouterPage extends StatelessWidget implements AutoRouteWrapper {
  const HomeTabRouterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authStatus = context.select<DjangoflowOdooAuthCubit, AuthStatus>(
      (value) => value.state.status,
    );
    // Happens during route change animation when user logs out
    if (authStatus != AuthStatus.authenticated) {
      return const SizedBox();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _maybeTriggerAutoSync(context);
    });

    return BlocListener<SyncCubit<TimesheetModel>, SyncState>(
      listener: (context, state) {
        logger.d('Status changed : ${state.status.name}');
        final loaderOverlay = context.loaderOverlay;
        if (state.status == SyncStatus.syncInProgress) {
          if (!loaderOverlay.visible) {
            loaderOverlay.show();
          }
        } else if ([SyncStatus.syncFailure, SyncStatus.syncSuccess]
            .contains(state.status)) {
          if (loaderOverlay.visible) {
            loaderOverlay.hide();
          }
        }

        if (state.status == SyncStatus.syncSuccess) {
          AppDialog.showSuccessDialog(
            context: context,
            title: 'Success',
            content: 'Synced successfully, cheers!',
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.surfaceVariant,
              Theme.of(context).colorScheme.surface,
            ],
            stops: const [.15, .85],
          ),
        ),
        child: AutoTabsRouter(
          builder: (context, child) {
            final tabsRouter = context.tabsRouter;
            return Column(
              children: [
                Expanded(
                  child: child,
                ),
                BottomNavigationBar(
                  currentIndex: tabsRouter.activeIndex,
                  onTap: tabsRouter.setActiveIndex,
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.clock),
                      activeIcon: Icon(CupertinoIcons.clock_fill),
                      label: 'Timers',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.briefcase),
                      activeIcon: Icon(CupertinoIcons.briefcase_fill),
                      label: 'Projects',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.settings),
                      activeIcon: Icon(CupertinoIcons.settings_solid),
                      label: 'Settings',
                    ),
                  ],
                ),
              ],
            );
          },
          routes: const [
            TimesheetsRoute(),
            ProjectsTabRouter(),
            SettingsRoute(),
          ],
        ),
      ),
    );
  }

  @override
  Widget wrappedRoute(BuildContext context) => this;

  void _maybeTriggerAutoSync(BuildContext context) {
    final dbName = context.read<DjangoflowOdooAuthCubit>().state.database;
    if (dbName != null) {
      if (context.read<LastAutoSyncCubit>().getLastAutoSyncTime(dbName) ==
          null) {
        context.read<LastAutoSyncCubit>().updateLastAutoSync(dbName);
        context.read<SyncCubit<TimesheetModel>>().sync();
      }
    }
  }
}
