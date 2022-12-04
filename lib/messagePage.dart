import 'dart:async';

import 'package:custom_clippers/custom_clippers.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

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

  @override
  Widget build(BuildContext context) {
    final _messageController = TextEditingController();

    MessageSession messageSession = ModalRoute.of(context)!.settings.arguments as MessageSession;
    List<Message> messages = messageSession.messages;

    print("len : ${messages.length}");

    return Scaffold(
      appBar: AppBar(
        title: Text(messageSession.sessionName)
      ),
      body: Column(
        children :[
          Expanded(
            child : ListView.builder(
              itemCount : messages.length,
              itemBuilder: (BuildContext ctx, int idx) {
                var isMyMessage = (getUid() == messages[idx].senderId);
                var messageClipper = UpperNipMessageClipperTwo(MessageType.receive);
                if(isMyMessage){
                   messageClipper = UpperNipMessageClipperTwo(MessageType.send);
                }

                String str_TimeSent = DateFormat("hh:mm:ss yyyy-MM-dd").format(DateTime.fromMillisecondsSinceEpoch(messages[idx].timestamp.millisecondsSinceEpoch));

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
                              Text(messages[idx].message),
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
            )
          ),
          Row(
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
                    Message newMessage = await addMessage(messageSession.msid, getUid(), _messageController.text);
                    setState(() {
                      messages.add(newMessage);
                    });
                  },
                ),
              ]
          ),
        ]
      )
    );
  }

}