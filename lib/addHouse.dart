import 'dart:async';
import 'dart:io';

import 'package:filter_list/filter_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:horizontal_card_pager/card_item.dart';
import 'package:horizontal_card_pager/horizontal_card_pager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:getwidget/getwidget.dart';
import 'package:kpostal/kpostal.dart';
import 'appState.dart';
import 'dbutility.dart';

Widget IconLocation(String str) {
  return Row(
    children: [
      Icon(Icons.location_on),
      Text(str),
    ],
  );
}

class AddHousePage extends StatefulWidget {
  const AddHousePage({Key? key}) : super(key: key);

  @override
  _AddHousePageState createState() => _AddHousePageState();
}

class _AddHousePageState extends State<AddHousePage> {
  List<XFile> _images = [
    XFile(
        "https://firebasestorage.googleapis.com/v0/b/handong-real-estate.appspot.com/o/addPhoto.png?alt=media&token=90bcd02f-91d3-4dd6-adb0-43317ad3cda8")
  ];
  bool isFileUploaded = false;
  final _houseNameController = TextEditingController();
  final _houseDepositController = TextEditingController();
  final _houseMonthlyController = TextEditingController();
  final _houseDescriptionController = TextEditingController();
  final _houseAddressController = TextEditingController();

  String postCode = '-';
  String roadAddress = '-';
  double kakaoLatitude = 0.0;
  double kakaoLongitude = 0.0;

  static const List<String> _options = [
    "싱크대", // 0
    "Wi-Fi", // 1
    "침대", // 2
    "가스 레인지", // 3
    "냉장고", // 4
    "에어콘", //5
    "장롱", // 6
    "세탁기", // 7
    "의자", // 8
    "신발장", // 9
    "배란다" // 10
  ]; // "채상"

  List<String> selectedTagList = [];
  final _formKey = GlobalKey<FormState>();

  List<bool> options_value = List.generate(_options.length, (index) => false);
  User user = FirebaseAuth.instance.currentUser as User;
  @override
  Widget build(BuildContext context) {
    // default : false
    Future<void> _openFilterDialog() async {
      await FilterListDialog.display<String>(
        context,
        hideSelectedTextCount: true,
        themeData: FilterListThemeData(context),
        headlineText: 'Select Tags',
        height: 500,
        listData: tagList,
        selectedListData: selectedTagList,
        choiceChipLabel: (item) => item, //item!.name,
        validateSelectedItem: (list, val) => list!.contains(val),
        controlButtons: [ControlButtonType.All, ControlButtonType.Reset],
        onItemSearch: (tag, query) {
          /// When search query change in search bar then this method will be called
          ///
          /// Check if items contains query
          return tag.toLowerCase().contains(query.toLowerCase());
        },

        onApplyButtonClick: (list) {
          setState(() {
            selectedTagList = List.from(list!);
          });
          Navigator.pop(context);
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "매물 등록",
        ),
        actions: [
          TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate() && _images.length > 3) {
                  String thumbnail = '';
                  List<String> uploadedImageUrls = [];
                  if (isFileUploaded) {
                    for (int i = 0; i < _images.length; i++) {
                      String imageUrl = await uploadFile(File(_images[i].path));
                      uploadedImageUrls.add(imageUrl);
                      if (i == 0) thumbnail = imageUrl;
                    }
                  }
                  String hid =
                      FirebaseFirestore.instance.collection('houses').doc().id;
                  House house = House(
                    hid: hid,
                    thumbnail: thumbnail,
                    name: _houseNameController.text,
                    monthlyPay: int.parse(_houseMonthlyController.text),
                    deposit: int.parse(_houseDepositController.text),
                    address: _houseAddressController.text,
                    description: _houseDescriptionController.text,
                    ownerId: user.uid,
                    documentId: "",
                    optionList: options_value,
                    location: LatLng(kakaoLatitude, kakaoLongitude),
                    imageLinks: uploadedImageUrls,
                    views: 0,
                    tags: selectedTagList,
                  );
                  addHouseToDB(house);
                  Navigator.pushReplacementNamed(context, '/home', arguments: 0);
                }
                else if(_images.length <=3){
                  const snackBar = SnackBar(
                    content: Text('사진은 최소 4장 이상 넣어주세요.'),
                  );

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
              child: const Text(
                "Save",
                style: TextStyle(color: Colors.black),
              )),
        ],
      ),
      body: SafeArea(
        child: ListView(children: [
          CarouselSlider(
            options: CarouselOptions(
              height: 200,
              aspectRatio: 16 / 9,
              viewportFraction: 0.8,
              initialPage: 0,
              enableInfiniteScroll: true,
              autoPlay: isFileUploaded,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              // onPageChanged: callbackFunction,
              scrollDirection: Axis.horizontal,
            ),
            items: _images.map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    // decoration: BoxDecoration(
                    //     color: Colors.amber
                    // ),
                    child: InkWell(
                      onDoubleTap: () async {
                        // Pick an image
                        final ImagePicker imagePicker = ImagePicker();
                        //var image = await ImagePicker.platform.pickImage(source: ImageSource.gallery);
                        final List<XFile> images =
                            await imagePicker.pickMultiImage();
                        //var images = await imagePicker.pickMultiImage();
                        setState(() {
                          if (images.isNotEmpty) {
                            _images = images;
                            isFileUploaded = true;
                          }
                        });
                      },
                      child: isFileUploaded
                          ? Image.file(
                              File(i.path),
                              fit: BoxFit.fitHeight,
                            )
                          : Image.network(
                              i.path,
                              fit: BoxFit.fitHeight,
                            ),
                    ),
                  );
                },
              );
            }).toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () async {
                  // Pick an image
                  final ImagePicker imagePicker = ImagePicker();
                  //var image = await ImagePicker.platform.pickImage(source: ImageSource.gallery);
                  final List<XFile> images = await imagePicker.pickMultiImage();
                  //var images = await imagePicker.pickMultiImage();
                  setState(() {
                    if (images.isNotEmpty) {
                      _images = images;
                      isFileUploaded = true;
                    }
                  });
                },
                icon: const Icon(
                  Icons.camera_alt,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          Form(
            key: _formKey,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                  children: [
                Row(
                  children: [
                    TextButton(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => KpostalView(
                              kakaoKey: 'cabdb067deb0d93614b6e47dff96ada3',
                              useLocalServer: false,
                              callback: (Kpostal result) {
                                print(result);
                                setState(() {
                                  roadAddress = result.address;
                                  kakaoLatitude =
                                      result.kakaoLatitude as double;
                                  kakaoLongitude =
                                      result.kakaoLongitude as double;
                                });
                              },
                            ),
                          ),
                        );
                        _houseAddressController.text = roadAddress.toString();
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.blue)),
                      child: const Text(
                        '주소검색',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        controller: _houseAddressController,
                        decoration: const InputDecoration(
                            filled: false, labelText: '주소'),
                        validator: (value) {
                          if(value == null || value.isEmpty){
                            return ("주소를 입력해주세요");
                          }
                          return null;
                        },
                      ),
                    ),

                  ],
                ),

                const SizedBox(
                  height: 10,
                ),
