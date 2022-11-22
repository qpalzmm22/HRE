import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'appState.dart';

void addGoogleUser(User? user){

  if(user != null) {
    print(user.uid);
    FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .set({
      'email': user.email.toString(),
      'name': user.displayName.toString(),
      'status_message': 'I promise to take the test honestly before GOD',
      'uid': user.uid,
    });
  }
}

void addAnonymousUser(User? user){

  if(user != null) {
    print(user.uid);
    FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .set({
      'email': "",
      'name': "",
      'status_message': 'I promise to take the test honestly before GOD',
      'uid': user.uid,
    });
  }
}

bool isUserExist(User? user){

  if(user != null){
    FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: user.uid)
        .get().then((value) {
      return (value.size > 0);
    });
  }
  return false;
}

void addHouse(
    String name,
    int deposit,
    int monthlyPay,
    String description,
    String thumbnail,
    List<String> imageLinks,
    List<bool> options){

  User? user = FirebaseAuth.instance.currentUser;
  if(user != null){
    FirebaseFirestore.instance
        .collection('houses')
        .add(<String, dynamic>{
      'name': name,
      'deposit': deposit,
      'monthlyPay': monthlyPay,
      'description' : description,
      'houseSize' : 0, // TODO
      'location' : "장성로 128번길 24-5", // TODO Geometry? string
      'userId': user.uid,
      'created': FieldValue.serverTimestamp(),
      'modified': FieldValue.serverTimestamp(),
      // TODO 'roomInfo' :  RoomInfo(room_type : "hello",  num_of_bedrooms : 2, num_of_bathrooms : 1), // TODO
      //'likers' : <String>[], // initial likes = 0
      'thumbnail': thumbnail,
      'imagelinks' : imageLinks,
      'options' : options,
    });
  }
}

Future<String> uploadFile (File? file) async {
  User? user = FirebaseAuth.instance.currentUser;
  print("uploading");

  String filelink = '';
  if(file != null && user != null) {

    final storageRef = FirebaseStorage.instance.ref();
    //$file
    String fullPath = "${user.uid}/${basename(file.path)}";
    print("full path" + fullPath);
    final destRef = storageRef.child(fullPath);
    await destRef.putFile(file);
    filelink = await destRef.getDownloadURL();
  } else {
    print("no file");
  }
  return filelink;
}