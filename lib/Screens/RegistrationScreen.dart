import 'dart:io';

import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart' as loc;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:smartsocietyadvertisement/Common/ClassList.dart';
import 'package:smartsocietyadvertisement/Common/Services.dart';
import 'package:smartsocietyadvertisement/Common/constant.dart' as cnst;
import 'package:smartsocietyadvertisement/Common/constant.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  int count = 1;
  String _stateDropdownError, _cityDropdownError;
  bool stateLoading = false;
  bool cityLoading = false;
  bool isLoading = false;
  String countryValue = "";
  String stateValue = "";
  String cityValue = "";

  DateTime _date;

  List<cityClass> cityClassList = [];
  cityClass _cityClass;

  List<stateClass> stateClassList = [];
  List stateName = [];
  stateClass _stateClass;

  ProgressDialog pr;

  loc.LocationData currentLocation;
  String latlong;

  GlobalKey<FormState> _formkey1 = GlobalKey<FormState>();
  GlobalKey<FormState> _formkey2 = GlobalKey<FormState>();

  TextEditingController txtName = new TextEditingController();
  TextEditingController txtMobile = new TextEditingController();
  TextEditingController txtEmail = new TextEditingController();
  TextEditingController txtAddress = new TextEditingController();
  TextEditingController txtPincode = new TextEditingController();
  TextEditingController txtArea = new TextEditingController();
  TextEditingController txtCompanyName = new TextEditingController();
  TextEditingController txtWebsite = new TextEditingController();
  TextEditingController txtYoutube = new TextEditingController();
  TextEditingController txtGSTNo = new TextEditingController();
  TextEditingController txtReferalCode = new TextEditingController();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: new DateTime(1960),
        lastDate: new DateTime(2021));

    if (picked != null && picked != _date && picked != "null") {
      print("Date Selected -->>${_date.toString()}");
      setState(() {
        _date = picked;
      });
    }
  }

  @override
  void initState() {
    getdata();
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
    getState();
  }

  getdata() async {
    await getLocation();
  }

  getLocation() async {
    loc.Location location = new loc.Location();
    currentLocation = await location.getLocation();

    latlong = "${currentLocation.latitude}," + "${currentLocation.longitude}";

    print("LATLONG : " + currentLocation.toString());
    print("LAT : " + currentLocation.latitude.toString());
    print("LONG : " + currentLocation.longitude.toString());
    print("LATLONG : " + latlong);
  }

  getState() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          stateLoading = true;
        });
        Future res = Services.GetState();
        res.then((data) async {
          setState(() {
            stateLoading = false;
          });
          if (data != null && data.length > 0) {
            setState(() {
              stateClassList = data;
            });
          }
        }, onError: (e) {
          showMsg("$e");
          setState(() {
            stateLoading = false;
          });
        });
      } else {
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("Something Went Wrong");
      setState(() {
        stateLoading = false;
      });
    }
  }

  // getState()async{
  //   try {
  //     setState(() {
  //       stateLoading = true;
  //     });
  //     final internetResult = await InternetAddress.lookup('google.com');
  //     if (internetResult.isNotEmpty &&
  //         internetResult[0].rawAddress.isNotEmpty) {
  //       var body = {
  //         "countryCode" : "IN"
  //       };
  //       Services.responseHandler(
  //           apiName: "admin/getState", body: body)
  //           .then((responseData) {
  //         if (responseData.Data.length > 0) {
  //           print(responseData.Data);
  //           // societyList = responseData.Data;
  //           stateName=responseData.Data;
  //           for(int i=0;i<stateClassList.length;i++){
  //             stateClassList[i]=stateName[i]["name"];
  //           }
  //           setState(() {
  //             stateLoading = false;
  //           });
  //
  //         } else {
  //           print(responseData);
  //           setState(() {
  //             isLoading = false;
  //           });
  //           Fluttertoast.showToast(
  //             msg: "${responseData.Message}",
  //             backgroundColor: Colors.white,
  //             textColor: appPrimaryMaterialColor,
  //           );
  //         }
  //       }).catchError((error) {
  //         setState(() {
  //           isLoading = false;
  //         });
  //         Fluttertoast.showToast(
  //           msg: "Error $error",
  //           backgroundColor: Colors.white,
  //           textColor: appPrimaryMaterialColor,
  //         );
  //       });
  //     }
  //   } catch (e) {
  //     setState(() {
  //       isLoading = false;
  //     });
  //     Fluttertoast.showToast(
  //       msg: "You aren't connected to the Internet !",
  //       backgroundColor: Colors.white,
  //       textColor: appPrimaryMaterialColor,
  //     );
  //   }
  // }

  getCity(String id) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          cityLoading = true;
        });
        Future res = Services.GetCity(id);
        res.then((data) async {
          setState(() {
            cityLoading = false;
          });
          if (data != null && data.length > 0) {
            setState(() {
              cityClassList = data;
            });
          }
        }, onError: (e) {
          showMsg("$e");
          setState(() {
            cityLoading = false;
          });
        });
      } else {
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("Something Went Wrong");
      setState(() {
        cityLoading = false;
      });
    }
  }

  // Registration() async {
  //   try {
  //     final result = await InternetAddress.lookup('google.com');
  //     if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
  //       pr.show();
  //       var data = {
  //         "Name": txtName.text,
  //         "Mobile": txtMobile.text,
  //         "Email": txtEmail.text,
  //         "Address": txtAddress.text,
  //         "Pincode": txtPincode.text,
  //         "Area": txtArea.text,
  //         "CompanyName": txtCompanyName.text,
  //         "WebsiteURL": txtWebsite.text,
  //         "YoutubeURL": txtYoutube.text,
  //         "GSTNo": txtGSTNo.text,
  //         "StateId": _stateClass.id.toString(),
  //         "CityId": _cityClass.id.toString(),
  //         "ReferalCode": "",
  //         "Location": latlong.toString(),
  //       };
  //
  //       print("Save Vendor Data = ${data}");
  //       Services.AdRegister(data).then((data) async {
  //         pr.hide();
  //
  //         if (data.Data != "0" && data.IsSuccess == true) {
  //           SharedPreferences prefs = await SharedPreferences.getInstance();
  //           await prefs.setString(cnst.Session.Id, data.Data);
  //           await prefs.setString(cnst.Session.Mobile, txtMobile.text);
  //           await prefs.setString(cnst.Session.Name, txtName.text);
  //           await prefs.setString(cnst.Session.Email, txtEmail.text);
  //           await prefs.setString(cnst.Session.Address, txtAddress.text);
  //           await prefs.setString(cnst.Session.Pincode, txtPincode.text);
  //           await prefs.setString(cnst.Session.Area, txtArea.text);
  //           await prefs.setString(
  //               cnst.Session.CompanyName, txtCompanyName.text);
  //           await prefs.setString(cnst.Session.WebsiteURL, txtWebsite.text);
  //           await prefs.setString(cnst.Session.YoutubeURL, txtYoutube.text);
  //           await prefs.setString(cnst.Session.GSTNo, txtGSTNo.text);
  //           await prefs.setString(
  //               cnst.Session.ReferalCode, txtReferalCode.text);
  //           await prefs.setString(cnst.Session.CityId, _cityClass.id);
  //           await prefs.setString(cnst.Session.StateId, _stateClass.id);
  //           await prefs.setString(cnst.Session.IsVerified, "false");
  //           Fluttertoast.showToast(
  //               msg: "Registered Successfully !",
  //               textColor: Colors.black,
  //               toastLength: Toast.LENGTH_LONG);
  //           Navigator.pushNamedAndRemoveUntil(
  //               context, "/LoginScreen", (Route<dynamic> route) => false);
  //         } else {
  //           showMsg(data.Message, title: "Error");
  //         }
  //       }, onError: (e) {
  //         pr.hide();
  //         showMsg("Try Again.");
  //       });
  //     } else
  //       showMsg("No Internet Connection.");
  //   } on SocketException catch (_) {
  //     pr.hide();
  //     showMsg("No Internet Connection.");
  //   }
  // }

  Registration() async {
    try {
      setState(() {
        isLoading = true;
      });
      final internetResult = await InternetAddress.lookup('google.com');
      if (internetResult.isNotEmpty &&
          internetResult[0].rawAddress.isNotEmpty) {
        var body = {
          "Name": txtName.text,
          "ContactNo": txtMobile.text,
          "emailId": txtEmail.text,
          "Address": txtAddress.text,
          "Pincode": txtPincode.text,
          "Area": txtArea.text,
          "State": stateValue,
          "City": cityValue,
          "CompanyName": txtCompanyName.text,
          "WebsiteURL": txtWebsite.text,
          "YoutubeURL": txtYoutube.text,
          "GSTNo": txtGSTNo.text,
          "ReferalCode": txtReferalCode.text,
          "lat": currentLocation.latitude.toString(),
          "long": currentLocation.longitude.toString()
        };
        Services.responseHandler(
                apiName: "adsVendor/registerVendor", body: body)
            .then((responseData) async {
          if (responseData.Data.length > 0) {
            print(responseData.Data);
            Fluttertoast.showToast(
                msg: "Registered Successfully Plaese Log In");
            // societyList = responseData.Data;
            setState(() {
              isLoading = false;
              Navigator.pop(context);
            });
          } else {
            print(responseData);
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(
              msg: "${responseData.Message}",
              backgroundColor: Colors.white,
              textColor: appPrimaryMaterialColor,
            );
          }
          // if (responseData.Message == "Vendor Added" &&
          //     responseData.IsSuccess == true) {
          //   SharedPreferences prefs = await SharedPreferences.getInstance();
          //   await prefs.setString(cnst.Session.Mobile, txtMobile.text);
          //   await prefs.setString(cnst.Session.Name, txtName.text);
          //   await prefs.setString(cnst.Session.Email, txtEmail.text);
          //   await prefs.setString(cnst.Session.Address, txtAddress.text);
          //   await prefs.setString(cnst.Session.Pincode, txtPincode.text);
          //   await prefs.setString(cnst.Session.Area, txtArea.text);
          //   await prefs.setString(
          //       cnst.Session.CompanyName, txtCompanyName.text);
          //   await prefs.setString(cnst.Session.WebsiteURL, txtWebsite.text);
          //   await prefs.setString(cnst.Session.YoutubeURL, txtYoutube.text);
          //   await prefs.setString(cnst.Session.GSTNo, txtGSTNo.text);
          //   await prefs.setString(
          //       cnst.Session.ReferalCode, txtReferalCode.text);
          //   await prefs.setString(cnst.Session.CityId, _cityClass.id);
          //   await prefs.setString(cnst.Session.StateId, _stateClass.id);
          //   await prefs.setString(cnst.Session.IsVerified, "true");
          // } else {
          //   Fluttertoast.showToast(msg: "Failed To Set Pref");
          // }
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
      appBar: AppBar(
        title: Text("Create Account"),
        centerTitle: true,
        backgroundColor: cnst.appPrimaryMaterialColor,
        leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(Icons.keyboard_backspace)),
      ),
      body: SingleChildScrollView(
        child: WillPopScope(
          onWillPop: () {
            count == 1
                ? Navigator.of(context).pop()
                : setState(() {
                    count = 1;
                  });
          },
          child: Column(
            children: <Widget>[
              count == 1
                  ? Form(
                      key: _formkey1,
                      child: Column(
                        children: <Widget>[
                          Card(
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              color: Colors.grey[200],
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 10.0),
                                          child: Text(
                                            "Name",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 50,
                                          child: TextFormField(
                                            validator: (value) {
                                              if (value.trim() == "") {
                                                return 'Please Enter Valid Name';
                                              }
                                              return null;
                                            },
                                            controller: txtName,
                                            textInputAction:
                                                TextInputAction.next,
                                            decoration: InputDecoration(
                                                border: new OutlineInputBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          5.0),
                                                  borderSide: new BorderSide(),
                                                ),
                                                labelText: "Enter Name",
                                                hintStyle:
                                                    TextStyle(fontSize: 13)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 10.0),
                                          child: Text(
                                            "Mobile",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            SizedBox(
                                              height: 50,
                                              child: TextFormField(
                                                validator: (value) {
                                                  if (value.trim() == "" ||
                                                      value.length < 10) {
                                                    return 'Please Enter 10 Digit Mobile Number';
                                                  }
                                                  return null;
                                                },
                                                maxLength: 10,
                                                keyboardType:
                                                    TextInputType.number,
                                                controller: txtMobile,
                                                textInputAction:
                                                    TextInputAction.next,
                                                decoration: InputDecoration(
                                                    counterText: "",
                                                    fillColor: Colors.grey[200],
                                                    contentPadding:
                                                        EdgeInsets.only(
                                                            top: 5,
                                                            left: 10,
                                                            bottom: 5),
                                                    focusedBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.all(
                                                            Radius.circular(5)),
                                                        borderSide: BorderSide(
                                                            width: 0,
                                                            color:
                                                                Colors.black)),
                                                    enabledBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.all(
                                                            Radius.circular(4)),
                                                        borderSide: BorderSide(
                                                            width: 0,
                                                            color:
                                                                Colors.black)),
                                                    hintText: 'Enter Mobile No',
                                                    labelText: "Mobile",
                                                    hintStyle: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 14)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 10.0),
                                          child: Text(
                                            "Email",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 50,
                                          child: TextFormField(
                                            validator: (value) {
                                              if (value.trim() == "" ||
                                                  !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                                      .hasMatch(value)) {
                                                return 'Please Enter Valid Email-id';
                                              }
                                              return null;
                                            },
                                            controller: txtEmail,
                                            textInputAction:
                                                TextInputAction.next,
                                            decoration: InputDecoration(
                                                border: new OutlineInputBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          5.0),
                                                  borderSide: new BorderSide(),
                                                ),
                                                labelText: "Enter Email",
                                                hintStyle:
                                                    TextStyle(fontSize: 13)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Padding(
                                  //   padding: const EdgeInsets.all(8.0),
                                  //   child: Column(
                                  //     crossAxisAlignment:
                                  //         CrossAxisAlignment.start,
                                  //     children: <Widget>[
                                  //       Padding(
                                  //         padding: const EdgeInsets.only(
                                  //             bottom: 10.0),
                                  //         child: Text(
                                  //           "Company Name",
                                  //           style: TextStyle(fontSize: 16),
                                  //         ),
                                  //       ),
                                  //       SizedBox(
                                  //         height: 50,
                                  //         child: TextFormField(
                                  //           validator: (value) {
                                  //             if (value.trim() == "") {
                                  //               return 'Please Enter Company Name';
                                  //             }
                                  //             return null;
                                  //           },
                                  //           controller: txtCompanyName,
                                  //           textInputAction:
                                  //               TextInputAction.next,
                                  //           decoration: InputDecoration(
                                  //               border: new OutlineInputBorder(
                                  //                 borderRadius:
                                  //                     new BorderRadius.circular(
                                  //                         5.0),
                                  //                 borderSide: new BorderSide(),
                                  //               ),
                                  //               labelText: "Enetr Company Name",
                                  //               hintStyle:
                                  //                   TextStyle(fontSize: 13)),
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 10.0),
                                          child: Text(
                                            "Webiste URL",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 50,
                                          child: TextFormField(
                                            /*validator: (value) {
                                              if (value.trim() == "") {
                                                return 'Please Enter Valid URL';
                                              }
                                              return null;
                                            },*/
                                            controller: txtWebsite,
                                            textInputAction:
                                                TextInputAction.next,
                                            decoration: InputDecoration(
                                                border: new OutlineInputBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          5.0),
                                                  borderSide: new BorderSide(),
                                                ),
                                                labelText: "Enter Website URL",
                                                hintStyle:
                                                    TextStyle(fontSize: 13)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 10.0),
                                          child: Text(
                                            "Youtube URL",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 50,
                                          child: TextFormField(
                                            /*validator: (value) {
                                              if (value.trim() == "") {
                                                return 'Please Enter Valid URL';
                                              }
                                              return null;
                                            },*/
                                            controller: txtYoutube,
                                            textInputAction:
                                                TextInputAction.next,
                                            decoration: InputDecoration(
                                                border: new OutlineInputBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          5.0),
                                                  borderSide: new BorderSide(),
                                                ),
                                                labelText: "Enter Youtube URL",
                                                hintStyle:
                                                    TextStyle(fontSize: 13)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 18.0, left: 8, right: 8, bottom: 8.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  color: cnst.appPrimaryMaterialColor,
                                  textColor: Colors.white,
                                  splashColor: Colors.white,
                                  child: Text("Next",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600)),
                                  onPressed: () {
                                    if (_formkey1.currentState.validate()) {
                                      setState(() {
                                        count = count + 1;
                                      });
                                    }
                                  }),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Form(
                      key: _formkey2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Card(
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              color: Colors.grey[200],
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 10.0),
                                          child: Text(
                                            "Company Name",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 50,
                                          child: TextFormField(
                                            validator: (value) {
                                              if (value.trim() == "") {
                                                return 'Please Enter Company Name';
                                              }
                                              return null;
                                            },
                                            controller: txtCompanyName,
                                            textInputAction:
                                            TextInputAction.next,
                                            decoration: InputDecoration(
                                                border: new OutlineInputBorder(
                                                  borderRadius:
                                                  new BorderRadius.circular(
                                                      5.0),
                                                  borderSide: new BorderSide(),
                                                ),
                                                labelText: "Enter Company Name",
                                                hintStyle:
                                                TextStyle(fontSize: 13)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 10.0),
                                          child: Text(
                                            "GST No",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 50,
                                          child: TextFormField(
                                            validator: (value) {
                                              if (value.length < 15) {
                                                return 'Please Enter Valid GSTNo';
                                              }
                                              return null;
                                            },
                                            controller: txtGSTNo,
                                            textCapitalization: TextCapitalization.sentences,
                                            maxLength: 15,
                                            textInputAction:
                                                TextInputAction.next,
                                            decoration: InputDecoration(
                                                border: new OutlineInputBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          5.0),
                                                  borderSide: new BorderSide(),
                                                ),
                                                labelText: "Enter GST No",
                                                hintStyle:
                                                    TextStyle(fontSize: 13)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 10.0),
                                          child: Text(
                                            "Company Address",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 50,
                                          child: TextFormField(
                                            validator: (value) {
                                              if (value.trim() == "") {
                                                return 'Please Enter Address';
                                              }
                                              return null;
                                            },
                                            controller: txtAddress,
                                            keyboardType: TextInputType.multiline,
                                            textInputAction:
                                                TextInputAction.next,
                                            decoration: InputDecoration(
                                                border: new OutlineInputBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          5.0),
                                                  borderSide: new BorderSide(),
                                                ),
                                                labelText: "Enter Address",
                                                hintStyle:
                                                    TextStyle(fontSize: 13)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Padding(
                                  //   padding: const EdgeInsets.all(12.0),
                                  //   child: Row(
                                  //     mainAxisAlignment:
                                  //         MainAxisAlignment.spaceAround,
                                  //     children: <Widget>[
                                  //       Column(
                                  //         crossAxisAlignment:
                                  //             CrossAxisAlignment.start,
                                  //         children: <Widget>[
                                  //           Text(
                                  //             "State",
                                  //             style: TextStyle(
                                  //                 fontWeight: FontWeight.w600,
                                  //                 color: Colors.grey[700]),
                                  //           ),
                                  //           stateLoading
                                  //               ? CircularProgressIndicator()
                                  //               : Container(
                                  //                   height: 45,
                                  //                   margin:
                                  //                       EdgeInsets.only(top: 5),
                                  //                   width:
                                  //                       MediaQuery.of(context)
                                  //                               .size
                                  //                               .width /
                                  //                           2.3,
                                  //                   padding:
                                  //                       EdgeInsets.symmetric(
                                  //                           horizontal: 10),
                                  //                   decoration: BoxDecoration(
                                  //                     borderRadius:
                                  //                         BorderRadius.circular(
                                  //                             5),
                                  //                     color: Colors.grey[200],
                                  //                     border: Border.all(
                                  //                         color: Colors.grey,
                                  //                         style:
                                  //                             BorderStyle.solid,
                                  //                         width: 0),
                                  //                   ),
                                  //                   child:
                                  //                       DropdownButtonHideUnderline(
                                  //                           child:
                                  //                               DropdownButton<
                                  //                                   stateClass>(
                                  //                     isExpanded: true,
                                  //                     hint: stateClassList
                                  //                                 .length >
                                  //                             0
                                  //                         ? Text(
                                  //                             'Select State',
                                  //                             style: TextStyle(
                                  //                                 fontSize: 12),
                                  //                           )
                                  //                         : Text(
                                  //                             "State Not Found",
                                  //                             style: TextStyle(
                                  //                                 fontSize: 12),
                                  //                           ),
                                  //                     value: _stateClass,
                                  //                     onChanged: (newValue) {
                                  //                       setState(() {
                                  //                         _stateClass =
                                  //                             newValue;
                                  //                         _cityClass = null;
                                  //                         _stateDropdownError =
                                  //                             null;
                                  //                         cityClassList = [];
                                  //                       });
                                  //                       getCity(newValue.id
                                  //                           .toString());
                                  //                     },
                                  //                     items: stateClassList.map(
                                  //                         (stateClass value) {
                                  //                       return DropdownMenuItem<
                                  //                           stateClass>(
                                  //                         value: value,
                                  //                         child:
                                  //                             Text(value.Name),
                                  //                       );
                                  //                     }).toList(),
                                  //                   ))),
                                  //           Align(
                                  //             alignment: Alignment.centerLeft,
                                  //             child: _stateDropdownError == null
                                  //                 ? Text(
                                  //                     "",
                                  //                     textAlign:
                                  //                         TextAlign.start,
                                  //                   )
                                  //                 : Text(
                                  //                     _stateDropdownError ?? "",
                                  //                     style: TextStyle(
                                  //                         color:
                                  //                             Colors.red[700],
                                  //                         fontSize: 12),
                                  //                     textAlign:
                                  //                         TextAlign.start,
                                  //                   ),
                                  //           ),
                                  //         ],
                                  //       ),
                                  //       Column(
                                  //         crossAxisAlignment:
                                  //             CrossAxisAlignment.start,
                                  //         children: <Widget>[
                                  //           Text(
                                  //             "City",
                                  //             style: TextStyle(
                                  //                 fontWeight: FontWeight.w600,
                                  //                 color: Colors.grey[700]),
                                  //           ),
                                  //           GestureDetector(
                                  //             onTap: () {
                                  //               if (cityClassList.length <= 0 &&
                                  //                   _stateClass != null) {
                                  //               } else
                                  //                 Fluttertoast.showToast(
                                  //                     msg:
                                  //                         "Please Select State First",
                                  //                     toastLength:
                                  //                         Toast.LENGTH_SHORT);
                                  //             },
                                  //             child: cityLoading
                                  //                 ? CircularProgressIndicator()
                                  //                 : Container(
                                  //                     height: 45,
                                  //                     margin: EdgeInsets.only(
                                  //                         top: 5),
                                  //                     width:
                                  //                         MediaQuery.of(context)
                                  //                                 .size
                                  //                                 .width /
                                  //                             2.3,
                                  //                     padding:
                                  //                         EdgeInsets.symmetric(
                                  //                             horizontal: 10),
                                  //                     decoration: BoxDecoration(
                                  //                       borderRadius:
                                  //                           BorderRadius
                                  //                               .circular(5),
                                  //                       color: Colors.grey[200],
                                  //                       border: Border.all(
                                  //                           color: Colors.grey,
                                  //                           style: BorderStyle
                                  //                               .solid,
                                  //                           width: 0),
                                  //                     ),
                                  //                     child:
                                  //                         DropdownButtonHideUnderline(
                                  //                       child: DropdownButton<
                                  //                           cityClass>(
                                  //                         isExpanded: true,
                                  //                         hint: cityClassList
                                  //                                     .length >
                                  //                                 0
                                  //                             ? Text(
                                  //                                 'Select City',
                                  //                                 style: TextStyle(
                                  //                                     fontSize:
                                  //                                         12),
                                  //                               )
                                  //                             : Text(
                                  //                                 "City Not Found",
                                  //                                 style: TextStyle(
                                  //                                     fontSize:
                                  //                                         12),
                                  //                               ),
                                  //                         value: _cityClass,
                                  //                         onChanged:
                                  //                             (newValue) {
                                  //                           setState(() {
                                  //                             _cityClass =
                                  //                                 newValue;
                                  //                             _cityDropdownError =
                                  //                                 null;
                                  //                           });
                                  //                         },
                                  //                         items: cityClassList
                                  //                             .map((cityClass
                                  //                                 value) {
                                  //                           return DropdownMenuItem<
                                  //                               cityClass>(
                                  //                             value: value,
                                  //                             child: Text(
                                  //                                 value.Name),
                                  //                           );
                                  //                         }).toList(),
                                  //                       ),
                                  //                     ),
                                  //                   ),
                                  //           ),
                                  //           Align(
                                  //             alignment: Alignment.centerLeft,
                                  //             child: _cityDropdownError == null
                                  //                 ? Text(
                                  //                     "",
                                  //                     textAlign:
                                  //                         TextAlign.start,
                                  //                   )
                                  //                 : Text(
                                  //                     _cityDropdownError ?? "",
                                  //                     style: TextStyle(
                                  //                         color:
                                  //                             Colors.red[700],
                                  //                         fontSize: 12),
                                  //                     textAlign:
                                  //                         TextAlign.start,
                                  //                   ),
                                  //           ),
                                  //         ],
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        // Padding(
                                        //   padding: const EdgeInsets.only(
                                        //       bottom: 10.0),
                                        //   child: Text(
                                        //     "Area",
                                        //     style: TextStyle(fontSize: 16),
                                        //   ),
                                        // ),
                                        SizedBox(
                                          height: 50,
                                          child: TextFormField(
                                            validator: (value) {
                                              if (value.trim() == "") {
                                                return 'Please Enter Area';
                                              }
                                              return null;
                                            },
                                            controller: txtArea,
                                            textInputAction:
                                            TextInputAction.next,
                                            decoration: InputDecoration(
                                                border: new OutlineInputBorder(
                                                  borderRadius:
                                                  new BorderRadius.circular(
                                                      5.0),
                                                  borderSide: new BorderSide(),
                                                ),
                                                labelText: "Enter Area",
                                                hintStyle:
                                                TextStyle(fontSize: 13)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Padding(
                                  //   padding: const EdgeInsets.all(10.0),
                                  //   child: Text(
                                  //     "Address",
                                  //     style: TextStyle(fontSize: 16),
                                  //   ),
                                  // ),
                                  Padding(
                                    padding:
                                        EdgeInsets.all(8),
                                    child: CSCPicker(
                                      showStates: true,
                                      showCities: true,
                                      dropdownDialogRadius: 5.0,
                                      searchBarRadius: 5.0,
                                      dropdownDecoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                        // color: Colors.white,
                                        border: Border.all(
                                          color: Colors.grey,
                                          width: 1,
                                        ),
                                      ),
                                      dropdownHeadingStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      layout: Layout.horizontal,
                                      defaultCountry: DefaultCountry.India,
                                      selectedItemStyle: TextStyle(
                                          fontSize: 16, color: Colors.grey[700]),
                                      onCityChanged: (value) {
                                        setState(() {
                                          ///store value in city variable
                                          cityValue = value;
                                        });
                                      },
                                      onStateChanged: (value) {
                                        setState(() {
                                          ///store value in state variable
                                          stateValue = value;
                                        });
                                      },
                                      onCountryChanged: (value) {
                                        setState(() {
                                          ///store value in country variable
                                          countryValue = value;
                                        });
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 10.0),
                                          child: Text(
                                            "Pincode",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 50,
                                          child: TextFormField(
                                            validator: (value) {
                                              if (value.trim() == "" ||
                                                  value.length < 6) {
                                                return 'Please Enter Valid PIN';
                                              }
                                              return null;
                                            },
                                            controller: txtPincode,
                                            keyboardType: TextInputType.number,
                                            textInputAction:
                                                TextInputAction.next,
                                            decoration: InputDecoration(
                                                border: new OutlineInputBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          5.0),
                                                  borderSide: new BorderSide(),
                                                ),
                                                labelText: "Enter Pincode",
                                                hintStyle:
                                                    TextStyle(fontSize: 13)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  /* Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        SizedBox(
                                          height: 50,
                                          child: TextFormField(
                                            controller: txtReferalCode,
                                            textInputAction:
                                                TextInputAction.next,
                                            decoration: InputDecoration(
                                                border: new OutlineInputBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          5.0),
                                                  borderSide: new BorderSide(),
                                                ),
                                                labelText: "Referal Code",
                                                hintStyle:
                                                    TextStyle(fontSize: 13)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),*/
                                ],
                              ),
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 18.0, left: 8, right: 8, bottom: 8.0),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: 50,
                                  child: RaisedButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      color: cnst.appPrimaryMaterialColor,
                                      textColor: Colors.white,
                                      splashColor: Colors.white,
                                      child: Text("Register",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600)),
                                      onPressed: () async {
                                        bool isValidate = true;
                                        setState(() {
                                          if (stateValue == null ||
                                              stateValue == "") {
                                            isValidate = false;
                                            Fluttertoast.showToast(
                                                msg: "Select State");
                                          }
                                          if (cityValue == null ||
                                              cityValue == "") {
                                            isValidate = false;
                                            Fluttertoast.showToast(
                                                msg: "Select City");
                                          }
                                        });
                                        if (_formkey2.currentState.validate()) {
                                          Registration();
                                        }
                                        /*Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      "/OTPVerification",
                                          (Route<dynamic> route) => false);*/
                                      }),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 30.0, bottom: 30),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text("Aleady Have an Account?"),
                                    GestureDetector(
                                        onTap: () {
                                          Navigator.pushReplacementNamed(
                                              context, '/LoginScreen');
                                        },
                                        child: Text("Login",
                                            style: TextStyle(
                                                color: cnst
                                                    .appPrimaryMaterialColor,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600)))
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
