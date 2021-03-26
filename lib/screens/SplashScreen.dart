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
  var color1 =  Colors.deepOrangeAccent;




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:color1 ,
      body: Center(

        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        width: 75,
                          height: 75,
                          child: Image.asset('images/D.png')),
                      Image.asset('images/Ellipse 1.png')
                    ],
                  ),
                  SizedBox(height: 15,),
                  Text("Dormammu",style: TextStyle(fontWeight:FontWeight.bold,color: Colors.white,fontSize: 35),)

                ],
              ),
              SizedBox(height: 15,),
              CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ]
        ),
      ),
    );
  }
}