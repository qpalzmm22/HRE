import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RoomInfo{
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
  final String imageUrl;
  final String name;
  final String location;
  final String documentId;
  final String ownerId;
  final String description;
  final int monthlyPay;
  final int deposit;
  final List<bool> optionList;
  House({
      required this.imageUrl,
      required this.name,
      required this.monthlyPay,
      required this.deposit,
      required this.location,
      required this.description,
      required this.ownerId,
      required this.documentId,
      required this.optionList,
  });
}


class AppState extends ChangeNotifier{

  late User user;
  final List<House> _bookmarked = [];
  List<House> get bookmarked => _bookmarked;

  House? _curHouse;
  House? get curHouse => _curHouse;


  void add(House house) {
    _bookmarked.add(house);
    notifyListeners();
  }

  void remove(House product){
    _bookmarked.remove(product);
    notifyListeners();
  }

  void removeAll() {
    _bookmarked.clear();
    notifyListeners();
  }
}
