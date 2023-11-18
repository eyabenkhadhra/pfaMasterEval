import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pfa_2023_iit/pages/auth/login.view.dart';

import '../screen/home.page.dart';

class SplashScreeen extends StatefulWidget {
  const SplashScreeen({Key? key}) : super(key: key);

  @override
  State<SplashScreeen> createState() => _SplashScreeenState();
}

class _SplashScreeenState extends State<SplashScreeen> {
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final Stream<User?> _authStream = FirebaseAuth.instance.authStateChanges();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: _authStream,
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final User? user = snapshot.data;
            if (user != null) {
              // User is signed in, navigate to home screen
              print("User is signed in, navigate to home screen");
              return HomeScreen();
            } else {
              // No user signed in, navigate to login screen
              print("No user signed in, navigate to login screen");
              return LoginPage();
            }
          } else {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }
}
