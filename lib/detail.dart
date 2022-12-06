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
import 'package:horizontal_card_pager/horizontal_card_pager.dart'; // TODO
import 'package:flutter_profile_picture/flutter_profile_picture.dart';

import 'appState.dart';
import 'home.dart';
import 'dbutility.dart';

Widget iconLocation(String str){
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      const Icon(Icons.location_on),
      Text(str),
    ],
  );
}

Widget CircleProfile(String img){
  return ProfilePicture(
    name: 'fixdetailpage:31',
    radius: 30,
    fontsize: 15,
    img: img,
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
    final NumberFormat numberFormat = NumberFormat.simpleCurrency(locale: "ko_KR");

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

    Widget buildFloatActionButton() {
      return FutureBuilder(
          future: getUserFromDB(house.ownerId),
          builder: (BuildContext buildContext, AsyncSnapshot<HreUser> snapshot){

            if(snapshot.hasData){
              HreUser? owner = snapshot.data;
              return Container(
                width:250,
                height: 90,
                child:
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: InkWell(
                    onTap: () async {
                      String uid = getUid();

                      List<String> participants = [house.ownerId, uid];

                      String msid = "";
                      await isMessageSessionExist(participants)
                          ? msid = await getMessageSessionIDbyuids(
                          participants)
                          : msid =
                      await makeMessageSession(participants);

                      MessageSession messageSession =
                      await getMessageSession(msid);
                      print("i sent : ${messageSession.messages.length}");
                      Navigator.pushNamed(context, '/messagePage', arguments: messageSession);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Row(
                        children: [
                          ProfilePicture(
                            name: 'ss',
                            radius: 30,
                            fontsize: 15,
                            img: owner!.profileImage,
                          ),
                          const SizedBox(width: 10,),
                          Text(
                            "Owner: ${owner!.name}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),),
                        ],
                      ),
                    ),
                  ),

                ),
              );
            } else{
              return CircularProgressIndicator();
            }
          });
    }

    Widget BookmarkIcon(){
      return IconButton(
          onPressed: isBookmarked
              ? (){
            var cart = context.read<AppState>();
            cart.remove(house);
          }
              : () {
            var cart = context.read<AppState>();
            cart.add(house);
            //TODO Add the database
          },
          icon: isBookmarked
              ? const Icon(
            Icons.bookmark_added,
            color: Colors.blue,
          )
              : const Icon(
            Icons.bookmark_add_outlined,
            color: Colors.blue,
          ) // : Icon(Icons.bookmark),  // TODO : if bookmarked make it
      );
    }


    return Scaffold(
      appBar: AppBar(
        title: Text(house.name), // TODO
        actions: house.ownerId == getUid() ?
        [ IconButton(
            onPressed: (){
              Navigator.pushNamed(context, '/editPage', arguments: house);
            },
              icon: Icon(Icons.edit),
          ),
          BookmarkIcon()
        ] :
        [BookmarkIcon()],
      ),
      body : Column(
        crossAxisAlignment : CrossAxisAlignment.start,
        children : [
          AspectRatio(
            aspectRatio: 16/11,
            child :
            InkWell(
              onDoubleTap: (){
                setState(() {
                  var cart = context.read<AppState>();
                  if(isBookmarked){
                    cart.remove(house);
                  } else{
                    cart.add(house);
                  }
                });
              },
              child: Image.network(
                house.thumbnail,
                fit: BoxFit.fitHeight,
              ) ,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start ,
                children: [
                  Text("  ${numberFormat.format(house.deposit)}만원 | ${numberFormat.format(house.monthlyPay)}원"),
                  iconLocation(house.address), // TODO
                ],
              ),
              Column(
                //mainAxisAlignment: MainAxisAlignment.center ,
                children: [
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(
                        Icons.remove_red_eye,
                      ),
                      SizedBox(width: 10),
                      Text(house.views.toString()),
                    ],
                  ),
                  TextButton(
                    onPressed: (){
                      Navigator.pushNamed(context, '/map', arguments: MapPoint(name: house.name, center: house.location, zoom: 19.5),);
                    },
                    child : const Text("지도에서 열기"),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left:30, right:30),
            child: availableOptionCards.length != 0 ?
              Text("Available Options") : Text("No Option Available"),
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
          Padding(
            padding: EdgeInsets.only(left:30, right:30),
            child: Text(house.description),
          ),
        ],
      ),
      floatingActionButton: buildFloatActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}