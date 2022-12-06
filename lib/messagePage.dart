import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_clippers/custom_clippers.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
// import 'package:fluttertoast/fluttertoast.dart';

import 'package:intl/intl.dart';

import 'appState.dart';
import 'firebase_options.dart';
import 'dbutility.dart';


class MessagePage extends StatefulWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  int _len = 0 ;
  @override
  Widget build(BuildContext context) {
    String uid = getUid();

    final _messageController = TextEditingController();

    void updateViewCount(String msid, int newLen) async {
      int prevViewCount = await getViewCountDB(msid, uid);
      if( prevViewCount != newLen){
        print(" viewCount: $prevViewCount, $newLen");
        updateViewCountDB(msid, uid, newLen - prevViewCount);
      }
    }

    MessageSession messageSession = ModalRoute.of(context)!.settings.arguments as MessageSession;

     return Scaffold(
        appBar: AppBar(
            title: Text(messageSession.sessionName)
        ),
        body: Column(
            children :[
              Expanded(
                  child : StreamBuilder(
                    stream : getMessageStream(messageSession.msid),
                    builder : (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                      if(snapshot.connectionState == ConnectionState.waiting){
                        return const Center(
                            child: Center(child: CircularProgressIndicator()));
                      } else{
                        // int len = snapshot.data == null ?  0 : snapshot.data!.length;
                        // print("length : $len");
                        // List<MessageSession>? messageSessions = len == 0 ? [] : snapshot.data!;

                        print("snapshot data exist? ${snapshot.data}");
                        var len = snapshot.data!.docs.length;
                        _len = len;
                        if(snapshot.hasData == true){
                          return ListView.builder(
                            reverse: true,
                            itemCount : len,
                            itemBuilder: (BuildContext ctx, int idx) {

                              var document = snapshot.data!.docs[idx];

                              Message message = Message(
                                timestamp: document['timestamp'],
                                senderId: document['senderId'],
                                message: document['message'],
                              );

                              var isMyMessage = (uid == message.senderId);
                              var messageClipper = UpperNipMessageClipperTwo(MessageType.receive);
                              if(isMyMessage){
                                messageClipper = UpperNipMessageClipperTwo(MessageType.send);
                              }

                              String str_TimeSent = DateFormat("hh:mm:ss yyyy-MM-dd").format(DateTime.fromMillisecondsSinceEpoch(message.timestamp.millisecondsSinceEpoch));



                              return Padding(
                                  padding : EdgeInsets.all(10),
                                  child : ClipPath(
                                      clipper: messageClipper,
                                      child: Container(
                                        //margin: EdgeInsets.all(20),
                                          padding : EdgeInsets.fromLTRB(20, 10, 20, 10,),
                                          color : isMyMessage ? Colors.yellow : Colors.white,
                                          // alignment: Alignment.topLeft,
                                          child : Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(message.message),
                                              Text(
                                                style : TextStyle(fontSize : 10),
                                                str_TimeSent
                                              ),
                                            ],
                                          )
                                      )
                                  )
                                );// return Text('${idx} : ${messages[idx].message}');
                              }
                            );
                          } else{
                            return SizedBox(height: 100,);
                          }
                        }
                      }
                  )
              ),
              Container(
                height: 100,
                child : Row(
                    children : [
                      SizedBox(width:10),
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: const InputDecoration(
                            labelText: 'message',
                          ),
                        ),
                      ),
                      TextButton(
                        child : Text("submit"),
                        onPressed: () async {

                          await addMessage(messageSession.msid, uid, _messageController.text);
                          updateViewCount(messageSession.msid, _len);

                          _messageController.clear();
                        },
                      ),
                    ]
                ),
              )
            ]
        )
    );
  }

}