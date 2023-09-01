import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/authentication/authentication.dart';
import 'package:timesheets/features/external/external.dart';
import 'package:timesheets/features/timesheet/presentation/timesheets_listview.dart';
import 'package:timesheets/features/timesheet/timesheet.dart';
import 'package:timesheets/utils/utils.dart';

@RoutePage()
class OdooTimesheetsPage extends StatelessWidget implements AutoRouteWrapper {
  const OdooTimesheetsPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) =>
      InitialTimesheetOrderingFilterWrapper(builder: (initialOrderingFilter) {
        context.read<OdooTimesheetWithTaskExternalListCubit>().load(
              TimesheetWithTaskExternalListFilter(
                isProjectLocal: false,
                isEndDateNull: true,
                orderingFilters: initialOrderingFilter != null
                    ? [initialOrderingFilter]
                    : [],
              ),
            );
        return this;
      });

  @override
  Widget build(BuildContext context) => AppVisiblityBuilder(
        key: const ValueKey('synced_timesheets_builder'),
        appVisibilityKey: const ValueKey('synced_timesheets_page'),
        child: InitialTimesheetOrderingFilterWrapper(
          builder: (initialOrderingFilter) =>
              TimesheetListView<OdooTimesheetWithTaskExternalListCubit>(
                  emptyBuilder: (context, state) {
            final isAuthenticated = context.select(
              (AuthCubit cubit) => cubit.state.connectedBackends
                  .getBackendsFilteredByType(BackendTypeEnum.odoo)
                  .isNotEmpty,
            );

            return OdooTimesheetsPlaceHolder(
              message: isAuthenticated
                  ? 'Create a timer to get started'
                  : 'Syncrhonize with odoo to get started',
              onGetStarted: () async {
                final odooProjectListCubit =
                    context.read<OdooTimesheetWithTaskExternalListCubit>();
                if (isAuthenticated) {
                  final result = await context.router.push(
                    TimesheetRouter(
                      children: [
                        TimesheetAddRoute(
                          disableLocalProjectTaskSelection: true,
                        ),
                      ],
                    ),
                  );

                  if (result != null && result is bool && result == true) {
                    odooProjectListCubit.reload();
                  }
                } else {
                  final result = await context.router.push(OdooLoginRoute());
                  if (result != null && result is bool && result == true) {
                    odooProjectListCubit.reload();
                  }
                }
              },
            );
          }),
        ),
      );
}
