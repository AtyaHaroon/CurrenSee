// import 'package:curr_admin/dashboard.dart';
// import 'package:curr_admin/splash.dart';
import 'dart:async';

import 'package:curr_admin/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool isinitialized = false;
  try {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyBPcSTVnX-DSygAO37ByMA19DYfefKOi_I",
            appId: "1:224799551002:android:7c9d212f91efaef7ef6ba3",
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

// ignore: must_be_immutable
class Main extends StatefulWidget {
  bool connection;
  Main({required this.connection});

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
   void initState() {
    super.initState();
    // Timer for splash screen duration
    Timer(Duration(seconds: 6), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Login()),
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: widget.connection
              //-------------------check for connection
              ?
              // Icon(Icons.emoji_emotions)
            Text("CurrenSee Admin ",style: TextStyle(color: Colors.teal,fontWeight: FontWeight.w700,fontSize: 40),)
              // Dashboard()
              // Addemployee()
              // Login()
              : Icon(Icons.cancel, color: Colors.red, size: 130),
        ),
      ),
    );
  }
}
