import 'package:coronavirus_rest_api_flutter_course/app/repositories/endpoints_data.dart';
import 'package:coronavirus_rest_api_flutter_course/app/services/api.dart';
import 'package:coronavirus_rest_api_flutter_course/app/services/api_service.dart';
import 'package:coronavirus_rest_api_flutter_course/app/services/endpoint_data.dart';
import 'package:http/http.dart';

class DataRepository {
  final APIService apiService;
  DataRepository({required this.apiService});
  late String _accessToken;
  Future<EndpointData> getEndpointData(Endpoint endpoint) async =>
      await _getDataRefreshingToken<EndpointData>(
          onGetData: () => apiService.getEndpointData(
              accessToken: _accessToken, endpoint: endpoint));

  Future<EndpointsData> getAllEndpointData() async =>
      await _getDataRefreshingToken<EndpointsData>(
          onGetData: _getAllEndpointsData);

  Future<T> _getDataRefreshingToken<T>(
      {required Future<T> Function() onGetData}) async {
    try {
      _accessToken = await apiService.getAccessToken();
      return await onGetData();
    } on Response catch (response) {
      if (response.statusCode == 401) {
        _accessToken = await apiService.getAccessToken();
        return await onGetData();
      }
      rethrow;
    }
  }

  Future<EndpointsData> _getAllEndpointsData() async {
    final values = await Future.wait([
      getEndpointData(Endpoint.cases),
      getEndpointData(Endpoint.casesSuspected),
      getEndpointData(Endpoint.casesConfirmed),
      getEndpointData(Endpoint.deaths),
      getEndpointData(Endpoint.recovered),
    ]);

    return EndpointsData(values: {
      Endpoint.cases: values[0],
      Endpoint.casesSuspected: values[1],
      Endpoint.casesConfirmed: values[2],
      Endpoint.deaths: values[3],
      Endpoint.recovered: values[4],
    });
  }
}
