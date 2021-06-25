import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsocietyadvertisement/Common/ClassList.dart';
import 'package:smartsocietyadvertisement/Common/MyExpansionTile.dart';
import 'package:smartsocietyadvertisement/Common/Services.dart';
import 'package:smartsocietyadvertisement/Common/constant.dart' as cnst;
import 'package:smartsocietyadvertisement/Common/constant.dart';
import 'package:smartsocietyadvertisement/Component/ViewMemberComponent.dart';
import 'package:url_launcher/url_launcher.dart';

class More extends StatefulWidget {
  @override
  _MoreState createState() => _MoreState();
}

class _MoreState extends State<More> with TickerProviderStateMixin {
  String Id,
      Mobile,
      Name,
      Email,
      Address,
      Pincode,
      Area,
      CityId,
      state_name,
      city_name,
      StateId,
      CompanyName,
      WebsiteURL,
      YoutubeURL,
      GSTNo,
      ReferalCode;

  List<stateClass> stateClassList = [];
  stateClass _stateClass;

  List<cityClass> cityClassList = [];
  cityClass _cityClass;
  bool stateLoading = false;
  bool cityLoading = false;
  String _url = "";

  File ProfileImage;

  ProgressDialog pr;
  bool isLoading = true;
  DateTime currentBackPressTime;
  TabController _tabController;

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: "Press Back Again to Exit");
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  void initState() {
    _tabController = new TabController(vsync: this, length: 2);
    // _getdata();
    // setData();
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
    _getLocalData();
    getPaymentDetails();
  }

  getPaymentDetails() async {
    try {
      setState(() {
        isLoading = true;
      });

      final internetResult = await InternetAddress.lookup('google.com');

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String ven = prefs.getString(cnst.Session.VendorId);
      print(ven);

      if (internetResult.isNotEmpty &&
          internetResult[0].rawAddress.isNotEmpty) {
        var body = {"vendorId": "609f63d915fb300022c1589b"};
        Services.responseHandler(
                apiName: "adsVendor/getVendorPayments", body: body)
            .then((responseData) {
          if (responseData.Data.length == 1 || responseData.Data == '') {
            print('Message:' + responseData.Message.toString());
            Fluttertoast.showToast(msg: responseData.Message.toString());
            setState(() {
              isLoading = false;
              // print(isSwitched);
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
        }).catchError((error) {
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(
            msg: "Error:: $error",
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
        msg: "You aren't connected to the Internet ! !",
        backgroundColor: Colors.white,
        textColor: appPrimaryMaterialColor,
      );
    }
  }

  setData() async {
    try {
      setState(() {
        isLoading = true;
      });
      final internetResult = await InternetAddress.lookup('google.com');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (internetResult.isNotEmpty &&
          internetResult[0].rawAddress.isNotEmpty) {
        var body = {"ContactNo": "${prefs.getString(cnst.Session.Mobile)}"};
        Services.responseHandler(apiName: "adsVendor/login", body: body)
            .then((responseData) async {
          if (responseData.Data.length == 0) {
            print(responseData.Data);
            // societyList = responseData.Data;
            // Mobile=responseData.Data[0]["ContactNo"];
            setState(() {
              isLoading = false;
            });
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

          // await prefs.setString(cnst.Session.Name, txtName.text);
          // await prefs.setString(cnst.Session.Email, txtEmail.text);
          // await prefs.setString(cnst.Session.Address, txtAddress.text);
          // await prefs.setString(cnst.Session.Pincode, txtPincode.text);
          // await prefs.setString(cnst.Session.Area, txtArea.text);
          // await prefs.setString(cnst.Session.CompanyName, txtCompanyName.text);
          // await prefs.setString(cnst.Session.WebsiteURL, txtWebsite.text);
          // await prefs.setString(cnst.Session.YoutubeURL, txtYoutube.text);
          // await prefs.setString(cnst.Session.GSTNo, txtGSTNo.text);
          // await prefs.setString(cnst.Session.ReferalCode, txtReferalCode.text);
          // await prefs.setString(cnst.Session.CityId, _cityClass.id);
          // await prefs.setString(cnst.Session.StateId, _stateClass.id);
          await prefs.setString(cnst.Session.IsVerified, "true");
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

  _getdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _url = prefs.getString(cnst.Session.ProfileImage);
    });
    String name = prefs.getString(cnst.Session.ProfileImage);
    print("Meherzan =>" + name.toString());
  }

  _uploadVendorPhoto() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });

        String filename = "";
        String filePath = "";
        File compressedFile;
        if (ProfileImage != null) {
          ImageProperties properties =
              await FlutterNativeImage.getImageProperties(ProfileImage.path);

          compressedFile = await FlutterNativeImage.compressImage(
            ProfileImage.path,
            quality: 80,
            targetWidth: 600,
            targetHeight: (properties.height * 600 / properties.width).round(),
          );

          filename = ProfileImage.path.split('/').last;
          filePath = compressedFile.path;
        }

        SharedPreferences preferences = await SharedPreferences.getInstance();
        FormData data = FormData.fromMap({
          "Id": "${preferences.getString(cnst.Session.VendorId)}",
          "Image": (filePath != null && filePath != '')
              ? await MultipartFile.fromFile(filePath,
                  filename: filename.toString())
              : null,
        });

        Services.UploadVendorPhoto(data).then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data.Data != "0" && data.IsSuccess == true) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            ProfileImage != null
                ? await prefs.setString(
                    cnst.Session.ProfileImage, "${data.Data}")
                : null;
            Fluttertoast.showToast(
                msg: "Uploaded Successfully",
                toastLength: Toast.LENGTH_SHORT,
                textColor: Colors.white,
                gravity: ToastGravity.TOP);
          } else {
            showMsg(data.Message);
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

  pickImage(source) async {
    var picture = await ImagePicker.pickImage(source: source);
    this.setState(() {
      ProfileImage = picture;
    });
    Navigator.pop(context);
    //Upload comes API here
    _uploadVendorPhoto();
  }

  Future<void> _chooseProfileImage(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Make Choice"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Text("Gallery"),
                    onTap: () {
                      pickImage(ImageSource.gallery);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  GestureDetector(
                    child: Text("Camera"),
                    onTap: () {
                      pickImage(ImageSource.camera);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  _launchWebsiteURL() async {
    if (await canLaunch(WebsiteURL)) {
      await launch(WebsiteURL);
    } else {
      Fluttertoast.showToast(msg: 'Could not launch url \'$WebsiteURL\'');
    }
  }

  _launchYoutubeURL() async {
    if (await canLaunch(YoutubeURL)) {
      await launch(YoutubeURL);
    } else if (YoutubeURL == null || YoutubeURL == '') {
      Fluttertoast.showToast(msg: 'Could not launch url it\'s null');
    } else {
      Fluttertoast.showToast(msg: 'Could not launch url \'$YoutubeURL\'');
    }
  }

  _getLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // Id = prefs.getString(cnst.Session.Id);
      Name = prefs.getString(cnst.Session.Name);
      Email = prefs.getString(cnst.Session.Email);
      Mobile = prefs.getString(cnst.Session.Mobile);
      Address = prefs.getString(cnst.Session.Address);
      Pincode = prefs.getString(cnst.Session.Pincode);
      Area = prefs.getString(cnst.Session.Area);
      // CityId = prefs.getString(cnst.Session.CityId);
      // StateId = prefs.getString(cnst.Session.StateId);
      city_name = prefs.getString(cnst.Session.CityName);
      state_name = prefs.getString(cnst.Session.StateName);
      CompanyName = prefs.getString(cnst.Session.CompanyName);
      WebsiteURL = prefs.getString(cnst.Session.WebsiteURL);
      YoutubeURL = prefs.getString(cnst.Session.YoutubeURL);
      GSTNo = prefs.getString(cnst.Session.GSTNo);
      ReferalCode = prefs.getString(cnst.Session.ReferalCode);
    });
  }

  getState() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          stateLoading = true;
        });
        Future res = Services.GetState();
        SharedPreferences pres = await SharedPreferences.getInstance();
        res.then((data) async {
          setState(() {
            stateLoading = false;
          });
          if (data != null && data.length > 0) {
            setState(() {
              stateClassList = data;
            });
            String currentData = pres.getString(Session.StateId);
            print("->>>>>" + currentData);
            for (int i = 0; i < data.length; i++) {
              if (data[i].id == currentData) {
                setState(() {
                  state_name = data[i].stateName;
                });
                getCity(data[i].id.toString());
              }
            }
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

  getCity(String id) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences pres = await SharedPreferences.getInstance();
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
            String CityId = pres.getString(Session.CityId);
            for (int i = 0; i < data.length; i++) {
              if (data[i].id == CityId) {
                setState(() {
                  city_name = data[i].cityName;
                });
              }
            }
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
    var AdList = ['hope'];
    var ScannedList = ['hope'];
    return Scaffold(
        appBar: AppBar(
          backgroundColor: cnst.appPrimaryMaterialColor,
          title: Text("Profile"),
          centerTitle: true,
        ),
        body: WillPopScope(
          onWillPop: onWillPop,
          child: Column(
            children: [
              TabBar(
                unselectedLabelColor: Colors.grey[500],
                indicatorColor: Colors.black,
                labelColor: Colors.black,
                controller: _tabController,
                tabs: [
                  Tab(
                    child: Text(
                      "Personal",
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Business",
                    ),
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Stack(
                                  children: <Widget>[
                                    ClipOval(
                                        child: ProfileImage != null
                                            ? Image.file(
                                                ProfileImage,
                                                width: 80,
                                                height: 80,
                                                fit: BoxFit.fill,
                                              )
                                            : _url != "" && _url != null
                                                ? FadeInImage.assetNetwork(
                                                    placeholder:
                                                        "images/man.png",
                                                    width: 80,
                                                    height: 80,
                                                    fit: BoxFit.fill,
                                                    image: "${cnst.IMG_URL}" +
                                                        _url)
                                                : Image.asset(
                                                    "images/man.png",
                                                    width: 80,
                                                    height: 80,
                                                    fit: BoxFit.fill,
                                                  )),
                                    Positioned(
                                        top: MediaQuery.of(context).size.width /
                                            7.9,
                                        left:
                                            MediaQuery.of(context).size.width /
                                                8.0,
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.add_a_photo,
                                            color: Colors.grey[600],
                                          ),
                                          onPressed: () {
                                            _chooseProfileImage(context);
                                          },
                                        )),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "${Name}",
                                  style: TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            thickness: 1,
                          ),
                          Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Mobile",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "${Mobile}",
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                  ),
                                ],
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                              ),
                              Divider(),
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Email",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "${Email}",
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                  ),
                                ],
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                              ),
                              Divider(
                                thickness: 1,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          ExpansionTile(
                            title: Text('Business Detatils'),
                            children: [
                              Column(
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "Company Name",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "${CompanyName}",
                                              style: TextStyle(
                                                  color: Colors.grey[600]),
                                            ),
                                          ),
                                        ],
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                      ),
                                      Divider(),
                                      Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "Gst No",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "${GSTNo}",
                                              style: TextStyle(
                                                  color: Colors.grey[600]),
                                            ),
                                          ),
                                        ],
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                      ),

                                      Divider(),
                                      Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "Address",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "${Address}",
                                              style: TextStyle(
                                                  color: Colors.grey[600]),
                                            ),
                                          ),
                                        ],
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                      ),
                                      Divider(),
                                      Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "State",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "${state_name}",
                                              style: TextStyle(
                                                  color: Colors.grey[600]),
                                            ),
                                          ),
                                        ],
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                      ),
                                      Divider(),
                                      Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "City",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "${city_name}",
                                              style: TextStyle(
                                                  color: Colors.grey[600]),
                                            ),
                                          ),
                                        ],
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                      ),
                                      Divider(),
                                      // Row(
                                      //   children: <Widget>[
                                      //     Padding(
                                      //       padding: const EdgeInsets.all(8.0),
                                      //       child: Text(
                                      //         "Area",
                                      //         style: TextStyle(fontWeight: FontWeight.w600),
                                      //       ),
                                      //     ),
                                      //     Padding(
                                      //       padding: const EdgeInsets.all(8.0),
                                      //       child: Text(
                                      //         "${Area}",
                                      //         style: TextStyle(color: Colors.grey[600]),
                                      //       ),
                                      //     ),
                                      //   ],
                                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      // ),
                                      // Divider(),
                                      Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "Pincode",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "${Pincode}",
                                              style: TextStyle(
                                                  color: Colors.grey[600]),
                                            ),
                                          ),
                                        ],
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                      ),
                                      Divider(),

                                      Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "Website Link",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: GestureDetector(
                                                onTap: () {
                                                  _launchWebsiteURL();
                                                },
                                                child: Image.asset(
                                                  "images/website.png",
                                                  width: 30,
                                                  height: 30,
                                                )),

                                            /*Text(
                                  "${WebsiteURL}",
                                  style: TextStyle(color: Colors.grey[600]),
                                ),*/
                                          ),
                                        ],
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                      ),
                                      Divider(),
                                      Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "Youtube Link",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: GestureDetector(
                                              onTap: () {
                                                _launchYoutubeURL();
                                              },
                                              child: Image.asset(
                                                "images/youtube.png",
                                                width: 30,
                                                height: 30,
                                              ),
                                            ),

                                            /*Text(
                                  "${WebsiteURL}",
                                  style: TextStyle(color: Colors.grey[600]),
                                ),*/
                                          ),
                                        ],
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Divider(),
                          ExpansionTile(
                            title: Text('Payment Details'),
                            children: [
                              Column(
                                children: [
                                  // Divider(
                                  //   thickness: 1,
                                  // ),
                                  Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Payment Date",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "17/05/2021",
                                          // "${Pincode}",
                                          style: TextStyle(
                                              color: Colors.grey[600]),
                                        ),
                                      ),
                                    ],
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                  ),
                                  Divider(),
                                  Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Payment Id",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "dscmdAdCS541X215ASX",
                                          // "${Pincode}",
                                          style: TextStyle(
                                              color: Colors.grey[600]),
                                        ),
                                      ),
                                    ],
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                  ),
                                  Divider(),
                                  Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Amount",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "111111",
                                          // "${Pincode}",
                                          style: TextStyle(
                                              color: Colors.grey[600]),
                                        ),
                                      ),
                                    ],
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                  ),
                                  Divider(),
                                  Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "InvoiceNo",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "INVOICE-304493",
                                          // "${Pincode}",
                                          style: TextStyle(
                                              color: Colors.grey[600]),
                                        ),
                                      ),
                                    ],
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                  ),
                                  Divider(),
                                  Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Account No:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "11515254524151",
                                          // "${Pincode}",
                                          style: TextStyle(
                                              color: Colors.grey[600]),
                                        ),
                                      ),
                                    ],
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                  ),
                                  Divider(),
                                  Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "OrderId",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "45ads1x5a1sd",
                                          // "${Pincode}",
                                          style: TextStyle(
                                              color: Colors.grey[600]),
                                        ),
                                      ),
                                    ],
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                  ),
                                  Divider(),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
