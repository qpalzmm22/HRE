import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:custom_clippers/custom_clippers.dart';
import 'dbutility.dart';





// List<ListTile> _buildHouseListTiles(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot, String uid){
//
//   return snapshot.data!.docs.map((DocumentSnapshot document) {
//
//     CollectionReference messagesRef = document.reference.collection('messageSessions');
//
//     MessageSession messageSession = MessageSession(
//       profileImage : document['profileImage'],
//       timestamp: document['timestamp'] as Timestamp, // last messaged
//       msid : document['msid'] as String,
//       recentMessage: document['recentMessage'],
//       // messagesRef : messagesRef, // all the messages?
//       messages: getMessages(document['msid']),
//       sessionName : document['sessionName'],
//       users : List<String>.from(document['users']),
//     );
//
//     return ListTile(
//         leading : Image.network(messageSession.profileImage),
//         title: InkWell(
//           onTap: (){
//             Navigator.pushNamed(context, '/message', arguments: messageSession.messages);
//           },
//           child: Column(
//             children: [
//               Row(
//                 children: [
//                   Text(messageSession.sessionName),
//                   Text(messageSession.timestamp.toString()),
//                 ],
//               ),
//               Text(messageSession.recentMessage),
//             ],
//           ),
//         )
//     );
//   }).toList();
// }



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
                    print("lneght : $len");

                    var messageSessions = snapshot.data!;

                    return ListView.builder(
                      itemCount: len,
                      itemBuilder: (BuildContext context, int idx) {
                        return ListTile(
                            leading: Image.network(messageSessions[idx].profileImage),
                            title: InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, '/messagePage',
                                    arguments: messageSessions[idx].messages);
                              },
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(messageSessions[idx].sessionName),
                                      Text(messageSessions[idx].timestamp.toString()),
                                    ],
                                  ),
                                  Text(messageSessions[idx].recentMessage),
                                ],
                              ),
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
