import 'package:timesheets/configurations/configurations.dart';

enum OdooApiEndpoint {
  common(commonEndpoint),
  object(objectEndpoint);

  const OdooApiEndpoint(this.name);

  final String name;
}
