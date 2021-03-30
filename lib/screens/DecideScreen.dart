import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vibranium/screens/HomePage.dart';
import 'package:vibranium/screens/Schedule.dart';
import 'package:vibranium/screens/dashboard.dart';

import 'Homepage1.dart';

class Decide extends StatefulWidget {
  static const String id ='Decide_screen';
  @override
  _DecideState createState() => _DecideState();
}

var color1 = Color(0xff0050F5);
var color2 = Color(0xff7BA3F6);
final _auth = FirebaseAuth.instance;
String user;
bool present=false;



class _DecideState extends State<Decide> {

  @override
  void initState() {
    getdata();
    verify1();
    super.initState();
  }
  getdata()async{
    await FirebaseFirestore.instance.collection("users").doc(_auth.currentUser.uid).get().then((result) {
      if(result["Type"]=="User"){
        setState(() {
          user ="User";
          print(user);
        });
      }
      else{
        setState(() {
          user="Admin";
          print(user);
        });
      }
    });

  }
  verify1()async{
    await FirebaseFirestore.instance.collection("users").doc(_auth.currentUser.uid).get().then((user) {
      if(user["Type"]=="Admin"){
        FirebaseFirestore.instance.collection("Vendors").get().then((querySnapshot) {
          querySnapshot.docs.forEach((result) {
            FirebaseFirestore.instance
                .collection("Vendors")
                .doc("SRMT")
                .collection("SRMT")
                .get()
                .then((querySnapshot) {
              querySnapshot.docs.forEach((result) {
                if(result["CreatedBY"] == _auth.currentUser.uid){
                  print("PRESENT");
                  print(result["StoreName"]);
                  setState(() {
                    present=true;
                  });
                }

              });
            });
          });
        });
      }


    });
  }
  verify()async{
    await FirebaseFirestore.instance.collection("users").doc(_auth.currentUser.uid).get().then((user) {
      if(user["Type"]=="Admin"){
        FirebaseFirestore.instance.collection("Vendors").get().then((querySnapshot) {
          querySnapshot.docs.forEach((result) {
            FirebaseFirestore.instance
                .collection("Vendors")
                .doc("SRMT")
                .collection("SRMT")
                .get()
                .then((querySnapshot) {
              querySnapshot.docs.forEach((result) {
                if(result["CreatedBY"] == _auth.currentUser.uid){
                  print("PRESENT");
                  print(result["StoreName"]);
                  Navigator.of(context)
                      .pushReplacement(MaterialPageRoute(builder: (context) => Dashboard()));
                }

              });
            });
          });
        });
      }


    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 70,
            ),
            Row(
              children: [
                SizedBox(width: 25,),
                Text("Mode",
                    style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: color1)),
              ],
            ),
            SizedBox(
              height: 50,
            ),
            SizedBox(
              width: 200,
              height: 45,
              child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(color2),
                    shape:MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: color2)
                        )
                    ),
                    //backgroundColor: color2, // background
                    //onPrimary: Colors.white, // foreground
                  ),
                  child: Text("Admin", style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    if(user=="Admin"){
                      if(present == true){
                        verify();
                      }
                      if(present ==false){
                        Navigator.of(context)
                            .pushReplacement(MaterialPageRoute(builder: (context) => HomePage1()));
                      }


                    }
                    else{
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Your not an Admin'),
                        ),
                      );
                    }
                  }),
            ),
            SizedBox(height: 25,),
            SizedBox(
              width: 200,
              height: 45,
              child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(color2),
                    shape:MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: color2)
                        )
                    ),
                    //backgroundColor: color2, // background
                    //onPrimary: Colors.white, // foreground
                  ),
                  child: Text("Client", style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    if(user=="User"){
                      Navigator.of(context)
                          .pushReplacement(MaterialPageRoute(builder: (context) => Schedule()));
                    }
                    else{
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Your not an Client'),
                        ),
                      );
                    }
                  }),
            ),
            SizedBox(height: 150,),

            Image.asset('images/image 74.png')
          ],
        ),
      ),
    );
  }
}
