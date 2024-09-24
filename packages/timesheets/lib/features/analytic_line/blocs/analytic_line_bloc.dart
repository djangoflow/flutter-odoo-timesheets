import 'package:djangoflow_sync_foundation/djangoflow_sync_foundation.dart';
import '../data/models/analytic_line_model.dart';
import '../data/repositories/analytic_line_repository.dart';

class AnalyticLineBloc extends SyncBloc<AnalyticLineModel> {
  AnalyticLineBloc(AnalyticLineRepository super.repository);
}
