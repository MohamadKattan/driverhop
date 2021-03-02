// class after driver accepted ride request will puch to this screen
import 'dart:async';
import 'package:driverhop/Assistants/assistantMethod.dart';
import 'package:driverhop/configMap.dart';
import 'package:driverhop/main.dart';
import 'package:driverhop/modle/rideDetails.dart';
import 'package:driverhop/widget/progssesDailgo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NewRideScreen extends StatefulWidget {
  final RideDetails rideDetails;
  NewRideScreen({this.rideDetails});

  @override
  _NewRideScreenState createState() => _NewRideScreenState();
}

class _NewRideScreenState extends State<NewRideScreen> {
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController
      newRideGoogleMapController; // when rider want a driver for change map

  static final CameraPosition _kGooglePlex = CameraPosition(
      target: LatLng(37.42796133580664, -122.085749655962), zoom: 14.4746);

  Position currentPosition;
  var geolocator = Geolocator();
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
            initialCameraPosition: _kGooglePlex,
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
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "10 min",
                      style: TextStyle(color: Colors.black, fontSize: 14.0),
                    ),
                    SizedBox(
                      height: 6.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Mohamad"),
                        Padding(
                          padding: EdgeInsets.only(right: 10.0),
                        ),
                        Icon(Icons.phone, color: Colors.black),
                      ],
                    ),
                    SizedBox(
                      height: 6.0,
                    ),
                    Row(
                      children: [
                        Icon(Icons.add_location, color: Colors.redAccent[700]),
                        Expanded(
                            child: Container(
                                child: Text(
                          "Street PickUp",
                          overflow: TextOverflow.ellipsis,
                        ))),
                      ],
                    ),
                    SizedBox(
                      height: 6.0,
                    ),
                    Row(
                      children: [
                        Icon(Icons.add_location, color: Colors.redAccent[700]),
                        Expanded(
                            child: Container(
                                child: Text(
                          "Street DROPoFF",
                          overflow: TextOverflow.ellipsis,
                        ))),
                      ],
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: RaisedButton(
                        onPressed: () {},
                        color: Colors.yellowAccent[700],
                        padding: EdgeInsets.all(17.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Arrived",
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

  // this method for got current + drop off location by (Direction Api) . step 2 for starting drawing line between two address
  Future<void> getPlaceDirection(
      LatLng pickUpLating, LatLng dropOffLating) async {
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
        polylineId: PolylineId("polylineId"),
        color: Colors.red,
        points: polylineCorOrdinates,
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );
      polylineSet.add(polyline);
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

  // this method for disPlay driver info to rider
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
        .set("${driversInfo.car} - ${driversInfo.color}");
    Map locMap = {
      "latitude": currentPosition.latitude.toString(),
      "longitude": currentPosition.longitude.toString(),
    };
    newrideRequest.child(rideRequestId).child("driver_location").set(locMap);
  }

  // method for listing to update live ride Position
  void getRideLocationLiveUpdate() {
    rideStreamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      currentPosition = position;
      myPosition = position;
      LatLng mPostion = LatLng(position.latitude, position.longitude);
      Marker animatingMarker = Marker(
          markerId: MarkerId("animating"),
          position: mPostion,
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
    });
  }
}