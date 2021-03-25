import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../LandingPage.dart';

class Post {
  final String title;
  final String intruction1;
  final String intruction2;
  final Color color;
  final String counter;


  Post(this.title, this.intruction1,this.intruction2,this.color,this.counter);
}

class HomePage extends StatefulWidget {
  static const String id ='Home_Page';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  final _auth = FirebaseAuth.instance;
  Completer<GoogleMapController>_controller = Completer();
  final Set<Marker> _markers = {};
  LatLng _lastMapPosition =center;
  MapType _currentMapType = MapType.normal;
  static LatLng center = const LatLng(16.9685574, 82.24632070000001);
  static LatLng center1 = const LatLng(16.998600, 82.243592);
  static LatLng center2 = const LatLng(16.973475,82.237144);
  static LatLng center3 = const LatLng(16.960680,82.235901);
   bool pressed1 = false;
  bool pressed2 = false;
  bool pressed3 = false;
  bool pressed4 = false;
  bool pressed5 = false;
  Color final_color;
  final stream1 =FirebaseFirestore.instance.collection("Vendors").snapshots();

  String present_count ="";
  int _count_;
  Color hello;

  String currentlocation="Current Location";
  String name_place="Geeth's House";

  @override
  void initState() {
  _getUserLocation();
  print("Marker1 ${_markers}");
  _onAddMarkerButtonPressed(center,currentlocation,name_place,pressed1,1);
  print("Marker2 ${_markers}");
  _onAddMarkerButtonPressed(center1,"SRMT mall","Open",pressed2,2);
  print("Marker3 ${_markers}");
  _onAddMarkerButtonPressed(center2,"Dominos","Open",pressed3,3);
  print("Marker4 ${_markers}");
  _onAddMarkerButtonPressed(center3,"Appllo hospital","Open",pressed4,4);
  print("Marker5 ${_markers}");
  refresh_count();


    super.initState();
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

  _onMapCreated(GoogleMapController controller){
    _controller.complete(controller);
  }

  _onCameraMove(CameraPosition position){
    _lastMapPosition = position.target;
  }

  Widget button(Function fuction,IconData icon){
    return FloatingActionButton(
      onPressed: fuction,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      backgroundColor: Colors.blue,
      child: Icon(icon,size:36.0),


    );
  }

  _onMapTypeButtonPressed(){
    setState(() {
      _currentMapType = _currentMapType==MapType.normal?MapType.hybrid:MapType.normal;

    });
  }

  _onAddMarkerButtonPressed(LatLng newposition,String title,String snippet,bool pressed,int a){
    setState(() {
      _markers.add(
          Marker(
              markerId: MarkerId(newposition.toString()),
              position:newposition,
            infoWindow: InfoWindow(
              title: title,
              snippet: snippet,
              onTap:(){
                setState(() {
                  refresh_count();
                  pressed =true;
                  print('Pressed${a} = ${pressed}');
                  refresh_count();
                  ontap(context);
                });
              }
            ),
            icon: BitmapDescriptor.defaultMarker,
          )
      );
      //print(_markers);

    });
  }

  Future refresh_count()async{
    await FirebaseFirestore.instance.collection("Vendors").doc("ehQnQQYcm6tiU3MmqgtW").get().then((result) {
      setState(() {
        present_count = result["Current_strength"].toString();
        _count_ = result["Current_strength"];
        print("${present_count}");
        if(_count_ <25){
          setState(() {
            hello=Colors.lightGreenAccent;
            print("green");
          });
        }
        if(_count_ >25 && _count_<=50){
          setState(() {
            hello=Colors.orange;
            print("orange");
          });
        }
        if(_count_ <=75 && _count_>50){
          setState(() {
            hello=Colors.red;
            print("Red");
          });
        }
        //details["Nike"]={["-Mask","-Asrogya setu",Colors.red,present_count]};
        print("HELLO");
      });

    });
  }

  void ontap(context){
    showModalBottomSheet(context: context, builder:(BuildContext bc){
      return Container(
        child:  Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left:26,top:26,right: 26,bottom: 10),
                  child: Align(
                      alignment:Alignment.topLeft,
                      child: Text("SRMT Mall",style:TextStyle(fontSize: 35,fontWeight: FontWeight.bold))),
                ),
                //Padding( padding: const EdgeInsets.only(left:26,top:26,right: 26,bottom: 10),child: Text("L",style:TextStyle(color: Colors.green,fontWeight: FontWeight.bold,fontSize:30 )))
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left:26),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text('-Mask')),
            ),
            Padding(
              padding: const EdgeInsets.only(left:26),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text('-Aarogya setu')),
            ),
            Padding(
              padding: const EdgeInsets.only(left:26),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text('-Covid test certificate')),
            ),
            StreamBuilder(
                stream: stream1,
                builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){

                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (BuildContext context,int index){
                        DocumentSnapshot user = snapshot.data.docs[index];
                        if(user["Current_strength"] <= user["Total_strength"]*0.25 ){
                            final_color=Colors.lightGreenAccent;
                        }
                        else if(user["Total_strength"]*0.25< user["Current_strength"]&& user["Current_strength"]<= user["Total_strength"]*0.75){
                          final_color=Colors.orange;
                        }
                        else if(user["Total_strength"]*0.75< user["Current_strength"]&& user["Current_strength"]<= user["Total_strength"]){
                          final_color=Colors.red;
                        }
                        return Card(
                          child: Padding(
                          padding: const EdgeInsets.all(8.0),
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                              Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(user["StoreName"],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
                                  Text(user["Instruction1"],style: TextStyle(fontSize: 15),),
                                  Text(user["Instruction2"],style: TextStyle(fontSize: 15),),
                                  Text("Open Time: ${user["Timings"][0]}",style: TextStyle(fontSize: 15),),
                                  Text("Close Time: ${user["Timings"][1]}",style: TextStyle(fontSize: 15),),
                          ],),
                              Column(
                                children: [
                                  Container(
                                  height: 25,
                                  width: 25,
                                  decoration: BoxDecoration(
                                      color: final_color,
                                      borderRadius: BorderRadius.all(Radius.circular(20))
                                       ),
                                     ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text("${user["Current_strength"]}/${user["Total_strength"]}")
                                ],
                              )
                              ],
                              ),
                              ),
                              );
                              },


                  );
                }
            ),
          ],
        )
      );

    });
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body:Stack(
            children: [
              GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: center,
                  zoom: 11.0,
                ),
                mapType: _currentMapType,
                markers: _markers,
                onCameraMove: _onCameraMove,
              ),
              Align(
                alignment: Alignment.bottomLeft ,
                child: Padding(
                  padding:EdgeInsets.only(top:650,left: 16) ,
                  child: Align(
                    alignment: Alignment.bottomLeft ,
                    child: Column(
                      children: [
                        button(_onMapTypeButtonPressed, Icons.map),
                        SizedBox(height: 16,),
                        FloatingActionButton(
                          backgroundColor: Colors.blue,
                          child: Icon(Icons.logout,size:35),
                          onPressed: () async{
                            await _auth.signOut();
                            Navigator.pushReplacementNamed(context, LandingPage.id);
                          }

                        ),
                        //button(_onAddMarkerButtonPressed(center1), Icons.add_location),
                      ],
                    ),

                  ),
                ),
              ),


            ],

          ),

    );
  }
}
