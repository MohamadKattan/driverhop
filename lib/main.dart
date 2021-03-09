import 'package:driverhop/allScreen/carInfo.dart';
import 'package:driverhop/allScreen/logingScreen.dart';
import 'package:driverhop/allScreen/mainScreen.dart';
import 'package:driverhop/allScreen/registeration.dart';
import 'package:driverhop/allScreen/searchScreen.dart';
import 'package:driverhop/configMap.dart';
import 'package:driverhop/provider/appData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  currentFirebaseUser =  FirebaseAuth.instance.currentUser;
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(MyApp());
  });
}
// this rideRequest will use for driver want to be on line for get his geoFire
DatabaseReference rideRequest = FirebaseDatabase.instance.reference().child("drivers").child(currentFirebaseUser.uid).child("newride");
// this driversRef for the main drivers collection
DatabaseReference driversRef = FirebaseDatabase.instance.reference().child("drivers");
// this newrideRequest for the rideRequest info collection
DatabaseReference newrideRequest = FirebaseDatabase.instance.reference().child("riderRequest");


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'driverHop',
        initialRoute:LoginScreen.screenId,
         // FirebaseAuth.instance.currentUser == null? LoginScreen.screenId:MainScreen.screenId,
        routes: {
          RegistrationScreen.screenId: (context) => RegistrationScreen(),
          MainScreen.screenId: (context) => MainScreen(),
          LoginScreen.screenId: (context) => LoginScreen(),
          SearchScreen.screenId: (context) => SearchScreen(),
          CarInfo.screenId: (context) => CarInfo(),
        },
      ),
    );
  }
}
