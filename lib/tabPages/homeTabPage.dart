import 'dart:async';
import 'package:driverhop/configMap.dart';
import 'package:driverhop/main.dart';
import 'package:driverhop/notifications/pushNotifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeTabPage extends StatefulWidget {
  @override
  _HomeTabPageState createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController newGoogleMapController; // when rider want a driver for change map

  static final CameraPosition _kGooglePlex = CameraPosition(
      target: LatLng(37.42796133580664, -122.085749655962), zoom: 14.4746);

  Position currentPosition;
  var geolocator = Geolocator();

  String driverStatusText="Go on line ";
  Color driverStatusColor=Colors.black;
  bool isDriverAvalble = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentDriverInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          mapType: MapType.normal,
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controllerGoogleMap.complete(controller);
            newGoogleMapController = controller;
            loctedPostion();
          },
        ),
        Container(
          height: 140,
          width: double.infinity,
          color: Colors.black54,
        ),
       Positioned(top: 60.0,left: 0.0,right: 0.0,child:
       Row(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
           Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
             child: RaisedButton(
               onPressed: (){
                if(isDriverAvalble!=true){
                  makeDriverOnLine();
                  getLocationLiveUpdate();
                  setState(() {
                    driverStatusColor = Colors.green;
                    driverStatusText = "On line";
                    isDriverAvalble=true;
                  });
                }else{
                  makeDriverOffLine();
                  setState(() {
                    driverStatusText="Go on line ";
                     driverStatusColor=Colors.black;
                     isDriverAvalble = false;
                  });

                }
               },
               color: driverStatusColor,
               child: Padding(
               padding: EdgeInsets.all(17.0),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(driverStatusText,style: TextStyle(color: Colors.white,fontSize: 20.0)),
                  Icon(Icons.phone_android,size: 24.0,color: Colors.white,)
                ],
               ),
               ),
             ),
           ),
         ],
       )),


      ],
    );
  }
  // this method for get current position
  void loctedPostion() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;
    LatLng latLngPosition = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition =
    CameraPosition(target: latLngPosition, zoom: 14.0);
    newGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    // String address =
    // await AssistantMethod.searchCoordinateAddress(position, context);
    // print(address);
  }

  // this method for got geoFireDriver
void makeDriverOnLine()async{
      Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
       currentPosition = position;
  Geofire.initialize("availableDrivers");
  Geofire.setLocation(currentFirebaseUser.uid,currentPosition.latitude,currentPosition.longitude);
  rideRequest.onValue.listen((event) {

  });


}

  void makeDriverOffLine(){
    Geofire.removeLocation(currentFirebaseUser.uid);
    rideRequest.onDisconnect();
    rideRequest.remove();
    rideRequest=null;
  }

// method for listing to update live driver Position
void getLocationLiveUpdate(){
  homeTabPageStreamSubscription = Geolocator.getPositionStream().listen((Position position) {
    currentPosition = position;
    if(isDriverAvalble==true){
      Geofire.setLocation(currentFirebaseUser.uid, position.latitude, position.longitude);
    }
    LatLng lating = LatLng(position.latitude,position.longitude);
    newGoogleMapController.animateCamera(CameraUpdate.newLatLng(lating));
  });
 }

 // this void for puch notifiction by firebase messaging
void getCurrentDriverInfo()async{
    currentFirebaseUser = await FirebaseAuth.instance.currentUser;
    PushNotifications pushNotifications = PushNotifications();
    pushNotifications.initialize(context);
    pushNotifications.getToken();
}
}
