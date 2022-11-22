import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:horizontal_card_pager/card_item.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:horizontal_card_pager/horizontal_card_pager.dart';

Widget IconLocation(String str){
  return Row(
    children: [
      Icon(Icons.location_on),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("NAme of the building"), // TODO
        actions: [
          IconButton(
            onPressed: (){},
            icon: Icon(Icons.bookmark_add_outlined) // : Icon(Icons.bookmark),  // TODO : if bookmarked make it
          ),
        ],
      ),
      body : Column(
        crossAxisAlignment : CrossAxisAlignment.start,
        children : [
          AspectRatio(
            aspectRatio: 16/11,
            child : Image.network(
              "https://handong.edu/site/handong/res/img/logo.png",
              fit: BoxFit.fitHeight,
            ), // TODO : from data
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text("100만원 | 30만원"),
                  IconLocation("장량로 128번길 24-5"),
                ],
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.yellow,
                      ),
                      Text("10"),
                    ],
                  ),
                  TextButton(
                    onPressed: (){},
                    child : Text("all reviews"),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left:30, right:30),
            child: Text("Available Options"),
          ),
          SizedBox(
            height: 100,
            child: ListView(
              // shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.all(8),
              children: [ // TODO
                Container(
                  width: 100,
                  child : Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(Icons.wifi),
                        Text("WiFi"),
                        //Sized
                      ],
                    ),
                  )
                ),
                Container(
                    width: 100,
                    child : Card(
                      child: Column(
                        children: [
                          Icon(Icons.wifi),
                          Text("WiFi"),
                        ],
                      ),
                    )
                ),
                Container(
                  width: 100,
                  child : Card(
                    child: Column(
                      children: [
                        Icon(Icons.wifi),
                        Text("WiFi"),
                      ],
                    ),
                  )
                ),
                Container(
                  width: 100,
                  child : Card(
                    child: Column(
                      children: [
                        Icon(Icons.wifi),
                        Text("WiFi"),
                      ],
                    ),
                  )
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}