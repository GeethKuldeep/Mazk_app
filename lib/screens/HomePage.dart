import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../LandingPage.dart';


class HomePage extends StatefulWidget {
  static const String id ='Home_Page';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var color =  Color(0xFF7BA3F6);
  final _auth = FirebaseAuth.instance;
  Completer<GoogleMapController>_controller = Completer();
  final Set<Marker> _markers = {};
  LatLng _lastMapPosition =center;
  MapType _currentMapType = MapType.normal;
  static LatLng center = const LatLng(16.9685574, 82.24632070000001);
  static LatLng center1 = const LatLng(16.998600, 82.243592);
  static LatLng center2 = const LatLng(16.973475,82.237144);
  static LatLng center3 = const LatLng(16.960680,82.235901);
  String Shopname;
  String Placename;
  bool pressed1 = false;
  bool pressed2 = false;
  bool pressed3 = false;
  bool pressed4 = false;
  bool pressed5 = false;
  Color final_color;
  var stream1 =FirebaseFirestore.instance.collection("Vendors").where("StoreName",isEqualTo:"KFC").snapshots();
  String present_count ="";
  int _count_;
  Color hello;
  String currentlocation="Current Location";
  String name_place="Geeth's House";
  TextEditingController _controller1 = TextEditingController();
  TextEditingController _controller2 = TextEditingController();
  bool tapped = false;
  String URL;

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
    _onAddMarkerButtonPressed(center3,"Appollo","Open",pressed4,4);
    print("Marker5 ${_markers}");
    refresh_count();


