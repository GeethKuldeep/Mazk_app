
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibranium/screens/DecideScreen.dart';
import 'package:vibranium/screens/HomePage.dart';
import 'package:vibranium/screens/Myschedule.dart';
import 'package:vibranium/screens/SplashScreen.dart';

import 'LandingPage.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return  ChangeNotifierProvider(
      create: (context)=>Myschedule(),
      child: MaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: SplashScreen.id ,
            routes:{
              LandingPage.id:(context)=> LandingPage(),
              Decide.id:(context)=> Decide(),
              SplashScreen.id:(context)=>SplashScreen(),
              HomePage.id:(context)=> HomePage(),
            }




      ),
    );
  }
}
