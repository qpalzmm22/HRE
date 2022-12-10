import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    MapPoint location = ModalRoute.of(context)!.settings.arguments as MapPoint;

    Widget buildMap(){
      return GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: location.center,
          zoom: location.zoom,
        ),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        markers: Set.from(location.markers),
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(location.name),
          backgroundColor: Colors.green[700],
        ),
        body: buildMap(),
      );
  }
}
