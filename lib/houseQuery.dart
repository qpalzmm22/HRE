import 'package:flutter/material.dart';
import 'package:handong_real_estate/dbutility.dart';
import 'appState.dart';

class HouseQueryResultPage extends StatefulWidget {
  const HouseQueryResultPage({Key? key}) : super(key: key);

  @override
  _HouseQueryResultPageState createState() => _HouseQueryResultPageState();
}

class _HouseQueryResultPageState extends State<HouseQueryResultPage> {
  @override
  Widget build(BuildContext context) {
    List<House> houses =
        ModalRoute.of(context)!.settings.arguments as List<House>;

    return Scaffold(
        appBar: AppBar(
          title: Text("검색 결과"),
        ),
        body: ListView.builder(
            itemCount: houses.length,
            itemBuilder: (BuildContext context, int idx) {
              House house = houses[idx];

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: InkWell(
                  onTap: () async {
                    await Navigator.pushNamed(context, '/detail',
                            arguments: house)
                        .then((value) {
                      if (value == true) {
                        deleteHouse(house.hid);
                      }
                    });
                      Navigator.pushReplacementNamed(context, '/home',
                        arguments: 0);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: ListTile(
                        leading: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Image.network(
                            house.thumbnail,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              house.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                            ),
                            Row(
                              children: [
                                const Icon(Icons.location_on),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Text(
                                    house.address,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                    maxLines: 2,
                                  ),
                                )
                              ],
                            )
                          ],
                        )),
                  ),
                ),
              );
            }));
  }
}
