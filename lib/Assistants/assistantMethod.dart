//this class for got current position from geolocatre and use with json jecoding
import 'package:driverhop/Assistants/requestAssistant.dart';
import 'package:driverhop/configMap.dart';
import 'package:driverhop/modle/address.dart';
import 'package:driverhop/modle/allUsers.dart';
import 'package:driverhop/modle/directionDetails.dart';
import 'package:driverhop/provider/appData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

// for insta auth and start get current user
User firebaseUser;
Users userCurrentInfo;

class AssistantMethod {
  // this method for got current location for user
  static Future<String> searchCoordinateAddress(
      Position position, BuildContext context) async {
    String placeAddress = '';
    String st1, st2, st3, st4;
    String url = // first we puted data from position in url response
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey';
    var response = await RequestAssistant.getRequest(
        url); //call from RequestAssistant class
    if (response != 'failed') {
      // placeAddress = response["results"][0]["formatted_address"];
      // use jeson
      st1 = response["results"][0]["address_components"][3]["long_name"];
      st2 = response["results"][0]["address_components"][4]["long_name"];
      st3 = response["results"][0]["address_components"][1]["long_name"];
      st4 = response["results"][0]["address_components"][6]["long_name"];
      placeAddress = '${st1 + "," + st2 + "," + st3 + "," + st4}';
      Address pickUpUserAddress = Address();
      pickUpUserAddress.longitude = position.longitude;
      pickUpUserAddress.latitude = position.latitude;
      pickUpUserAddress.placeName = placeAddress;
      // now we will update to provider class (AppData)
      Provider.of<AppData>(context, listen: false)
          .updatePickUpLocation(pickUpUserAddress);
    }
    return placeAddress; // address ready for use in google map
  }

  // this method for got current + drop off location by (Direction Api) .First step for starting drawing line between two address
  static Future<DirectionDetails> obtainPlaceDirctionDiatels(
      LatLng initialPosition, LatLng finalPosition) async {
    String dirtionUrl =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${initialPosition.latitude},${initialPosition.longitude}&destination=${finalPosition.latitude},${finalPosition.longitude} &key=$mapKey";
    var res = await RequestAssistant.getRequest(dirtionUrl);

    if (res == "failed") {
      return null;
    }

    DirectionDetails directionDetails = DirectionDetails();
    directionDetails.encodedPoints =
        res["routes"][0]["overview_polyline"]["points"];
    directionDetails.distanceText =
        res["routes"][0]["legs"][0]["distance"]["text"];
    directionDetails.distanceValue =
        res["routes"][0]["legs"][0]["distance"]["value"];
    directionDetails.durationText =
        res["routes"][0]["legs"][0]["duration"]["text"];
    directionDetails.durationValue =
        res["routes"][0]["legs"][0]["duration"]["value"];

    return directionDetails;
  }

  // this method for calcutta money for trip by use time and distance
  static int calcuttaFares(DirectionDetails directionDetails) {
    double timeTravelFare = (directionDetails.durationValue / 60) * 0.20;
    double distanceTravelFare = (directionDetails.distanceValue / 1000) * 0.20;
    double totalFareAmount = timeTravelFare + distanceTravelFare;
    return totalFareAmount.truncate();
  }

// this method for got current user id after finish login for set user id
  static void getCurrentonlineUserInfo(BuildContext context) async {
    firebaseUser = await FirebaseAuth.instance.currentUser;
    String userId = firebaseUser.uid;
    DatabaseReference reference =
        FirebaseDatabase.instance.reference().child("users").child(userId);

    // after set current user id now we can got info user
        reference.once().then((DataSnapshot dataSnapshot){
          if(dataSnapshot.value!=null){
           userCurrentInfo = Users.fromDataSnapshot(dataSnapshot);
          }

        });

  }
}
