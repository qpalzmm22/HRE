import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

  Widget getProfile(User user) {
    return SafeArea(
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            _getProfilePhoto(user),
            const SizedBox(
              height: 20,
            ),
            Text(
              user?.displayName as String,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              textAlign: TextAlign.center,
            ),
            _getEmail(user),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: Divider(color: Colors.black, thickness: 1.5),
                ),
              ],
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
