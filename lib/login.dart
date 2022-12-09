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
      headerBuilder: (context, contraints, doub){
        return Image.network("https://firebasestorage.googleapis.com/v0/b/handong-real-estate.appspot.com/o/%E1%84%92%E1%85%A1%E1%86%AB%E1%84%83%E1%85%A9%E1%86%BC%E1%84%82%E1%85%A6_%E1%84%8B%E1%85%A1%E1%84%8B%E1%85%B5%E1%84%8F%E1%85%A9%E1%86%AB-removebg-preview.png?alt=media&token=95846669-4652-4b83-aed1-b197e65941c2");
      },
      actions: [
        AuthStateChangeAction<SignedIn>((context, state) {
          addUser(FirebaseAuth.instance.currentUser);
          Navigator.pushReplacementNamed(context, '/home', arguments: 0);
        }),
      ],
    );
  }
}