import 'package:flutter/material.dart';

import 'Appcolor.dart';

class Utilityclass{
  static showInternetDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.symmetric(horizontal: 5),
          title: Container(
              width: MediaQuery.of(context).size.width,
              height: 40,
              child: const Text(
                '⚠ No Internet Connection',
                style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'OpenSans',
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              )),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Center(
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                          'You need to have mobile data or wifi to access this. '),
                    )),
              ],
            ),
          ),
          actions: <Widget>[
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Appcolor.COLOR_PRIMARY,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5))),
                child: Container(

                    width: 100,
                    child: const Center(child: Text('Close'))),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }
}