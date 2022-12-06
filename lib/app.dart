import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:flutterfire_ui/i10n.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:handong_real_estate/placePicker.dart';
import 'package:handong_real_estate/profile.dart';
import 'package:handong_real_estate/roommates.dart';
import 'package:handong_real_estate/search.dart';

// import 'home.dart';
import 'login.dart';
import 'home.dart';
import 'detail.dart';
import 'addHouse.dart';
import 'map.dart';
import 'messagePage.dart';
import 'edit.dart';

class LabelOverrides extends DefaultLocalizations {
  const LabelOverrides();

  @override
  String get emailInputLabel => '이메일';

  @override
  String get passwordInputLabel => '비밀번호';

}


class HreApp extends StatelessWidget {
  const HreApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        FlutterFireUILocalizations.withDefaultOverrides(const LabelOverrides()),

        // Delegates below take care of built-in flutter widgets
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,

        // This delegate is required to provide the labels that are not overridden by LabelOverrides
        FlutterFireUILocalizations.delegate,
      ],
      title: 'Shrine',
      initialRoute: '/',
      routes: {
        '/' : (BuildContext context) => const LoginPage(),
        // '/add_product': (BuildContext context) => const AddProduct(),
        // '/product_detail': (BuildContext context) => const ProductDetail(),
        '/home': (BuildContext context) => const HomePage(),
        '/detail': (BuildContext context) => const DetailPage(),
        '/editPage': (BuildContext context) => const EditPage(),
        '/addHouse' : (BuildContext context) => const AddHousePage(),
        // '/edit': (BuildContext context) => const UpdateProduct(),
        '/map': (BuildContext context) =>  Map(),
        '/messagePage': (BuildContext context) => const MessagePage(),
        '/communityPage' : (BuildContext context) => const ComunityPage(),
        '/searchPage': (BuildContext context) => PlacePicker(),
        '/postPage' : (BuildContext context) => const PostPage(),
        '/roommateDetail' : (BuildContext context)  => const RoommateDetail(),
        '/profile': (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("계정 관리"),
            ),
            body: ProfileScreen(
              // no providerConfigs property here as well
              actions: [
                SignedOutAction((context) {
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, '/');
                }),
              ],
            ),
          );
        },
        //'ssions'
        // '/wishlist': (BuildContext context) => const Wishlist(),
      },
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.purple[50],
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFAF7FF),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
          iconTheme: IconThemeData(
            color: Colors.black,
            size: 20,
          ),
        ),
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