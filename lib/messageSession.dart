import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:badges/badges.dart';
import 'dart:async';

import 'dbutility.dart';


class MessageSessionPage {

  User? user = FirebaseAuth.instance.currentUser;
  // @override
  // Widget build(BuildContext context) {

  Widget getMessageSessionPage() {

    CollectionReference futureMessageSessions = FirebaseFirestore.instance.collection("messageSessions");
    return SafeArea(
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              SizedBox(height: 10,),
              Expanded(
                child: StreamBuilder<QuerySnapshot> (
                  stream: futureMessageSessions.where('users', arrayContains: user?.uid).snapshots(),
                  builder: (context, snapshot){
                    int len = snapshot.data == null ? 0 : snapshot.data!.docs.length;
                    List messageSessions = snapshot.data == null ? [] : snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: len,
                      itemBuilder: (BuildContext context, int idx) {

                        String messageSessionProfileImage = messageSessions[idx]["profileImage"][0];
                        for(int i = 0; i < messageSessions[idx]["users"].length; i++){
                          if(messageSessions[idx]["users"][i] != getUid()) messageSessionProfileImage = messageSessions[idx]["profileImage"][i];
                        }
                        print("Selected image : $messageSessionProfileImage");
                        return ListTile(
                            contentPadding: EdgeInsets.symmetric(vertical: 5,),
                            leading: AspectRatio(
                              aspectRatio: 1/1,
                              child : FutureBuilder(
                                future : getDiffMSViewCount(messageSessions[idx]["msid"], getUid()),
                                builder: (context, snapshot){
                                  if(snapshot.hasData && snapshot.data! > 0 ){
                                    // print("snapshot has data :  ${snapshot.data.toString()}");
                                    return Badge(
                                      badgeContent: Text(snapshot.data.toString()), // To mae
                                      child: Image.network(messageSessionProfileImage),
                                    );
                                  } else {
                                    // print("snapshot doesn't data :  ${snapshot.data.toString()}");
                                    return Image.network(messageSessionProfileImage,
                                    fit: BoxFit.fitHeight,
                                    );
                                  }
                              }),
                              // child: Image.network(messageSessionProfileImage),
                            ),
                            title: InkWell(
                              onTap: () {
                                  Navigator.pushReplacementNamed(context, '/messagePage', arguments: messageSessions[idx]).then((_) async {
                                    // MessageSession newMessageSession = await getMessageSession(messageSessions[idx].msid);
                                    // await updateMSViewCount(messageSessions[idx].msid, newMessageSession.messages.length);
                                  });
                              },
                              child : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(messageSessions[idx]["sessionName"],
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  Text(messageSessions[idx]["recentMessage"],
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey
                                    ),
                                  )
                                ],
                              )
                            ),
                          trailing: Text(DateFormat("MM월 d일").format(DateTime.fromMillisecondsSinceEpoch((messageSessions[idx]["timestamp"] as Timestamp).millisecondsSinceEpoch)),
                          style: TextStyle(
                            fontSize: 12,
                          ),),
                          );
                        }
                    );
                  }),
              ),
            ],
          ),
        )
    );
  }




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

  Text _getUserName(User? user){
    String userName;
    if (user?.email == null) {
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
