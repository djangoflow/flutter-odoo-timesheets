import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:djangoflow_app/djangoflow_app.dart';
import 'package:drift/drift.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/external/external.dart';

import 'package:timesheets/features/odoo/data/repositories/odoo_authentication_repository.dart';
import 'package:timesheets/features/odoo/odoo.dart';
import 'package:timesheets/utils/utils.dart';

import 'auth_state.dart';
export 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final OdooAuthenticationRepository odooAuthenticationRepository;
  final BackendsRepository backendsRepository;
  StreamSubscription? _backendsSubscription;
  AuthCubit({
    required this.odooAuthenticationRepository,
    required this.backendsRepository,
  }) : super(
          const AuthState(),
        ) {
    _backendsSubscription = backendsRepository.watchAllBackends().listen(
      (backends) {
        odooAuthenticationRepository.rpcClient.backendCrednetials = backends
            .getBackendsFilteredByType(BackendTypeEnum.odoo)
            .backendCredentialsMap;

        emit(
          state.copyWith(
            connectedBackends: backends,
          ),
        );
      },
    );
  }

  @override
  Future<void> close() {
    _backendsSubscription?.cancel();
    return super.close();
  }

  Future<void> loadBackends() async {
    final backends = await backendsRepository.getItems();
    emit(
      state.copyWith(
        connectedBackends: backends,
      ),
    );
  }

  Future<void> logout(Backend backend) async {
    await backendsRepository.delete(backend);
  }

  Future<int> loginWithOdoo({
    required String email,
    required String password,
    required String serverUrl,
    required String db,
  }) async {
    final userId = await odooAuthenticationRepository.connect(
      email: email,
      password: password,
      serverUrl: serverUrl,
      db: db,
    );

    final backendId = await backendsRepository.create(
      BackendsCompanion(
        backendType: const Value(BackendTypeEnum.odoo),
        db: Value(db),
        email: Value(email),
        password: Value(password),
        serverUrl: Value(serverUrl),
        userId: Value(userId),
      ),
    );

    final backend = await backendsRepository.getItemById(backendId);
    if (backend == null) {
      throw Exception('Backend not found');
    }
    emit(
      state.copyWith(
        connectedBackends: [
          backend,
          ...state.connectedBackends,
        ],
        lastConnectedOdooDb: db,
        lastConnectedOdooServerUrl: serverUrl,
      ),
    );

    return backendId;
  }
}
