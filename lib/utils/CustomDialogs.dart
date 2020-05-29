import 'package:flutter/material.dart';

class CustomDialogs {
  static void loadingDialog({
    @required BuildContext context,
    @required String message,
    @required bool dismissible,
  }) {
    showDialog(
        context: context,
        barrierDismissible: dismissible,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Row(
              children: <Widget>[
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                ),
                SizedBox(width: 30.0),
                Text(
                  message,
                  style: TextStyle(fontSize: 16.0),
                )
              ],
            ),
          );
        });
  }

  static void alertDialog1({
    @required BuildContext context,
    @required String message,
    @required bool dismissible,
  }) {
    showDialog(
        context: context,
        barrierDismissible: dismissible,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(
              message,
              style: TextStyle(fontSize: 16.0),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        });
  }
}
