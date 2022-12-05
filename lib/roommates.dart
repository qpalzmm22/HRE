import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'dbutility.dart';

class ComunityPage extends StatefulWidget {
  const ComunityPage ({Key? key}) : super(key: key);

  @override
  _ComunityPageState createState() => _ComunityPageState();
}

class _ComunityPageState extends State<ComunityPage>{

  int _selectedIndex = 0;
  User currentUser = FirebaseAuth.instance.currentUser as User;

  void setInitIndex(int index){
    _selectedIndex = index;
  }

  Widget getContentsPage(BuildContext context, PageInfo pageInfo) {

    CollectionReference page = FirebaseFirestore.instance.collection(pageInfo.collectionName);

    return SafeArea(
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            children: [
              SizedBox(height: 10,),
              Expanded(
                child: FutureBuilder(
                    future: page.get(),
                    builder: (context, snapshot){

                      List myDocCount = snapshot.data == null ? [] : snapshot.data!.docs;
                      int len = snapshot.data == null ?  0 : snapshot.data!.docs.length;
                      print("length : $len");

                      return ListView.builder(
                          itemCount: len,
                          itemBuilder: (BuildContext context, int idx) {
                            return ListTile(
                                title: InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(context, '/messagePage',
                                        arguments: myDocCount[idx]['title']);
                                  },
                                  child :Text(myDocCount[idx]['title']),
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

  AppBar? buildAppBar() {
    if (_selectedIndex == 0) {
      return AppBar(
        leading: null,
        title: const Text("룸메이트 찾기"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/searchPage');
              },
              icon: const Icon(Icons.edit))
        ],
      );
    }
    if (_selectedIndex == 1) {
      return AppBar(
        leading: null,
        title: const Text("단기양도"),
        actions: [

        ],
      );
    }
    if (_selectedIndex == 2) {
      return AppBar(
        leading: null,
        title: const Text("장터"),
        actions: [

        ],
      );
    }
    if (_selectedIndex == 3) {
      return AppBar(
        leading: null,
        title: const Text("같이카"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {

    PageInfo pageInfo = ModalRoute.of(context)!.settings.arguments as PageInfo;

    setInitIndex(pageInfo.pageIndex);

    return Scaffold(
      appBar: buildAppBar(),
      body: getContentsPage(context, pageInfo),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person_search),
            label: '룸메이트찾기',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.house),
            label: '단기양도',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: '장터',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_taxi),
            label: '같이카',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (ind) {
          setState((){
            pageInfo.pageIndex = ind;
            _selectedIndex = ind;
          });
        },
      ),
    );
  }
}



class PageInfo {
  final String pageTitle;
  final String collectionName;
  late int pageIndex;

  PageInfo({required this.pageTitle, required this.collectionName, required this.pageIndex});
}