// class after driver accepted ride request will puch to this screen
import 'dart:async';
import 'package:driverhop/Assistants/assistantMethod.dart';
import 'package:driverhop/Assistants/mapKitAssistants.dart';
import 'package:driverhop/configMap.dart';
import 'package:driverhop/main.dart';
import 'package:driverhop/modle/rideDetails.dart';
import 'package:driverhop/widget/collectFareDailog.dart';
import 'package:driverhop/widget/progssesDailgo.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NewRideScreen extends StatefulWidget {
  final RideDetails rideDetails;
  NewRideScreen({this.rideDetails});

  static final CameraPosition _kGooglePlex = CameraPosition(
      target: LatLng(37.42796133580664, -122.085749655962), zoom: 14.4746);

  @override
  _NewRideScreenState createState() => _NewRideScreenState();
}

class _NewRideScreenState extends State<NewRideScreen> {
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController
      newRideGoogleMapController; // when rider want a driver for change map

  // Position currentPosition;
  var geoLocator = Geolocator();
  var locationOptions =
      LocationOptions(accuracy: LocationAccuracy.bestForNavigation);
  BitmapDescriptor animatMarkersIcon;
  Set<Marker> markerSet = Set<Marker>();
  Set<Circle> circleSet = Set<Circle>();
  Set<Polyline> polylineSet = Set<Polyline>();
  List<LatLng> polylineCorOrdinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  double mapPadding = 0;
  Position myPosition;
  String status = 'accepted';
  String durationRide = '';
  bool isRequestingDirection =
      false; //will use for don't call this method  updateRideDetails always
  String btnTitle = 'Arrived';
  Color btnColor = Colors.blueAccent;
  Timer timer;
  int durationCounter = 0;

