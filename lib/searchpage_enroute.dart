import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_search/mapbox_search.dart';
import 'package:plugyourev/en_route.dart';
import 'package:plugyourev/maparea.dart';

class MapBoxSearchScreenEnroute extends StatefulWidget {
  String target;
  MapBoxSearchScreenEnroute({this.target = ''});
  @override
  _MapBoxSearchScreenEnrouteState createState() =>
      _MapBoxSearchScreenEnrouteState();
}

class _MapBoxSearchScreenEnrouteState extends State<MapBoxSearchScreenEnroute> {
  List<String> _placesList = [];
  //search places

  String MAPBOX_ACCESS_TOKEN =
      'pk.eyJ1IjoibW1pZGh1biIsImEiOiJjbGFxYTIxODcxNDB0M3ZucGlmcWp3cHpuIn0.4ekFwyhXAkUt-zYu9ePDpQ';

  String baseUrl = 'https://api.mapbox.com/geocoding/v5/mapbox.places';
  String searchType = 'place%2Cpostcode%2Caddress';
  String searchResultsLimit = '5';
  String proximity = 'ip';
  String country = 'in';

  Dio _dio = Dio();
  final TextEditingController _textEditingController = TextEditingController();

  List<MapBoxPlace> searchResults = [];
  Future getSearchResultsFromQueryUsingMapbox(String searchtext) async {
    String url =
        '$baseUrl/$searchtext.json?&proximity=$proximity&access_token=$MAPBOX_ACCESS_TOKEN';
    url = Uri.parse(url).toString();
    // String url =
    //     '$baseUrl/$searchtext.json?country=$country&limit=$searchResultsLimit&proximity=$proximity&types=$searchType&access_token=$MAPBOX_ACCESS_TOKEN';
    // url = Uri.parse(url).toString();
    print(url);
    try {
      _dio.options.contentType = Headers.jsonContentType;
      final responseData = await _dio.get(url);
      setState(() {
        _placesList.add(responseData.data['features'][0]['place_name']);
      });
      print(responseData.data['features'][0]['place_name']);
      return responseData.data;
    } catch (e) {
      var DioExceptions;
      final errorMessage = DioExceptions.fromDioError(e as DioError).toString();
      debugPrint(errorMessage);
    }
  }

  Future<void> getPlaces(String searchQ) async {
    PlacesSearch placesSearch = PlacesSearch(
      apiKey:
          'pk.eyJ1IjoibW1pZGh1biIsImEiOiJjbGFxYTIxODcxNDB0M3ZucGlmcWp3cHpuIn0.4ekFwyhXAkUt-zYu9ePDpQ',
      limit: 5,
    );

    List<MapBoxPlace>? results = await placesSearch.getPlaces(searchQ);

    setState(() {
      searchResults = results!;
    });
  }

  @override
  void initState() {
    super.initState();
    print("widget.target");
    print(widget.target);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.76,
              child: CupertinoSearchTextField(
                controller: _textEditingController,
                onChanged: (v) {
                  getPlaces(v);
                },
                //onTap: _search,
                backgroundColor: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                placeholder: 'Search',
              ),

              // autoCompleteWidget,
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: searchResults.length,
        itemBuilder: (BuildContext context, int index) {
          MapBoxPlace item = searchResults[index];
          return ListTile(
            onTap: () {
              print(item.geometry!.coordinates);
              double lng = item.geometry!.coordinates![0];
              double lat = item.geometry!.coordinates![1];
              widget.target == 'source'
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EnRoute(
                                source: true,
                                lat: lat,
                                lon: lng,
                              )),
                    )
                  : Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EnRoute(
                                destination: true,
                                lat: lat,
                                lon: lng,
                              )),
                    );
            },
            title: Text(item.placeName!),
          );
        },
      ),
    );
  }
}
