// provides http client for web and mobile depending on the platform
export 'web_only_client.dart' if (dart.library.io) './mobile_only_client.dart';
