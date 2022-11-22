import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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

void addHouse(String name, int monthlyPay, String description, String thumbnail, List<String> imageLinks){
  User? user = FirebaseAuth.instance.currentUser;
  if(user != null){
    FirebaseFirestore.instance
        .collection('houses')
        .add(<String, dynamic>{
      'name': name,
      'monthlyPay': monthlyPay,
      'description' : description,
      'userId': user.uid,
      'created': FieldValue.serverTimestamp(),
      'modified': FieldValue.serverTimestamp(),
      'likers' : <String>[], // initial likes = 0
      // 'bookmarkers' : <String>[],
      'thumbnail': thumbnail,
      'imagelinks' : imageLinks,
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