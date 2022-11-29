import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'appState.dart';
import 'package:intl/intl.dart';

class Bookmark{

  Widget getBookmarkPage(BuildContext contedt){
    return Column(
      children: [
        Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: _BookmarkedList(),
            )
        ),
      ],
    );

  }

}


class _BookmarkedList extends StatelessWidget{

  @override
  Widget build(BuildContext context) {

    final NumberFormat numberFormat = NumberFormat.simpleCurrency(locale: "ko_KR");

    var cart = context.watch<AppState>();

    Widget buildListCards(House house) {
      // List<Product> products = ProductsRepository.loadProducts(Category.all);


      final ThemeData theme = Theme.of(context);

      return  SizedBox(
          height: 130,
          child: Card(
            // elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: InkWell(
              onTap: (){
                Navigator.pushNamed(context, "/detail", arguments: house);
              },
              child: ListTile(
                leading: SizedBox(
                  height: 110.0,
                  width: 90.0,
                  child: Image(
                      image: NetworkImage(
                        house.imageUrl,
                      ),
                      fit: BoxFit.cover),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      house.name,
                      style: theme.textTheme.headline6,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      children: [
                        const Icon(Icons.location_on),
                        Text(
                          house.location,
                          style: theme.textTheme.subtitle2,
                        ),
                      ],
                    ),
                    Text(
                      "보증금 ${numberFormat.format(house.deposit)} / 월 ${numberFormat.format(house.monthlyPay)} ",//document['monthlyPay']),
                    ),
                  ],
                ),
              ),
            ),

          ),
        );
    }
    
    return ListView.builder(
      itemCount: cart.bookmarked.length,
      itemBuilder: (BuildContext context, int index) {
        final house = cart.bookmarked[index];
        return Dismissible(
          background: Container(
            padding: const EdgeInsets.only(right: 20),
            alignment: Alignment.centerRight,
            color: Colors.red,
            child: const Icon(Icons.delete),
          ),
            key: Key(house.name),
            child: buildListCards(house),
            onDismissed: (direction){
                cart.bookmarked.remove(house);
            },
        );
      },

    );
  
  
  }




}