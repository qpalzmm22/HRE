import 'dart:async';
import 'dart:io';

// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:handong_real_estate/messageSession.dart';
import 'package:path/path.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'appState.dart';

void addUser(User? user){

  if(user != null) {
    print(user.uid);

    bool isUserExist = false;
    FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get()
        .then((docSnapshot) {
          if(docSnapshot.exists){
            isUserExist = true;
          } else {
            FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .set({
              'email': user.email.toString(),
              'name': user.displayName.toString(),
              'status_message': 'I promise to take the test honestly before GOD',
              'uid': user.uid,
              'profileImage':user.photoURL,
              'messageViewCount' : 0,
            });
          }
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
      'profileImage':user.photoURL,
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

List<String> tagList = [
  "그할마",
  "커피유야",
  "법원",
  "양덕 주차장",
  "다이소(양덕",

  "원룸",
  "미니투룸",
  "투룸",
  "쉐어하우스",
  "싱크대",

  "Wi-Fi",
  "침대",
  "가스 레인지",
  "냉장고",
  "에어콘",

  "장롱",
  "세탁기",
  "의자",
  "신발장",
  "배란다",
];





void addHouseToDB(House house){
      String hid = FirebaseFirestore.instance
          .collection('houses').doc().id;

      FirebaseFirestore.instance
        .collection('houses')
        .add(<String, dynamic>{
      'hid' : hid,
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
      'views' : house.views,
      'tags' : house.tags,
    });
}

void updateHouseToDB(House house){
  FirebaseFirestore.instance
      .collection('houses')
      .doc(house.hid)
      .set(<String, dynamic>{
    'hid' : house.hid,
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
    'views' : house.views,
    'tags' : house.tags,
  });
}

void deleteHouse(String hid){
  CollectionReference myHouses = FirebaseFirestore.instance.collection("houses");
  myHouses.doc(hid).delete(); // could be async
}

House helperDocToHouse(QueryDocumentSnapshot document){
  GeoPoint gps = document['location'];

  return House(
    hid : document['hid'],
    thumbnail: document['thumbnail'],
    name: document['name'],
    address: document['address'],
    documentId: document.id,
    ownerId: document['userId'],
    description: document['description'] as String,
    monthlyPay: document['monthlyPay'] as int,
    deposit: document['deposit'],
    optionList: List<bool>.from(document['options']),
    location: LatLng(gps.latitude, gps.longitude),
    imageLinks: List.from( document['imagelinks']),
    views: document['views'],
    tags : List.from(document['tags']),
  );
}


// (Deposit && Monthly && Tag)
Future<List<House>> getQueriedHouses(double ds, double de, double ms, double me, List<String> tags) async {
  Set<String> houses_id = {};
  Map<String, House> depositHouses = {};
  Map<String, House> monthlyHouses = {};
  List<House> houses = [];

  await FirebaseFirestore.instance
    .collection('houses')
    .where('tags', arrayContainsAny: tags)
    .where('deposit', isGreaterThanOrEqualTo: ds)
    .where('deposit', isLessThanOrEqualTo: de)
    .get()
    .then((value) {
      print("size of query result ${value.size}");
      for( var document in value.docs){
        houses_id.add(document['hid']);
        depositHouses.addAll({document['hid'] : helperDocToHouse(document)});
      }
    });

  await FirebaseFirestore.instance
      .collection('houses')
      .where('tags', arrayContainsAny: tags)
      .where('monthlyPay', isGreaterThanOrEqualTo: ms)
      .where('monthlyPay', isLessThanOrEqualTo: me)
      .get()
      .then((value) {
    for( var document in value.docs){
      houses_id.add(document['hid']);
      monthlyHouses.addAll({document['hid'] : helperDocToHouse(document)});
    }
  });

  for(int i = 0 ; i < houses_id.length; i++){
    if(depositHouses.containsKey(houses_id.elementAt(i)) && monthlyHouses.containsKey(houses_id.elementAt(i))){
      houses.add(monthlyHouses[houses_id.elementAt(i)]!);
    }
  }
  print("queried houses : ${houses.length}");

  return houses.toList();
}


class HreUser{
  HreUser(
      {required this.uid,
        required this.name,
        required this.profileImage,
        required this.email,
        required this.messageViewCount,
      });
  final String uid;
  final String name;
  final String profileImage;
  final String email;
  final int messageViewCount;
}

Future<HreUser> getUserFromDB(String uid) async {
  return await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .get()
      .then((value) {
    if(value.data() == null){
      print("JY ERROR!!! :  getuserFromdb : no value().data ");
    }
    return HreUser(
      uid: value.data()!['uid'],
      name: value.data()!['name'],
      profileImage:value.data()!['profileImage'],
      email: value.data()!['email'],
      messageViewCount : value.data()!['messageViewCount'],
    );
  });
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
  final List<String> profileImage;
  final String msid;
  final String sessionName;
  final Timestamp timestamp;
}

Stream<QuerySnapshot<Map<String,dynamic>>> getMessageSessionStreambyuid(String uid){
  return FirebaseFirestore.instance
      .collection('messageSessions')
      .where('users', arrayContains: uid)
      .orderBy('timestamp', descending: false)
      .snapshots();
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
              profileImage: List<String>.from(doc['profileImage']),
              timestamp: doc['timestamp'],
              sessionName: doc['sessionName'],
          ));
        }
    });

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
      profileImage: List<String>.from(doc['profileImage']),
      timestamp: doc['timestamp'],
      sessionName: doc['sessionName'],
    ));
  //return messageSession;
}

