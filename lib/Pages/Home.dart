import 'dart:io';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsocietyadvertisement/Common/Services.dart';
import 'package:smartsocietyadvertisement/Common/constant.dart' as cnst;
import 'package:smartsocietyadvertisement/Common/constant.dart';
import 'package:smartsocietyadvertisement/Component/ViewAdComponent.dart';
import 'package:smartsocietyadvertisement/Component/ViewAdvertisementComponent.dart';
import 'package:smartsocietyadvertisement/Screens/AdvertisementCreate.dart';
import 'package:smartsocietyadvertisement/Screens/Offers.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {


  String barcode = "";
  String Id, AdvertisementId, MemberId, AdvertiserId;
  var Price;
  var ads;
  var AdList;
  List ScannedList = [];
  List Advertise = [];
  ProgressDialog pr;
  bool isLoading = true;
  DateTime currentBackPressTime;
  TabController _tabController;
  ScrollController scrollController;
  bool dialVisible = true;

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

  void setDialVisible(bool value) {
    setState(() {
      dialVisible = value;
    });
  }

  Widget buildBody() {
    return ListView.builder(
      controller: scrollController,
      itemCount: 1,
      itemBuilder: (ctx, i) => ListTile(title: Text('Item $i')),
    );
  }

  @override
  void initState() {
    _getAdList();
    _getAdvertise();
    // GetScannedAd();
    _tabController = new TabController(vsync: this, length: 2);
    scrollController = ScrollController()
      ..addListener(() {
        setDialVisible(scrollController.position.userScrollDirection ==
            ScrollDirection.forward);
      });
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

    handleScroll();
  }

  @override
  void dispose() {
    _scrollController.removeListener(() {});
    super.dispose();
  }

  ScrollController _scrollController = new ScrollController(); // set controller on scrolling
  bool _show = true;

  void showFloationButton() {
    setState(() {
      _show = true;
    });
  }

  void hideFloationButton() {
    setState(() {
      _show = false;
    });
  }

  void handleScroll() async {
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        hideFloationButton();
      }
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        showFloationButton();
      }
    });
  }

  GetScannedAd() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        String advertiserId =
        await preferences.getString(cnst.Session.VendorId);
        Future res = Services.GetAdScanData(advertiserId);
        setState(() {
          isLoading = true;
        });
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              ScannedList = data;
              isLoading = false;
            });

            print("Scanned Details =>" + ScannedList.toString());
          } else {
            setState(() {
              ScannedList = [];
              isLoading = false;
            });
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          print("Error : on GetAd Data Call $e");
          showMsg("$e");
        });
      } else {
        showMsg("Something went Wrong!");
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  _getAdList() async {
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
        var body = {"vendorId": ven};
        Services.responseHandler(apiName: "adsVendor/getDeals", body: body)
            .then((responseData) {
          if (responseData.Data.length > 0) {
            print('Message:' + responseData.Message.toString());
            Fluttertoast.showToast(msg: responseData.Message.toString());
            print(responseData.Data);
            setState(() {
              isLoading = false;
              print(responseData.Data);
              AdList = responseData.Data;
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
        msg: "You aren't connected to the Internet ! !",
        backgroundColor: Colors.white,
        textColor: appPrimaryMaterialColor,
      );
    }
    // try {
    //   final result = await InternetAddress.lookup('google.com');
    //   if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
    //     SharedPreferences preferences = await SharedPreferences.getInstance();
    //     String id = await preferences.getString(cnst.Session.Id);
    //     Future res = Services.GetAdvertisement(id);
    //     setState(() {
    //       isLoading = true;
    //     });
    //     res.then((data) async {
    //       if (data != null && data.length > 0) {
    //         setState(() {
    //           AdList = data;
    //           isLoading = false;
    //         });
    //         print("Ad-DATA =>" + AdList.toString());
    //       } else {
    //         setState(() {
    //           AdList = [];
    //           isLoading = false;
    //         });
    //       }
    //     }, onError: (e) {
    //       setState(() {
    //         isLoading = false;
    //       });
    //       print("Error : on GetAd Data Call $e");
    //       showMsg("$e");
    //     });
    //   } else {
    //     showMsg("Something went Wrong!");
    //   }
    // } on SocketException catch (_) {
    //   showMsg("No Internet Connection.");
    // }
  }

  _getAdvertise() async {
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
        var body = {"vendorId": ven};
        Services.responseHandler(
            apiName: "adsVendor/getVendorAdvertise", body: body)
            .then((responseData) {
          if (responseData.Data.length > 0) {
            print('Message:' + responseData.Message.toString());
            Fluttertoast.showToast(msg: responseData.Message.toString());
            print(responseData.Data);
            setState(() {
              isLoading = false;
              print(responseData.Data);
              Advertise = responseData.Data;
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
        msg: "You aren't connected to the Internet ! !",
        backgroundColor: Colors.white,
        textColor: appPrimaryMaterialColor,
      );
    }
    // try {
    //   final result = await InternetAddress.lookup('google.com');
    //   if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
    //     SharedPreferences preferences = await SharedPreferences.getInstance();
    //     String id = await preferences.getString(cnst.Session.Id);
    //     Future res = Services.GetAdvertisement(id);
    //     setState(() {
    //       isLoading = true;
    //     });
    //     res.then((data) async {
    //       if (data != null && data.length > 0) {
    //         setState(() {
    //           AdList = data;
    //           isLoading = false;
    //         });
    //         print("Ad-DATA =>" + AdList.toString());
    //       } else {
    //         setState(() {
    //           AdList = [];
    //           isLoading = false;
    //         });
    //       }
    //     }, onError: (e) {
    //       setState(() {
    //         isLoading = false;
    //       });
    //       print("Error : on GetAd Data Call $e");
    //       showMsg("$e");
    //     });
    //   } else {
    //     showMsg("Something went Wrong!");
    //   }
    // } on SocketException catch (_) {
    //   showMsg("No Internet Connection.");
    // }
  }

  _advertiseScan() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        pr.show();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var data = {
          "Id": 0,
          "AdvertisementId": AdvertisementId,
          "MemberId": MemberId,
          "Price": Price,
          "AdvertiserId": prefs.getString(cnst.Session.VendorId),
        };

        print("Add Scanned Data = ${data}");
        Services.AdvertiseScan(data).then((data) async {
          pr.hide();

          if (data.Data != "0" && data.IsSuccess == true) {
            Fluttertoast.showToast(
                msg: "Data Added Successfully",
                textColor: Colors.black,
                gravity: ToastGravity.TOP,
                backgroundColor: Colors.green,
                toastLength: Toast.LENGTH_LONG);

            Navigator.pushNamedAndRemoveUntil(
                context, "/Dashboard", (Route<dynamic> route) => false);
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

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      var qrtext = barcode.toString().split(",");
      print("QR Text: ${barcode}");
      //&& qrtext.length > 2

      if (qrtext != null) {
        setState(() {
          MemberId = qrtext[0].toString();
          AdvertisementId = qrtext[1].toString();
          Price = qrtext[2].toString();

          this.barcode = barcode;
        });
        try {
          final result = await InternetAddress.lookup('google.com');
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            _advertiseScan();
          }
        } on SocketException catch (_) {
          showMsg("No Internet Connection.");
        }
        setState(() => this.barcode = barcode);
      } else {
        showMsg("Try Again.");
      }
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() =>
      this.barcode =
      'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }

  /*Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      var qrtext = barcode.toString().split(",");
      print("QR Text: ${barcode}");
      //&& qrtext.length > 2

      if (qrtext != null) {
        setState(() {
          Id = qrtext[0].toString();
          Name = qrtext[1].toString();
          Mobile = qrtext[2].toString();

          this.barcode = barcode;
        });
        List scannedData = [
          {
            "Id": Id,
            "PersonName": Name,
            "MobileNo": Mobile,
          },
        ];
        */ /*  Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ApplyCoupon(
                  visitorData: scannedData[0],
                )));*/ /*

        setState(() => this.barcode = barcode);
      } else {
        //  showMsg("Scan Again.");
      }
    } on PlatformException catch (e) {
      print("Error");
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => this.barcode =
          'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }*/

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
        backgroundColor: cnst.appPrimaryMaterialColor,
        title: Text("Home"),
        centerTitle: true,
        // actions: <Widget>[
          // Padding(
          //   padding: const EdgeInsets.only(right: 15.0),
          //   child: InkWell(
          //     onTap: () {
          //       scan();
          //     },
          //     child: Image.asset(
          //       "images/QrCode.png",
          //       color: Colors.white,
          //       width: 25,
          //       height: 25,
          //     ),
          //   ),
          // ),
          /*  GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, "/Notifications");
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0, left: 10.0),
              child: Icon(Icons.notifications),
            ),
          ),*/
        // ],
      ),
      body: WillPopScope(
        onWillPop: onWillPop,
        child: Column(
          children: <Widget>[
            TabBar(
              unselectedLabelColor: Colors.grey[500],
              indicatorColor: Colors.black,
              labelColor: Colors.black,
              controller: _tabController,
              tabs: [
                Tab(
                  child: Text(
                    "Deals",
                  ),
                ),
                Tab(
                  child: Text(
                    "Advertisements",
                  ),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  isLoading
                      ? Center(child: CircularProgressIndicator())
                      : AdList != null
                      ? ListView.builder(
                      controller: _scrollController,
                      itemCount: AdList.length,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder:
                          (BuildContext context, int index) {
                        return SingleChildScrollView(
                            padding: EdgeInsets.only(
                              bottom: 0,
                            ),
                            child: ViewAdComponent(
                                AdList[AdList.length - index - 1],
                                    () {
                                  setState(() {
                                    _getAdList();
                                  });
                                }));
                      })
                      : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                            child: Container(
                                height: 40,
                                width: 100,
                                child: LottieBuilder.asset(
                                    "assets/nodta.json"))),
                        Text(
                          "No Data Found",
                          style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  isLoading
                      ? Center(child: CircularProgressIndicator())
                      : Advertise.length > 0
                      ? ListView.builder(
                      shrinkWrap: true,
                      controller: _scrollController,
                      itemCount: Advertise.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (BuildContext context, int i) {
                        return SingleChildScrollView(
                          padding: EdgeInsets.only(
                            bottom: 0,
                          ),
                          child: ViewAdvertisementComponent(
                            Advertisemnt: Advertise[Advertise.length - i -
                                1], onChange: () {
                            setState(() {
                              _getAdvertise();
                            });
                          },),);
                      })
                      : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                            child: Container(
                                height: 40,
                                width: 100,
                                child: LottieBuilder.asset(
                                    "assets/nodta.json"))),
                        Text(
                          "No Data Found",
                          style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Visibility(
        visible: _show,
        child: SpeedDial(
          foregroundColor: Colors.white,
          backgroundColor: cnst.appPrimaryMaterialColor,
          icon: Icons.add,
          iconTheme: IconThemeData(size: 32),
          useRotationAnimation: true,
          curve: Curves.bounceIn,
          overlayColor: Colors.white10,
          shape: CircleBorder(),
          closeManually: false,
          activeIcon: Icons.highlight_off,
          children: [
            SpeedDialChild(
              child: Icon(
                Icons.add_circle_outline,
                color: Colors.white,
              ),
              backgroundColor: cnst.appPrimaryMaterialColor[800],
              label: 'Add Deal',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () {
                // Navigator.pushNamed(context, '/Offers');
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        Offers(
                          onAddOffer: _getAdList,
                        ),
                  ),
                );
              },
              onLongPress: () => Fluttertoast.showToast(msg: "Add Deal"),
            ),
            SpeedDialChild(
              child: Icon(
                Icons.add_circle_outline,
                color: Colors.white,
              ),
              backgroundColor: cnst.appPrimaryMaterialColor[700],
              label: 'Add Advertisement',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        AdvertisementCreate(
                          onChange: _getAdvertise,
                        ),
                  ),
                );
              },
            ),
            // SpeedDialChild(
            //   child: Icon(
            //     Icons.add_circle_outline,
            //     color: Colors.white,
            //   ),
            //   backgroundColor: cnst.appPrimaryMaterialColor[700],
            //   label: 'Add Services',
            //   labelStyle: TextStyle(fontSize: 18.0),
            //   onTap: () {
            //     Navigator.of(context).push(
            //       MaterialPageRoute(
            //         builder: (BuildContext context) =>
            //             AddServices(),
            //       ),
            //     );
            //   },
            // ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: IconButton(
      //     onPressed: () {
      //       // Navigator.pushNamed(context, '/Offers');
      //       Navigator.of(context).push(
      //         MaterialPageRoute(
      //           builder: (BuildContext context) => Offers(
      //             onAddOffer: _getAdList,
      //           ),
      //         ),
      //       );
      //       // Navigator.pushNamed(context, '/ContactMyjini');
      //     },
      //     icon: Icon(
      //       Icons.add,
      //       size: 32,
      //     ),
      //   ),
      //   backgroundColor: cnst.appPrimaryMaterialColor[800],
      //   onPressed: () {},
      // ),
    );
  }
}
