import 'package:flutter/material.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsocietyadvertisement/Common/constant.dart' as cnst;


class Splashscreen extends StatefulWidget {
  @override
  _SplashscreenState createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    Timer(Duration(seconds: 2), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String VendorId = prefs.getString(cnst.Session.VendorId);
      String IsVerify = prefs.getString(cnst.Session.IsVerified);
      print(IsVerify);
      if (VendorId != null && VendorId != "") {
        Navigator.pushReplacementNamed(context, '/Dashboard');
      } else {
        Navigator.pushReplacementNamed(context, '/LoginScreen');
      }
    });

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Image.asset(
                'images/background.png',
                fit: BoxFit.fill,
              )),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 60, right: 40, left: 60),
                child: Image.asset(
                  'images/gini.png',
                  height: MediaQuery.of(context).size.height / 1.6,
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Image.asset(
                  'images/myginitext.png',
                  height: 100,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
