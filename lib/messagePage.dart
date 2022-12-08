import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_clippers/custom_clippers.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

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

    MessageSession messageSession = ModalRoute.of(context)!.settings.arguments as MessageSession ;

     return Scaffold(
        appBar: AppBar(
            leading : IconButton(
              onPressed: () async {
                await updateMSViewCount(messageSession.msid, _len);
                Navigator.pushNamed(context, '/home', arguments: 2); // 2: messageSession index
              },
              icon: Icon(Icons.arrow_back_ios),
            ),
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
                        // int len = snapshot.data == null ?  0 : snapshot.data!.f;
                        // print("length : $len");
                        // List<MessageSession>? messageSessions = len == 0 ? [] : snapshot.data!;

                        print("snapshot data exist? ${snapshot.data}");
                        var len = snapshot.data!.docs.length;
                        _len = len;
                        if(snapshot.hasData == true){ // not working..
                          return ListView.builder(
                            reverse: true,
                            itemCount : len,
                            itemBuilder: (BuildContext ctx, int idx) {
                              if(snapshot.data!.docs[idx]['timestamp'] != null){
                                var document = snapshot.data!.docs[idx];

                                Message message = Message(
                                  senderId: document['senderId'],
                                  message: document['message'],
                                  timestamp: document['timestamp'] as Timestamp,
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
                                );
                              } else {
                                return SizedBox(height: 100,);
                              }
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
                      const SizedBox(width:10),
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
                          // increaseTotalMessageDB(messageSession.msid, 1);
                          // updateMSViewCount(messageSession.msid, _len);
                          _messageController.clear();
                          // setState(() async {
                            await increaseTotalMessageDB(messageSession.msid, 1);
                            await updateMSViewCount(messageSession.msid, _len);
                          // });
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