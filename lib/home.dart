import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

import 'package:provider/provider.dart';

import 'appState.dart';


class HomePage extends StatefulWidget {

  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  TextEditingController searchBarController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    var cart = context.watch<AppState>();

    final ThemeData theme = Theme.of(context);
    return Scaffold(

        body: Column(
          children: [
            buildAnimSearchBar(),
            locationSection(),
            Text(cart.user.displayName.toString()),
          ],
        ),
        bottomNavigationBar : BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark),
              label: 'bookmark',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.message),
              label: 'message',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'profile',
            ),
          ],
          currentIndex: _selectedIndex,
//          selectedItemColor: Colors.amber[800],

          onTap: (ind){
            setState(() {
              _selectedIndex = ind;
            });
          },
        ),
    );
  }

  Widget buildAnimSearchBar(){

    return Padding(
      padding:  const EdgeInsets.symmetric(vertical: 0, horizontal: 25),
      child: AnimSearchBar(
        autoFocus: true,
        width: 400,
        textController: searchBarController,
        onSuffixTap: (){
          setState(() {
            searchBarController.clear();
          });
        },
      ),
    );
  }

  SizedBox _locationCard(String where, Icon icon){
    return  SizedBox(
      child: Card(
          child:InkWell(
            onTap: (){
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  icon,
                  const SizedBox(width: 5,),
                  Text(where),
                ],
              ),
            ) ,
          )
      ),
    );
  }

  Widget locationSection(){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Expanded(
                child: Text(
                  "위치",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),),
              ) ,
              TextButton(
                  onPressed: (){

                  },
                  child: const Text(
                    "View ALL",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 17
                    ),
                  ),
              ),
            ],
          ),
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _locationCard("그할마", const Icon(Icons.home_filled)),
                _locationCard("다이소(양덕)", const Icon(Icons.shopping_cart)),
                _locationCard("법원", const Icon(Icons.house_outlined)),
                _locationCard("커피유야", const Icon(Icons.coffee)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // List<Card> _buildHouseCards(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
  //   final NumberFormat numberFormat = NumberFormat.simpleCurrency(locale: "ko_KR");
  //
  //   return snapshot.data!.docs.map((DocumentSnapshot document) {
  //     var isInCart = context.select<AppState, bool>(
  //           (cart) => cart.items
  //           .where((element) => element.documentId == document.id)
  //           .isNotEmpty,
  //     );
  //     return Card(
  //       child: Column(
  //         //crossAxisAlignment: CrossAxisAlignment.start,
  //         children: <Widget>[
  //           AspectRatio(
  //             aspectRatio: 16 / 11,
  //             child: isInCart
  //                 ? Stack(
  //               children: [
  //                 Image.network(
  //                   document['imageUrl'],
  //                   fit: BoxFit.fitHeight,
  //                 ),
  //                 const (
  //                   top: 10,
  //                   righPositionedt: 10,
  //                   child: Icon(
  //                     Icons.check_circle,
  //                     color: Colors.blue,
  //                   ),)
  //               ],
  //             )
  //                 : Image.network(
  //               document['imageUrl'],
  //               fit: BoxFit.fitHeight,
  //             ),
  //           ),
  //           Expanded(
  //             child: Padding(
  //               padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
  //               child: Row(
  //                 children: [
  //                   const SizedBox(
  //                     width: 7,
  //                   ),
  //                   Expanded(
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: <Widget>[
  //                         Text(
  //                           document['productName'],
  //                           style: const TextStyle(
  //                             fontSize: 13,
  //                             fontWeight: FontWeight.bold,
  //                           ),
  //                           maxLines: 1,
  //                         ),
  //                         Expanded(
  //                           child: Text(
  //                             numberFormat.format(document['price']),
  //                             style: const TextStyle(
  //                               fontSize: 11,
  //                             ),
  //                             maxLines: 2,
  //                           ),
  //                         ),
  //                         Row(
  //                             mainAxisAlignment: MainAxisAlignment.end,
  //                             children: [
  //                               SizedBox(
  //                                 width: 50,
  //                                 height: 30,
  //                                 child: TextButton(
  //                                   onPressed: () async {
  //                                     Product info = Product(
  //                                       user: user,
  //                                       documentId: document.id,
  //                                       productName: document['productName'],
  //                                       description: document['description'],
  //                                       imageUrl: document['imageUrl'],
  //                                       price: document['price'],
  //                                     );
  //                                     Navigator.pushNamed(context, '/product_detail', arguments: info).then((value){
  //                                       if(value == true){
  //                                         Future.delayed(const Duration(milliseconds: 500), (){
  //                                           products.doc(document.id).delete();
  //                                           FirebaseStorage.instance
  //                                               .refFromURL(document['imageUrl'])
  //                                               .delete();
  //                                         });
  //                                       }
  //                                     });
  //                                   },
  //                                   child: const Text(
  //                                     "more",
  //                                     textAlign: TextAlign.right,
  //                                     style: TextStyle(
  //                                       fontSize: 11,
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ),
  //                             ]),
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     );
  //   }).toList();
  // }
}
