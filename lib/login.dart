import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import 'appState.dart';
import 'firebase_options.dart';
import 'dbutility.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
//
//   Future<User?> signInWithGoogle({required BuildContext context}) async {
//     FirebaseAuth firebaseAuth = FirebaseAuth.instance;
//     User? user;
//
//     final GoogleSignInAccount? googleSignInAccount = await GoogleSignIn(clientId: DefaultFirebaseOptions.currentPlatform.iosClientId).signIn();
//     if(googleSignInAccount != null){
//       final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
//       final AuthCredential authCredential = GoogleAuthProvider.credential(
//         accessToken: googleSignInAuthentication.accessToken,
//         idToken: googleSignInAuthentication.idToken,
//       );
//
//       final UserCredential userCredential = await firebaseAuth.signInWithCredential(authCredential);
//       user = userCredential.user;
//     }
//     return user;
//   }

  @override
  Widget build(BuildContext context) {
  var cart = context.watch<AppState>();
    return SignInScreen(
      // headerBuilder: (context, constr, ss){
      //   return Text("hello");
      // },
      // footerBuilder: (context, auth){
      //   return Text("hello2");
      // },
      actions: [
        AuthStateChangeAction<SignedIn>((context, state) {
          addUser(FirebaseAuth.instance.currentUser);
          Navigator.pushReplacementNamed(context, '/home');
        }),
      ],
    );
  }
}