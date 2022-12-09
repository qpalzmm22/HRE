import 'package:flutter/material.dart';
import 'package:kpostal/kpostal.dart';

class PlacePicker extends StatefulWidget {
  const PlacePicker({Key? key}) : super(key: key);

  @override
  _PlacePicker createState() => _PlacePicker();
}

class _PlacePicker extends State<PlacePicker> {
  String postCode = '-';
  String roadAddress = '-';
  String jibunAddress = '-';
  String latitude = '-';
  String longitude = '-';
  String kakaoLatitude = '-';
  String kakaoLongitude = '-';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("widget.title"),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () async {
                await Navigator.push(context, MaterialPageRoute(
                  builder: (_) => KpostalView(
                    callback: (Kpostal result) {
                    },
                  ),
                ));
              },
              child: Text('Search!'),
            ),

            TextButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => KpostalView(
                      kakaoKey: 'cabdb067deb0d93614b6e47dff96ada3',
                      callback: (Kpostal result) {
                        setState(() {
                          this.postCode = result.postCode;
                          this.roadAddress = result.address;
                          this.jibunAddress = result.jibunAddress;
                          this.latitude = result.latitude.toString();
                          this.longitude = result.longitude.toString();
                          this.kakaoLatitude = result.kakaoLatitude.toString();
                          this.kakaoLongitude =
                              result.kakaoLongitude.toString();
                        });
                      },
                    ),
                  ),
                );
              },
              style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.blue)),
              child: Text(
                'Search Address',
                style: TextStyle(color: Colors.white),
              ),
            ),
            Container(
              padding: EdgeInsets.all(40.0),
              child: Column(
                children: [
                  Text('postCode',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('result: ${this.postCode}'),
                  Text('road_address',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('result: ${this.roadAddress}'),
                  Text('jibun_address',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('result: ${this.jibunAddress}'),
                  Text('LatLng', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                      'latitude: ${this.latitude} / longitude: ${this.longitude}'),
                  Text('through KAKAO Geocoder',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                      'latitude: ${this.kakaoLatitude} / longitude: ${this.kakaoLongitude}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}