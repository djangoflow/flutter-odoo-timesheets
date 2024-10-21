import 'package:djangoflow_odoo_auth/djangoflow_odoo_auth.dart';
import 'package:djangoflow_sync_foundation/djangoflow_sync_foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timesheets/features/sync/sync.dart';

class SyncProvider<M extends SyncModel, R extends SyncRepository<M>>
    extends StatelessWidget {
  const SyncProvider({
    super.key,
    required this.builder,
    required this.odooModelName,
  });

  final Widget Function(BuildContext context, String? backendId) builder;
  final String odooModelName;

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<DjangoflowOdooAuthCubit>();
    final baseUrl = authCubit.state.baseUrl;

    final type = SyncBackendTypes.drift.name;
    final backendId = context.read<SyncBackendCubit>().getBackendId(
          baseUrl ?? '',
          type,
        );
    if (backendId != null) {
      return BlocProvider<SyncCubit<M>>(
        create: (context) => SyncCubit<M>(
          repository: context.read<R>(),
          syncRegistryRepository: context.read<AppSyncRegistryRepository>(),
          backendId: backendId,
          modelName: odooModelName,
        ),
        lazy: false,
        child: Builder(builder: (context) => builder(context, backendId)),
      );
    } else {
      return builder(context, null);
    }
  }
}
