import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_search/mapbox_search.dart';
import 'package:plugyourev/maparea.dart';

class MapBoxSearchScreen extends StatefulWidget {
  @override
  _MapBoxSearchScreenState createState() => _MapBoxSearchScreenState();
}

class _MapBoxSearchScreenState extends State<MapBoxSearchScreen> {
  List<String> _placesList = [];

  final TextEditingController _textEditingController = TextEditingController();

  List<MapBoxPlace> searchResults = [];

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
                backgroundColor: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                placeholder: 'Search',
              ),
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

              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MapArea(
                          lat: lat,
                          lng: lng,
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
