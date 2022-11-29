import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:horizontal_card_pager/card_item.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:horizontal_card_pager/horizontal_card_pager.dart';

import 'appState.dart';

Widget iconLocation(String str){
  return Row(
    children: [
      const Icon(Icons.location_on),
      Text(str),
    ],
  );
}




class DetailPage extends StatefulWidget {

  const DetailPage({Key? key}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {

  int _selectedIndex = 0;


  List<Icon> optionIconList = [
    Icon(Icons.wifi), Icon(Icons.wifi), Icon(Icons.bed), Icon(Icons.wifi),
    Icon(Icons.kitchen), Icon(Icons.wifi), Icon(Icons.wifi), Icon(Icons.wifi),
    Icon(Icons.chair), Icon(Icons.wifi), Icon(Icons.wifi),
  ];

  static List<String> _options = [
    "sink", "wifi", "bed", "gas_stove",
    "refrigerator", "airconditioner", "closet", "washing_machine",
    "chair", "shoe_closet", "veranda"
  ];

  List<Card> availableOptionCards = [];

  @override
  Widget build(BuildContext context) {
    House house = ModalRoute.of(context)!.settings.arguments as House;

    var isBookmarked = context.select<AppState, bool>(
          (cart) => cart.bookmarked
          .where((element) => element.documentId == house.documentId)
          .isNotEmpty,
    );
    for(int i = 0; i < house.optionList.length; i++){
      if(house.optionList[i]) {
        availableOptionCards.add(Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              optionIconList[i],//Icon(Icons.wifi),
              Text(_options[i]),
            ],
          ),
        ));
      }
    }
    //bool isBookMarked = passedProduct.;

    return Scaffold(
      appBar: AppBar(
        title: Text(house.name), // TODO
        actions: [
          IconButton(
            onPressed: isBookmarked
            ? null
            : () {
              var cart = context.read<AppState>();
              cart.add(house);
              //TODO Add the database
            },
            icon: isBookmarked
            ? const Icon(
              Icons.bookmark_added,
              color: Colors.yellow,
            )
            : const Icon(
                Icons.bookmark_add_outlined,
              color: Colors.yellow,
            ) // : Icon(Icons.bookmark),  // TODO : if bookmarked make it
          ),
        ],
      ),
      body : Column(
        crossAxisAlignment : CrossAxisAlignment.start,
        children : [
          AspectRatio(
            aspectRatio: 16/11,
            child : Image.network(
              house.imageUrl,
              fit: BoxFit.fitHeight,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text("${house.deposit}만원 | ${house.monthlyPay}원"),
                  iconLocation("장량로 128번길 24-5"), // TODO
                ],
              ),
              Column(
                //mainAxisAlignment: MainAxisAlignment.center ,
                children: [
                  SizedBox(height: 16),
                  Row(
                    children: const [
                      Icon(
                        Icons.star,
                        color: Colors.yellow,
                      ),
                      Text("10"),
                    ],
                  ),
                  TextButton(
                    onPressed: (){},
                    child : const Text("all reviews"),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left:30, right:30),
            child: Text(house.description),
          ),
          Padding(
            padding: EdgeInsets.only(left:30, right:30),
            child: Text("Available Options"),
          ),
          SizedBox(
            height: 100,
            child : ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.all(8),
                itemCount: availableOptionCards.length,
                itemBuilder: (context, idx ){
                  return Container(
                    width: 100,
                    child : availableOptionCards[idx]
                );
              }
            )
          ),
        ],
      ),
    );
  }
}