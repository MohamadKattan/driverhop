import 'package:driverhop/Assistants/requestAssistant.dart';
import 'package:driverhop/configMap.dart';
import 'package:driverhop/modle/directionDetails.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AssistantMethod {
// this method will use here for direction bettwen driver and rider
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

  // this method for make driver busy after accepted request from rider
  static void disableHomeTabLiveLocatUpdate() {
    homeTabPageStreamSubscription.pause();
    Geofire.removeLocation(currentFirebaseUser.uid);
  }

  // this method for reBack driver available after finish
  static void enableHomeTabLiveLocatUpdate() {
    homeTabPageStreamSubscription.resume();
    Geofire.setLocation(currentFirebaseUser.uid, currentPosition.latitude,
        currentPosition.longitude);
  }
}
