import 'package:http/http.dart' as http;

http.BaseClient getHttpClient() => http.Client() as http.BaseClient;
