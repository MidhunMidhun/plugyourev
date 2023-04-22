import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

final myCenter = LatLng(10.850516, 76.271080);

class EnRoute extends StatefulWidget {
  const EnRoute({Key? key}) : super(key: key);
  static const String ACCESS_TOKEN = String.fromEnvironment(
      "pk.eyJ1IjoibW1pZGh1biIsImEiOiJjbGFxYTIxODcxNDB0M3ZucGlmcWp3cHpuIn0.4ekFwyhXAkUt-zYu9ePDpQ");
  static const String mapBoxStyleId = 'clfgi2vwf00a901rxqoiggpna';

  @override
  State<EnRoute> createState() => _EnRouteState();
}

//Test Comment
class _EnRouteState extends State<EnRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              zoom: 8,
              center: myCenter,
            ),
            children: [
              TileLayer(
                  urlTemplate:
                      'https://api.mapbox.com/styles/v1/mmidhun/clfgi2vwf00a901rxqoiggpna/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoibW1pZGh1biIsImEiOiJjbGFxYTIxODcxNDB0M3ZucGlmcWp3cHpuIn0.4ekFwyhXAkUt-zYu9ePDpQ',
                  additionalOptions: {
                    'mapStyleId': EnRoute.mapBoxStyleId,
                    'accessToken': EnRoute.ACCESS_TOKEN,
                  }),
            ],
          ),
        ],
      ),
    );
  }
}
