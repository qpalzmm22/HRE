import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:horizontal_card_pager/card_item.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:carousel_slider/carousel_slider.dart';

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

  @override
  Widget build(BuildContext context) {
    House house = ModalRoute.of(context)!.settings.arguments as House;
    final NumberFormat numberFormat = NumberFormat.simpleCurrency(locale: "ko_KR");

    var isBookmarked = context.select<AppState, bool>(
          (cart) => cart.bookmarked
          .where((element) => element.documentId == house.documentId)
          .isNotEmpty,
    );

    Widget buildFloatActionButton()  {


      return FutureBuilder(
          future: getUserFromDB(house.ownerId),
          builder: (BuildContext buildContext, AsyncSnapshot<HreUser> snapshot)  {
            HreUser? owner =  snapshot.data;

            if(snapshot.hasData){
              return SizedBox(
                  width: 300,
                  height: 100,
                  child:Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ProfilePicture(
                                  name: 'ss',
                                  radius: 30,
                                  fontsize: 15,
                                  img: owner!.profileImage,
                                ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("?????????: ${owner!.name}"),
                              Text(
                                owner.email,
                                style: const TextStyle(
                                    fontSize: 10, color: Colors.grey),
                              ),
                            ],
                          ),
                          IconButton(
                              onPressed: () async {
                                String uid = getUid();
                                List<String> participants = [owner.uid, uid];
                                participants.sort();

                                navigateToMessagePage(context, participants);

                              },
                              icon: const Icon(Icons.message))
                        ],
                      ),
                    ),
                  ),
                );

            } else{
              return const CircularProgressIndicator();
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
          },
          icon: isBookmarked
              ? const Icon(
            Icons.bookmark_added,
            color: Colors.blue,
          )
              : const Icon(
            Icons.bookmark_add_outlined,
            color: Colors.blue,
          )
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
          IconButton(
            onPressed: (){
              Navigator.pop(context, true);
            },
            icon: const Icon(Icons.delete),
          ),
        ] :
        [BookmarkIcon()],
      ),
      body : Column(
        crossAxisAlignment : CrossAxisAlignment.start,
        children : [
          CarouselSlider(
            options: CarouselOptions(
              height: 200,
              aspectRatio: 16/9,
              viewportFraction: 0.8,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              // onPageChanged: callbackFunction,
              scrollDirection: Axis.horizontal,
            ),
            items: house.imageLinks.map((image) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    // decoration: BoxDecoration(
                    //     color: Colors.amber
                    // ),
                    child: Image.network(
                        image,
                        fit: BoxFit.fitHeight,
                      ) ,
                  );
                },
              );
            }).toList(),
          ),
          // AspectRatio(
          //   aspectRatio: 16/11,
          //   child :
          //   InkWell(
          //     onDoubleTap: (){
          //       setState(() {
          //         var cart = context.read<AppState>();
          //         if(isBookmarked){
          //           cart.remove(house);
          //         } else{
          //           cart.add(house);
          //         }
          //       });
          //     },
          //     child: Image.network(
          //       house.thumbnail,
          //       fit: BoxFit.fitHeight,
          //     ) ,
          //   ),
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start ,
                children: [
                  Text("  ${numberFormat.format(house.deposit)} ?????? | ${numberFormat.format(house.monthlyPay)} ??????"),
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
                      List<Marker> markers = [];
                      markers.add(Marker(
                        markerId: MarkerId(house.name,),
                          position: house.location,
                          onTap: () {
                            Navigator.pushNamed(context, '/detail', arguments: house);
                          }
                      ));
                      Navigator.pushNamed(context, '/map', arguments: MapPoint(name: house.name, center: house.location, zoom: 19.0, markers: markers ),);
                    },
                    child : const Text("???????????? ??????"),
                  ),
                ],
              ),
            ],
          ),
          const Divider(height: 10,),
          Padding(
            padding: EdgeInsets.only(left:30, right:30),
            child: Text("??????: ${house.description}"),
          ),
          const Divider(height: 10,),
          Padding(
            padding: EdgeInsets.only(left:30, right:30),
            child: house.tags.length != 0 ?
              Text("Available Options") : Text("No Option Available"),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.only(left:30, right:30),
              // crossAxisCount : 4,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5, //1 ?????? ?????? ????????? item ??????
                childAspectRatio: 4 / 1, //item ??? ?????? 1, ?????? 2 ??? ??????
                mainAxisSpacing: 5, //?????? Padding
                crossAxisSpacing: 5, //?????? Padding
              ),
              itemBuilder: (context, index) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.cyan,
                    borderRadius:
                    BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: Center(child: Text(house.tags[index])),
                );
              },
              // separatorBuilder: (context, index) => const Divider(),
              itemCount: house.tags.length,
            ),
          ),
        ],
      ),
      floatingActionButton: buildFloatActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}