// Returns msid
Future<String> makeMessageSession(List<String> uids) async {
  uids.sort(); //

  HreUser user1 = await getUserFromDB(uids[0]);
  HreUser user2 = await getUserFromDB(uids[1]);

  String msid = FirebaseFirestore.instance
      .collection('messageSessions').doc().id;

  await FirebaseFirestore.instance
      .collection('messageSessions').doc(msid)
      .set(<String, dynamic>{
    'msid': msid,
    'users': uids,
    'usersString': uids.toString(),
    'recentMessage': "",
    'profileImage' : [user1.profileImage, user2.profileImage], // Access Profile image by index ..!
    'timestamp': FieldValue.serverTimestamp(),
    'sessionName': "${user1.name} 와 ${user2.name} 의 대화방",
  });

  createViewCountDB(msid, uids);

  return msid;
}

void increaseHouseViewCount(String hid){
  FirebaseFirestore.instance
      .collection('houses')
      .doc(hid)
      .update({'views' : FieldValue.increment(1)});
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
      .orderBy('timestamp', descending: true)
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
  return messages;
}

Stream<QuerySnapshot<Map<String, dynamic>>> getMessageStream(String msid){
  return FirebaseFirestore.instance
      .collection('messageSessions')
      .doc(msid)
      .collection('messages')
      .orderBy('timestamp', descending: true)
      .snapshots();
}

// Only works when there's only two exist
void createViewCountDB(String msid, List<String> uids) async {

  await FirebaseFirestore.instance
      .collection('msViewCount')
      .doc(msid)
      .set(<String, dynamic>{
      'msid': msid,
      uids[0] : 0,
      uids[1] : 0,
      'numMessages' : 0,
  });
}

// Updates UserViewCount as well
// Update == increase the num_messages
Future<void> updateMSViewCountDB(String msid, String uid, int addingAmount) async {
  print("Updating view count for session: $addingAmount");
  await FirebaseFirestore.instance
      .collection('msViewCount')
      .doc(msid)
      .set(<String, dynamic>{
        uid : FieldValue.increment(addingAmount),
        // "numMessages" : FieldValue.increment(addingAmount),
  }, SetOptions(merge: true));

  print("Updating view count for user: $addingAmount");
  await FirebaseFirestore.instance
    .collection('users')
    .doc(uid)
    .set(<String, dynamic>{
      'messageViewCount' : FieldValue.increment(addingAmount),
  }, SetOptions(merge: true));
}
//
Future<void> increaseTotalMessageDB(String msid, int addingAmount)async {
  await FirebaseFirestore.instance
      .collection('msViewCount')
      .doc(msid)
      .set(<String, dynamic>{
    'numMessages' : FieldValue.increment(addingAmount),
  }, SetOptions(merge: true));
}

Future<int> getMSViewCountDB(String msid, String uid) async{
  return await FirebaseFirestore.instance
      .collection('msViewCount')
      .doc(msid)
      .get()
      .then((snapshot) => snapshot.data()![uid]);
}
Future<int> getUserMSViewCount(String uid) async {
  return await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .get()
      .then((snapshot) => snapshot.data()!['messageViewCount']);
}

Future<int> getDiffMSViewCount(String msid, String uid) async {
  int prevCount = await getMSViewCountDB(msid, uid);
  int curCount = await getMessageSession(msid).then((value) => value.messages.length);
  return curCount - prevCount;
}

Future<int> getUserDiffMSViewCount(String uid) async {

  int prevCount = await getUserMSViewCount(uid); // UserDB
  int curCount = 0;
  await FirebaseFirestore.instance
        .collection('msViewCount')
        .where(uid, isNotEqualTo: '')
        .get()
        .then((snapshot) {
          for(var doc in snapshot.docs){
            curCount += doc.data()['numMessages'] as int;
          }
  });

  // MessageSessionDB
  // print("user diff : $curCount , $prevCount");
  return curCount - prevCount;
}

Future<void> updateMSViewCount(String msid, int newLen) async {
  String uid = getUid();
  // HreUser hreUser = await getUserFromDB(uid);

  int prevViewCount = await getMSViewCountDB(msid, uid);
  if( prevViewCount != newLen){
    print("..viewCount: $newLen, $prevViewCount");
    await updateMSViewCountDB(msid, uid, newLen - prevViewCount);
  }
}

class Content {
  Content(
      {required this.author,
        // required this.messagesRef,
        required this.profileImage,
        required this.upload_time,
        required this.title,
      });

  final User author;
  //final CollectionReference messagesRef;
  final String profileImage;
  final String title;
  final Timestamp upload_time;
}