//>>>>>>> main
                TextFormField(
                  controller: _houseNameController,
                  decoration: const InputDecoration(
                      filled: false, labelText: 'House Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return ("건물 이름을 입력해 주세요");
                    }
                  },
                ),
                const SizedBox(
                  height: 10,
                ),

                TextFormField(
                  controller: _houseDepositController,
                  decoration: const InputDecoration(
                      filled: false, labelText: 'Deposit'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return ("보증금을 입력해주세요");
                    }
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _houseMonthlyController,
                  decoration: const InputDecoration(
                      filled: false, labelText: 'Monthly Pay'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "월세를 입력해주세요.";
                    }
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _houseDescriptionController,
                  decoration: const InputDecoration(
                      filled: false, labelText: 'Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "설명을 입력해주세요.";
                    } else if (value.length < 10) {
                      return "10자 이상으로 작성해 주세요.";
                    }
                  },
                ),
                const SizedBox(
                  height: 10,
                ),

                    TextButton(
                      child: const Text(
                        '태그 추가',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: _openFilterDialog,
                      style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue)),

                      // style: ButtonStyle(
                      //   backgroundColor: MaterialStateProperty.all(Colors.blue),
                      // ),
                    ),

                    SizedBox(
                      height: 500,
                      child: GridView.builder(
                        // crossAxisCount : 4,
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5, //1 개의 행에 보여줄 item 개수
                          childAspectRatio: 3 / 1, //item 의 가로 1, 세로 2 의 비율
                          mainAxisSpacing: 5, //수평 Padding
                          crossAxisSpacing: 5, //수직 Padding
                        ),
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: const BoxDecoration(
                              color: Colors.cyan,
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                            child: Center(child: Text(selectedTagList![index])),
                          );
                        },
                        // separatorBuilder: (context, index) => const Divider(),
                        itemCount: selectedTagList!.length,
//=======
                      ),
                    ),
              ]),
            ),
          )
        ]),
      ),
    );
  }
}
