import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../LandingPage.dart';
enum EmailSignInFormType { signIn, register }


class EmailSigninPage extends StatefulWidget {
  @override
  _EmailSigninPageState createState() => _EmailSigninPageState();
}

class _EmailSigninPageState extends State<EmailSigninPage> {


  var _formkey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _UsernameController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final FocusNode _UsernameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _typeFocusNode = FocusNode();
  final FocusNode _password1FocusNode = FocusNode();
  String get _Username => _UsernameController.text;
  String get _type => _typeController.text;
  String get _email => _emailController.text;
  String get _password => _passwordController.text;
  EmailSignInFormType _formType = EmailSignInFormType.signIn;
  final firestoreInstance = FirebaseFirestore.instance;

  var color1 = Color(0xff0050F5);
  var color5 = Color(0xff7BA3F6);



  bool _passwordVisible;
  final snackBar = SnackBar(content: Text('Email is already registered'));
  String hello;
  int please;
  List emails = [];
  String formatted;
  final auth = FirebaseAuth.instance;
  Timer timer;
  bool verified = false;
  UserCredential authResult;
  User newuser;
  File _imageFile;


  Future<String> createAlertDialog(BuildContext context){
    TextEditingController customController =TextEditingController();
    return showDialog(context: context,builder:  (context){
      return AlertDialog(
        backgroundColor: Colors.black,
        title: Text("Forgot password?",style:TextStyle(color:Colors.white)),
        content:Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Enter email id',style:TextStyle(color:Colors.white,fontSize: 15)),
            ),
            TextField(
              cursorColor: Colors.white,
              decoration: InputDecoration(
                labelText: 'Email ID',
                labelStyle: TextStyle(color: Colors.white, fontSize: 13),
                contentPadding: const EdgeInsets.all(8.0),
                errorBorder: new OutlineInputBorder(
                  borderSide: new BorderSide(
                    color: Colors.white,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                errorStyle: TextStyle(
                  color: color1,
                ),
              ),
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              controller: customController,

            ),
          ],
        ),
        actions: [
          Row(

            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.1,
              ),
              RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),

                  ),
                  elevation: 5.0,
                  child: Text('Reset password',style:TextStyle(color:Colors.black)),
                  color: color1,
                  onPressed: () {
                    Navigator.of(context).pop(customController.text.toString());
                  }
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.18,
              ),
            ],
          ),


        ],
      );
    });

  }

  void sendverification() async {
    await authResult.user.sendEmailVerification();
    print('email sent');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
            'Verification link has been sent \n Please verify to continue '),
      ),
    );
    timer = Timer.periodic(Duration(seconds: 3), (timer) async {
      await verify();
      if (verified == true) {
        print("Hello");
        if (authResult.user.uid != null) {
          print("Hello1");

          await firestoreInstance
              .collection('users')
              .doc(authResult.user.uid)
              .set({
            'username': _Username,
            'email': _email,
            'ID' : authResult.user.uid,
            'Type':_type,
          });
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (context) => LandingPage()));
        }

      } else {
        print("Email is not verified");
      }
    });

  }

  void verify() async {
    print(authResult.user.emailVerified);
    print(authResult.user);
    newuser = await auth.currentUser;
    print(newuser);
    await newuser.reload();
    print(newuser.emailVerified);
    print('checking');
    if( newuser.emailVerified!=null){
      if ((await newuser.emailVerified) == true) {
        setState(() {
          verified = true;
          print('verified = true');
        });
      }
    }
  }

  void _submit() async {

    try {
      if (_formType == EmailSignInFormType.signIn) {
        authResult = await auth.signInWithEmailAndPassword(email: _email, password: _password);
        print(authResult);
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => LandingPage()));
        print('HomePage called 1');
      }
      if(_formType == EmailSignInFormType.register){
        authResult = await auth.createUserWithEmailAndPassword(email:_email,password: _password);
        print(authResult);
        sendverification();
      }

    } catch (e) {
      print(e.toString());
      if (e is PlatformException) {
        if (e.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
          hello = e.code;
          print(hello);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                  'This Email is already registered \n Please go back '),
            ),
          );
        }
        if (e.code == 'ERROR_WRONG_PASSWORD') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Wrong password'),
            ),
          );
        }
        if (e.code == 'ERROR_WRONG_PASSWORD') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Wrong password!!!'),
            ),
          );
        }
        if (e.code == 'ERROR_USER_NOT_FOUND') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('No user found!!!'),
            ),
          );
        }
      }
    }
  }

  @override
  void initState() {
    _passwordVisible = false;
  }

  void _UsernameEditingComplete() {
    FocusScope.of(context).requestFocus(_typeFocusNode);
  }
  void _typeEditingComplete() {
    FocusScope.of(context).requestFocus(_emailFocusNode);
  }

  void _emailEditingComplete() {
    FocusScope.of(context).requestFocus(_password1FocusNode);
  }

  void forgotpassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Reset email has been sent'),
        ),
      );
    } catch (e) {
      print(e);
      if (e is PlatformException) {
        if (e != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Enter your email'),
            ),
          );
        }
      }
    }
  }


  void _toggleFormType() {
    setState(() {
      _formType = _formType == EmailSignInFormType.signIn
          ? EmailSignInFormType.register
          : EmailSignInFormType.signIn;
    });
    _emailController.clear();
    _passwordController.clear();
  }


  @override
  Widget build(BuildContext context) {
    final primaryText =
    _formType == EmailSignInFormType.signIn ? 'SIGN IN' : 'SIGN UP';
    final secondaryText = _formType == EmailSignInFormType.signIn
        ? 'Need an account? \n         Sign up'
        : 'Have an account? \n         Sign in';
    var color2 =  Color(0xffA99CF0);
    var color3 =  Color(0xffDD6BA9);



    return Scaffold(
      resizeToAvoidBottomInset: true,
      body:  Column(
              children: [
                SizedBox(
                  height: 65,
                ),
                Image.asset('images/1.png',scale: 0.7,),
                SizedBox(
                  height:45,
                ),
                Text("Just a step away",style: TextStyle(color:Colors.white,fontSize: 25,fontWeight: FontWeight.bold),),
                SizedBox(height: MediaQuery.of(context).size.width * 0.07,),
                Expanded(
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top:25.0,left:40,right: 40),
                        child:Form(
                          key: _formkey,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                //Text("Just a step away",style: TextStyle(color:color3,fontSize: 25,fontWeight: FontWeight.bold),),
                                //SizedBox(height: MediaQuery.of(context).size.width * 0.07,),
                                if (_formType == EmailSignInFormType.register)
                                  TextFormField(
                                    style: TextStyle(color: Colors.black),
                                    cursorColor: Colors.black,
                                    key: ValueKey("UserName"),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Enter your Name';
                                      }
                                      return null;
                                    },
                                    controller: _UsernameController,
                                    focusNode: _UsernameFocusNode,
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
                                          color: color5,
                                          width: 2.0,
                                        ),
                                        borderRadius: BorderRadius.circular(12.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: color5,
                                          width: 2.0,
                                        ),
                                        borderRadius: BorderRadius.circular(12.0),
                                      ),
                                      labelText: 'UserName',
                                      errorStyle: TextStyle(
                                        color: color5,
                                      ),
                                    ),
                                    autocorrect: false,
                                    keyboardType: TextInputType.name,
                                    textInputAction: TextInputAction.next,
                                    onEditingComplete: _UsernameEditingComplete,
                                  ),
                                SizedBox(
                                  height: MediaQuery.of(context).size.width * 0.07,
                                ),

                                if (_formType == EmailSignInFormType.register)
                                  TextFormField(
                                    style: TextStyle(color: Colors.black),
                                    cursorColor: Colors.black,
                                    key: ValueKey("Type"),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Vendor or User?';
                                      }
                                      return null;
                                    },
                                    controller: _typeController,
                                    focusNode: _typeFocusNode,
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
                                      labelText: 'Vendor or User',
                                      errorStyle: TextStyle(
                                        color: color1,
                                      ),
                                    ),
                                    autocorrect: false,
                                    keyboardType: TextInputType.name,
                                    textInputAction: TextInputAction.next,
                                    onEditingComplete: _typeEditingComplete,
                                  ),

                                SizedBox(
                                  height: MediaQuery.of(context).size.width * 0.07,
                                ),

                                TextFormField(
                                  style: TextStyle(color: Colors.black),
                                  cursorColor: Colors.black,
                                  key: ValueKey("email"),
                                  validator: (value) {
                                    if (value.isEmpty || !value.contains('@')) {
                                      return 'Please enter a valid email';
                                    }
                                    return null;
                                  },
                                  controller: _emailController,
                                  focusNode: _emailFocusNode,
                                  decoration: InputDecoration(
                                    labelStyle: TextStyle(color: color1, fontSize: 13),
                                    contentPadding: const EdgeInsets.all(8.0),
                                    errorBorder: new OutlineInputBorder(
                                      borderSide: new BorderSide(
                                        color: color1,
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
                                    labelText: 'Email ID',
                                    errorStyle: TextStyle(
                                      color: color1,
                                    ),
                                  ),
                                  autocorrect: false,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  onEditingComplete: _emailEditingComplete,
                                ),

                                SizedBox(
                                  height: MediaQuery.of(context).size.width * 0.07,
                                ),

                                TextFormField(
                                  style: TextStyle(color: Colors.black),
                                  cursorColor: Colors.black,
                                  key: ValueKey("password1"),
                                  validator: (value) {
                                    if (value.isEmpty || value.length < 7) {
                                      return 'Please enter atleast 7 characters';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    errorBorder: new OutlineInputBorder(
                                      borderSide: new BorderSide(
                                        color: color1,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    labelStyle: TextStyle(color: color1, fontSize: 13),
                                    contentPadding: const EdgeInsets.all(8.0),
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
                                    labelText: 'Password',
                                    errorStyle: TextStyle(
                                      color: color1,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        // Based on passwordVisible state choose the icon
                                        _passwordVisible ? Icons.visibility : Icons.visibility_off,
                                        color: color1,
                                      ),
                                      onPressed: () {
                                        // Update the state i.e. toogle the state of passwordVisible variable
                                        setState(() {
                                          _passwordVisible = !_passwordVisible;
                                        });
                                      },
                                    ),
                                  ),
                                  controller: _passwordController,
                                  focusNode: _password1FocusNode,
                                  textInputAction: TextInputAction.done,
                                  onEditingComplete: _submit,
                                  obscureText: !_passwordVisible,
                                ),


                                if (_formType == EmailSignInFormType.signIn)
                                  Row(
                                    children: [
                                      FlatButton(
                                        child: Text('Forgot password?',
                                        style: TextStyle(color: color1)),
                                        onPressed: () {
                                          createAlertDialog(context).then((onValue){
                                            print(onValue);
                                            forgotpassword(onValue);
                                          });

                                        },
                                      ),
                                    ],
                                  ),

                                SizedBox(
                                  height: MediaQuery.of(context).size.width * 0.04,
                                ),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    RaisedButton(
                                        child: Text(primaryText,style: TextStyle(color: Colors.white,fontSize: 20),),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12.0),
                                        ),
                                        color: Colors.deepOrangeAccent,
                                        onPressed: () {
                                          if (_formkey.currentState.validate() == true) {
                                            _submit();
                                          }
                                        }),
                                    FlatButton(
                                      child: Text(
                                        secondaryText,
                                        style: TextStyle(color: color1),
                                      ),
                                      onPressed: _toggleFormType,
                                    ),
                                  ],
                                ),

                                SizedBox(
                                  height: MediaQuery.of(context).size.width * 0.01,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                  ),
                ),
              ],
            ),




      backgroundColor: color1,
    );
  }
}