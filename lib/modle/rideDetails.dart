// in this class will save data from collection:riderRequest
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RideDetails {
  String ride_request_id;
  String riderName;
  String riderPhone;
  String payment_method;
  String dropOffName;
  String pickUpName;
  LatLng dropOff;
  LatLng pickUp;
  RideDetails(
      {this.ride_request_id,
      this.riderPhone,
      this.riderName,
      this.pickUpName,
      this.pickUp,
      this.dropOffName,
      this.dropOff,
      this.payment_method});
}
