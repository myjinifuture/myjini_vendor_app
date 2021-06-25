import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsocietyadvertisement/Common/Services.dart';
import 'package:smartsocietyadvertisement/Common/constant.dart' as cnst;


class OTPVerification extends StatefulWidget {
  @override
  _OTPVerificationState createState() => _OTPVerificationState();
}

class _OTPVerificationState extends State<OTPVerification> {

  TextEditingController txtOTP = new TextEditingController();

  String rndnumber = "";
  String mobileNo = "";
  ProgressDialog pr;
  bool isLoading = false;

  @override
  void initState() {
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(
        message: "Please Wait..",
        borderRadius: 10.0,
        progressWidget: Container(
          padding: EdgeInsets.all(15),
          child: CircularProgressIndicator(
            //backgroundColor: cnst.appPrimaryMaterialColor,
          ),
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w600));
    getLocalData();
  }



  getLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      mobileNo = prefs.getString(cnst.Session.Mobile);
    });
    print(mobileNo);
    _SendVerificationCode();
  }

  _SendVerificationCode() async {
    try {
      setState(() {
        rndnumber = "";
      });
      var rnd = new Random();

      setState(() {
        for (int i = 1; i <= 4; i++) {
          setState(() {
            rndnumber = rndnumber + rnd.nextInt(9).toString();
          });
        }
      });
      print(rndnumber);
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        pr.show();
        SharedPreferences prefs = await SharedPreferences.getInstance();


        Services.SendOtpToAdVendor(mobileNo,rndnumber).then((data) async {
          pr.hide();

          if (data.Data != "0" && data.IsSuccess == true) {
            Fluttertoast.showToast(
                msg: "OTP Sent Successfully !",
                textColor: Colors.black,
                toastLength: Toast.LENGTH_LONG);
          } else {
            showMsg(data.Message, title: "Error");
          }
        }, onError: (e) {
          pr.hide();
          showMsg("Try Again.");
        });
      } else
        showMsg("No Internet Connection.");
    } on SocketException catch (_) {
      pr.hide();
      showMsg("No Internet Connection.");
    }
  }

  _otpVerification() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        pr.show();
        SharedPreferences prefs = await SharedPreferences.getInstance();


        Services.VerifyAdVendor(mobileNo).then((data) async {
          pr.hide();

          if (data.Data != "0" && data.IsSuccess == true) {
            Fluttertoast.showToast(
                msg: "OTP Verified succsecfully",
                textColor: Colors.black,
                toastLength: Toast.LENGTH_LONG);

            Navigator.pushNamedAndRemoveUntil(context, "/Dashboard",
                    (Route<dynamic> route) => false);
          } else {
            showMsg(data.Message, title: "Error");
          }
        }, onError: (e) {
          pr.hide();
          showMsg("Try Again.");
        });
      } else
        showMsg("No Internet Connection.");
    } on SocketException catch (_) {
      pr.hide();
      showMsg("No Internet Connection.");
    }
  }

  showMsg(String msg, {String title = "MyJini Advertisement"}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("MyJini Advertisement"),
          content: new Text(msg),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Image.asset('images/verify.png', width: 100),
            ),
            Align(
                alignment: Alignment.center,
                child: Text("Verifying Your Number!",
                    style:
                    TextStyle(fontSize: 24, fontWeight: FontWeight.w600))),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Align(
                  alignment: Alignment.center,
                  child: Text("We Have Sent an OTP on +91${mobileNo}",
                      style: TextStyle(fontSize: 17))),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: PinCodeTextField(
                controller: txtOTP,
                highlight: true,
                highlightColor: cnst.appPrimaryMaterialColor,
                defaultBorderColor: Colors.grey,
                maxLength: 4,
                wrapAlignment: WrapAlignment.center,
                pinBoxDecoration:
                ProvidedPinBoxDecoration.underlinedPinBoxDecoration,
                pinTextStyle: TextStyle(fontSize: 30.0),
                pinTextAnimatedSwitcherTransition:
                ProvidedPinBoxTextAnimation.scalingTransition,
                pinTextAnimatedSwitcherDuration: Duration(milliseconds: 100),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "If you didn't receive a code ?",
                    style: TextStyle(fontSize: 16),
                  ),
                  GestureDetector(
                    onTap: () {
                      Fluttertoast.showToast(msg: "Resend",
                          toastLength: Toast.LENGTH_LONG,
                          backgroundColor: Colors.grey,);
                    },
                    child: Text(" Resend",
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                            color: cnst.appPrimaryMaterialColor)),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: GestureDetector(
                onTap: () {
                  if (txtOTP.text == rndnumber) {
                    _otpVerification();
                  } else {
                    Fluttertoast.showToast(
                        msg: "Entered Wrong OTP !",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER);
                  }
                },
                child: Container(
                  child: Center(
                      child: Text(
                        "Verify",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      )),
                  width: MediaQuery
                      .of(context)
                      .size
                      .width / 2,
                  height: 50,
                  decoration: BoxDecoration(
                      color: cnst.appPrimaryMaterialColor,
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
