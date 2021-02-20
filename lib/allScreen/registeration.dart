import 'package:driverhop/allScreen/carInfo.dart';
import 'package:driverhop/allScreen/logingScreen.dart';
import 'package:driverhop/configMap.dart';
import 'package:driverhop/widget/progssesDailgo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';




class RegistrationScreen extends StatelessWidget {
  RegistrationScreen({Key key}) : super(key: key);
  static const String screenId = 'RegistrationScreen';
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passWordTextEditingController = TextEditingController();
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
              'Register as Driver',
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
                    controller: nameTextEditingController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      labelStyle: TextStyle(fontSize: 14.0),
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 10.0),
                    ),
                    style: TextStyle(fontSize: 14.0),
                  ),
                  SizedBox(
                    height: 2.0,
                  ),
                  TextField(
                    controller: emailTextEditingController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(fontSize: 14.0),
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 10.0),
                    ),
                    style: TextStyle(fontSize: 14.0),
                  ),
                  SizedBox(
                    height: 2.0,
                  ),
                  TextField(
                    controller: phoneTextEditingController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Phone',
                      labelStyle: TextStyle(fontSize: 14.0),
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 10.0),
                    ),
                    style: TextStyle(fontSize: 14.0),
                  ),
                  SizedBox(
                    height: 2.0,
                  ),
                  TextField(
                    controller: passWordTextEditingController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'PassWord',
                      labelStyle: TextStyle(fontSize: 14.0),
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 10.0),
                    ),
                    style: TextStyle(fontSize: 14.0),
                  ),
                  SizedBox(
                    height: 9.0,
                  ),
                  RaisedButton(
                    color: Colors.black,
                    textColor: Colors.yellowAccent,
                    child: Container(
                        child: Text(
                      'Register',
                      style: TextStyle(fontSize: 18.0),
                    )),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0)),
                    onPressed: () {
                      checkInfo(context);
                    },
                  ),
                  SizedBox(
                    height: 2.0,
                  ),
                  FlatButton(
                    onPressed: () => Navigator.pushNamedAndRemoveUntil(
                        context, LoginScreen.screenId, (route) => false),
                    child: Text(
                      'Already  have an account ? Login here',
                      style: TextStyle(fontSize: 18.0, color: Colors.black),
                    ),
                  )
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
    if (nameTextEditingController.text.length < 3) {
      displayTostMessage('Name should be more from 3 letters', context);
    } else if (!emailTextEditingController.text.contains('@')) {
      displayTostMessage('Check your email address', context);
    } else if (phoneTextEditingController.text.isEmpty) {
      displayTostMessage('phone number is required', context);
    } else if (passWordTextEditingController.text.length < 6) {
      displayTostMessage('PassWord should be more from 5 characters', context);
    } else {
      regeisterNewUser(context);
    }
  }
// this method for auth and set to database real time
  void regeisterNewUser(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
      builder: (context){
          return ProgssesDailgo(message: 'Loading...');
      }
    );
    final User firebaseUser = (await _firebaseAuth
            .createUserWithEmailAndPassword(
                email: emailTextEditingController.text,
                password: passWordTextEditingController.text)
            .catchError((ex) {
      Navigator.pop(context);
      displayTostMessage('Error:' + ex.toString(), context);
    })).user;
    if (firebaseUser != null) {
      Map driverDataMap = {
        'name': nameTextEditingController.text.trim(),
        'email': emailTextEditingController.text.trim(),
        'phone': phoneTextEditingController.text.trim(),
      };
      FirebaseDatabase.instance
          .reference()
          .child('drivers')
          .child(firebaseUser.uid)
          .set(driverDataMap);
      currentFirebaseUser = firebaseUser;
      displayTostMessage('Welcome', context);
      Navigator.pushNamed(
          context, CarInfo.screenId);
    } else {
      Navigator.pop(context);
      displayTostMessage('some thing went wrong try again', context);
    }
  }

  displayTostMessage(String message, BuildContext context) {
    Fluttertoast.showToast(msg: message);
  }
}
