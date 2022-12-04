import 'dart:async';
import 'dart:io';

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
        required this.recentMessage,
        // required this.messagesRef,
        required this.messages,
        required this.msid,
        required this.profileImage,
        required this.timestamp,
        required this.sessionName,
      });

  final List<String> users;
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
      .then((snapshots){
        for (var doc in snapshots.docs) {
          messageSessions.add(MessageSession(
              users: List<String>.from(doc['users']),
              recentMessage: doc['recentMessage'],
              messages: getMessages(doc['msid']),
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

bool isMessageSessionExist(List<String> uids){
  uids.sort();
  print(uids);

  bool ret = false;
  FirebaseFirestore.instance
      .collection('messageSessions')
      .where('users', isEqualTo: uids) // TODO : need to check if this works
      .get().then((value) {
    ret =  (value.size > 0);
  });
  return ret;
}

String getMessageSessionIDbyuids(List<String> uids){
  uids.sort();

  String msid = "";
  FirebaseFirestore.instance
      .collection('messageSessions')
      .where('users', arrayContains: uids)
      .get()
      .then((value) =>  msid = value.docs.elementAt(0).id
  );
  return msid;
}


Future<MessageSession> getMessageSession(String msid){

  return FirebaseFirestore.instance
    .collection('messageSessions')
    .doc(msid)
    .get()
    .then((doc) => MessageSession(
      users: List<String>.from(doc['users']),
      recentMessage: doc['recentMessage'],
      messages : getMessages(msid),
      msid: msid,
      profileImage: doc['profileImage'],
      timestamp: doc['timestamp'],
      sessionName: doc['sessionName']
    ));
  //return messageSession;
}

// Returns msid
String makeMessageSession(List<String> uids){
  uids.sort();

  String msid = FirebaseFirestore.instance
      .collection('messageSessions').doc().id;

  FirebaseFirestore.instance
      .collection('messageSessions').doc(msid)
      .set(<String, dynamic>{
    'msid': msid,
    'users': uids,
    'recentMessage': "",
    'profileImage' : "",// TODO : get it from firebase storage?
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

Future<Message> addMessage(String msid, String senderid, String message) {

  Future<DocumentReference> messageRef =  FirebaseFirestore.instance
      .collection('messageSessions')
      .doc(msid)
      .collection('messages')
      .add(<String, dynamic>{
    'timestamp': FieldValue.serverTimestamp(),
    'senderId': senderid,
    'message': message,
  });

  return messageRef.then((docRef) {
    return docRef.get().then((doc) => Message(
        timestamp: doc['timestamp'],
        senderId: doc['senderId'],
        message: doc['message'],
    ));
  });

  //return outMessage;
}

List<Message> getMessages(String msid){
  List<Message> messages = [];


  FirebaseFirestore.instance
      .collection('messageSessions')
      .doc(msid)
      .collection('messages')
      .orderBy('timestamp')
      .get().then((value) {
        value.docs.map((doc) => messages.add(Message(
          timestamp: doc['timestamp'],
          senderId: doc['senderId'],
          message : doc['message'],
        ))
      );
  });
  return messages;

}