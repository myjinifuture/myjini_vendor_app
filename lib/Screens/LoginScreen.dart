import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsocietyadvertisement/Common/Services.dart';
import 'package:smartsocietyadvertisement/Common/constant.dart' as cnst;
import 'package:smartsocietyadvertisement/Common/constant.dart';

import 'OTPScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController txtMobileNo = new TextEditingController();

  ProgressDialog pr;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
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
  }

  setData() async {
    try {
      setState(() {
        isLoading = true;
      });
      final internetResult = await InternetAddress.lookup('google.com');
      if (internetResult.isNotEmpty &&
          internetResult[0].rawAddress.isNotEmpty) {
        var body = {
          "ContactNo": txtMobileNo.text,
        };
        Services.responseHandler(apiName: "adsVendor/login", body: body)
            .then((responseData) async {
          if (responseData.Data.length == 0) {
            print("responseData.Data");
            print(responseData.Data);
            print("responseData.Mess");
            print(responseData.Message);
            Fluttertoast.showToast(
              msg: "${responseData.Message}",
              backgroundColor: Colors.white,
              textColor: appPrimaryMaterialColor,
            );
          } else {
            print(responseData.Data);
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(
              msg: "${responseData.Message}",
              backgroundColor: Colors.white,
              textColor: appPrimaryMaterialColor,
            );
          }
          SharedPreferences prefs = await SharedPreferences.getInstance();
          print(txtMobileNo.text);
          // await prefs.setString(cnst.Session.Mobile, responseData.Data[0]["ContactNo"]);
          await prefs.setString(cnst.Session.Mobile.toString(), txtMobileNo.text);
          await prefs.setString(cnst.Session.VendorId.toString(), responseData.Data[0]["_id"]);
          await prefs.setString(cnst.Session.Name, responseData.Data[0]["Name"]);
          await prefs.setString(cnst.Session.Email.toString(), responseData.Data[0]["emailId"]);
          await prefs.setString(cnst.Session.Address, responseData.Data[0]["Address"]);
          await prefs.setString(cnst.Session.Pincode, responseData.Data[0]["Pincode"]);
          // await prefs.setString(cnst.Session.Area, txtArea.text);
          await prefs.setString(cnst.Session.CompanyName, responseData.Data[0]["CompanyName"]);
          await prefs.setString(cnst.Session.WebsiteURL, responseData.Data[0]["WebsiteURL"]);
          await prefs.setString(cnst.Session.YoutubeURL, responseData.Data[0]["YoutubeURL"]);
          await prefs.setString(cnst.Session.GSTNo, responseData.Data[0]["GSTNo"]);
          await prefs.setString(cnst.Session.ReferalCode, responseData.Data[0]["ReferalCode"]);
          await prefs.setString(cnst.Session.CityName, responseData.Data[0]["City"]);
          await prefs.setString(cnst.Session.StateName, responseData.Data[0]["State"]);
          await prefs.setString(cnst.Session.IsVerified, "true");
          print("cnst.Session.Mobile:");
          print(prefs.getString(cnst.Session.Mobile));
          print(prefs.getString(cnst.Session.VendorId));
          print(prefs.getString(cnst.Session.Email));
          print(prefs.getString(cnst.Session.Address));
          print(prefs.getString(cnst.Session.CityName));
          print(prefs.getString(cnst.Session.StateName));
          // print(prefs.getString(cnst.Session.Email));
          print(prefs.getString(cnst.Session.ReferalCode));
          Navigator.of(context)
              .pushNamedAndRemoveUntil( '/Dashboard', (Route<dynamic> route) => false);
        }).catchError((error) {
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(
            msg: "Error $error",
            backgroundColor: Colors.white,
            textColor: appPrimaryMaterialColor,
          );
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(
        msg: "You aren't connected to the Internet !",
        backgroundColor: Colors.white,
        textColor: appPrimaryMaterialColor,
      );
    }
  }

  _Login() async {

    // Navigator.pushNamed(context, '/RegistrationScreen');
    // if (txtMobileNo.text != "") {
    //   try {
    //     final result = await InternetAddress.lookup('google.com');
    //     if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
    //       pr.show();
    //       Future res = Services.Login(txtMobileNo.text);
    //       res.then((data) async {
    //         pr.hide();
    //         SharedPreferences prefs = await SharedPreferences.getInstance();
    //         if (data != null && data.length > 0) {
    //           await prefs.setString(cnst.Session.Id, data[0]["Id"].toString());
    //           await prefs.setString(cnst.Session.Name, data[0]["Name"]);
    //           await prefs.setString(
    //               cnst.Session.Mobile, data[0]["Mobile"]);
    //           await prefs.setString(
    //               cnst.Session.Email, data[0]["Email"]);
    //           await prefs.setString(cnst.Session.Address, data[0]["Address"]);
    //           await prefs.setString(
    //               cnst.Session.StateId, data[0]["StateId"].toString());
    //           await prefs.setString(
    //               cnst.Session.CityId, data[0]["CityId"].toString());
    //           await prefs.setString(
    //               cnst.Session.CityName, data[0]["CityName"].toString());
    //           await prefs.setString(
    //               cnst.Session.StateName, data[0]["StateName"].toString());
    //           await prefs.setString(cnst.Session.Pincode, data[0]["Pincode"]);
    //           await prefs.setString(
    //               cnst.Session.Area, data[0]["Area"]);
    //           await prefs.setString(cnst.Session.CompanyName, data[0]["CompanyName"]);
    //           await prefs.setString(cnst.Session.WebsiteURL, data[0]["WebsiteURL"]);
    //           await prefs.setString(
    //               cnst.Session.YoutubeURL, data[0]["YoutubeURL"]);
    //           await prefs.setString(cnst.Session.GSTNo, data[0]["GSTNo"]);
    //           await prefs.setString(cnst.Session.ProfileImage, data[0]["Image"]);
    //           await prefs.setString(cnst.Session.ReferalCode, data[0]["ReferalCode"]);
    //           await prefs.setString(
    //               cnst.Session.IsVerified, data[0]["IsVerified"].toString());
    //           print(data[0]["MemberId"]);
    //           await prefs.setString(cnst.Session.MemberId, data[0]["MemberId"].toString());
    //
    //           Navigator.pushNamedAndRemoveUntil(context, "/Dashboard",
    //                   (Route<dynamic> route) => false);
    //
    //           if (data[0]["IsVerified"].toString() == "true" &&
    //               data[0]["IsVerified"] != null) {
    //             Navigator.pushNamedAndRemoveUntil(context, "/Dashboard",
    //                     (Route<dynamic> route) => false);
    //           } else {
    //             Navigator.pushNamedAndRemoveUntil(context,
    //                 "/OTPVerification", (Route<dynamic> route) => false);
    //           }
    //
    //         } else {
    //           pr.hide();
    //           showMsg("Invalid login Detail");
    //         }
    //       }, onError: (e) {
    //         //pr.hide();
    //         print("Error : on Login Call $e");
    //         showMsg("$e");
    //       });
    //     }
    //   } on SocketException catch (_) {
    //     showMsg("No Internet Connection.");
    //   }
    // } else {
    //   Fluttertoast.showToast(
    //       msg: "Please Enter Registerd Mobile Number",
    //       toastLength: Toast.LENGTH_SHORT,
    //       backgroundColor: Colors.red,
    //       textColor: Colors.white,
    //       gravity: ToastGravity.TOP);
    // }
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
        child: Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 110.0),
              child: Container(
                child: Center(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset('images/applogo.png',
                                      width: 90, height: 90),
                                ],
                              ),
                            ),
                            Text("Welcome User",
                                style: TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.w600,
                                    color: cnst.appPrimaryMaterialColor)),
                            Text("Login with Mobile Number to Continue",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: cnst.appPrimaryMaterialColor)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 180.0),
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 20.0, left: 10.0, right: 10.0),
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 4.0, right: 8.0, top: 6.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          SizedBox(
                                            height: 50,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: TextFormField(
                                                textInputAction:
                                                    TextInputAction.done,
                                                controller: txtMobileNo,
                                                maxLength: 10,
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration: InputDecoration(
                                                    labelText: "Mobile No",
                                                    labelStyle: TextStyle(
                                                        color: cnst
                                                            .appPrimaryMaterialColor),
                                                    counterText: "",
                                                    focusedBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: cnst
                                                                .appPrimaryMaterialColor)),
                                                    border:
                                                        new OutlineInputBorder(
                                                      borderRadius:
                                                          new BorderRadius
                                                              .circular(5.0),
                                                      borderSide:
                                                          new BorderSide(),
                                                    ),
                                                    hintText:
                                                        "Your Mobile Number",
                                                    hintStyle: TextStyle(
                                                        fontSize: 13)),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 18.0, left: 8, right: 8),
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 45,
                                        child: RaisedButton(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          color: cnst.appPrimaryMaterialColor,
                                          textColor: Colors.white,
                                          splashColor: Colors.white,
                                          child: Text("Login",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600)),
                                          onPressed: () {
                                            // setData();
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => OTPScreen(
                                                mobileNo: txtMobileNo.text,
                                                onSuccess: setData,
                                              )),);

                                            // _Login();
                                            // Navigator.pushReplacementNamed(
                                            //         context, '/Dashboard');
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 35.0, bottom: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text("Don't Have an Account?  "),
                                    GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, '/RegistrationScreen');
                                        },
                                        child: Text("Register",
                                            style: TextStyle(
                                                color: cnst
                                                    .appPrimaryMaterialColor,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600)))
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
