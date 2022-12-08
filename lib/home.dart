import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:handong_real_estate/bookmark.dart';
import 'package:handong_real_estate/dbutility.dart';
import 'package:handong_real_estate/profile.dart';
import 'package:handong_real_estate/messageSession.dart';
import 'package:handong_real_estate/roommates.dart';
import 'package:badges/badges.dart';
import 'package:intl/intl.dart';
// import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:provider/provider.dart';
import 'appState.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  bool _isBottomNavIdxChanged = false;

  // @override
  // void initState() {
  //   super.initState();
  //
  //   int argPageNum = ModalRoute.of(context)!.settings.arguments as int;
  //   _selectedIndex = argPageNum;
  //
  //   // MessageSession newMessageSession = await getMessageSession(messageSessions[idx].msid);
  //   // await updateMSViewCount(messageSessions[idx].msid, newMessageSession.messages.length);
  // }




  TextEditingController searchBarController = TextEditingController();
  CollectionReference houseCollectionReference =
      FirebaseFirestore.instance.collection('houses');

  String uid = getUid();
  // bool _isNewMessage = false;
  List<House> houseList = [];
  List<Marker> markers = [];

  @override
  void initState() {
    super.initState();
    print("hello");


  }

  @override
  Widget build(BuildContext context) {

    int argPageNum = ModalRoute.of(context)!.settings.arguments as int;
    _selectedIndex = _isBottomNavIdxChanged? _selectedIndex : argPageNum;

    var cart = context.watch<AppState>();

    final ThemeData theme = Theme.of(context);

    Profile profilePage = Profile();
    Bookmark bookmarkPage = Bookmark();
    MessageSessionPage messageSessionPage = MessageSessionPage();

    for (House house in houseList) {
      Marker marker = Marker(
          markerId: MarkerId(house.name),
          position: house.location,
          onTap: () {
            Navigator.pushNamed(context, '/detail', arguments: house);
          });

       cart.addMarker(marker);
    }

    Widget homeScreen() {
      return Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          //buildAnimSearchBar(),
          locationSection(),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 25,
                ),
                child: Text(
                  "새로운 매물",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          buildHouseCard(),
        ],
      );
    }

    Widget buildBody(BuildContext context) {

      if (_selectedIndex == 0) {
        return homeScreen();
      } else if (_selectedIndex == 1) {
        return bookmarkPage.getBookmarkPage(context);
      } else if (_selectedIndex == 2) {
        return messageSessionPage.getMessageSessionPage();
      } else {
        return profilePage
            .getProfile(context, FirebaseAuth.instance.currentUser as User);
      }
    }

    AppBar? buildAppBar() {
      if (_selectedIndex == 0) {
        return AppBar(
          leading: null,
          title: const Text("Home"),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/searchPage');
                },
                icon: const Icon(Icons.tune))
          ],
        );
      }
      if (_selectedIndex == 1) {
        return AppBar(
          leading: null,
          title: const Text("Bookmarked"),
          actions: [],
        );
      }
      if (_selectedIndex == 2) {
        return AppBar(
          leading: null,
          title: const Text("Message"),
          actions: [],
        );
      }
      if (_selectedIndex == 3) {
        return AppBar(
          leading: null,
          title: const Text("Profile"),
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

    Widget buildFloatActionButton() {
      if (_selectedIndex == 0) {
        return FloatingActionButton(
          backgroundColor: Colors.pink,
          onPressed: () {

            Navigator.pushNamed(context, '/addHouse');
          },
          child: Icon(Icons.add),
        );
      } else {
        return Text("");
      }
    }

    return Scaffold(
      appBar: buildAppBar(),
      body: SafeArea(
        child: buildBody(context),
      ),
      drawer: Drawer(
        child: Column(
          // Important: Remove any padding from the ListView.
          //padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Center(
                child: Text(
                  '커뮤니티',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person_search),
              title: const Text('룸메이트 구해요'),
              onTap: () async {
                Navigator.pop(context);
                await Navigator.pushNamed(context, '/communityPage',
                    arguments: PageInfo(
                        pageTitle: "룸메이트",
                        collectionName: 'roommates',
                        pageIndex: 0));
              },
            ),
            ListTile(
              leading: Icon(Icons.house),
              title: const Text('단기양도'),
              onTap: () async {
                Navigator.pop(context);
                await Navigator.pushNamed(context, '/communityPage',
                    arguments: PageInfo(
                        pageTitle: "단기양도",
                        collectionName: '단기양도',
                        pageIndex: 1));
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: const Text('장터'),
              onTap: () async {
                Navigator.pop(context);
                await Navigator.pushNamed(context, '/communityPage',
                    arguments: PageInfo(
                        pageTitle: "장터",
                        collectionName: 'market',
                        pageIndex: 2));
              },
            ),
            ListTile(
              leading: Icon(Icons.local_taxi),
              title: const Text('같이카'),
              onTap: () async {
                Navigator.pop(context);
                await Navigator.pushNamed(context, '/communityPage',
                    arguments: PageInfo(
                        pageTitle: "택시", collectionName: 'taxi', pageIndex: 3));
              },
            ),
            const Expanded(child: Text("")),
            ListTile(
              leading: const Icon(
                Icons.logout,
                color: Colors.red,
              ),
              title: const Text(
                "로그아웃",
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items:  <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'bookmark',
          ),
          BottomNavigationBarItem(
            icon: FutureBuilder(
              future : getUserDiffMSViewCount(getUid()),
              builder: (context, snapshot){
                if(snapshot.hasData){
                  return snapshot.data! > 0 ?
                  Badge(
                    badgeContent: Text(snapshot.data.toString()), // To mae
                    child: Icon(Icons.message),
                  ) :
                  Icon(Icons.message);
                } else {
                  return Icon(Icons.message);
                }
              }),
            label: 'message',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (ind) {
          setState(() {
            _isBottomNavIdxChanged = true;
            _selectedIndex = ind;
          });
        },
      ),
      floatingActionButton: buildFloatActionButton(),
    );
  }

  SizedBox _locationCard(Icon icon, MapPoint location) {

    return SizedBox(
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/map', arguments: location);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  icon,
                  const SizedBox(
                    width: 5,
                  ),
                  Text(location.name),
                ],
              ),
            ),
          )),
    );
  }

  Widget locationSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Expanded(
                child: Text(
                  "위치",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/map',
                    arguments: MapPoint(
                      name: "양덕동 근처 매물",
                      center: const LatLng(36.081809, 129.39697),
                      zoom: 14,
                    ));
                },
                child: const Text(
                  "View ALL",
                  style: TextStyle(color: Colors.grey, fontSize: 17),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _locationCard(
                    const Icon(Icons.home_filled),
                    MapPoint(
                        name: "그할마 ",
                        center: const LatLng(36.079753, 129.394197),
                        zoom: 17)),
                _locationCard(
                    const Icon(Icons.shopping_cart),
                    MapPoint(
                        name: "다이소(양덕)",
                        center: const LatLng(36.084206, 129.396543),
                        zoom: 17)),
                _locationCard(
                    const Icon(Icons.house_outlined),
                    MapPoint(
                        name: "법원",
                        center: const LatLng(36.08925, 129.387588),
                        zoom: 17)),
                _locationCard(
                    const Icon(Icons.coffee),
                    MapPoint(
                        name: "커피유야",
                        center: const LatLng(36.080508, 129.399658),
                        zoom: 17)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Card> _buildHouseCards(
      BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    final NumberFormat numberFormat =
        NumberFormat.simpleCurrency(locale: "ko_KR");

    return snapshot.data!.docs.map((DocumentSnapshot document) {
      GeoPoint gps = document['location'];

      House house = House(
        thumbnail: document['thumbnail'],
        name: document['name'],
        address: document['address'],
        documentId: document.id,
        ownerId: document['userId'],
        description: document['description'] as String,
        monthlyPay: document['monthlyPay'] as int,
        deposit: document['deposit'],
        optionList: List<bool>.from(document['options']),
        location: LatLng(gps.latitude, gps.longitude),
        imageLinks: List.from( document['imagelinks']),
        views: document['views'],
      );

        markers.add(Marker(
            markerId: MarkerId(house.name),
            position: house.location,
            onTap: () {
              Navigator.pushNamed(context, '/detail', arguments: house);
            }));


      var isInCart = context.select<AppState, bool>(
        (cart) => cart.bookmarked
            .where((element) => element.documentId == document.id)
            .isNotEmpty,
      );

      return Card(
          child: InkWell(
        borderRadius: BorderRadius.circular(50),
        onTap: () {
          increaseHouseViewCount(house.documentId);
          Navigator.pushNamed(context, '/detail', arguments: house);
        },
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 16 / 11,
              child: isInCart
                  ? Stack(
                      children: [
                        Image.network(
                          house.thumbnail,
                          fit: BoxFit.cover,
                        ),
                        const Positioned(
                          top: 10,
                          right: 10,
                          child: Icon(
                            Icons.check_circle,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    )
                  : Image.network(
                      house.thumbnail,
                      fit: BoxFit.cover,
                    ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 7,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            house.name, //document['name'],
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                          ),
                          Row(
                            children: [
                              Icon(Icons.location_on),
                              Expanded(
                                  child: Text(
                                "${house.address}",
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                            ],
                          ),
                          const Divider(height: 8),
                          Text(
                            "보증금 ${numberFormat.format(house.deposit)} / 월 ${numberFormat.format(house.monthlyPay)}", //document['monthlyPay']),
                            style: const TextStyle(
                              fontSize: 11,
                            ),
                            maxLines: 2,
                          ),
                          const Divider(height: 8),
                          Text("설명 : ${house.description}"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ));
    }).toList();
  }

  Widget buildHouseCard() {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: houseCollectionReference
            .orderBy('monthlyPay', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: Center(child: CircularProgressIndicator()));
          } else {
            return OrientationBuilder(
              builder: (context, orientation) {
                return GridView.count(
                  scrollDirection: Axis.horizontal,
                  crossAxisCount: 1,
                  padding: const EdgeInsets.all(16.0),
                  childAspectRatio: 16.0 / 12.0,
                  children: _buildHouseCards(context, snapshot),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class MapPoint {
  final String name;
  final LatLng center;
  final double zoom;
  MapPoint({required this.name, required this.center, required this.zoom});
}
