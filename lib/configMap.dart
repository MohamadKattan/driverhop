import 'dart:async';
import 'package:driverhop/modle/driver.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';

String mapKey = 'AIzaSyAMEfNY_DfMea_xBnCLhHWXYR8efpbe0eE';

User currentFirebaseUser; // for  get current user from (User firebaseUser;)

User firebaseUser;

// will use in method for listing to update live driver Position in void getLocationLiveUpdate()
StreamSubscription<Position> homeTabPageStreamSubscription;
// will use in method for listing to update live ride Position in void getLocationLiveUpdate()
StreamSubscription<Position> rideStreamSubscription;
// drivers model
Drivers driversInfo;

Position currentPosition;

// final assetsAudioPlayer = AssetsAudioPlayer();