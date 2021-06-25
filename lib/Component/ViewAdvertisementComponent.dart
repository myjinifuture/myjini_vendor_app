import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_card_swipper/flutter_card_swiper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smartsocietyadvertisement/Common/MyExpansionTile.dart';
import 'package:smartsocietyadvertisement/Common/Services.dart';
import 'package:smartsocietyadvertisement/Common/constant.dart' as cnst;
import 'package:smartsocietyadvertisement/Pages/Home.dart';
import 'package:smartsocietyadvertisement/Screens/AddServices.dart';
import 'package:smartsocietyadvertisement/Screens/ManageService.dart';
import '../Screens/UpdateAdvertise.dart';

class ViewAdvertisementComponent extends StatefulWidget {
  var Advertisemnt;
  final Function onChange;

  ViewAdvertisementComponent({this.Advertisemnt, this.onChange});

  @override
  _ViewAdvertisementComponentState createState() =>
      _ViewAdvertisementComponentState();
}

class _ViewAdvertisementComponentState
    extends State<ViewAdvertisementComponent> {
  List images;
  bool isLoading;

  void _showConfirmDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // title: new Text("MyJINI"),
          content: new Text("Are You Sure You Want To Remove This ?"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("No",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Yes",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600)),
              onPressed: () {
                // widget.onChange();
                Navigator.of(context).pop(MaterialPageRoute(
                    builder: (BuildContext context) => Home()));
                _deleteAdvertise();
              },
            ),
          ],
        );
      },
    );
  }

  _deleteAdvertise() async {
    try {
      setState(() {
        isLoading = true;
      });
      final internetResult = await InternetAddress.lookup('google.com');
      if (internetResult.isNotEmpty &&
          internetResult[0].rawAddress.isNotEmpty) {
        var body = {"advertiseId": "${widget.Advertisemnt["_id"]}"};
        Services.responseHandler(
                apiName: "adsVendor/deleteAdvertise", body: body)
            .then((responseData) {
          if (responseData.Data == 1) {
            print('Message:' + responseData.Message.toString());
            Fluttertoast.showToast(msg: responseData.Message.toString());
            setState(() {
              isLoading = false;
              // print(isSwitched);
              widget.onChange();
            });
          } else {
            print(responseData);
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(
              msg: "${responseData.Message}",
              backgroundColor: Colors.white,
              textColor: cnst.appPrimaryMaterialColor,
            );
          }
        }).catchError((error) {
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(
            msg: "Error $error",
            backgroundColor: Colors.white,
            textColor: cnst.appPrimaryMaterialColor,
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
        textColor: cnst.appPrimaryMaterialColor,
      );
    }
    // try {
    //   final result = await InternetAddress.lookup('google.com');
    //   if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
    //     pr.show();
    //
    //     //print("Accept Payment Data = ${data}");
    //     Services.DeleteAd(widget.AdList["Id"].toString()).then((data) async {
    //       pr.hide();
    //
    //       if (data.Data != "0" && data.IsSuccess == true) {
    //         Fluttertoast.showToast(
    //             msg: "Deleted Successfully !",
    //             textColor: Colors.black,
    //             toastLength: Toast.LENGTH_LONG);
    //
    //         // showDialog(context: context, child: AcceptedDialog());
    //         widget.onChange();
    //         Navigator.pushNamedAndRemoveUntil(
    //             context, "/Dashboard", (Route<dynamic> route) => false);
    //       } else {
    //         showMsg(data.Message, title: "Error");
    //       }
    //     }, onError: (e) {
    //       pr.hide();
    //       showMsg("Try Again.");
    //     });
    //   } else
    //     showMsg("No Internet Connection.");
    // } on SocketException catch (_) {
    //   pr.hide();
    //   showMsg("No Internet Connection.");
    // }
  }

  void initState() {
    images = widget.Advertisemnt["Image"];
    print(images);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          children: [
            Stack(alignment: Alignment.topRight, children: [
              Container(
                margin: EdgeInsets.all(2),
                child: widget.Advertisemnt["Image"] != "" &&
                        widget.Advertisemnt["Image"] != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(13),
                        child: Container(
                          height: 180,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: cnst.appPrimaryMaterialColor),
                            child: FadeInImage.assetNetwork(
                              placeholder: "images/Ad1.jpg",
                              width: MediaQuery.of(context).size.width,
                              height: 150,
                              fit: BoxFit.fitWidth,
                              image: cnst.API_URL1 +
                                  widget.Advertisemnt["Image"][0],
                            ),
                          ),
                          // child: Swiper(
                          //   // containerHeight: 150,
                          //   pagination: SwiperPagination(
                          //       margin: EdgeInsets.all(2),
                          //       builder: SwiperPagination.dots),
                          //   itemBuilder: (context, index) {
                          //     return Container(
                          //         width: MediaQuery.of(context).size.width,
                          //         decoration: BoxDecoration(
                          //             color: cnst.appPrimaryMaterialColor[200]),
                          //         child: GestureDetector(
                          //             child: FadeInImage.assetNetwork(
                          //               placeholder: "images/Ad1.jpg",
                          //               width:
                          //                   MediaQuery.of(context).size.width,
                          //               height: 150,
                          //               fit: BoxFit.fitWidth,
                          //               image: cnst.API_URL1 + images[index],
                          //             ),
                          //             onTap: () {}));
                          //   },
                          //   itemCount: images.length,
                          // ),
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(13),
                        child: Image.asset(
                          "images/Ad1.jpg",
                          width: MediaQuery.of(context).size.width,
                          height: 120,
                          fit: BoxFit.fill,
                        ),
                      ),
              ),
              Container(
                margin: EdgeInsets.only(right: 6),
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UpdateAdvertise(
                                    Advertise: widget.Advertisemnt)));
                      },
                      child: Container(
                        margin: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(255, 255, 255, 1),
                            borderRadius: BorderRadius.circular(3)),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Icon(
                            Icons.edit,
                            size: 30,
                            color: cnst.appPrimaryMaterialColor[700],
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _showConfirmDialog();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(255, 255, 255, 1),
                            borderRadius: BorderRadius.circular(3)),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Icon(
                            Icons.delete,
                            size: 30,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  margin: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(13),
                        topLeft: Radius.circular(13)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ManageService(Id: widget.Advertisemnt["_id"],)));
                        },
                        child: Container(

                          width: MediaQuery.of(context).size.width * 0.4,
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(13),
                                topLeft: Radius.circular(13)),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Add Services".toUpperCase(),
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // GestureDetector(
                      //   onTap: () {
                      //     _showConfirmDialog();
                      //   },
                      //   child: Container(
                      //     decoration: BoxDecoration(
                      //         color: Color.fromRGBO(255, 255, 255, 1),
                      //         borderRadius: BorderRadius.circular(3)),
                      //     child: Padding(
                      //       padding: const EdgeInsets.all(2.0),
                      //       child: Icon(
                      //         Icons.delete,
                      //         size: 30,
                      //         color: Colors.red,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ]),
            Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: MyExpansionTile(
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "${widget.Advertisemnt["Title"]}",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      widget.Advertisemnt["AdPosition"]
                                  .toString()
                                  .toLowerCase() ==
                              'top'
                          ? Icon(
                              Icons.arrow_circle_up,
                              color: Colors.grey,
                              size: 30,
                            )
                          : widget.Advertisemnt["AdPosition"]
                                      .toString()
                                      .toLowerCase() ==
                                  'bottom'
                              ? Icon(
                                  Icons.arrow_circle_down,
                                  color: Colors.grey,
                                  size: 30,
                                )
                              : Row(
                                  children: [
                                    Icon(
                                      Icons.arrow_circle_up,
                                      color: Colors.grey,
                                      size: 30,
                                    ),
                                    Icon(
                                      Icons.arrow_circle_down,
                                      color: Colors.grey,
                                      size: 30,
                                    ),
                                  ],
                                ),
                    ],
                  ),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Theme(
                      data:
                          Theme.of(context).copyWith(dividerColor: Colors.grey),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Des: ",
                                      style: TextStyle(
                                          fontSize: 17, color: Colors.grey),
                                    ),
                                    Expanded(
                                      child: Text(
                                        "${widget.Advertisemnt["Description"]}",
                                        style: TextStyle(fontSize: 17),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "From : ",
                                          style: TextStyle(
                                              fontSize: 15, color: Colors.grey),
                                        ),
                                        Text(
                                          "${widget.Advertisemnt["dateTime"][0].toString()}",
                                          style: TextStyle(fontSize: 17),
                                        ),
                                      ],
                                    ),
                                    Divider(),
                                    Row(
                                      children: [
                                        Text(
                                          "To : ",
                                          style: TextStyle(
                                              fontSize: 15, color: Colors.grey),
                                        ),
                                        Text(
                                          "${widget.Advertisemnt["ExpiryDate"][0].toString()}",
                                          style: TextStyle(fontSize: 17),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Divider(),
                                Row(
                                  children: [
                                    // Icon(Icons.call),
                                    Text(
                                      "Contact: ",
                                      style: TextStyle(
                                          fontSize: 17, color: Colors.grey),
                                    ),
                                    Text(
                                      "${widget.Advertisemnt["ContactNo"]}",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                  ],
                                ),
                                Divider(),
                                // Row(
                                //   children: [
                                //     Text(
                                //       "isPaid: ",
                                //       style: TextStyle(
                                //           fontSize: 17, color: Colors.grey),
                                //     ),
                                //     Text(
                                //       "${widget.Advertisemnt["isPaid"]}",
                                //       style: TextStyle(fontSize: 17),
                                //     ),
                                //   ],
                                // ),
                                // Divider(),
                                Row(
                                  children: [
                                    Text(
                                      "Web: ",
                                      style: TextStyle(
                                          fontSize: 17, color: Colors.grey),
                                    ),
                                    Expanded(
                                      child: Text(
                                        "${widget.Advertisemnt["WebsiteURL"]}",
                                        style: TextStyle(fontSize: 17),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(),
                                Row(
                                  children: [
                                    Text(
                                      "Mail: ",
                                      style: TextStyle(
                                          fontSize: 17, color: Colors.grey),
                                    ),
                                    Expanded(
                                      child: Text(
                                        "${widget.Advertisemnt["EmailId"]}",
                                        style: TextStyle(fontSize: 17),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(),
                                Row(
                                  children: [
                                    Text(
                                      "Video: ",
                                      style: TextStyle(
                                          fontSize: 17, color: Colors.grey),
                                    ),
                                    Expanded(
                                      child: Text(
                                        "${widget.Advertisemnt["VideoLink"]}",
                                        style: TextStyle(fontSize: 17),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
