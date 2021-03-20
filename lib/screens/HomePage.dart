import 'package:firebase_auth/firebase_auth.dart';
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


  final _auth = FirebaseAuth.instance;
  Completer<GoogleMapController>_controller = Completer();
  final Set<Marker> _markers = {};
  LatLng _lastMapPosition =center;
  MapType _currentMapType = MapType.normal;
  static LatLng center = const LatLng(16.9685574, 82.24632070000001);
  static LatLng center1 = const LatLng(16.998600, 82.243592);
  static LatLng center2 = const LatLng(16.973475,82.237144);
  static LatLng center3 = const LatLng(16.960680,82.235901);


  String currentlocation="Current Location";
  String name_place="Geeth's House";

  @override
  void initState() {
  _getUserLocation();
  _onAddMarkerButtonPressed(center,currentlocation,name_place);
  _onAddMarkerButtonPressed(center1,"SRMT mall","Open");
  _onAddMarkerButtonPressed(center2,"Dominos","Open");
  _onAddMarkerButtonPressed(center3,"Appllo hospital","Open");



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

  _onAddMarkerButtonPressed(LatLng newposition,String title,String snippet){
    setState(() {
      _markers.add(
          Marker(
              markerId: MarkerId(newposition.toString()),
              position:newposition,
            infoWindow: InfoWindow(
              title: title,
              snippet: snippet,
            ),
            icon: BitmapDescriptor.defaultMarker,
          )
      );
      print(_markers);

    });
  }

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
            Padding(
              padding:EdgeInsets.all(16.0) ,
              child: Align(
                alignment: Alignment.topRight ,
                child: Column(
                  children: [
                    button(_onMapTypeButtonPressed, Icons.map),
                    SizedBox(height: 16.0,),
                    //button(_onAddMarkerButtonPressed(center1), Icons.add_location),
                  ],
                ),

              ),
            )
          ],

        )
    );
  }
}
