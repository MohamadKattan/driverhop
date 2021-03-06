import 'dart:io' show Platform;
import 'package:driverhop/configMap.dart';
import 'package:driverhop/main.dart';
import 'package:driverhop/modle/rideDetails.dart';
import 'package:driverhop/notifications/notificationDailog.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PushNotifications {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
// this mehtod for intalize firebase messaging
  Future initialize(context) async {
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        retrievRideRequestInfo(getRideRequestId(message), context);
      },
      onLaunch: (Map<String, dynamic> message) async {
        retrievRideRequestInfo(getRideRequestId(message), context);
      },
      onResume: (Map<String, dynamic> message) async {
        retrievRideRequestInfo(getRideRequestId(message), context);
      },
    );
  }

// this method for got token driver and set in collection driver
  Future<String> getToken() async {
    String token = await firebaseMessaging.getToken();
    print("this is token ::");
    print(token);

    driversRef.child(currentFirebaseUser.uid).child('token').set(token);
    firebaseMessaging.subscribeToTopic("alldrivers");
    firebaseMessaging.subscribeToTopic("alldusers");
  }

  // this method for got ride request id  from data base collection:riderRequest
  String getRideRequestId(Map<String, dynamic> message) {
    String rideRequestId = '';
    if (Platform.isAndroid) {
      print('this is your ridRequstId:::::::::::::::::::::');
      rideRequestId = message['data']['ride_request_id'];
      print(rideRequestId);
    } else {
      rideRequestId = message['ride_request_id'];
    }
    return rideRequestId;
  }

  // this method after got id rider will receive data from collection:riderRequest
  void retrievRideRequestInfo(String rideRequestId, BuildContext context) {
    // for inclod voice with nonfiction
    // assetsAudioPlayer.open(
    //   Audio("sounds/Alarm-Fast-A1-www.fesliyanstudios.com.mp3"),
    // );
    // assetsAudioPlayer.play();
    // first recive data from collection :riderRequest
    newrideRequest
        .child(rideRequestId)
        .once()
        .then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value != null) {
        double pickUpLat =
            double.parse(dataSnapshot.value["pickUpLat"].toString());
        double pickUpLon =
            double.parse(dataSnapshot.value["pickUpLon"].toString());
        String pickUpName = dataSnapshot.value["pickUpName"].toString();
        double dropOffLat =
            double.parse(dataSnapshot.value["dropOffLat"].toString());
        double dropOfflon =
            double.parse(dataSnapshot.value["dropOffLon"].toString());
        String dropOffName = dataSnapshot.value["dropOffName"].toString();
        String payment_method = dataSnapshot.value["payment_method"].toString();
        String riderName = dataSnapshot.value['riderName'];
        String riderPhone = dataSnapshot.value['riderPhone'];

        // initialize model
        RideDetails rideDetails = RideDetails();
        // save data in model
        rideDetails.payment_method = payment_method;
        rideDetails.dropOff = LatLng(dropOffLat, dropOfflon);
        rideDetails.pickUp = LatLng(pickUpLat, pickUpLon);
        rideDetails.ride_request_id = rideRequestId;
        rideDetails.dropOffName = dropOffName;
        rideDetails.pickUpName = pickUpName;
        rideDetails.riderName = riderName;
        rideDetails.riderPhone = riderPhone;
        print("this is information ::");
        print(rideDetails.pickUpName);
        print(rideDetails.dropOffName);
        // after save data will show to driver NotificationDailog for accept or not
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) =>
                NotificationDailog(rideDetails: rideDetails));
      }
    });
  }
}
