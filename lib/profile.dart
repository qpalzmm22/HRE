import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import 'appState.dart';

class ProfileMessage {
  ProfileMessage(
      {required this.email,
      required this.name,
      required this.statusMessage,
      required this.uid});

  final String email;
  final String name;
  final String statusMessage;
  final String uid;
}

class Profile {
  CollectionReference users = FirebaseFirestore.instance.collection('user');

  SizedBox _getProfilePhoto(User? user) {
    String photoUrl;
    if (user?.photoURL == null) {
      photoUrl = "https://handong.edu/site/handong/res/img/logo.png";
    } else {
      photoUrl = user?.photoURL as String;
    }
    return SizedBox(
      height: 130,
      width: 130,
      child: ClipOval(
        clipper: MyClipper(),
        child: Image.network(
          photoUrl,
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }

  Text _getEmail(User? user) {
    String email;
    if (user?.email == null) {
      email = "anonymous";
    } else {
      email = user?.email as String;
    }
    return Text(
      email,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: Colors.blueGrey,
      ),
      maxLines: 1,
      textAlign: TextAlign.center,
    );
  }

  Text _getUserName(User? user) {
    String userName;
    if (user?.displayName == null) {
      userName = "anonymous";
    } else {
      userName = user?.displayName as String;
    }
    return Text(
      userName,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.blueGrey,
      ),
      maxLines: 1,
      textAlign: TextAlign.center,
    );
  }

  Widget getProfile(BuildContext context, User user) {
    CollectionReference myHouses =
        FirebaseFirestore.instance.collection("houses");
    final ThemeData theme = Theme.of(context);

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            _getProfilePhoto(user),
            const SizedBox(
              height: 20,
            ),
            _getUserName(user),
            _getEmail(user),
            Column(
              children: const [
                SizedBox(
                  height: 30,
                  width: double.infinity,
                  child: Divider(color: Colors.black, thickness: 1.5),
                ),
              ],
            ),
            Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "등록한 매물",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                )),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: FutureBuilder(
                  future: myHouses.where("userId", isEqualTo: user.uid).get(),
                  builder: (context, snapshot) {
                    List data =
                        snapshot.data == null ? [] : snapshot.data!.docs;
                    int len =
                        snapshot.data == null ? 0 : snapshot.data!.docs.length;
                    print("uid : ${user.uid}");
                    final NumberFormat numberFormat =
                        NumberFormat.simpleCurrency(locale: "ko_KR");
                    return ListView.builder(
                        itemCount: len,
                        itemBuilder: (BuildContext context, int idx) {
                          GeoPoint gps = data[idx]['location'];

                          House house = House(
                            thumbnail: data[idx]['thumbnail'],
                            name: data[idx]['name'],
                            address: data[idx]['address'],
                            documentId: data[idx].id,
                            ownerId: data[idx]['userId'],
                            description: data[idx]['description'] as String,
                            monthlyPay: data[idx]['monthlyPay'] as int,
                            deposit: data[idx]['deposit'],
                            optionList: List<bool>.from(data[idx]['options']),
                            location: LatLng(gps.latitude, gps.longitude),
                            imageLinks: List.from(data[idx]['imagelinks']),
                            views: data[idx]['views'],
                          );

                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, '/detail',
                                    arguments: house);
                              },
                              child: Padding(
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                child: ListTile(
                                    leading: AspectRatio(
                                      aspectRatio: 16 / 9,
                                      child: Image.network(
                                        data[idx]["thumbnail"],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          house.name,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 1,
                                        ),
                                        Row(
                                          children: [
                                            Icon(Icons.location_on),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: Text(
                                                house.address,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                ),
                                                maxLines: 2,
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    )),
                              ),
                            ),
                          );
                        });
                  }),
            )
          ],
        ),
      ),
    );
  }
}

class MyClipper extends CustomClipper<Rect> {
  @override
  getClip(Size size) {
    // TODO: implement getClip
    return Rect.fromLTWH(0, 0, size.width, size.height);
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return false;
  }
}
