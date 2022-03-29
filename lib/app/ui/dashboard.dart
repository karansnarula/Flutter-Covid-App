import 'package:coronavirus_rest_api_flutter_course/app/repositories/data_repository.dart';
import 'package:coronavirus_rest_api_flutter_course/app/repositories/endpoints_data.dart';
import 'package:coronavirus_rest_api_flutter_course/app/services/api.dart';
import 'package:coronavirus_rest_api_flutter_course/app/ui/endpoint_card.dart';
import 'package:coronavirus_rest_api_flutter_course/app/ui/last_updated_status_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  EndpointsData? _endpointsData;
  bool isLoading = true;

  @override
  initState() {
    super.initState();
    _updateData();
  }

  Future<void> _updateData() async {
    final dataRepository = Provider.of<DataRepository>(context, listen: false);
    final endpointsData = await dataRepository.getAllEndpointData();
    setState(() {
      isLoading = false;
      _endpointsData = endpointsData;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isLoading) {
      final formatter = LastUpdatedDateFormatter(
          lastUpdated: _endpointsData?.values[Endpoint.cases]?.date);
      return Scaffold(
        appBar: AppBar(
          title: const Text('Coronavirus Tracker'),
        ),
        body: RefreshIndicator(
          onRefresh: _updateData,
          child: ListView(children: [
            LastUpdatedStatusText(text: formatter.lastUpdatedStatusText()),
            for (var endpoint in Endpoint.values)
              EndpointCard(
                endpoint: endpoint,
                value: _endpointsData?.values[endpoint]?.value,
              )
          ]),
        ),
      );
    } else {
      return const Center(
        child: CircularProgressIndicator.adaptive(),
      );
    }
  }
}
