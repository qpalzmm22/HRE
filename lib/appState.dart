import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class House {
  final String imageUrl;
  final String name;
  final String location;
  final String documentId;
  final User owner;
  final int monthlyPay;
  final int deposit;
  House(
      {required this.imageUrl,
      required this.name,
      required this.monthlyPay,
      required this.deposit,
      required this.location,
      required this.owner,
      required this.documentId});
}


class AppState extends ChangeNotifier{

  late User user;
  final List<House> _houses = [];

  List<House> get houses => _houses;

  void add(House house) {
    _houses.add(house);
    notifyListeners();
  }

  void remove(House product){
    _houses.remove(product);
    notifyListeners();
  }

  void removeAll() {
    _houses.clear();
    notifyListeners();
  }


}
