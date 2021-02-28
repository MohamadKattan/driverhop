import 'package:driverhop/configMap.dart';
import 'package:driverhop/main.dart';
import 'package:driverhop/modle/rideDetails.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NotificationDailog extends StatelessWidget {
  final RideDetails rideDetails;
  NotificationDailog({this.rideDetails});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      backgroundColor: Colors.transparent,
      elevation: 1.0,
      child: Container(
        margin: EdgeInsets.all(5.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          SizedBox(
            height: 20,
          ),
          Icon(
            Icons.campaign_rounded,
            size: 40,
            color: Colors.redAccent[700],
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "New request ride found",
            style: TextStyle(fontSize: 18.0),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
              padding: EdgeInsets.all(10),
              child: Column(children: [
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Icon(
                    Icons.add_location_sharp,
                    color: Colors.redAccent[700],
                    size: 25.0,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Container(
                      child: Text(
                        rideDetails.pickUpName,
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                  )
                ]),
                SizedBox(
                  height: 15,
                ),
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Icon(
                    Icons.add_location_sharp,
                    color: Colors.redAccent[700],
                    size: 25.0,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Container(
                      child: Text(
                        rideDetails.dropOffName,
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                  )
                ]),
                Divider(),
                SizedBox(
                  height: 8.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FlatButton(
                      onPressed: () {
                        assetsAudioPlayer.stop();
                        Navigator.pop(context);
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.redAccent[700]),
                      ),
                      color: Colors.white,
                      textColor: Colors.redAccent[700],
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Cancel",
                        style: TextStyle(fontSize: 14.0),
                      ),
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    FlatButton(
                      onPressed: () {
                        assetsAudioPlayer.stop();
                        availabletyOfRider(context);
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.green[700]),
                      ),
                      color: Colors.white,
                      textColor: Colors.green[700],
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Accept",
                        style: TextStyle(fontSize: 14.0),
                      ),
                    ),
                  ],
                ),
              ])),
        ]),
      ),
    );
  }

  // this method to know if any driver accepted rifer request or still waiting
  void availabletyOfRider(context) {
    rideRequest.once().then((DataSnapshot dataSnapshot) {
      Navigator.pop(context);
      String theRideId = "";
      if (dataSnapshot.value != null) {
        // ignore: unnecessary_statements
        theRideId == dataSnapshot.value.toString();
      } else {
        displayTostMessage("rider not exist", context);
      }
      if (theRideId == rideDetails.ride_request_id) {
        rideRequest.set("accepted");
      } else if (theRideId == "cancelled") {
        displayTostMessage("rider has canceled", context);
      } else if (theRideId == "timeout") {
        displayTostMessage("rider has timeOut", context);
      } else {
        displayTostMessage("rider not exist", context);
      }
    });
  }

  displayTostMessage(String message, BuildContext context) {
    Fluttertoast.showToast(msg: message);
  }
}
