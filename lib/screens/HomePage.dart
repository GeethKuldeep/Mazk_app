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

  Post(this.title, this.intruction1,this.intruction2,this.color);
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
  Map details={"Nike":["-Mask","-Asrogya setu",Colors.red],"Big Bazar":["-Mask","-Asrogya setu",Colors.orange],"Lalitha Jewellers":["-Mask","-Asrogya setu",Colors.lightGreenAccent],"Jack and Jones":["-Mask","-Asrogya setu",Colors.red],};


  String currentlocation="Current Location";
  String name_place="Geeth's House";

  @override
  void initState() {
  _getUserLocation();
  _onAddMarkerButtonPressed(center,currentlocation,name_place,pressed1,1);
  _onAddMarkerButtonPressed(center1,"SRMT mall","Open",pressed2,2);
  _onAddMarkerButtonPressed(center2,"Dominos","Open",pressed3,3);
  _onAddMarkerButtonPressed(center3,"Appllo hospital","Open",pressed4,4);



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
                  pressed =true;
                  print('Pressed${a} = ${pressed}');
                  ontap(context);
                });
              }
            ),
            icon: BitmapDescriptor.defaultMarker,
          )
      );
      print(_markers);

    });
  }

  void ontap(context){
    showModalBottomSheet(context: context, builder:(BuildContext bc){
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: MediaQuery.of(context).size.height*.60,
            child: Column(
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
                      Padding( padding: const EdgeInsets.only(left:26,top:26,right: 26,bottom: 10),child: Text("L",style:TextStyle(color: Colors.green,fontWeight: FontWeight.bold,fontSize:30 )))
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
                  Expanded(
                    child: SearchBar<Post>(
                      onSearch: search,
                      onItemFound: (Post post, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(post.title,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
                                      Text(post.intruction1,style: TextStyle(fontSize: 15),),
                                      Text(post.intruction2,style: TextStyle(fontSize: 15),),



                                    ],
                                  ),
                                  Container(

                                    height: 25,
                                      width: 25,
                                      decoration: BoxDecoration(
                                            color: post.color,
                                          borderRadius: BorderRadius.all(Radius.circular(20))
                                      ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                ],
              ),

          ),
        ),
      );
    });
  }

  Future<List<Post>> search(String search1) async {
    await Future.delayed(Duration(seconds: 2));
    return List.generate(details.length, (int index) {
      return Post(
        "${details.keys.toList()[index]}",
        "${details.values.toList()[index][0]}",
        "${details.values.toList()[index][1]}",
        details.values.toList()[index][2],
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
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
                padding:EdgeInsets.only(top:700,left: 16) ,
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

        )
    );
  }
}
