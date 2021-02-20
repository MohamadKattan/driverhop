import 'package:flutter/material.dart';

class ProgssesDailgo extends StatelessWidget {
  String message;
  ProgssesDailgo({this.message});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.2,
      child: Container(
        color: Colors.black,
        width: MediaQuery.of(context).size.width,
        child: Dialog(
            backgroundColor: Colors.black,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.yellowAccent)),
                SizedBox(height: 5),
                Text(message,
                    style: TextStyle(color: Colors.white, fontSize: 20))
              ],
            )),
      ),
    );
  }
}
