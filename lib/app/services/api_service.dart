import 'dart:convert';

import 'package:coronavirus_rest_api_flutter_course/app/services/api.dart';
import 'package:http/http.dart' as http;

class APIService {
  final API api;
  APIService(this.api);
  Future<String> getAccessToken() async {
    final response = await http.post(
      api.tokenUri(),
      headers: {'Authorization': 'Basic ${api.apiKey}'},
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final accessToken = data['access_token'];
      if (accessToken != null) {
        return accessToken;
      }
    }
    throw response;
  }

  Future<int> getEndpointData(
      {required String accessToken, required Endpoint endpoint}) async {
    final uri = api.endpointUri(endpoint);
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(
          response.body); // The content is a List of Map [{'test' : 123,},]
      if (data.isNotEmpty) {
        final Map<String, dynamic> endpointData = data[0];
        final String responseJsonKey = _responseJsonKeys[endpoint] as String;
        final int result = endpointData[responseJsonKey];
        if (result != null) {
          return result;
        }
      }
    }
    throw response;
  }

  static final Map<Endpoint, String> _responseJsonKeys = {
    Endpoint.cases: 'cases',
    Endpoint.casesSuspected: 'data',
    Endpoint.casesConfirmed: 'data',
    Endpoint.deaths: 'data',
    Endpoint.recovered: 'data',
  };
}
