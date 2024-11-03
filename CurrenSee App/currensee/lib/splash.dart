import 'dart:async';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:currensee/welcome.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'CurrenSee',
    home: Splash_sc(),
  ));
}

class Splash_sc extends StatefulWidget {
  @override
  _VideoSplashScreenState createState() => _VideoSplashScreenState();
}

class _VideoSplashScreenState extends State<Splash_sc> {
  late VideoPlayerController _controller;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('video/CurrenSee.mp4')
      ..initialize().then((_) {
        setState(
            () {}); // Ensure the first frame is shown after the video is initialized
        _controller.play();
      }).catchError((error) {
        print('Error initializing video player: $error');
      });

    _timer = Timer(Duration(seconds: 4), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) => Welcome()), // Replace with your next screen
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final videoWidth = screenWidth;
    final videoHeight = screenHeight * 0.8;

    return Scaffold(
      backgroundColor: Colors.black,
      body: _controller.value.isInitialized
          ? Center(
              child: SizedBox(
                width: videoWidth,
                height: videoHeight,
                child: VideoPlayer(_controller),
              ),
            )
          : Center(
              child: CircularProgressIndicator(
                color: Colors.teal,
                backgroundColor: Colors.black,
              ), // Show a loading spinner while the video is initializing
            ),
    );
  }
}
