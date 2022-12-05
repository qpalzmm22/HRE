import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:intl/intl.dart';

import 'dbutility.dart';

class ComunityPage extends StatefulWidget {
  const ComunityPage({Key? key}) : super(key: key);

  @override
  _ComunityPageState createState() => _ComunityPageState();
}

class _ComunityPageState extends State<ComunityPage> {
  int _selectedIndex = 0;
  User currentUser = FirebaseAuth.instance.currentUser as User;

  void setInitIndex(int index) {
    _selectedIndex = index;
  }

  Widget getContentsPage(BuildContext context, PageInfo pageInfo) {
    CollectionReference page =
        FirebaseFirestore.instance.collection(pageInfo.collectionName);

    return SafeArea(
        child: Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: FutureBuilder(
                future: page.orderBy('upload_time', descending: true).get(),
                builder: (context, snapshot) {
                  List data = snapshot.data == null ? [] : snapshot.data!.docs;
                  int len =
                      snapshot.data == null ? 0 : snapshot.data!.docs.length;
                  print("length : $len");

                  return ListView.builder(
                      itemCount: len,
                      itemBuilder: (BuildContext context, int idx) {
                        DateTime createdTime = DateTime.parse(
                            data[idx]['upload_time'].toDate().toString());

                        return Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: Colors.green.shade300,
                            ),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: ListTile(
                            title: InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, '/roommateDetail',
                                    arguments: data[idx]);
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(data[idx]['title']),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          data[idx]['author'],
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '${DateFormat('yy').format(createdTime)}.${createdTime.month}.${createdTime.day} ${createdTime.hour}:${createdTime.minute}:${createdTime.second} created',
                                        style: const TextStyle(
                                            fontSize: 10, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                }),
          ),
        ],
      ),
    ));
  }

  AppBar? buildAppBar() {
    if (_selectedIndex == 0) {
      return AppBar(
        leading: null,
        title: const Text("룸메이트 찾기"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/postPage');
              },
              icon: const Icon(Icons.edit))
        ],
      );
    }
    if (_selectedIndex == 1) {
      return AppBar(
        leading: null,
        title: const Text("단기양도"),
        actions: [],
      );
    }
    if (_selectedIndex == 2) {
      return AppBar(
        leading: null,
        title: const Text("장터"),
        actions: [],
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
          setState(() {
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

  PageInfo(
      {required this.pageTitle,
      required this.collectionName,
      required this.pageIndex});
}

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  User currentUser = FirebaseAuth.instance.currentUser as User;

  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("글쓰기"),
        actions: [
          IconButton(
            onPressed: () async {
              FirebaseFirestore.instance
                  .collection('roommates')
                  .add(<String, dynamic>{
                'author': currentUser.displayName,
                'uid': currentUser.uid,
                'title': _titleController.text,
                'content': _contentController.text,
                'upload_time': FieldValue.serverTimestamp(),
              });

              Navigator.pushReplacementNamed(context, '/communityPage',
                  arguments: PageInfo(
                      pageTitle: "룸메이트 찾기",
                      pageIndex: 0,
                      collectionName: 'roommates'));
            },
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "제목",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              decoration: const InputDecoration(
                  hintText: "제목을 입력해주세요.",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.blue),
                  )),
              controller: _titleController,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "내용",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
                child: TextField(
              controller: _contentController,
              maxLines: 20,
              decoration: const InputDecoration(
                  hintText:
                      "내용을 입력해주세요. (ex: 룸메이트 구합니다. 비흡연자, 남자 원합니다. \n가격은 월 20만원씩 입니다.",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.blue),
                  )),
            )),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class RoommateDetail extends StatefulWidget {
  const RoommateDetail({super.key});

  _RoommateDetailState createState() => _RoommateDetailState();
}

class _RoommateDetailState extends State<RoommateDetail> {
  User currentUser = FirebaseAuth.instance.currentUser as User;
  CollectionReference userReference = FirebaseFirestore.instance.collection('users');

  var _contentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    DocumentSnapshot data =
        ModalRoute.of(context)!.settings.arguments as DocumentSnapshot;
    _contentController.text = data['content'];
    DateTime createdTime = DateTime.parse(
        data['upload_time'].toDate().toString());
      return Scaffold(
          appBar: AppBar(
            title: Text(data["title"]),
            actions: [
              currentUser.uid == data['uid']
                  ? IconButton(onPressed: () {

              }, icon: Icon(Icons.edit))
                  : Text("")
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10,),
                Expanded(
                    child: TextField(
                      focusNode: AlwaysDisabledFocusNode(),
                      controller: _contentController,
                      maxLines: 20,
                      decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(color: Colors.blue),
                          )),
                    )),
                SizedBox(height: 20,),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FutureBuilder(
                            future: userReference.doc(data["uid"]).get(),
                            builder: (context, snapshot) {
                              String profileImage = snapshot.data == null ? "" : snapshot.data!["profileImage"];
                              return ProfilePicture(
                                name: 'ss',
                                radius: 30,
                                fontsize: 15,
                                img: profileImage,
                              );
                            }),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("작성자: ${data["author"]}"),
                                Text(
                                  '${DateFormat('yy').format(createdTime)}.${createdTime.month}.${createdTime.day} ${createdTime.hour}:${createdTime.minute}:${createdTime.second} created',
                                  style: const TextStyle(
                                      fontSize: 10, color: Colors.grey),
                                ),
                              ],
                            ),
                        IconButton(
                            onPressed: () async {
                              String uid = getUid();

                              List<String> participants = [data['uid'], uid];

                              String msid = "";
                              await isMessageSessionExist(participants)
                                  ? msid = await getMessageSessionIDbyuids(
                                  participants)
                                  : msid =
                              await makeMessageSession(participants);

                              MessageSession messageSession =
                              await getMessageSession(msid);
                              print("i sent : ${messageSession.messages.length}");
                              Navigator.pushNamed(context, '/messagePage', arguments: messageSession);
                            },
                            icon: const Icon(Icons.message))
                      ],
                    ),
                  ),
                ),

              ],
            ),
          ));
    }
  }

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}