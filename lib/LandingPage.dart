import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vibranium/screens/Authentication.dart';
import 'package:vibranium/screens/DecideScreen.dart';
import 'package:vibranium/screens/HomePage.dart';





class LandingPage extends StatefulWidget {
  static const String id ='landing_screen';
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final auth1 =FirebaseAuth.instance;
  User user1;
  void authCurrentUser(){
    setState(() {
      user1 = auth1.currentUser;
    });
  }
  @override
  void initState() {
    authCurrentUser();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
        stream: auth1.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User user = snapshot.data;
            if (user != null ) {
              if(user1 != null){
                user1.reload();
                if( user1.emailVerified == true){
                  print('HomePage called 2');
                  return Decide();
                }
              }

            }
            return EmailSigninPage();
          }
          else {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        }
    );
  }
}