  @override
  void initState() {
    super.initState();
    accptedRideRequest();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: mapPadding),
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            markers: markerSet,
            circles: circleSet,
            polylines: polylineSet,
            initialCameraPosition: NewRideScreen._kGooglePlex,
            onMapCreated: (GoogleMapController controller) async {
              _controllerGoogleMap.complete(controller);
              newRideGoogleMapController = controller;

              setState(() {
                mapPadding = 265.0;
              });

              //driver
              var currentLatLing =
                  LatLng(currentPosition.latitude, currentPosition.longitude);
              //ride
              var pickUpLatLing = widget.rideDetails.pickUp;

              await getPlaceDirection(currentLatLing, pickUpLatLing);

              getRideLocationLiveUpdate();
            },
          ),
          Positioned(
            right: 0.0,
            left: 0.0,
            bottom: 0.0,
            child: Container(
              height: 270.0,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(16.0),
                      topLeft: Radius.circular(16.0)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black54,
                        blurRadius: 16.0,
                        spreadRadius: 0.5,
                        offset: Offset(0.7, 0.7))
                  ]),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      durationRide,
                      style: TextStyle(color: Colors.black, fontSize: 14.0),
                    ),
                    SizedBox(
                      height: 12.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("${widget.rideDetails.riderName}".toString()),
                        Padding(
                          padding: EdgeInsets.only(right: 10.0),
                        ),
                        Icon(Icons.phone, color: Colors.black),
                      ],
                    ),
                    SizedBox(
                      height: 12.0,
                    ),
                    Row(
                      children: [
                        Icon(Icons.add_location, color: Colors.redAccent[700]),
                        Expanded(
                            child: Container(
                                child: Text(
                          " from : ${widget.rideDetails.pickUpName}".toString(),
                          overflow: TextOverflow.ellipsis,
                        ))),
                      ],
                    ),
                    SizedBox(
                      height: 12.0,
                    ),
                    Row(
                      children: [
                        Icon(Icons.add_location, color: Colors.redAccent[700]),
                        Expanded(
                            child: Container(
                                child: Text(
                          "to :  ${widget.rideDetails.dropOffName}".toString(),
                          overflow: TextOverflow.ellipsis,
                        ))),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: RaisedButton(
                        onPressed: () async {
                          if (status == 'accepted') {
                            status = 'arrived';
                            String rideRequestId =
                                widget.rideDetails.ride_request_id;
                            newrideRequest
                                .child(rideRequestId)
                                .child('status')
                                .set(status);
                            setState(() {
                              btnTitle = 'Start trip';
                              btnColor = Colors.yellowAccent;
                            });
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) =>
                                    ProgssesDailgo(
                                      message: 'Please wait...',
                                    ));
                            await getPlaceDirection(widget.rideDetails.pickUp,
                                widget.rideDetails.dropOff);
                            Navigator.pop(context);
                          } else if (status == 'arrived') {
                            status = 'onRide';
                            String rideRequestId =
                                widget.rideDetails.ride_request_id;
                            newrideRequest
                                .child(rideRequestId)
                                .child('status')
                                .set(status);
                            setState(() {
                              btnTitle = 'End trip';
                              btnColor = Colors.redAccent[700];
                            });
                            initTimer();
                          } else if (status == 'onRide') {
                            endTheTrip();
                          }
                        },
                        color: btnColor,
                        padding: EdgeInsets.all(17.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              btnTitle,
                              style: TextStyle(
                                  color: Colors.black, fontSize: 20.0),
                            ),
                            Icon(
                              Icons.directions_car,
                              color: Colors.black,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

//driver
  void loctedPostion() async {
    LatLng latLngPosition =
        LatLng(currentPosition.latitude, currentPosition.longitude);
    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 14.0);
    newRideGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    // String address =
    // await AssistantMethod.searchCoordinateAddress(position, context);
    // print(address);
  }

  // this method for polyline and direction
  Future<void> getPlaceDirection(LatLng pickUpLating, LatLng dropOffLating) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return ProgssesDailgo(
            message: "Please wait",
          );
        });
    var details = await AssistantMethod.obtainPlaceDirctionDiatels(
        pickUpLating, dropOffLating);

    Navigator.pop(context);
    print("getPlaceDirection::");
    print(details.encodedPoints);
    // for line on mape
    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> pointLatLngResult =
        polylinePoints.decodePolyline(details.encodedPoints);
    polylineCorOrdinates.clear();
    if (pointLatLngResult.isNotEmpty) {
      pointLatLngResult.forEach((PointLatLng pointLatLng) {
        polylineCorOrdinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }
    polylineSet.clear();
    setState(() {
      Polyline polyline = Polyline(
        color: Colors.red,
        polylineId: PolylineId("polylineId"),
        points: polylineCorOrdinates,
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );
      polylineSet.add(polyline);
      // control by site for both pickup and dropdown
      LatLngBounds latLngBounds;
      if (pickUpLating.latitude > dropOffLating.latitude &&
          pickUpLating.longitude > dropOffLating.longitude) {
        latLngBounds =
            LatLngBounds(southwest: dropOffLating, northeast: pickUpLating);
      } else if (pickUpLating.latitude > dropOffLating.latitude) {
        latLngBounds = LatLngBounds(
          southwest: LatLng(dropOffLating.latitude, pickUpLating.longitude),
          northeast: LatLng(pickUpLating.latitude, dropOffLating.longitude),
        );
      } else if (pickUpLating.longitude > dropOffLating.longitude) {
        latLngBounds = LatLngBounds(
          southwest: LatLng(pickUpLating.latitude, dropOffLating.longitude),
          northeast: LatLng(dropOffLating.latitude, pickUpLating.longitude),
        );
      } else {
        latLngBounds =
            LatLngBounds(southwest: pickUpLating, northeast: dropOffLating);
      }
      newRideGoogleMapController
          .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));
    });
    Marker pickUpLocationMarker = Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
        position: pickUpLating,
        markerId: MarkerId("PickUpId"));
    Marker dropOffLocationMarker = Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        position: dropOffLating,
        markerId: MarkerId("DropOffId"));
    setState(() {
      markerSet.add(pickUpLocationMarker);
      markerSet.add(dropOffLocationMarker);
    });
    Circle pickUpCircle = Circle(
        fillColor: Colors.blueAccent,
        center: pickUpLating,
        radius: 12,
        strokeWidth: 4,
        strokeColor: Colors.blue,
        circleId: CircleId("PickUpId"));
    Circle droOffCircle = Circle(
        fillColor: Colors.redAccent,
        center: dropOffLating,
        radius: 12,
        strokeWidth: 4,
        strokeColor: Colors.red,
        circleId: CircleId("DropOffId"));
    setState(() {
      circleSet.add(pickUpCircle);
      circleSet.add(droOffCircle);
    });
  }

  // this method for disPlay driver info to rider auto when driver accpeted
  void accptedRideRequest() {
    String rideRequestId = widget.rideDetails.ride_request_id;
    newrideRequest.child(rideRequestId).child("status").set("accepted");
    newrideRequest
        .child(rideRequestId)
        .child("driver_name")
        .set(driversInfo.name);
    newrideRequest
        .child(rideRequestId)
        .child("driver_phone")
        .set(driversInfo.phone);
    newrideRequest.child(rideRequestId).child("driver_id").set(driversInfo.id);
    newrideRequest
        .child(rideRequestId)
        .child("carInfo")
        .set('${driversInfo.car} - ${driversInfo.color}');
    Map locMap = {
      "latitude": currentPosition.latitude.toString(),
      "longitude": currentPosition.longitude.toString(),
    };
    newrideRequest.child(rideRequestId).child("driver_location").set(locMap);
    driversRef.child(currentFirebaseUser.uid).child('history').child(rideRequestId).set(true);
  }

  // method for listing to update live driver includ trip details
  void getRideLocationLiveUpdate() {
    LatLng oldPos = LatLng(0, 0);
    // driver
    rideStreamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      currentPosition = position;
      myPosition = position;
      LatLng mPostion = LatLng(position.latitude, position.longitude);

      // using map_toolKit for update location from point to another when driver move
      var rot = MapKitAssistant.getMarkerLocation(oldPos.latitude,
          oldPos.longitude, mPostion.latitude, mPostion.longitude);
//*****************************************************************************
      //driver
      Marker animatingMarker = Marker(
          markerId: MarkerId("animating"),
          position: mPostion, //driver
          rotation: rot,
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
          infoWindow: InfoWindow(title: "currentLoction"));
      setState(() {
        CameraPosition cameraPosition =
            new CameraPosition(target: mPostion, zoom: 17);
        newRideGoogleMapController
            .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

        markerSet.removeWhere((marker) => marker.markerId.value == "animating");
        markerSet.add(animatingMarker);
      });
      //****************************************
      oldPos = mPostion; //driver
      updateRideDetails(); //rider
      // for update live driverLocation to newrideRequest collection
      String rideRequestId = widget.rideDetails.ride_request_id;
      Map locMap = {
        'latitude': currentPosition.latitude.toString(),
        'longitude': currentPosition.longitude.toString(),
      };
      newrideRequest.child(rideRequestId).child('driver_location').set(locMap);
    });
  }

  // this method id driver status accpeted will see dirction driver to pickup rider else it is mean will see dirction from pickUp rider to dropOff rider
  void updateRideDetails() async {
    if (isRequestingDirection == false) {
      isRequestingDirection = true;
      if (myPosition == null) {
        return;
      }
      //driver
      var posLatLng = LatLng(myPosition.latitude, myPosition.longitude);
      //rider
      LatLng destinationLatLng;
      if (status == 'accepted') {
        destinationLatLng = widget.rideDetails.pickUp;
      } else {
        destinationLatLng = widget.rideDetails.dropOff;
      }
      var directionDetails = await AssistantMethod.obtainPlaceDirctionDiatels(
          posLatLng, destinationLatLng);
      if (directionDetails != null) {
        setState(() {
          durationRide = directionDetails.durationText;
        });
      }
      isRequestingDirection = false;
    }
  }

  // this method for count time trip
  void initTimer() {
    const interval = Duration(seconds: 1);
    timer = Timer.periodic(interval, (timer) {
      durationCounter = durationCounter + 1;
    });
  }
