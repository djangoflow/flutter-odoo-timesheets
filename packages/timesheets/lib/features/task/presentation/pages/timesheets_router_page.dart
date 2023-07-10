import 'package:timesheets/configurations/configurations.dart';

@RoutePage(name: 'TimesheetsRouter')
class TimesheetsRouterPage extends AutoRouter {
  final int timesheetId;

  const TimesheetsRouterPage({super.key, @pathParam required this.timesheetId});
}
