import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:location/location.dart' as loc;
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsocietyadvertisement/Common/Services.dart';
import 'package:smartsocietyadvertisement/Common/constant.dart' as constant;
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:smartsocietyadvertisement/Common/constant.dart';
import 'package:smartsocietyadvertisement/Screens/ContactMyjini.dart';

class UpdateAdvertise extends StatefulWidget {
  var Advertise;
  Function onUpdate;

  UpdateAdvertise({this.Advertise,this.onUpdate});
  @override
  _UpdateAdvertiseState createState() => _UpdateAdvertiseState();
}

class _UpdateAdvertiseState extends State<UpdateAdvertise> {
  TextEditingController edtTitle = new TextEditingController();
  TextEditingController edtTagLine = new TextEditingController();
  TextEditingController edtDescription = new TextEditingController();
  TextEditingController edtContact = new TextEditingController();
  TextEditingController edtLat = new TextEditingController();
  TextEditingController edtLong = new TextEditingController();
  TextEditingController edtWebsiteURL = new TextEditingController();
  TextEditingController edtEmail = new TextEditingController();
  TextEditingController edtVideoLink = new TextEditingController();

  // TextEditingController edtPrice = new TextEditingController();

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  String ImageError;

  FocusNode myFocusNode;
  String selectedType;
  String selectedLocationType;
  String selectedLocations = "";
  int selected_package;
  File image;

  bool typeSelected = false;
  String Type = "TOP";

  List _locationsData = [];
  List _packageAllList = [];
  List _packageList = [];
  List _selectedCheckList = [];
  List _paymentDetails = [];

  bool isLoading = false;
  ProgressDialog pr;
  String _lat = "", _long = "";
  bool invisible = true;

  @override
  void initState() {
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(message: 'Please Wait');
    myFocusNode = FocusNode();
    // getPackages();
    getdata();
    // getPaymentDetails();
    super.initState();
    _getLocation();
  }

  getdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      edtTitle.text=widget.Advertise["Title"];
      edtDescription.text=widget.Advertise["Description"];
      edtContact.text=widget.Advertise["ContactNo"];
      edtWebsiteURL.text=widget.Advertise["WebsiteURL"];
      edtEmail.text=widget.Advertise["EmailId"];
      edtVideoLink.text=widget.Advertise["VideoLink"];
      print("object");
      print(widget.Advertise);
    });
  }

  loc.LocationData currentLocation;
  String latlong;

  Future<void> _getLocation() async {
    loc.Location location = new loc.Location();
    currentLocation = await location.getLocation();

    latlong = "${currentLocation.latitude}," + "${currentLocation.longitude}";

    edtLat.text = currentLocation.latitude.toString();
    print("LATLONG : " + currentLocation.toString());
    print("LAT : " + currentLocation.latitude.toString());
    edtLat.text = currentLocation.latitude.toString();
    print("LONG : " + currentLocation.longitude.toString());
    edtLong.text = currentLocation.longitude.toString();
    print("LATLONG : " + latlong);
  }

  List<String> files = [];
  String base64Image;
  List<Asset> images = <Asset>[];
  String _error = 'No Error Detected';

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#8522a9",
          actionBarTitle: "My JINI Advertisement",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;
    });
  }

  Widget BuildGridView() {
    return GridView.count(
      crossAxisCount: 1,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return AssetThumb(
          asset: asset,
          width: 300,
          height: 300,
        );
      }),
    );
  }

  makePayment() async {}

  Future getImage(ImageSource source) async {
    var newImage = await ImagePicker.pickImage(source: source);
    if (newImage != null) {
      setState(() {
        image = newImage;
        // ImageError = null;
      });
    }
  }

  getPackages() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.GetPackages();
        setState(() {
          isLoading = true;
        });
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              _packageAllList = data;
              isLoading = false;
            });
          } else {
            setState(() {
              isLoading = false;
              _packageAllList = data;
            });
          }
        }, onError: (e) {
          showMsg("Something Went Wrong.\nPlease Try Again");
          setState(() {
            isLoading = false;
          });
        });
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  /* getPaymentDetails() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.GetPaymentDetails();
        setState(() {
          isLoading = true;
        });
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              _paymentDetails = data;
              isLoading = false;
            });
          } else {
            setState(() {
              isLoading = false;
              _paymentDetails = data;
            });
          }
        }, onError: (e) {
          showMsg("Something Went Wrong.\nPlease Try Again");
          setState(() {
            isLoading = false;
          });
        });
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }*/

  getLocationData(String selectedType) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (selectedType == "For Society")
          setState(() {
            selectedLocationType = "Society";
          });
        else if (selectedType == "For Area")
          setState(() {
            selectedLocationType = "Area";
          });
        else if (selectedType == "For City")
          setState(() {
            selectedLocationType = "City";
          });
        Future res = Services.GetAdvertiseFor(selectedLocationType);
        pr.show();
        res.then((data) async {
          pr.hide();
          if (data != null && data.length > 0) {
            setState(() {
              _locationsData = data;
            });
            setPackage();
          } else {
            setState(() {
              _locationsData = data;
            });
          }
        }, onError: (e) {
          pr.hide();
          showMsg("Something Went Wrong.\nPlease Try Again");
        });
      } else {
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
      pr.hide();
    }
  }

  showMsg(String msg, {String title = 'My Jini'}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(title),
          content: new Text(msg),
          actions: <Widget>[
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

  setPackage() async {
    setState(() {
      _packageList.clear();
      selected_package = null;
    });

    for (int i = 0; i < _packageAllList.length; i++) {
      if (_packageAllList[i]["Type"] == selectedLocationType) {
        setState(() {
          _packageList.add(_packageAllList[i]);
        });
      }
    }
  }

  _makePayment() async {
    if (edtTitle.text != "" &&
        edtDescription.text != "" &&
        edtWebsiteURL.text != "" &&
        edtEmail.text != "") {
      final validCharacters =
      RegExp(r'^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$');
      //final validCharacters = RegExp(r'^[A-Z]{2}-[0-9]{2}-[A-Z]{2}-[0-9]{4}$');
      var validate = validCharacters.hasMatch(edtEmail.text);
      if (validate == false) {
        Fluttertoast.showToast(
            msg: "Please enter valid E-mail",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            backgroundColor: Colors.red,
            textColor: Colors.white);
      } else {
        DateTime expiredDate = DateTime.now();

        expiredDate = expiredDate
            .add(Duration(days: _packageList[selected_package]["Duration"]));

        var data = {
          "key": "${_paymentDetails[0]["InstaMojoKey"]}",
          "token": "${_paymentDetails[0]["InstaMojoToken"]}",
          "amount": "${double.parse(
            (_packageList[selected_package]["Price"] *
                _selectedCheckList.length)
                .toString(),
          )}",
          "title": "${edtTitle.text}",
          "desc": "${edtDescription.text}",
          "photo": image,
          "packageId": "${_packageList[selected_package]["Id"]}",
          "expiredDate": "${expiredDate.toString()}",
          "type": "${selectedLocationType}",
          "targetedId": "${selectedLocations}",
          "renew": "false",
          "WebsiteURL": edtWebsiteURL.text,
          "VideoLink": edtVideoLink.text,
          "Email": edtEmail.text,
          "GoogleMap": _lat + "," + _long,
        };

        print(data);
        /*    Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentWebView(data),
          ),
        );*/
      }
    } else
      Fluttertoast.showToast(
          msg: "Please Enter All Fields",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.red,
          textColor: Colors.white);
  }

  _UpdatePost() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String ven = prefs.getString(constant.Session.VendorId);
    print(ven);
    if (files == '' || files == null||edtTitle.text==''||edtDescription.text==''||edtContact.text=='') {
      Fluttertoast.showToast(
        msg:
        "Please Fill all mandatory Fields",
        backgroundColor: Colors.red,
        gravity: ToastGravity.BOTTOM,
        textColor: Colors.white,
      );

    } else {
      files.clear();
      for (int i = 0; i < images.length; i++) {
        ByteData byteData = await images[i].getByteData();
        List<int> imageData = byteData.buffer.asUint8List();
        base64Image = base64Encode(imageData);
        print(i);
        files.add(base64Image);
        print(images.toString());
        print(files);
      }
      try {
        setState(() {
          isLoading = true;
        });
        final internetResult = await InternetAddress.lookup('google.com');
        if (internetResult.isNotEmpty &&
            internetResult[0].rawAddress.isNotEmpty) {
          var body = {
            "advertiseId": "${widget.Advertise["_id"]}",
            "Title": edtTitle.text,
            "Description": edtDescription.text,
            "vendorId": ven,
            "WebsiteURL": "${edtWebsiteURL.text}",
            "EmailId": "${edtEmail.text}",
            "VideoLink": "${edtVideoLink.text}",
            "lat": double.parse(edtLat.text),
            "long": double.parse(edtLong.text),
            "AdPosition": Type.toUpperCase(),
            "ContactNo": "${edtContact.text}",
            "image": files
          };
          print(body);
          Services.responseHandler(
              apiName: "adsVendor/updateAdvertise", body: body)
              .then((responseData) async {
            Fluttertoast.showToast(
              msg: "${responseData.Message}",
              backgroundColor: Colors.white,
              textColor: appPrimaryMaterialColor,
            );
            if (responseData.Data == 1) {
              print(responseData.Data.toString());
              setState(() {
                isLoading = false;
              });
              widget.onUpdate;
              Navigator.pop(context);
            } else {
              setState(() {
                isLoading = false;
              });
              Fluttertoast.showToast(
                msg: "${responseData.Message}",
                backgroundColor: Colors.white,
                textColor: appPrimaryMaterialColor,
              );
            }
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
          msg: "${e}  You aren't connected to the Internet !",
          backgroundColor: Colors.white,
          textColor: appPrimaryMaterialColor,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(" Create Ad"),
          centerTitle: true,
          backgroundColor: constant.appPrimaryMaterialColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              // bottom: Radius.circular(10),
            ),
          ),
        ),
        body: isLoading
            ? Container(
          child: Center(child: CircularProgressIndicator()),
        )
            : Form(
          key: _formkey,
          child: Column(
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(top: 8, right: 8, left: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 15.0, right: 5.0, left: 5.0),
                          child: Row(
                            children: <Widget>[
                              Text("Advertisement Title*",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w500))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 5.0, right: 5.0, top: 6.0),
                          child: SizedBox(
                            height: 50,
                            child: TextFormField(
                              validator: (value) {
                                if (value.trim() == "") {
                                  return 'Please Enter Title';
                                }
                                return null;
                              },
                              controller: edtTitle,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                  border: new OutlineInputBorder(
                                    borderRadius:
                                    new BorderRadius.circular(5.0),
                                    borderSide: new BorderSide(),
                                  ),
                                  labelText: "Enter Name",
                                  hintStyle: TextStyle(fontSize: 13)),
                            ),
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.only(
                        //       top: 15.0, right: 5.0, left: 5.0),
                        //   child: Row(
                        //     children: <Widget>[
                        //       Text("Tag Line*",
                        //           style: TextStyle(
                        //               fontSize: 15,
                        //               color: Colors.grey[600],
                        //               fontWeight: FontWeight.w500))
                        //     ],
                        //   ),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.only(
                        //       left: 5.0, right: 5.0, top: 6.0),
                        //   child: SizedBox(
                        //     child: TextFormField(
                        //       validator: (value) {
                        //         if (value.trim() == "") {
                        //           return 'Please Enter Tag Line';
                        //         }
                        //         return null;
                        //       },
                        //       controller: edtTagLine,
                        //       textInputAction: TextInputAction.next,
                        //       // maxLines: 4,
                        //       keyboardType: TextInputType.multiline,
                        //       decoration: InputDecoration(
                        //           border: new OutlineInputBorder(
                        //             borderRadius:
                        //                 new BorderRadius.circular(5.0),
                        //             borderSide: new BorderSide(),
                        //           ),
                        //           labelText: "Enter Tag Line",
                        //           hintStyle: TextStyle(fontSize: 13)),
                        //     ),
                        //   ),
                        // ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 15.0, right: 5.0, left: 5.0),
                          child: Row(
                            children: <Widget>[
                              Text("Description*",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w500))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 5.0, right: 5.0, top: 6.0),
                          child: SizedBox(
                            child: TextFormField(
                              validator: (value) {
                                if (value.trim() == "") {
                                  return 'Please Enter Description';
                                }
                                return null;
                              },
                              controller: edtDescription,
                              textInputAction: TextInputAction.next,
                              maxLines: 4,
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                  border: new OutlineInputBorder(
                                    borderRadius:
                                    new BorderRadius.circular(5.0),
                                    borderSide: new BorderSide(),
                                  ),
                                  labelText: "Enter Description",
                                  hintStyle: TextStyle(fontSize: 13)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 15.0, right: 5.0, left: 5.0),
                          child: Row(
                            children: <Widget>[
                              Text("Contact*",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w500))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 5.0, right: 5.0, top: 6.0),
                          child: SizedBox(
                            child: TextFormField(
                              validator: (value) {
                                if (value.trim() == "") {
                                  return 'Please Enter Contact';
                                }
                                return null;
                              },
                              controller: edtContact,
                              textInputAction: TextInputAction.next,
                              maxLength: 10,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  border: new OutlineInputBorder(
                                    borderRadius:
                                    new BorderRadius.circular(5.0),
                                    borderSide: new BorderSide(),
                                  ),
                                  labelText: "Enter Contact",
                                  hintStyle: TextStyle(fontSize: 13)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 15.0, right: 5.0, left: 5.0),
                          child: Text("Location",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 5.0, left: 5.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 5.0, right: 5),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 5.0,
                                            right: 5.0,
                                            left: 5.0),
                                        child: Text(
                                          "Lat",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600],
                                              fontWeight:
                                              FontWeight.w500),
                                        ),
                                      ),
                                      Flexible(
                                        child: TextFormField(
                                          validator: (value) {
                                            if (value.trim() == "") {
                                              return 'Please Enter Lat';
                                            }
                                            return null;
                                          },
                                          controller: edtLat,
                                          textInputAction:
                                          TextInputAction.next,
                                          keyboardType:
                                          TextInputType.number,
                                          decoration: InputDecoration(
                                              border:
                                              new OutlineInputBorder(
                                                borderRadius:
                                                new BorderRadius
                                                    .circular(5.0),
                                                borderSide:
                                                new BorderSide(),
                                              ),
                                              labelText: "Enter Lat",
                                              hintStyle: TextStyle(
                                                  fontSize: 13)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 5.0, right: 5),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 5.0,
                                            right: 5.0,
                                            left: 5.0),
                                        child: Text(
                                          "Long",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600],
                                              fontWeight:
                                              FontWeight.w500),
                                        ),
                                      ),
                                      Flexible(
                                        child: TextFormField(
                                          validator: (value) {
                                            if (value.trim() == "") {
                                              return 'Please Enter Long';
                                            }
                                            return null;
                                          },
                                          controller: edtLong,
                                          textInputAction:
                                          TextInputAction.next,
                                          keyboardType:
                                          TextInputType.number,
                                          decoration: InputDecoration(
                                              border:
                                              new OutlineInputBorder(
                                                borderRadius:
                                                new BorderRadius
                                                    .circular(5.0),
                                                borderSide:
                                                new BorderSide(),
                                              ),
                                              labelText: "Enter Long",
                                              hintStyle: TextStyle(
                                                  fontSize: 13)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 15.0, right: 5.0, left: 5.0),
                          child: Row(
                            children: <Widget>[
                              Text("Website URL",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w500))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 5.0, right: 5.0, top: 6.0),
                          child: Container(
                            height: 55,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding:
                                  const EdgeInsets.only(left: 8.0),
                                  child: TextFormField(
                                    // readOnly: true,
                                    controller: edtWebsiteURL,
                                    decoration: InputDecoration(
                                      hintText: "URL",
                                      hintStyle: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[400]),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1,
                                    color:
                                    constant.appPrimaryMaterialColor),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(6.0))),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 15.0, right: 5.0, left: 5.0),
                          child: Row(
                            children: <Widget>[
                              Text("E-Mail",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w500))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 5.0, right: 5.0, top: 6.0),
                          child: Container(
                            height: 55,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding:
                                  const EdgeInsets.only(left: 8.0),
                                  child: TextFormField(
                                    // readOnly: true,
                                    controller: edtEmail,
                                    decoration: InputDecoration(
                                      hintText: "Enter E-Mail",
                                      hintStyle: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[400]),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1,
                                    color:
                                    constant.appPrimaryMaterialColor),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(6.0))),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 15.0, right: 5.0, left: 5.0),
                          child: Row(
                            children: <Widget>[
                              Text("Youtube Video Link",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w500))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 5.0, right: 5.0, top: 6.0),
                          child: Container(
                            height: 55,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding:
                                  const EdgeInsets.only(left: 8.0),
                                  child: TextFormField(
                                    // readOnly: true,
                                    controller: edtVideoLink,
                                    decoration: InputDecoration(
                                      hintText:
                                      "Enter Youtube Video Link",
                                      hintStyle: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[400]),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1,
                                    color:
                                    constant.appPrimaryMaterialColor),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(6.0))),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 15.0, right: 8.0, left: 8.0),
                          child: Row(
                            children: <Widget>[
                              Text("Select Photo",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w500))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 5.0, right: 8.0, left: 8.0),
                          child: Text("1280x622 px",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: loadAssets,
                            child: Container(
                              height: 150,
                              child: DottedBorder(
                                  color: Colors.grey,
                                  dashPattern: [4],
                                  padding: EdgeInsets.all(6.0),
                                  child: BuildGridView()),
                            ),
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Radio(
                                value: "TOP",
                                autofocus: true,
                                groupValue: Type,
                                onChanged: (value) {
                                  setState(() {
                                    typeSelected = true;
                                    Type = value;
                                  });
                                  print("Radio $value");
                                }),
                            Text(
                              "Top",
                              style: TextStyle(
                                  fontSize: 14, color: Colors.black),
                            ),
                            Radio(
                              value: "BOTTOM",
                              onChanged: (value) {
                                setState(() {
                                  Type = value;
                                  typeSelected = false;
                                });
                                print("Radio $value");
                              },
                              groupValue: Type,
                            ),
                            Text(
                              "Bottom",
                              style: TextStyle(
                                  fontSize: 14, color: Colors.black),
                            ),
                            Radio(
                              value: "BOTH",
                              onChanged: (value) {
                                setState(() {
                                  Type = value;
                                  typeSelected = false;
                                });
                                print("Radio $value");
                              },
                              groupValue: Type,
                            ),
                            Text(
                              "Both",
                              style: TextStyle(
                                  fontSize: 14, color: Colors.black),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  _UpdatePost();
                                },
                                child: Container(
                                  margin: EdgeInsets.all(7),
                                  padding:
                                  EdgeInsets.symmetric(vertical: 13),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(5),
                                      color: constant
                                          .appPrimaryMaterialColor),
                                  child: Text(
                                    "Update Advertise",
                                    // "Pay Now ${constant.Inr_Rupee}",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
