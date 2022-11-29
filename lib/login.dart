import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    User? user;

    final GoogleSignInAccount? googleSignInAccount = await GoogleSignIn(clientId: DefaultFirebaseOptions.currentPlatform.iosClientId).signIn();
    if(googleSignInAccount != null){
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential userCredential = await firebaseAuth.signInWithCredential(authCredential);
      user = userCredential.user;
    }
    return user;
  }

  @override
  Widget build(BuildContext context) {
  var cart = context.watch<AppState>();
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            const SizedBox(height: 80.0),
            Column(
              children: const <Widget>[
                SizedBox(height: 16.0),
                Text('SHRINE'),
              ],
            ),
            const SizedBox(height: 120.0),
            ElevatedButton(
              onPressed: () async{
                User? user = await signInWithGoogle(context: context);
                if(user != null){
                  // TODO : Need to check if the user exist in DB before adding a new one
                  if( !isUserExist(user) ) addGoogleUser(user);
                  cart.user = user!;
                  Navigator.pushReplacementNamed(context, '/home');
                }
              },
              child: const Text('Google'),
            ),
            const SizedBox(height: 20,),
            ElevatedButton(
              onPressed: () async{

                final userCredential = await FirebaseAuth.instance.signInAnonymously();

                User? user = userCredential.user;
                cart.user = user!;

                addAnonymousUser(user);
                Navigator.pushReplacementNamed(context, '/home');
              },
              child: const Text('Anonymous Login'),
            ),
          ],
        ),
      ),
    );
  }
}