import 'package:coronavirus_rest_api_flutter_course/app/services/api.dart';

class EndpointsData {
  final Map<Endpoint, int> values;
  EndpointsData({required this.values});
  int? get cases => values[Endpoint.cases];
  int? get casesSuspected => values[Endpoint.casesSuspected];
  int? get casesConfirmed => values[Endpoint.casesConfirmed];
  int? get deaths => values[Endpoint.deaths];
  int? get recovered => values[Endpoint.recovered];
}
