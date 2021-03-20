import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../LandingPage.dart';

class HomePage extends StatelessWidget {
  static const String id ='Home_Page';
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(Icons.logout,size:35),
              color: Colors.white,
              iconSize: 30,
              onPressed: () async{
                await _auth.signOut();
                Navigator.pushReplacementNamed(context, LandingPage.id);
              }),
        ],
      ),
        body: Center(child: Container(
        color:Colors.white,
        child: Text("Hello",style: TextStyle(fontSize: 50),),
      )),
    );
  }
}
