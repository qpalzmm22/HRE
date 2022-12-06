import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:horizontal_card_pager/card_item.dart';
import 'package:horizontal_card_pager/horizontal_card_pager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
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

class EditPage extends StatefulWidget {
  const EditPage({Key? key}) : super(key: key);

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  List<XFile> _newImages = [
    XFile("https://firebasestorage.googleapis.com/v0/b/handong-real-estate.appspot.com/o/addPhoto.png?alt=media&token=90bcd02f-91d3-4dd6-adb0-43317ad3cda8")
  ];
  String _thumbnail = '';
  List<String> _existImages = [];
  bool isFileUploaded = false;
  bool isFileExist = false;
  int _imgLen = 0;
  final _houseNameController = TextEditingController();
  final _houseDepositController = TextEditingController();
  final _houseMonthlyController = TextEditingController();
  final _houseDescriptionController = TextEditingController();
  final _houseAddressController = TextEditingController();

  String postCode = '-';
  String roadAddress = '-';
  double kakaoLatitude = 0.0;
  double kakaoLongitude = 0.0;

  static List<String> _options = [
    "sink",
    "wifi",
    "bed",
    "gas_stove",
    "refrigerator",
    "airconditioner",
    "closet",
    "washing_machine",
    "chair",
    "shoe_closet",
    "veranda"
  ];

  //List<String> get options => _options;

  List<bool> options_value = List.generate(_options.length, (index) => false);
  User user = FirebaseAuth.instance.currentUser as User;
  @override
  Widget build(BuildContext context) {
    House house = ModalRoute.of(context)!.settings.arguments as House;

    bool isFileExist = house.thumbnail.isNotEmpty;
    if(isFileExist){
      _existImages = house.imageLinks;
      _thumbnail = house.thumbnail;
      _imgLen = house.imageLinks.length;
    }

    _houseNameController.text = house.name;
    _houseDepositController.text = house.deposit.toString();
    _houseMonthlyController.text = house.monthlyPay.toString();
    _houseDescriptionController.text = house.description;
    _houseAddressController.text = house.address;

    options_value = house.optionList;

    // postCode = house.;
    roadAddress = '-';
    kakaoLatitude = house.location.latitude;
    kakaoLongitude = house.location.longitude;


    // default : false
    //List<bool> options_value = List.generate(_options.length, (index) => false);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "매물 등록",
        ),
        actions: [
          TextButton(
              onPressed: () async {

                List<String> uploadedImageUrls = [];
                if (isFileUploaded) {
                  _imgLen = _newImages.length;
                  for (int i = 0; i < _newImages.length; i++) {
                    String imageUrl = await uploadFile(File(_newImages[i].path));
                    uploadedImageUrls.add(imageUrl);
                    if (i == 0) _thumbnail = imageUrl;
                  }
                }
                House newHouse = House(
                  thumbnail: _thumbnail,
                  name: _houseNameController.text,
                  monthlyPay: int.parse(_houseMonthlyController.text),
                  deposit: int.parse(_houseDepositController.text),
                  address: _houseAddressController.text,
                  description: _houseDescriptionController.text,
                  ownerId: user.uid,
                  documentId: "",
                  optionList: options_value,
                  location: LatLng(kakaoLatitude ,kakaoLongitude),
                  imageLinks: isFileUploaded? uploadedImageUrls : _existImages,
                  views: house.views,
                );
                setHouseToDB(house.documentId, newHouse);
                Navigator.pushReplacementNamed(context, '/home');
              },
              child: const Text(
                "Save",
                style: TextStyle(color: Colors.black),
              )),
        ],
      ),
      body: SafeArea(
        child: ListView(
          children: [
            HorizontalCardPager(
              initialPage: 2, // default value is 2
              onPageChanged: (page) {},
              onSelectedItem: (page) {},
              items: List<ImageCarditem>.generate(_imgLen, (index) {
                return ImageCarditem(
                    image: isFileUploaded
                        ? Image.file(File(_newImages[index].path))
                        : Image.network(_existImages[index]));
              }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () async {
                    // Pick an image
                    final ImagePicker imagePicker = ImagePicker();
                    //var image = await ImagePicker.platform.pickImage(source: ImageSource.gallery);
                    final List<XFile> images =
                    await imagePicker.pickMultiImage();
                    //var images = await imagePicker.pickMultiImage();
                    setState(() {
                      if (images.isNotEmpty) {
                        _newImages = images;
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
            Container(
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
                                    kakaoLatitude = result.kakaoLatitude as double;
                                    kakaoLongitude = result.kakaoLongitude as double;
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
                        child: Text(
                          '주소검색',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextField(
                          readOnly: true,
                          controller: _houseAddressController,
                          decoration: const InputDecoration(
                              filled: false, labelText: '주소'),
                        ),
                      ),
                    ],
                  ),
                  TextField(
                    controller: _houseNameController,
                    decoration: const InputDecoration(
                        filled: false, labelText: 'House Name'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _houseDepositController,
                    decoration: const InputDecoration(
                        filled: false, labelText: 'Deposit'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _houseMonthlyController,
                    decoration: const InputDecoration(
                        filled: false, labelText: 'Monthly Pay'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _houseDescriptionController,
                    decoration: const InputDecoration(
                        filled: false, labelText: 'Description'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 400,
                    height: 700,
                    child: GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 3,
                      //padding: const EdgeInsets.all(4.0),
                      //childAspectRatio: 16.0 / 19.0,
                      children: List.generate(_options.length, (idx) {
                        return Card(
                          child: Column(
                            children: [
                              Text(
                                _options[idx],
                                //style: TextStyle(fontSize: 10),
                              ),
                              GFCheckbox(
                                size: GFSize.SMALL,
                                onChanged: (value) {
                                  setState(() {
                                    options_value[idx] = value;
                                  });
                                },
                                value: options_value[idx],
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
