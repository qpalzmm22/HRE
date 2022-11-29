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

  final List<House> _bookmarked = [];
  final List<House> _recentlyView =[];


  List<House> get bookmarked => _bookmarked;
  List<House> get recentlyView => _recentlyView;

  House? _curHouse;
  House? get curHouse => _curHouse;


  void add(House house) {
    _bookmarked.add(house);
    notifyListeners();
  }

  void remove(House house){
    _bookmarked.remove(house);
    notifyListeners();
  }

  void removeAll() {
    _bookmarked.clear();
    notifyListeners();
  }

  void addRecentlyView(House house){
    _recentlyView.add(house);
    notifyListeners();
  }

}
