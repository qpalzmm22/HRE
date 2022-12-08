import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RoomInfo {
  final String room_type;
  final int num_of_bedrooms;
  final int num_of_bathrooms;

  RoomInfo({
    required this.room_type,
    required this.num_of_bedrooms,
    required this.num_of_bathrooms,
  });
}

class House {
  final String thumbnail;
  final String name;
  final String address;
  final String documentId;
  final String ownerId;
  final String description;
  final int monthlyPay;
  final int deposit;
  final LatLng location;
  final List<bool> optionList;
  final List<String> imageLinks;
  final int views;
  House({
    required this.location,
    required this.thumbnail,
    required this.name,
    required this.monthlyPay,
    required this.deposit,
    required this.address,
    required this.description,
    required this.ownerId,
    required this.documentId,
    required this.optionList,
    required this.imageLinks,
    required this.views,
  });
}

class AppState extends ChangeNotifier {
  final List<House> _bookmarked = [];
  final List<House> _recentlyView = [];
  late List<Marker> _markers = [];

  List<House> get bookmarked => _bookmarked;
  List<House> get recentlyView => _recentlyView;
  List<Marker> get markers => _markers;

  House? _curHouse;
  House? get curHouse => _curHouse;

  init(){
    _markers = [];
  }

  void add(House house) {
    _bookmarked.add(house);
    notifyListeners();
  }

  void addMarker(Marker marker) {
    _markers.add(marker);
  }

  void setNotifyListener(){
    notifyListeners();
  }

  void remove(House house) {
    _bookmarked.remove(house);
    notifyListeners();
  }

  void removeAll() {
    _bookmarked.clear();
    notifyListeners();
  }

  void addRecentlyView(House house) {
    _recentlyView.add(house);
    notifyListeners();
  }

}