    super.initState();
  }

  _search() {
    setState(() {
      Shopname = _controller1.text;
    });
    _controller1.clear();

  }

  _search1(){
    setState(() {
      //Placename = _controller2.text;
      tapped=false;
      _controller2.clear();

    });
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

  void ontap(context,){
    showModalBottomSheet(context: context,shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
    ), builder:(BuildContext bc){

      return SingleChildScrollView(
        child: Container(

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
                SizedBox(height: 12,),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(left:12.0,bottom: 8.0),
                        decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(24.0)
                        ),
                        child:TextFormField(
                          controller: _controller1,
                          onEditingComplete: _search,
                          decoration: InputDecoration(
                              hintText: "Search a shop",
                              contentPadding: const EdgeInsets.only(left: 24.0),
                              border: InputBorder.none
                          ),
                        ),

                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.search,color: Colors.blue,),
                      onPressed: () {
                       _search();
                        },
                    ),
                  ],
                ),
                StreamBuilder(
                    stream: Shopname==null?FirebaseFirestore.instance.collection("Vendors").doc("SRMT").collection("SRMT").snapshots():FirebaseFirestore.instance.collection("Vendors").doc("SRMT").collection("SRMT").where("StoreName",isEqualTo:"${Shopname}").snapshots(),
                    builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot) {
                      print("No:of Shops = ${snapshot.data.docs.length}");
                      if (snapshot.data.docs.isEmpty ) {
                        //print("No such shop found");
                        return Center(child: Text("No such shop found",
                          style: TextStyle(fontStyle: FontStyle.italic,
                              fontSize: 15),));
                      }
                      else if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.lightBlueAccent,
                          ),
                        );
                      }
                      else if (snapshot.hasData && snapshot.data != null) {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            DocumentSnapshot user = snapshot.data.docs[index];
                            if (user["Current_strength"] <=
                                user["Total_strength"] * 0.25) {
                              final_color = Colors.lightGreenAccent;
                            }
                            else if (user["Total_strength"] * 0.25 <
                                user["Current_strength"] &&
                                user["Current_strength"] <=
                                    user["Total_strength"] * 0.75) {
                              final_color = Colors.orange;
                            }
                            else if (user["Total_strength"] * 0.75 <
                                user["Current_strength"] &&
                                user["Current_strength"] <=
                                    user["Total_strength"]) {
                              final_color = Colors.red;
                            }
                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: [
                                        Text(user["StoreName"], style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 25),),
                                        Text(user["Instruction1"],
                                          style: TextStyle(fontSize: 15),),
                                        Text(user["Instruction2"],
                                          style: TextStyle(fontSize: 15),),
                                        Text("Open Time: ${user["Timings"][0]}",
                                          style: TextStyle(fontSize: 15),),
                                        Text("Close Time: ${user["Timings"][1]}",
                                          style: TextStyle(fontSize: 15),),
                                      ],),
                                    Column(
                                      children: [
                                        Container(
                                          height: 25,
                                          width: 25,
                                          decoration: BoxDecoration(
                                              color: final_color,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20))
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                            "${user["Current_strength"]}/${user["Total_strength"]}")
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },


                        );
                      }
                      else {
                        return Center(
                          child: Text('Something is wrong'),
                        );
                      }
                    }
                ),
              ],
            )
        ),
      );

    });
  }

  zoom(LatLng location)async{
    final GoogleMapController mapController1 = await _controller.future;
    mapController1.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(location.latitude,location.longitude),
            zoom:18.0,
            bearing: 90.0,
            tilt: 45.0
        )
    ));
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
            alignment: Alignment.topCenter ,
            child: Padding(
                    padding: const EdgeInsets.only(top:45.0,left: 10,right: 10),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left:5.0,right: 5.0),
                          decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(15.0)
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _controller2,
                                  onEditingComplete: _search1,
                                  onChanged: (String hello){
                                    setState(() {
                                      tapped =true;
                                      Placename=hello;
                                    });
                                  },
                                  style: TextStyle(color: Colors.white,fontSize: 20),
                                  decoration: InputDecoration(
                                      hintStyle: TextStyle(
                                        color: Colors.white, // <-- Change this
                                      ),
                                      hintText: "Search",
                                      contentPadding: const EdgeInsets.only(left: 24.0,right: 24.0),
                                      border: InputBorder.none
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.search,color: Colors.white,size: 28,),
                                onPressed: () {
                                  _search1();
                                },
                              ),
                            ],
                          ),
                        ),
                       if(tapped==true)
                          StreamBuilder(
                           stream: Placename== null? FirebaseFirestore.instance.collection("Vendors").snapshots():FirebaseFirestore.instance.collection("Vendors").snapshots(),
                           builder:(BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
                             print("No:of Shops = ${snapshot.data.docs.length}");
                             if (snapshot.data.docs.isEmpty ) {
                               //print("No such shop found");
                               return Center(child: Text("No such shop found",
                                 style: TextStyle(fontStyle: FontStyle.italic,
                                     fontSize: 15),));
                             }
                             else if (snapshot.connectionState == ConnectionState.waiting) {
                               return Center(
                                 child: CircularProgressIndicator(
                                   backgroundColor: Colors.lightBlueAccent,
                                 ),
                               );
                             }
                             else if (snapshot.hasData && snapshot.data != null) {
                               return ListView.builder(
                                 shrinkWrap: true,
                                 itemCount: Placename == "SRMT"?1:snapshot.data.docs.length,
                                 itemBuilder: (BuildContext context, int index) {
                                   DocumentSnapshot user = snapshot.data.docs[index];
                                   if(user.id=="SRMT")
                                    URL ="images/mall1.png";
                                   else if(user.id=="Dominos")
                                     URL ="images/dom.png";
                                   else if(user.id == "Appollo")
                                     URL ="images/hos.png";
                                   if(Placename == "SRMT")
                                      return Container(

                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(Radius.circular(15))),
                                        child: ListTile(
                                            leading: CircleAvatar(
                                              backgroundImage: AssetImage("images/mall1.png"),
                                            ),
                                            contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                            title: Text("SRMT",style: TextStyle(fontWeight: FontWeight.bold),),
                                            trailing: Icon(Icons.location_pin,color: Colors.black,),
                                            onTap: () {
                                                zoom(center1);
                                            }
                                        ),
                                      );
                                   return Column(
                                       children: [
                                         Container(

                                           decoration: BoxDecoration(
                                               color: Colors.white,
                                               borderRadius: BorderRadius.all(Radius.circular(15))
                                           ),
                                           child: ListTile(
                                               leading: CircleAvatar(
                                                 backgroundImage: AssetImage(URL),
                                               ),
                                               contentPadding: EdgeInsets.symmetric(horizontal: 15),
                                               title: Text(user.id,style: TextStyle(fontWeight: FontWeight.bold),),
                                               trailing: Icon(Icons.location_pin,color: Colors.black,),
                                               onTap: () {
                                                 if(user.id=="SRMT")
                                                   zoom(center1);
                                                 else if(user.id=="Dominos")
                                                   zoom(center2);
                                                 else if(user.id == "Appollo")
                                                   zoom(center3);
                                               }
                                           ),
                                         ),
                                         SizedBox(height: 12,)
                                       ],

                                   );


                                 },


                               );
                             }
                             else {
                               return Center(
                                 child: Text('Something is wrong'),
                               );
                             }
                           } )
                      ],
                    ),
                  ),
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