import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

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

  Future<void> getCurrentLocation()  async {
    final GoogleMapController controller = await mapController.future;
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(position.latitude, position.longitude))));

  }

  @override
  Widget build(BuildContext context) {
    MapPoint location = ModalRoute.of(context)!.settings.arguments as MapPoint;

    Widget buildFloatingSearchBar() {
      final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

      return FloatingSearchBar(
        hint: '위치로 검색...',
        scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
        transitionDuration: const Duration(milliseconds: 800),
        transitionCurve: Curves.easeInOut,
        physics: const BouncingScrollPhysics(),
        axisAlignment: isPortrait ? 0.0 : -1.0,
        openAxisAlignment: 0.0,
        width: isPortrait ? 600 : 500,
        debounceDelay: const Duration(milliseconds: 500),
        onQueryChanged: (query) {
          // Call your model, bloc, controller here.
        },
        // Specify a custom transition to be used for
        // animating between opened and closed stated.
        transition: CircularFloatingSearchBarTransition(),
        actions: [
          FloatingSearchBarAction(
            showIfOpened: false,
            child: CircularButton(
              icon: const Icon(Icons.place),
              onPressed: () {},
            ),
          ),
          FloatingSearchBarAction.searchToClear(
            showIfClosed: false,
          ),
        ],
        builder: (context, transition) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Material(
              color: Colors.white,
              elevation: 4.0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text("HelloHello")
                ]
              ),
            ),
          );
        },
      );
    }

    Widget buildMap(){
      return GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: location.center,
          zoom: 17.0,
        ),
        myLocationEnabled: false,
        myLocationButtonEnabled: false,
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('\'${location.name}\' 부근 매물 목록'),
          backgroundColor: Colors.green[700],
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            buildMap(),
            buildFloatingSearchBar(),
          ]
        ),
        floatingActionButton: IconButton(
          icon: const Icon(Icons.my_location),
          onPressed: ()  {
            getCurrentLocation();
            },

        ),
      );
  }
}
