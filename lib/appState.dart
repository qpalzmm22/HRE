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
  final String hid;
  final String thumbnail;
  final String name;
  final String address;
  final String documentId;
  final String ownerId;
  final String description;
  final int monthlyPay;
  final int deposit;
  final LatLng location;
  final List<bool> optionList; // TODO : DEPRECATED
  final List<String> imageLinks;
  final int views;
  final List<String> tags;
  House({
    required this.hid,
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
    required this.tags,
  });
}

class AppState extends ChangeNotifier {
  final List<House> _bookmarked = [];

  bool isNeedToBeUpdated = false;
  List<House> get bookmarked => _bookmarked;

  House? _curHouse;
  House? get curHouse => _curHouse;

  void add(House house) {
    _bookmarked.add(house);
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



}
