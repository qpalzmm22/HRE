import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';


import 'appState.dart';
import 'home.dart';

class Map extends StatefulWidget {
  const Map({Key? key}) : super(key: key);

  @override
  _Map createState() => _Map();
}

class _Map extends State<Map> {

  Completer<GoogleMapController> mapController = Completer();

  get Geolocator => null;
  void _onMapCreated(GoogleMapController controller) {
    mapController = mapController;
  }

  Future<void> getAddress(LatLng location) async{
    String url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=${location.latitude},${location.longitude}&key=AIzaSyBCizThefGgFPIwkUjYe2JiZkzdMQyJiRs';
    final response = await http.get(Uri.parse(url));
    print(jsonDecode(response.body)['results'][0]['formatted_address']);
  }

  @override
  Widget build(BuildContext context) {
    MapPoint location = ModalRoute.of(context)!.settings.arguments as MapPoint;

    var cart = context.read<AppState>();

    Widget buildMap(){

      return GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: location.center,
          zoom: location.zoom,
        ),
        myLocationEnabled: false,
        myLocationButtonEnabled: false,
        markers: Set.from(cart.markers),
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(location.name),
          backgroundColor: Colors.green[700],
        ),
        body: buildMap(),
        floatingActionButton: IconButton(
          icon: const Icon(Icons.my_location),
          onPressed: () {

            },

        ),
      );
  }
}
