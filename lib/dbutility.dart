import 'dart:async';
import 'dart:io';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:handong_real_estate/messageSession.dart';
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


Future<HreUser> getUserFromDB(String uid) async {
  return await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .get()
      .then((value) {
        if(value.data() != null){
          print("JY ERROR!!! :  getuserFromdb : no value().data ");
        }
        return HreUser(
          uid: value.data()!['uid'],
          name: value.data()!['name'],
          profileImage:value.data()!['name'],
          email: value.data()!['email'],
        );
  });
}

class HreUser{
  HreUser(
      {required this.uid,
        required this.name,
        required this.profileImage,
        required this.email,
      });
  final String uid;
  final String name;
  final String profileImage;
  final String email;
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

void addHouseToDB(House house){
      FirebaseFirestore.instance
        .collection('houses')
        .add(<String, dynamic>{
      'name': house.name,
      'deposit': house.deposit,
      'monthlyPay': house.monthlyPay,
      'description' : house.description,
      'houseSize' : 0, // TODO
      'address' : house.address,
      'userId': house.ownerId,
      'created': FieldValue.serverTimestamp(),
      'modified': FieldValue.serverTimestamp(),
      // TODO 'roomInfo' :  RoomInfo(room_type : "hello",  num_of_bedrooms : 2, num_of_bathrooms : 1), // TODO
      //'likers' : <String>[], // initial likes = 0
      'thumbnail': house.thumbnail,
      'imagelinks' : house.imageLinks,
      'options' : house.optionList,
      'location' : GeoPoint(house.location.latitude, house.location.longitude),
    });
}

// void addHouse(
//     String address,
//     LatLng location,
//     String name,
//     int deposit,
//     int monthlyPay,
//     String description,
//     String thumbnail,
//     List<String> imageLinks,
//     List<bool> options,
//     ){
//
//   User? user = FirebaseAuth.instance.currentUser;
//   if(user != null){
//     FirebaseFirestore.instance
//         .collection('houses')
//         .add(<String, dynamic>{
//       'name': name,
//       'deposit': deposit,
//       'monthlyPay': monthlyPay,
//       'description' : description,
//       'houseSize' : 0, // TODO
//       'address' : "장성로 128번길 24-5", // TODO Geometry? string
//       'userId': user.uid,
//       'created': FieldValue.serverTimestamp(),
//       'modified': FieldValue.serverTimestamp(),
//       // TODO 'roomInfo' :  RoomInfo(room_type : "hello",  num_of_bedrooms : 2, num_of_bathrooms : 1), // TODO
//       //'likers' : <String>[], // initial likes = 0
//       'thumbnail': thumbnail,
//       'imagelinks' : imageLinks,
//       'options' : options,
//       'location' : location,
//     });
//   }
// }

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

class Message{
  Message(
      {required this.timestamp,
        required this.senderId,
        required this.message,
      });
  final Timestamp timestamp;
  final String senderId;
  final String message;
}

class MessageSession {
  MessageSession(
      {required this.users,
        required this.usersString,
        required this.recentMessage,
        // required this.messagesRef,
        required this.messages,
        required this.msid,
        required this.profileImage,
        required this.timestamp,
        required this.sessionName,
      });

