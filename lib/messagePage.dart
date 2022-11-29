import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: Text(messageSession.sessionName)
      ),
      body: Column(
        children :[
          Padding(
            padding: EdgeInsets.only(left: 30, right: 30),
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
          Expanded(
            child : ListView.builder(
              itemCount : messages.length,
              itemBuilder: (BuildContext ctx, int idx) {
                return Text('${idx} : ${messages[idx].message}');
              }
            )
          )
        ]
      )
    );
  }

}