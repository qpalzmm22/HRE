import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:horizontal_card_pager/card_item.dart';
import 'package:horizontal_card_pager/horizontal_card_pager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'dbutility.dart';


Widget IconLocation(String str){
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
  //PickedFile? _image;
  List<XFile> _images = [XFile("https://firebasestorage.googleapis.com/v0/b/handong-real-estate.appspot.com/o/addPhoto.png?alt=media&token=90bcd02f-91d3-4dd6-adb0-43317ad3cda8")];
  bool isFileUploaded = false;
  final _houseNameController = TextEditingController();
  final _houseMonthlyController = TextEditingController();
  final _houseDescriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "매물 등록",
        ),
        actions: [
          TextButton(
            onPressed: () async {
              String thumbnail = '';
              List<String> uploadedImageUrls = [];

              if(isFileUploaded){
                for(int i = 0; i < _images.length; i++){
                  String imageUrl = await uploadFile(File(_images[i].path));
                  uploadedImageUrls.add(imageUrl);
                  if(i == 0) thumbnail = imageUrl;
                }
              }
              addHouse(
                  _houseNameController.text,
                  int.parse(_houseMonthlyController.text),
                  _houseDescriptionController.text,
                  thumbnail,
                  uploadedImageUrls
              );
              Navigator.pushNamed(context, '/home');
            },
            child: Text(
              "Save",
              style: TextStyle(color : Colors.white),
            )
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            HorizontalCardPager(
              initialPage : 2, // default value is 2
              onPageChanged: (page){},
              onSelectedItem: (page){},
              items: List<ImageCarditem>.generate(_images.length, (index) {
                return ImageCarditem(
                  image : isFileUploaded
                      ? Image.file(File(_images[index].path))
                        : Image.network(_images[index].path)
                  );
              }),
            ),


            // Container(
            //   height: 100,
            //   width: 100,
            //   child: ListView.builder(
            //     scrollDirection: Axis.horizontal,
            //     itemBuilder: (context, ind){
            //       return
            //     },
            //   )
            // ),
            // SizedBox(
            //   width: double.infinity,
            //   height: 300,
            //   child:
            //   _image
            //       ? Image.network(
            //     "http://handong.edu/site/handong/res/img/logo.png",
            //     fit: BoxFit.cover,
            //   )
            //       : Image.file(
            //       File(_image!.path),
            //       fit: BoxFit.cover
            //   ),
            // ),
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
                      if(images.isNotEmpty){
                        _images = images;
                        isFileUploaded  = true;
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
                  TextField(
                    controller: _houseNameController,
                    decoration: const InputDecoration(
                        filled: false,
                        labelText: 'Product Name'
                    ),
                  ),
                  const SizedBox(height: 10,),
                  TextField(
                    controller: _houseMonthlyController,
                    decoration: const InputDecoration(
                        filled: false,
                        labelText: 'Price'
                    ),
                  ),
                  const SizedBox(height: 10,),
                  TextField(
                    controller: _houseDescriptionController,
                    decoration: const InputDecoration(
                        filled: false,
                        labelText: 'Description'
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