import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';


class HomePage extends StatefulWidget {

  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {

    final ThemeData theme = Theme.of(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Main"),
        ),
        body: Column(
            children: [
              Text("Do this"),
              TextButton(
                onPressed: (){
                  Navigator.pushNamed(context, '/detail');
                },
                child: Text("Detail")
              ),
            ]
        ),
        bottomNavigationBar : BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark),
              label: 'bookmark',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.message),
              label: 'message',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'profile',
            ),
          ],
          currentIndex: _selectedIndex,
//          selectedItemColor: Colors.amber[800],

          onTap: (ind){
            setState(() {
              _selectedIndex = ind;
            });
          },
        ),
    );
  }
}
