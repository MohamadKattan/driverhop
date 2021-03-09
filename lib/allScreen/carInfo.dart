import 'package:driverhop/allScreen/mainScreen.dart';
import 'package:driverhop/allScreen/registeration.dart';
import 'package:driverhop/configMap.dart';
import 'package:driverhop/main.dart';
import 'package:driverhop/modle/allUsers.dart';
import 'package:driverhop/widget/progssesDailgo.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Users driverCurrentInfo;

class CarInfo extends StatelessWidget {
  static String screenId = "CarInfo";
  CarInfo({Key key}) : super(key: key);
  TextEditingController carModleController = TextEditingController();
  TextEditingController carNoController = TextEditingController();
  TextEditingController carColorController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 15.0,
            ),
            Image(
              image: AssetImage('images/logoLogIn.png'),
              height: 250.0,
              width: 250.0,
              alignment: Alignment.center,
            ),
            SizedBox(
              height: 9.0,
            ),
            Text(
              'Driver car info',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 5.0,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    controller: carModleController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'Car model',
                      labelStyle: TextStyle(fontSize: 14.0),
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 10.0),
                    ),
                    style: TextStyle(fontSize: 14.0),
                  ),
                  SizedBox(
                    height: 2.0,
                  ),
                  TextField(
                    controller: carColorController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Car Color',
                      labelStyle: TextStyle(fontSize: 14.0),
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 10.0),
                    ),
                    style: TextStyle(fontSize: 14.0),
                  ),
                  SizedBox(
                    height: 2.0,
                  ),
                  TextField(
                    controller: carNoController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Car number',
                      labelStyle: TextStyle(fontSize: 14.0),
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 10.0),
                    ),
                    style: TextStyle(fontSize: 14.0),
                  ),
                  SizedBox(
                    height: 2.0,
                  ),
                  SizedBox(
                    height: 9.0,
                  ),
                  RaisedButton(
                    color: Colors.black,
                    textColor: Colors.yellowAccent,
                    child: Container(
                        child: Text(
                      'Continue register',
                      style: TextStyle(fontSize: 18.0),
                    )),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0)),
                    onPressed: () {
                      checkInfo(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // this method for check Info if not emptey befor start auth and set
  void checkInfo(BuildContext context) {
    if (carModleController.text.length < 3) {
      displayTostMessage('Name should be more from 3 letters', context);
    } else if (carColorController.text.isEmpty) {
      displayTostMessage('Color Car shouldn\'t be empty', context);
    } else if (carNoController.text.isEmpty) {
      displayTostMessage('car number is required', context);
    } else {
      saveCarInfo(context);
    }
  }

// this method for auth and set to database real time
  void saveCarInfo(BuildContext context) async {
    String userId = currentFirebaseUser.uid;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return ProgssesDailgo(message: 'Loading...');
        });

    if (userId != null) {
      Map carInfoDataMap = {
        'car': carModleController.text.trim(),
        'color': carColorController.text.trim(),
        'number': carNoController.text.trim(),
      };
      FirebaseDatabase.instance
          .reference()
          .child("drivers")
          .child(userId)
          .child("carInfo")
          .set(carInfoDataMap);
      displayTostMessage('Welcome', context);
      Navigator.push(context,  MaterialPageRoute(builder: (context)=>MainScreen()));
    } else {
      Navigator.pop(context);
      displayTostMessage('some thing went wrong try again', context);
    }
  }

  displayTostMessage(String message, BuildContext context) {
    Fluttertoast.showToast(msg: message);
  }
}
