import 'package:driverhop/configMap.dart';
import 'package:driverhop/modle/rideDetails.dart';
import 'package:flutter/material.dart';

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
                  Expanded  (
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
}
