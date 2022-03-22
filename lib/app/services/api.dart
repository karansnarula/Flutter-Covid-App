import 'package:coronavirus_rest_api_flutter_course/app/services/api_keys.dart';

class API {
  final String apiKey;
  API({required this.apiKey});

  factory API.sandbox() => API(apiKey: APIKeys.ncovSandboxKey);

  static const String host = 'ncov2019-admin.firebaseapp.com';

  Uri tokenUri() => Uri(scheme: 'https', host: host, path: 'token');
}
