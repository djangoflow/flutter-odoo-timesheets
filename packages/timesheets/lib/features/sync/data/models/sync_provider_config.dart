import 'package:djangoflow_sync_foundation/djangoflow_sync_foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timesheets/features/sync/sync.dart';

class SyncProviderConfig<M extends SyncModel, R extends SyncRepository<M>> {
  final String odooModelName;
  final R Function(BuildContext context) repositoryBuilder;
  SyncProviderConfig({
    required this.odooModelName,
    required this.repositoryBuilder,
  });

  BlocProvider<SyncCubit<M>> createBlocProvider(
          BuildContext context, String backendId) =>
      BlocProvider<SyncCubit<M>>(
        create: (context) => SyncCubit<M>(
          repository: repositoryBuilder(context),
          syncRegistryRepository: context.read<AppSyncRegistryRepository>(),
          backendId: backendId,
          modelName: odooModelName,
        ),
        lazy: false,
      );
}