// for end trip and save earn
  endTheTrip() async {
    timer.cancel();

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => ProgssesDailgo(
              message: 'Please wait...',
            ));

    var currentLatlng = LatLng(myPosition.latitude, myPosition.longitude);
    var directionalDetails = await AssistantMethod.obtainPlaceDirctionDiatels(
        widget.rideDetails.pickUp, currentLatlng);
    Navigator.pop(context);
    int fareAmount = AssistantMethod.calcuttaFares(directionalDetails);

    String rideRequestId = widget.rideDetails.ride_request_id;
    newrideRequest
        .child(rideRequestId)
        .child('fares')
        .set(fareAmount.toString());
    newrideRequest.child(rideRequestId).child('status').set('ended');
    rideStreamSubscription.cancel();

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => CollectFareDialog(
              paymentMethod: widget.rideDetails.payment_method,
              fareAmount: fareAmount,
            ));
    saveEarnings(fareAmount);
  }

// this method for save money all totle
  void saveEarnings(int fareAmount) {
    //get old money what driver earning till last trip
    driversRef
        .child(currentFirebaseUser.uid)
        .child('earnings')
        .once()
        .then((DataSnapshot dataSnapShot) {
      if (dataSnapShot.value != null) {
        double oldEarning = double.parse(dataSnapShot.value.toString());
        //count old earning with last trip earn
        double totalEarning = fareAmount + oldEarning;
        driversRef
            .child(currentFirebaseUser.uid)
            .child('earnings')
            .set(totalEarning.toStringAsFixed(2));
      } else {
        // if no found old just set new earn
        double totalEarning = fareAmount.toDouble();
        driversRef
            .child(currentFirebaseUser.uid)
            .child('earnings')
            .set(totalEarning.toStringAsFixed(2));
      }
    });
  }
}
