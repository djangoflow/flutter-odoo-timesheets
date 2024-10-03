import 'package:djangoflow_odoo_auth/djangoflow_odoo_auth.dart';
import 'package:djangoflow_sync_foundation/djangoflow_sync_foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timesheets/features/sync/sync.dart';

class MultiSyncProvider extends StatelessWidget {
  final List<SyncProviderConfig> configs;
  final Widget Function(BuildContext context, String? backendId) builder;

  const MultiSyncProvider({
    super.key,
    required this.configs,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<DjangoflowOdooAuthCubit>();
    final baseUrl = authCubit.state.baseUrl;
    final type = SyncBackendTypes.drift.name;
    final backendId = context.read<SyncBackendCubit>().getBackendId(
          baseUrl ?? '',
          type,
        );

    return backendId == null
        ? builder(context, null)
        : MultiBlocProvider(
            providers: configs
                .map(
                  (config) => config.createBlocProvider(context, backendId),
                )
                .toList(),
            child: builder(context, backendId),
          );
  }
}

extension SyncCubitExtension on BuildContext {
  SyncCubit<T> syncCubitFor<T extends SyncModel>() => read<SyncCubit<T>>();
}
