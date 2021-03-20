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
  //static LatLng _initialPosition;
  static LatLng center = const LatLng(16.9685574, 82.24632070000001);
@override
  void initState() {
  _getUserLocation();
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
      _currentMapType = _currentMapType==MapType.normal?MapType.satellite:MapType.normal;

    });
  }
  _onAddMarkerButtonPressed(){
    setState(() {
      _markers.add(
          Marker(
              markerId: MarkerId(_lastMapPosition.toString()),
              position: _lastMapPosition,
            infoWindow: InfoWindow(
              title: 'My Current Location',
              snippet: 'Geeth',
            ),
            icon: BitmapDescriptor.defaultMarker,
          )
      );

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
                    button(_onAddMarkerButtonPressed, Icons.add_location),
                  ],
                ),

              ),
            )
          ],

        )
    );
  }
}
