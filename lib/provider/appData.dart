// this class for listing to chancing data gecoding in Assistants method
import 'package:driverhop/modle/address.dart';
import 'package:flutter/cupertino.dart';

class AppData extends ChangeNotifier {
  Address pickUpLocation, dropOffLocation;

  void updatePickUpLocation(Address pickUPAddress) {
    pickUpLocation = pickUPAddress;
    notifyListeners();
  }

  void updateDropOffLocation(Address dropOffAddress) {
    dropOffLocation = dropOffAddress;
    notifyListeners();
  }
}
