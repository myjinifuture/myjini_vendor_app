import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

import 'Dashboard.dart';

class OTPScreen extends StatefulWidget {
  var mobileNo;
  Function onSuccess;

  OTPScreen({
    this.mobileNo,
    this.onSuccess
  });

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String _verificationCode;
  TextEditingController _txtOTP = TextEditingController();
  bool isLoading = false;


  @override
  void initState() {
    // super.initState();
    _verifyPhone();
    print(widget.mobileNo);

  }

  _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91${widget.mobileNo}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((UserCredential value) async {

            print("value.user.toString()");
            print(value.user.toString());
            if (value.user != null) {
              widget.onSuccess();
              print(widget.mobileNo);
              print("Login Successfully");
            } else {
              Fluttertoast.showToast(msg: "Error validating OTP, try again");
            }
          }).catchError((error) {
            log("->>>" + error.toString());
            Fluttertoast.showToast(msg: " $error");
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
        },
        codeSent: (String verficationID, int resendToken) {
          setState(() {
            _verificationCode = verficationID;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          setState(() {
            _verificationCode = verificationID;
          });
        },
        timeout: Duration(seconds: 120));
  }

  _onFormSubmitted() async {
    setState(() {
      isLoading = true;
    });
    AuthCredential _authCredential = PhoneAuthProvider.credential(
        verificationId: _verificationCode, smsCode: _txtOTP.text);
    _firebaseAuth
        .signInWithCredential(_authCredential)
        .then((UserCredential value) {
      setState(() {
        isLoading = false;
      });
      if (value.user != null) {
        print(value.user);
        widget.onSuccess();
        // setData();
        Navigator.pushReplacement(
            context,
            PageTransition(
                // child: Home(),
                child: Dashboard(),
                type: PageTransitionType.rightToLeft));
      } else {
        Fluttertoast.showToast(msg: "Invalid OTP");
      }
    }).catchError((error) {
      log(error.toString());
      Fluttertoast.showToast(msg: "$error Something went wrong");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.deepPurpleAccent,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // CircleDesign(title: "OTP Verification", backbutton: true),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    )),
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(top: 10, left: 25),
                          height: 100,
                          width: 100,
                          child: LottieBuilder.asset("assets/otp.json")),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(
                            "Enter Verification Code",
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Text(
                          "We have sent a verification code on",
                          // style: fontConstants.smallText,
                          style: TextStyle(fontWeight: FontWeight.w300),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          "+91${widget.mobileNo}",
                          // style: fontConstants.smallText,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.w400),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      PinCodeTextField(
                        controller: _txtOTP,
                        autofocus: true,
                        wrapAlignment: WrapAlignment.center,
                        highlight: true,
                        pinBoxHeight: 42,
                        pinBoxWidth: 42,
                        pinBoxRadius: 8,
                        //pinBoxColor: Colors.grey[200],
                        highlightColor: Color.fromRGBO(114, 34, 169, .6),
                        defaultBorderColor: Color.fromRGBO(114, 34, 169, .2),
                        hasTextBorderColor: Color.fromRGBO(114, 34, 169, 1),
                        maxLength: 6,
                        pinBoxDecoration:
                            ProvidedPinBoxDecoration.defaultPinBoxDecoration,
                        pinTextStyle: TextStyle(fontSize: 17),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          _onFormSubmitted();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(horizontal: 30),
                          height: 40,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(114, 34, 169, 1),
                              borderRadius: BorderRadius.circular(7)),
                          child: Text(
                            "Verify",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          _verifyPhone();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RichText(
                                text: TextSpan(
                                    text: "If you didn't receive code ? ",
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontFamily: 'WorkSans',
                                        fontSize: 16))),
                            Padding(
                              padding: const EdgeInsets.only(top: 2.0),
                              child: Text("Resend",
                                  style: TextStyle(
                                      color: Colors.deepPurpleAccent,
                                      fontFamily: 'WorkSans Bold',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16)),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