  final List<String> users;
  final String usersString;
  final String recentMessage;
  //final CollectionReference messagesRef;
  final List<Message> messages;
  final String profileImage;
  final String msid;
  final String sessionName;
  final Timestamp timestamp;
}

Future<List<MessageSession>> getMessageMutipleSessionsbyuid(String uid) async {

  List<MessageSession> messageSessions = [];
  await FirebaseFirestore.instance
      .collection('messageSessions')
      .where('users', arrayContains: uid)
      .orderBy('timestamp', descending: true)
      .get()
      .then((snapshots) async {
        for (var doc in snapshots.docs) {
          messageSessions.add(MessageSession(
              users: List<String>.from(doc['users']),
              usersString: doc['usersString'],
              recentMessage: doc['recentMessage'],
              messages: await getMessages(doc['msid']),
              msid: doc['msid'],
              profileImage: doc['profileImage'],
              timestamp: doc['timestamp'],
              sessionName: doc['sessionName'],
          ));
        }
    });
    //   .then((value) {
    //     print(value.docs.length);
    //     value.docs.map((doc) {
    //       print(doc.id);
    //       messageSessions.add(MessageSession(
    //         users: doc['users'],
    //         recentMessage: doc['recentMessage'],
    //         messages: getMessages(doc['msid']),
    //         msid: doc['msid'],
    //         profileImage: doc['profileImage'],
    //         timestamp: doc['timestamp'],
    //         sessionName: doc['sessionName'],
    //     ));
    //     });
    // });
  print("ins : ${messageSessions.length}");
  return messageSessions;
}

Future<bool> isMessageSessionExist(List<String> uids) async {
  uids.sort();
  // concatenate uids(with seperator ',') and check if that string exist in "users"

  bool ret = false;
  await FirebaseFirestore.instance
      .collection('messageSessions')
      .where('usersString', isEqualTo: uids.toString()) // TODO : need to check if this works
      .get()
      .then((value)  {
    ret = (value.size > 0);
  });
  print("${uids.toString} exist is $ret");
  return ret;
}

Future<String> getMessageSessionIDbyuids(List<String> uids) async {
  uids.sort();

  String msid = "";
  await FirebaseFirestore.instance
      .collection('messageSessions')
      .where('usersString', isEqualTo: uids.toString())
      .get()
      .then((value) =>  msid = value.docs.elementAt(0).id
  );
  return msid;
}


Future<MessageSession> getMessageSession(String msid) async {
  print("get Message Session for $msid");

  return FirebaseFirestore.instance
    .collection('messageSessions')
    .doc(msid)
    .get()
    .then((doc) async => MessageSession(
      users: List<String>.from(doc['users']),
      usersString : doc['usersString'],
      recentMessage: doc['recentMessage'],
      messages : await getMessages(msid),
      msid: msid,
      profileImage: doc['profileImage'],
      timestamp: doc['timestamp'],
      sessionName: doc['sessionName']
    ));
  //return messageSession;
}

// Returns msid
Future<String> makeMessageSession(List<String> uids) async {
  uids.sort();

  String msid = FirebaseFirestore.instance
      .collection('messageSessions').doc().id;

  await FirebaseFirestore.instance
      .collection('messageSessions').doc(msid)
      .set(<String, dynamic>{
    'msid': msid,
    'users': uids,
    'usersString': uids.toString(),
    'recentMessage': "",
    'profileImage' : "https://handong.edu/site/handong/res/img/logo.png",// TODO : get it from firebase storage?
    'timestamp': FieldValue.serverTimestamp(),
    'sessionName': "Message Session" // TODO : Fix this
//    'messages' : ,
  });
  return msid;
}

String getUid(){
  User? user = FirebaseAuth.instance.currentUser;
  if(user != null) return user.uid;
  return "";
}

Future<Message> addMessage(String msid, String senderid, String message) async {

  Future<DocumentReference> messageRef =  FirebaseFirestore.instance
      .collection('messageSessions')
      .doc(msid)
      .collection('messages')
      .add(<String, dynamic>{
    'timestamp': FieldValue.serverTimestamp(),
    'senderId': senderid,
    'message': message,
  });

  Message newMessage = await messageRef.then((docRef) {
    return docRef.get().then((doc) => Message(
        timestamp: doc['timestamp'],
        senderId: doc['senderId'],
        message: doc['message'],
    ));
  });

  // TODO : update Message Sessions' recent page and timestamp

  //addMessageToMessageSession(msid, new_message);
  FirebaseFirestore.instance
      .collection('messageSessions').doc(msid)
      .set(<String, dynamic>{
    // 'users': uids,
    'recentMessage': newMessage.message,
    'timestamp': newMessage.timestamp,
  }, SetOptions(merge: true));

  return newMessage;
}

Future<List<Message>> getMessages(String msid) async {
  List<Message> messages = [];

  await FirebaseFirestore.instance
      .collection('messageSessions')
      .doc(msid)
      .collection('messages')
      .orderBy('timestamp', descending: false)
      .get()
      .then((snapshots)  {
        for( var doc in snapshots.docs) {
          messages.add(Message(
            timestamp: doc['timestamp'],
            senderId: doc['senderId'],
            message: doc['message'],
        ));
      }
  });

  print("out ${messages.length}");
  return messages;
}

Stream<QuerySnapshot<Map<String, dynamic>>> getMessageStream(String msid){
  return FirebaseFirestore.instance
      .collection('messageSessions')
      .doc(msid)
      .collection('messages')
      .orderBy('timestamp', descending: false)
      .snapshots();
}