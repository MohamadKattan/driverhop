import 'package:driverhop/allScreen/mainScreen.dart';
import 'package:driverhop/allScreen/registeration.dart';
import 'package:driverhop/configMap.dart';
import 'package:driverhop/widget/progssesDailgo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
class LoginScreen extends StatelessWidget {
  static const String screenId = 'LoginScreen';
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passWordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 40.0,
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
              'Login as Driver',
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
                    height:10,
                  ),
                  RaisedButton(
                    color: Colors.black,
                    textColor: Colors.yellowAccent,
                    child: Container(
                        child: Text(
                      'Login',
                      style: TextStyle(fontSize: 18.0),
                    )),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0)),
                    onPressed: () {
                      loginUser(context);
                    },
                  ),
                  SizedBox(
                    height: 2.0,
                  ),
                  FlatButton(
                    onPressed: () => Navigator.pushNamedAndRemoveUntil(
                        context, RegistrationScreen.screenId, (route) => false),
                    child: Text(
                      'Don\'t have an account ? Register here',
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
    if (!emailTextEditingController.text.contains('@')) {
      displayTostMessage('Check your email address', context);
    } else if (passWordTextEditingController.text.isEmpty) {
      displayTostMessage('PassWord should be not empty', context);
    } else {
      loginUser(context);
    }
  }

// for login
  void loginUser(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          return ProgssesDailgo(message: 'Loading...');
        }
    );
    final User firebaseUser = (await _firebaseAuth
            .signInWithEmailAndPassword(
                email: emailTextEditingController.text,
                password: passWordTextEditingController.text)
            .catchError((ex) {
      Navigator.pop(context);
      displayTostMessage('Error:' + ex.toString(), context);
    }))
        .user;
    if (firebaseUser != null) {
      FirebaseDatabase.instance
          .reference()
          .child('drivers')
          .child(firebaseUser.uid)
          .once()
          .then((DataSnapshot snapshot) {
        if (snapshot.value != null) {
          currentFirebaseUser=firebaseUser;
          displayTostMessage('Welcome', context);
          Navigator.pushNamedAndRemoveUntil(
              context, MainScreen.screenId, (route) => false);
        } else {
          _firebaseAuth.signOut();
          Navigator.pop(context);
          displayTostMessage('No record , please create new account', context);
        }
      });
    } else {
      displayTostMessage('some thing went wrong try again', context);
      Navigator.pop(context);
    }
  }

  displayTostMessage(String message, BuildContext context) {
    Fluttertoast.showToast(msg: message);
  }
}
