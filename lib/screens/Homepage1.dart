import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../LandingPage.dart';

class HomePage1 extends StatefulWidget {
  @override
  _HomePage1State createState() => _HomePage1State();
}
var color1 = Color(0xff0050F5);
var color2 = Color(0xff7BA3F6);
var _formkey = GlobalKey<FormState>();
final TextEditingController _shopnameController = TextEditingController();
final TextEditingController _shopcapacityController = TextEditingController();
final TextEditingController _Instruction1Controller = TextEditingController();
final TextEditingController _Instruction2Controller = TextEditingController();
final FocusNode _shopnameFocusNode = FocusNode();
final FocusNode _shopcapacityFocusNode = FocusNode();
final FocusNode _Instruction1FocusNode = FocusNode();
final FocusNode _Instruction2FocusNode = FocusNode();
String get _shopname => _shopnameController.text;
String get _shopcapacity => _shopcapacityController.text;
String get _Instruction1 => _Instruction1Controller.text;
String get _Instruction2 => _Instruction2Controller.text;
final firestoreInstance = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;




class _HomePage1State extends State<HomePage1> {
  signout()async{
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, LandingPage.id);
  }
  _submit()async{
    await firestoreInstance
        .collection('Vendors')
        .doc("ehQnQQYcm6tiU3MmqgtW")
        .update({
      'Name': _shopname,
      'Total_strength': _shopcapacity,
      'Instruction1' : _Instruction1,
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Your Data has been submitted'),
      ),
    );
  }
  void _shopnameEditingComplete() {
    FocusScope.of(context).requestFocus(_shopcapacityFocusNode);
  }
  void _shopcapacityEditingComplete() {
    FocusScope.of(context).requestFocus(_Instruction1FocusNode);
  }

  void _Instruction1EditingComplete() {
    FocusScope.of(context).requestFocus(_Instruction2FocusNode);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 70,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(width: 25,),
                  Text("Admin",
                      style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: color1)),
                  RaisedButton(
                      child: Icon(Icons.logout,color: Colors.white,),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      color: color1,
                      onPressed: () {

                        signout();
                      }),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //Text("Just a step away",style: TextStyle(color:color3,fontSize: 25,fontWeight: FontWeight.bold),),
                    //SizedBox(height: MediaQuery.of(context).size.width * 0.07,),

                    TextFormField(
                        style: TextStyle(color: Colors.black),
                        cursorColor: Colors.black,
                        key: ValueKey("ShopName"),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter your ShopName';
                          }
                          return null;
                        },
                        controller:_shopnameController,
                        focusNode: _shopnameFocusNode,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(color: color1, fontSize: 13),
                          contentPadding: const EdgeInsets.all(8.0),
                          errorBorder: new OutlineInputBorder(
                            borderSide: new BorderSide(
                              color: color2,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: color1,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: color1,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          hintText: "Enter your Shop Name",
                          labelText: 'ShopName',
                          errorStyle: TextStyle(
                            color: color1,
                          ),
                        ),
                        autocorrect: false,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        onEditingComplete: _shopnameEditingComplete,
                      ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.07,
                    ),

                    TextFormField(
                        style: TextStyle(color: Colors.black),
                        cursorColor: Colors.black,
                        key: ValueKey("shopcapacity"),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter a  number';
                          }
                          return null;
                        },
                        controller: _shopcapacityController,
                        focusNode: _shopcapacityFocusNode,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(color: color1, fontSize: 13),
                          contentPadding: const EdgeInsets.all(8.0),
                          errorBorder: new OutlineInputBorder(
                            borderSide: new BorderSide(
                              color: color2,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: color1,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: color1,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          labelText: 'Shop Capacity',
                          hintText: "100",
                          errorStyle: TextStyle(
                            color: color1,
                          ),
                        ),
                        autocorrect: false,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        onEditingComplete: _shopcapacityEditingComplete,
                      ),

                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.07,
                    ),

                    TextFormField(
                      style: TextStyle(color: Colors.black),
                      cursorColor: Colors.black,
                      key: ValueKey("123"),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter Intructions';
                        }
                        return null;
                      },
                      controller: _Instruction1Controller,
                      focusNode: _Instruction1FocusNode,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: color1, fontSize: 13),
                        contentPadding: const EdgeInsets.all(8.0),
                        errorBorder: new OutlineInputBorder(
                          borderSide: new BorderSide(
                            color: color2,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: color1,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: color1,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        hintText: "-Mask is mandatory",
                        labelText: 'Instructions',
                        errorStyle: TextStyle(
                          color: color1,
                        ),
                      ),
                      autocorrect: false,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      onEditingComplete: _Instruction1EditingComplete,
                    ),

                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.04,
                    ),

          Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RaisedButton(
                            child: Text("Submit",style: TextStyle(color: Colors.white,fontSize: 20),),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            color: color1,
                            onPressed: () {
                              if (_formkey.currentState.validate() == true) {
                                _submit();
                              }
                            }),

                      ],
                    ),


                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.01,
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  SizedBox(width: 75,),
                  Image.asset('images/image 79.png'),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}
