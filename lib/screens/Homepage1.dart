import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../LandingPage.dart';

class HomePage1 extends StatefulWidget {
  @override
  _HomePage1State createState() => _HomePage1State();
}
var color1 = Color(0xff0050F5);
var color2 = Color(0xff7BA3F6);
var _formkey = GlobalKey<FormState>();
final TextEditingController _shoptypeController = TextEditingController();
final TextEditingController _shoptypenameController = TextEditingController();
final TextEditingController _shopnameController = TextEditingController();
final TextEditingController _shopcapacityController = TextEditingController();
final TextEditingController _Instruction1Controller = TextEditingController();
final TextEditingController _OpeningtimeController = TextEditingController();
final TextEditingController _ClosingtimeController = TextEditingController();
final FocusNode _shoptypeFocusNode = FocusNode();
final FocusNode _shoptypenameFocusNode = FocusNode();
final FocusNode _shopnameFocusNode = FocusNode();
final FocusNode _shopcapacityFocusNode = FocusNode();
final FocusNode _Instruction1FocusNode = FocusNode();
final FocusNode _OpeningtimeFocusNode = FocusNode();
final FocusNode _ClosingtimeFocusNode = FocusNode();
String get _shoptype => _shoptypeController.text;
String get _shoptypename => _shoptypenameController.text;
String get _shopname => _shopnameController.text;
String get _shopcapacity => _shopcapacityController.text;
String get _Instruction1 => _Instruction1Controller.text;
String get _Openingtime => _OpeningtimeController.text;
String get _Closingtime => _ClosingtimeController.text;
final firestoreInstance = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
LatLng center;




class _HomePage1State extends State<HomePage1> {
  signout()async{
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, LandingPage.id);
  }
  _submit()async{
    await firestoreInstance
        .collection('Vendors')
        .doc("SRMT").collection("SRMT").doc()
        .set({
      'StoreName': _shopname,
      'Total_strength': int.parse(_shopcapacity),
      'Instruction1' : _Instruction1,
      'ShopType' :_shoptype,
      'Timings':FieldValue.arrayUnion([_Openingtime,_Closingtime]),
      'Location':FieldValue.arrayUnion([center.latitude,center.longitude]),
      'Current_strength':50,
      'LocatedIN':_shoptypename,



    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Your Data has been submitted'),
      ),
    );
  }
  void _getUserLocation() async {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      center = LatLng(position.latitude, position.longitude);
      print("hello");
      print('${center}');
      print("hello1");
    });
  }
  void _shoptypeEditingComplete() {
    FocusScope.of(context).requestFocus(_shoptypenameFocusNode);
  }
  void _shoptypenameEditingComplete() {
    FocusScope.of(context).requestFocus(_shopnameFocusNode);
  }
  void _shopnameEditingComplete() {
    FocusScope.of(context).requestFocus(_shopcapacityFocusNode);
  }
  void _shopcapacityEditingComplete() {
    FocusScope.of(context).requestFocus(_Instruction1FocusNode);
  }

  void _Instruction1EditingComplete() {
    FocusScope.of(context).requestFocus(_OpeningtimeFocusNode);
  }
  void _OpeningtimeEditingComplete() {
    FocusScope.of(context).requestFocus(_ClosingtimeFocusNode);
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
                    TextFormField(
                      style: TextStyle(color: Colors.black),
                      cursorColor: Colors.black,
                      key: ValueKey("Shoptype"),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter your Shoptype';
                        }
                        return null;
                      },
                      controller:_shoptypeController,
                      focusNode: _shoptypeFocusNode,
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
                        hintText: "Individual or Complex",
                        labelText: 'ShopType',
                        errorStyle: TextStyle(
                          color: color1,
                        ),
                      ),
                      autocorrect: false,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      onEditingComplete: _shoptypeEditingComplete,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.07,
                    ),
                    if(_shoptype == "Complex")
                      TextFormField(
                      style: TextStyle(color: Colors.black),
                      cursorColor: Colors.black,
                      key: ValueKey("Shoptypename"),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter your complex name';
                        }
                        return null;
                      },
                      controller:_shoptypenameController,
                      focusNode: _shoptypenameFocusNode,
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
                        hintText: "Your Complex name",
                        labelText: 'Complex name',
                        errorStyle: TextStyle(
                          color: color1,
                        ),
                      ),
                      autocorrect: false,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      onEditingComplete: _shoptypenameEditingComplete,
                    ),
                    if(_shoptype == "Complex")
                      SizedBox(
                      height: MediaQuery.of(context).size.width * 0.07,
                    ),
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
                        hintText: "Mask is mandatory",
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
                      height: MediaQuery.of(context).size.width * 0.07,
                    ),
                    TextFormField(
                      style: TextStyle(color: Colors.black),
                      cursorColor: Colors.black,
                      key: ValueKey("12345"),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter time';
                        }
                        return null;
                      },
                      controller: _OpeningtimeController,
                      focusNode: _OpeningtimeFocusNode,
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
                        hintText: "9:30AM",
                        labelText: 'Opening time',
                        errorStyle: TextStyle(
                          color: color1,
                        ),
                      ),
                      autocorrect: false,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      onEditingComplete: _OpeningtimeEditingComplete,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.07,
                    ),
                    TextFormField(
                      style: TextStyle(color: Colors.black),
                      cursorColor: Colors.black,
                      key: ValueKey("1234"),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter time';
                        }
                        return null;
                      },
                      controller: _ClosingtimeController,
                      focusNode: _ClosingtimeFocusNode,
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
                        hintText: "11:30PM",
                        labelText: 'Closing time',
                        errorStyle: TextStyle(
                          color: color1,
                        ),
                      ),
                      autocorrect: false,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      onEditingComplete: _submit,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.04,
                    ),
                     ElevatedButton(
                       style: ElevatedButton.styleFrom(shape: new RoundedRectangleBorder(
                         borderRadius: new BorderRadius.circular(12.0),
                       ),),
                       onPressed: (){
                         _getUserLocation();
                       },
                       child: center==null?Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             Text("Add location",style:TextStyle(fontSize: 20)),
                             Icon(Icons.location_pin,color: Colors.grey,),
                           ],
                         ),
                       ):Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             Text("Location added",style:TextStyle(fontSize: 20)),
                             SizedBox(width: 25,),
                             Icon(Icons.location_pin,color: Colors.red,),
                           ],
                         ),
                       ),
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
