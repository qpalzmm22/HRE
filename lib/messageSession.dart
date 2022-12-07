import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart';

import 'dbutility.dart';

class MessageSessionPage {

  User? user = FirebaseAuth.instance.currentUser;
  // @override
  // Widget build(BuildContext context) {

  Widget getMessageSession() {
    Future<List<MessageSession>> futureMessageSessions = getMessageMutipleSessionsbyuid(user!.uid);

    return SafeArea(
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            children: [
              SizedBox(height: 10,),
              Expanded(
                child: FutureBuilder<List<MessageSession>>(
                  future: futureMessageSessions,
                  builder: (context, snapshot){
                    int len = snapshot.data == null ?  0 : snapshot.data!.length;
                    print("length : $len");

                    List<MessageSession>? messageSessions = len == 0 ? [] : snapshot.data!;

                    return ListView.builder(
                      itemCount: len,
                      itemBuilder: (BuildContext context, int idx) {

                        String messageSessionProfileImage = messageSessions[idx].profileImage[0];
                        for(int i = 0; i < messageSessions[idx].users.length; i++){
                          if(messageSessions[idx].users[i] != getUid()) messageSessionProfileImage = messageSessions[idx].profileImage[i];
                        }
                        print("Selected image : $messageSessionProfileImage");
                        return ListTile(
                            leading: AspectRatio(
                              aspectRatio: 1/1,
                              child : FutureBuilder(
                                future : getDiffMSViewCount(messageSessions[idx].msid, getUid()),
                                builder: (context, snapshot){
                                  if(snapshot.hasData && snapshot.data! > 0 ){
                                    print("snapshot has data :  ${snapshot.data.toString()}");
                                    return Badge(
                                      badgeContent: Text(snapshot.data.toString()), // To mae
                                      child: Image.network(messageSessionProfileImage),
                                    );
                                  } else {
                                    print("snapshot doesn't data :  ${snapshot.data.toString()}");
                                    return Image.network(messageSessionProfileImage);
                                  }
                              }),
                              // child: Image.network(messageSessionProfileImage),
                            ),
                            title: InkWell(
                              onTap: () {
                                // setState(){
                                  updateMSViewCount(messageSessions[idx].msid, messageSessions[idx].messages.length);
                                // }
                                Navigator.pushNamed(context, '/messagePage',
                                    arguments: messageSessions[idx]);
                              },
                              child :Text(messageSessions[idx].sessionName),
                            )
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
