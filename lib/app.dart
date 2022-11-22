import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:handong_real_estate/profile.dart';

// import 'home.dart';
import 'login.dart';
import 'home.dart';
import 'detail.dart';
import 'addHouse.dart';

class HreApp extends StatelessWidget {
  const HreApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shrine',
      initialRoute: '/',
      routes: {
        '/' : (BuildContext context) => const LoginPage(),
        // '/add_product': (BuildContext context) => const AddProduct(),
        // '/product_detail': (BuildContext context) => const ProductDetail(),
        '/home': (BuildContext context) => const HomePage(),
        '/detail': (BuildContext context) => const DetailPage(),
        '/addHouse' : (BuildContext context) => const AddHousePage(),
        // '/edit': (BuildContext context) => const UpdateProduct(),
        // '/wishlist': (BuildContext context) => const Wishlist(),
      },
      theme: ThemeData(
        // Define the default brightness and colors.
        //brightness: Brightness.dark,
        primaryColor: const Color(0xff268C9F),
        //bottomAppBarColor: Color(0xff7E6078),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor : Colors.deepPurpleAccent,//Color(0xff7E6078),
          selectedItemColor: Colors.red,
          unselectedItemColor: Colors.grey,
        ),
        // Define the default font family.
        //fontFamily: GoogleFonts.poppins(),

        // Define the default `TextTheme`. Use this to specify the default
        // text styling for headlines, titles, bodies of text,  and more.
        // textTheme: const TextTheme(
        //   headline1: TextStyle(fontSize: 52.0),
        //   headline6: TextStyle(fontSize: 26.0),
        //   bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        // ),
        textTheme:GoogleFonts.poppinsTextTheme(),
      ),
    );
  }
}