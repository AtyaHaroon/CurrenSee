// import 'package:currensee/welcome.dart';
// ignore_for_file: must_be_immutable

// import 'dart:async';

// import 'package:currensee/currensynews.dart';
// import 'package:currensee/login.dart';
import 'package:currensee/splash.dart';
// import 'package:currensee/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:currensee/login.dart';

// String? FinalEmail;

void main() async {
  //-------------------step to connect firebase
  WidgetsFlutterBinding.ensureInitialized();
  bool isinitialized = false;
  try {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyBPcSTVnX-DSygAO37ByMA19DYfefKOi_I",
            appId: "1:224799551002:android:7c9d212f91efaef7ef6ba3",
            // storageBucket: "fbapp-b8bef.appspot.com",
            messagingSenderId: "224799551002",
            projectId: "currensee-79c17"));
    isinitialized = true;
  } catch (ex) {
    print("Error connection ${ex}");
    isinitialized = false;
  }
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "CurrenSee",
    home: Main(
      connection: isinitialized,
    ),
  ));
}

class Main extends StatefulWidget {
  bool connection;
  Main({required this.connection});

  // const Main_pg({Key? key}) : super(key: key);

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: widget.connection
              ?
              Splash_sc()
              : Icon(Icons.cancel, color: Colors.red, size: 130),
        ),
      ),
    );
  }
}
