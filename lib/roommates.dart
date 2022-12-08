import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:intl/intl.dart';

import 'dbutility.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({Key? key}) : super(key: key);

  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  int _selectedIndex = 0;
  User currentUser = FirebaseAuth.instance.currentUser as User;

  void setInitIndex(int index) {
    _selectedIndex = index;
  }

  Widget getContentsPage(BuildContext context, String collectionName) {
    CollectionReference page =
        FirebaseFirestore.instance.collection(collectionName);

    return SafeArea(
        child: Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        children: [
          const SizedBox(
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

                        return ListTile(
                          title: InkWell(
                            onTap: () async {
                              await Navigator.pushNamed(
                                      context, '/roommateDetail',
                                      arguments: DetailInfo(data: data[idx], collectionName: collectionName),)
                                  .then((value) {
                                if (value == true) {
                                  FirebaseFirestore.instance
                                      .collection(collectionName)
                                      .doc(data[idx].id)
                                      .delete();
                                }
                              });
                              setState(() {
                                _selectedIndex = _selectedIndex;
                              });
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(data[idx]['title']),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "작성자: ${data[idx]['author']}",
                                        style: const TextStyle(
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
                                const SizedBox(
                                  height: 12,
                                  width: double.infinity,
                                  child: Divider(
                                      color: Colors.black, thickness: 0.5),
                                ),
                              ],
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

  Widget buildBody() {
    if (_selectedIndex == 0) {
      return getContentsPage(context, "roommates");
    } else if (_selectedIndex == 1) {
      return getContentsPage(context, "단기양도");
    } else if (_selectedIndex == 2) {
      return getContentsPage(context, "market");
    } else {
      return getContentsPage(context, "taxi");
    }
  }

  AppBar? buildAppBar() {
    if (_selectedIndex == 0) {
      return AppBar(
        leading: null,
        title: const Text("룸메이트 찾기"),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search))],
      );
    }
    if (_selectedIndex == 1) {
      return AppBar(
        leading: null,
        title: const Text("단기양도"),
      );
    }
    if (_selectedIndex == 2) {
      return AppBar(
        leading: null,
        title: const Text("장터"),
      );
    }
    if (_selectedIndex == 3) {
      return AppBar(
        leading: null,
        title: const Text("같이카"),
      );
    }
    return null;
  }

  Widget buildFloatingActionButton() {
    if (_selectedIndex == 0) {
      return FloatingActionButton(
        backgroundColor: Colors.pink,
        onPressed: () {
          PageInfo pageInfo = PageInfo(
              pageTitle: '룸메이트 찾기', collectionName: 'roommates', pageIndex: 0);
          pageInfo.hintTitle = "제목을 입력해주세요. (ex: 그할마인근 투룸 남자 룸메이트 구합니다.)";
          pageInfo.hintContent =
              "내용을 입력해주세요. \n(ex: 1인당 월세 20만원, 필요한 물건은 다 있으니 몸만 오시면 됩니다. 비흡연자 선호합니다. 입주는 20xx년 xx월 xx일부터 가능합니다. 연락주세요.)";
          Navigator.pushNamed(context, '/postPage', arguments: pageInfo);
        },
        child: const Icon(Icons.add),
      );
    } else if (_selectedIndex == 1) {
      return FloatingActionButton(
        backgroundColor: Colors.pink,
        onPressed: () {
          PageInfo pageInfo =
              PageInfo(pageTitle: '단기양도', collectionName: '단기양도', pageIndex: 1);
          pageInfo.hintTitle = "제목을 입력해주세요. (ex: 단기양도 합니다 / 단기양도 구합니다.)";
          pageInfo.hintContent =
              "내용을 입력해주세요. \n(ex: 종강 후부터 개강 전까지 양도 받으실분/해주실분 구합니다. 위치는 커피유야 부근이고, 월 30만원에 관리비 5만원정도 있습니다. 연락주세요. )";
          Navigator.pushNamed(context, '/postPage', arguments: pageInfo);
        },
        child: const Icon(Icons.add),
      );
    } else if (_selectedIndex == 2) {
      return FloatingActionButton(
        backgroundColor: Colors.pink,
        onPressed: () {
          PageInfo pageInfo =
              PageInfo(pageTitle: '장터', collectionName: 'market', pageIndex: 2);
          pageInfo.hintTitle = "제목을 입력해주세요. (ex: 외부거주 물품 판매/구매합니다.)";
          pageInfo.hintContent =
              "내용을 입력해주세요. \n(ex: 1. 책상 - 5만원 \n2. 의자: 3만원\n3.전자레인지: 4만원\n거래는 양덕동 다이소 인근에서 가능합니다.)";
          Navigator.pushNamed(context, '/postPage', arguments: pageInfo);
        },
        child: const Icon(Icons.add),
      );
    } else {
      return FloatingActionButton(
        backgroundColor: Colors.pink,
        onPressed: () {
          PageInfo pageInfo =
              PageInfo(pageTitle: '같이카', collectionName: 'taxi', pageIndex: 3);
          pageInfo.hintTitle =
              "제목을 입력해주세요. (ex: 12/8 (목) 포항역 -> 기숙사 택시 010xxxxxxxx)";
          pageInfo.hintContent = "내용을 입력해주세요. \n(ex: 택시같이타실분 연락주세요.)";

          Navigator.pushNamed(context, '/postPage', arguments: pageInfo);
        },
        child: const Icon(Icons.add),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    PageInfo pageInfo = ModalRoute.of(context)!.settings.arguments as PageInfo;
    setInitIndex(pageInfo.pageIndex);

    return Scaffold(
      appBar: buildAppBar(),
      body: buildBody(),
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
      floatingActionButton: buildFloatingActionButton(),
    );
  }
}

class PageInfo {
  final String pageTitle;
  final String collectionName;
  late int pageIndex;
  late String hintTitle = "";
  late String hintContent = "";
  late String title = "";
  late String content = "";

  PageInfo({
    required this.pageTitle,
    required this.collectionName,
    required this.pageIndex,
  });
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
    PageInfo pageInfo = ModalRoute.of(context)!.settings.arguments as PageInfo;

    if (pageInfo.title.isNotEmpty) {
      _titleController.text = pageInfo.title;
    }
    if (pageInfo.content.isNotEmpty) {
      _contentController.text = pageInfo.content;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("글쓰기"),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection(pageInfo.collectionName)
                  .add(<String, dynamic>{
                'author': currentUser.displayName,
                'uid': currentUser.uid,
                'title': _titleController.text,
                'content': _contentController.text,
                'upload_time': FieldValue.serverTimestamp(),
              });
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/communityPage',
                  arguments: PageInfo(
                    pageTitle: pageInfo.pageTitle,
                    pageIndex: pageInfo.pageIndex,
                    collectionName: pageInfo.collectionName,
                  ));
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
              decoration: InputDecoration(
                  hintText: pageInfo.hintTitle,
                  enabledBorder: const OutlineInputBorder(
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
              maxLines: 500,
              decoration: InputDecoration(
                  hintText: pageInfo.hintContent,
                  enabledBorder: const OutlineInputBorder(
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
  CollectionReference userReference =
      FirebaseFirestore.instance.collection('users');

  final _contentController = TextEditingController();
  late String title;

  @override
  Widget build(BuildContext context) {
    DetailInfo detailInfo =
        ModalRoute.of(context)!.settings.arguments as DetailInfo;
    DocumentSnapshot data = detailInfo.data;
    String collectionName = detailInfo.collectionName;

    _contentController.text = data['content'];
    DateTime createdTime =
        DateTime.parse(data['upload_time'].toDate().toString());
    title = data['title'];

    return Scaffold(
        appBar: AppBar(
          title: Text(title),
          actions: currentUser.uid == data['uid']
              ? [
                  IconButton(
                      onPressed: () async {
                        await Navigator.pushNamed(context, '/communityEditPage',
                            arguments: UpdateInfo(
                                documentId: data.id,
                                title: data['title'],
                                content: data['content'],
                                collectionName: collectionName));
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.edit)),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      icon: Icon(Icons.delete))
                ]
              : [],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Expanded(
                  child: TextField(
                focusNode: AlwaysDisabledFocusNode(),
                controller: _contentController,
                maxLines: 500,
                decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Colors.blue),
                )),
              )),
              const SizedBox(
                height: 20,
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FutureBuilder(
                          future: userReference.doc(data["uid"]).get(),
                          builder: (context, snapshot) {
                            String profileImage = snapshot.data == null
                                ? "https://firebasestorage.googleapis.com/v0/b/handong-real-estate.appspot.com/o/default_profile_img.jpg?alt=media&token=2d767ac3-f972-421d-814e-1e3deb86f0a5"
                                : snapshot.data!["profileImage"];
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
                                : msid = await makeMessageSession(participants);

                            MessageSession messageSession =
                                await getMessageSession(msid);
                            print("i sent : ${messageSession.messages.length}");
                            Navigator.pushNamed(context, '/messagePage',
                                arguments: messageSession);
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

class MyPost extends StatefulWidget {
  const MyPost({super.key});

  _MyPost createState() => _MyPost();
}

class _MyPost extends State<MyPost> {
  final List<String> pageList = ["룸메이트 구해요", "단기양도", "장터", "같이카"];
  late int _selectedPageIndex = 0;

  User currentUser = FirebaseAuth.instance.currentUser as User;

  Widget buildBody() {
    String collectionName;

    if (_selectedPageIndex == 0) {
      collectionName = 'roommates';
    } else if (_selectedPageIndex == 1) {
      collectionName = '단기양도';
    } else if (_selectedPageIndex == 2) {
      collectionName = 'market';
    } else {
      collectionName = 'taxi';
    }

    CollectionReference page =
        FirebaseFirestore.instance.collection(collectionName);
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: FutureBuilder(
                future: page.where('uid', isEqualTo: currentUser.uid).get(),
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

                        return ListTile(
                          title: InkWell(
                            onTap: () async {
                              await Navigator.pushNamed(
                                      context, '/roommateDetail',
                                      arguments: DetailInfo(data: data[idx], collectionName: collectionName),)
                                  .then((value) {
                                if (value == true) {
                                  FirebaseFirestore.instance
                                      .collection(collectionName)
                                      .doc(data[idx].id)
                                      .delete();
                                }
                              });
                              setState(() {
                                _selectedPageIndex = _selectedPageIndex;
                              });
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(data[idx]['title']),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "작성자: ${data[idx]['author']}",
                                        style: const TextStyle(
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
                                const SizedBox(
                                  height: 12,
                                  width: double.infinity,
                                  child: Divider(
                                      color: Colors.black, thickness: 0.5),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                }),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("작성한 글"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
            child: DropdownSearch<String>(
              popupProps: PopupProps.menu(
                showSelectedItems: true,
                disabledItemFn: (String s) => s.startsWith('I'),
              ),
              items: pageList,
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelText: "게시판",
                  hintText: "게시판을 선택해주세요.",
                ),
              ),
              onChanged: (data) {
                setState(() {
                  _selectedPageIndex = pageList.indexOf(data!);
                });
              },
              selectedItem: pageList[0],
            ),
          ),
          Expanded(child: buildBody()),
        ],
      ),
    );
  }
}

class CommunityEditPage extends StatefulWidget {
  const CommunityEditPage({super.key});

  @override
  _CommunityEditPageState createState() => _CommunityEditPageState();
}

class _CommunityEditPageState extends State<CommunityEditPage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  User currentUser = FirebaseAuth.instance.currentUser as User;

  @override
  Widget build(BuildContext context) {
    UpdateInfo updateInfo =
        ModalRoute.of(context)!.settings.arguments as UpdateInfo;

    _titleController.text = updateInfo.title;
    _contentController.text = updateInfo.content;

    return Scaffold(
      appBar: AppBar(
        title: const Text("글수정"),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection(updateInfo.collectionName)
                  .doc(updateInfo.documentId)
                  .update({
                'author': currentUser.displayName,
                'uid': currentUser.uid,
                'title': _titleController.text,
                'content': _contentController.text,
                'upload_time': FieldValue.serverTimestamp(),
              });
              Navigator.pop(context, updateInfo);
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
              decoration: InputDecoration(
                  hintText: updateInfo.title,
                  enabledBorder: const OutlineInputBorder(
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
              maxLines: 500,
              decoration: InputDecoration(
                  hintText: updateInfo.content,
                  enabledBorder: const OutlineInputBorder(
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

class UpdateInfo {
  final String collectionName;
  final String documentId;
  final String title;
  final String content;

  UpdateInfo(
      {required this.documentId,
      required this.title,
      required this.content,
      required this.collectionName});
}

class DetailInfo {
  final String collectionName;
  DocumentSnapshot data;
  DetailInfo({required this.collectionName, required this.data});
}
