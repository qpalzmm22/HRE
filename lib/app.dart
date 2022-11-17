import 'package:flutter/material.dart';
// import 'home.dart';
import 'login.dart';
import 'home.dart';

class HreApp extends StatelessWidget {
  const HreApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shrine',
      initialRoute: '/',
      routes: {
        '/' : (BuildContext context) => const LoginPage(),
        // '/profile': (BuildContext context) => const Profile(),
        // '/add_product': (BuildContext context) => const AddProduct(),
        // '/product_detail': (BuildContext context) => const ProductDetail(),
        '/home': (BuildContext context) => const HomePage(),
        // '/edit': (BuildContext context) => const UpdateProduct(),
        // '/wishlist': (BuildContext context) => const Wishlist(),
      },
    );
  }
}