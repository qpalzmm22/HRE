import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:custom_clippers/custom_clippers.dart';
import 'dbutility.dart';





List<ListTile> _buildHouseListTiles(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot, String uid){

  return snapshot.data!.docs.map((DocumentSnapshot document) {

    CollectionReference messagesRef = document.reference.collection('messages');

    MessageSession messageSession = MessageSession(
      profileImage : document['profileImage'],
      timestamp: document['timestamp'] as Timestamp, // last messaged
      msid : document['msid'] as String,
      recentMessage: document['recentMessage'],
      // messagesRef : messagesRef, // all the messages?
      messages: getMessages(document['msid']),
      sessionName : document['name'],
      users : List<String>.from(document['users']),
    );

    //String profileId = messageSession.users.firstWhere((user) => user != uid);

    // var isInCart = context.select<AppState, bool>(
    //       (cart) => cart.bookmarked
    //       .where((element) => element.documentId == document.id)
    //       .isNotEmpty,
    // );

    return ListTile(
        leading : Image.network(messageSession.profileImage),
        title: InkWell(
          onTap: (){
            Navigator.pushNamed(context, '/message', arguments: messageSession.messages);
          },
          child: Column(
            children: [
              Row(
                children: [
                  Text(messageSession.sessionName),
                  Text(messageSession.timestamp.toString()),
                ],
              ),
              Text(messageSession.recentMessage),
            ],
          ),
        )
    );
  }).toList();
}



class MessageSessionPage {

  User? user = FirebaseAuth.instance.currentUser;
  CollectionReference messageSessionsCollectionReference = FirebaseFirestore.instance.collection('message_sessions');

  // @override
  // Widget build(BuildContext context) {

  Widget getMessageSession(){
    return SafeArea(
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          children: [
            Expanded(
              child : StreamBuilder<QuerySnapshot>(
                stream: messageSessionsCollectionReference.where('users', arrayContains: user!.uid).orderBy('timestamp', descending: true).snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return const Center(
                        child: Center(child: CircularProgressIndicator()));
                  }
                  else{
                    return OrientationBuilder(
                      builder: (context, orientation) {
                        return GridView.count(
                          scrollDirection: Axis.horizontal,
                          crossAxisCount: 1,
                          padding: const EdgeInsets.all(16.0),
                          childAspectRatio: 16.0 / 12.0,
                          children: _buildHouseListTiles(context, snapshot, user!.uid),
                        );
                      },
                    );
                  }
                },
              ),

              // const SizedBox(
              //   height: 20,
              // ),
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: const [
              //     SizedBox(
              //       height: 50,
              //       width: double.infinity,
              //       child: Divider(color: Colors.black, thickness: 1.5),
              //     ),
              //   ],
            )
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
