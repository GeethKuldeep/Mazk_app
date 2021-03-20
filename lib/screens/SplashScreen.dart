import 'dart:async';
import 'package:flutter/material.dart';

import '../LandingPage.dart';




class SplashScreen extends StatefulWidget {
  static const String id ='splash_screen';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(
        Duration(seconds: 3),
            () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => LandingPage())));
    print('timer done');
  }
  var color1 =  Color(0xffA99CF0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:color1 ,
      body: Center(

        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('images/splash.png')
                ],
              ),
              CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ]
        ),
      ),
    );
  }
}