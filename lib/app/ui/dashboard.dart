import 'dart:io';

import 'package:coronavirus_rest_api_flutter_course/app/repositories/data_repository.dart';
import 'package:coronavirus_rest_api_flutter_course/app/repositories/endpoints_data.dart';
import 'package:coronavirus_rest_api_flutter_course/app/services/api.dart';
import 'package:coronavirus_rest_api_flutter_course/app/ui/endpoint_card.dart';
import 'package:coronavirus_rest_api_flutter_course/app/ui/last_updated_status_text.dart';
import 'package:coronavirus_rest_api_flutter_course/app/ui/show_alert_dialog.dart';
import 'package:flutter/material.dart';
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
    try {
      final dataRepository =
          Provider.of<DataRepository>(context, listen: false);
      final endpointsData = await dataRepository.getAllEndpointData();
      setState(() {
        isLoading = false;
        _endpointsData = endpointsData;
      });
    } on SocketException catch (_) {
      // catch block for when connectivity issue to the server
      showAlertDialog(
          context: context,
          title: 'Connection Error',
          content: 'Could not retrive data, please try again later',
          defaultActionText: 'OK');
    } catch (_) {
      showAlertDialog(
          // catch block when there is an issue with the server
          context: context,
          title: 'Unknown Error',
          content: 'Please contact support or try again later',
          defaultActionText: 'OK');
    }
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
