import 'package:coronavirus_rest_api_flutter_course/app/services/api.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EndpointCardData {
  final String title;
  final String assetName;
  final Color color;

  EndpointCardData(this.title, this.assetName, this.color);
}

class EndpointCard extends StatelessWidget {
  const EndpointCard({Key? key, this.endpoint, this.value}) : super(key: key);
  final Endpoint? endpoint;
  final int? value;

  static final Map<Endpoint, EndpointCardData> _cardsData = {
    Endpoint.cases:
        EndpointCardData('Cases', 'assets/count.png', const Color(0xFFFFF492)),
    Endpoint.casesSuspected: EndpointCardData(
        'Suspected cases', 'assets/suspect.png', const Color(0xFFEEDA28)),
    Endpoint.casesConfirmed: EndpointCardData(
        'Confirmed cases', 'assets/fever.png', const Color(0xFFE99600)),
    Endpoint.deaths:
        EndpointCardData('Deaths', 'assets/death.png', const Color(0xFFE40000)),
    Endpoint.recovered: EndpointCardData(
        'Recovered', 'assets/patient.png', const Color(0xFF70A901)),
  };

  String get formattedValue {
    return NumberFormat('#,###,###,###').format(value);
  }

  @override
  Widget build(BuildContext context) {
    final cardData = _cardsData[endpoint];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cardData!.title,
                style: Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .copyWith(color: cardData.color),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 45,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      cardData.assetName,
                      color: cardData.color,
                    ),
                    Text(
                      formattedValue,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(color: cardData.color),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
