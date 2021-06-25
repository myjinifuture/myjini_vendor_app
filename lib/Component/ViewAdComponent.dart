import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swipper/flutter_card_swiper.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsocietyadvertisement/Common/MyExpansionTile.dart';
import 'package:smartsocietyadvertisement/Common/Services.dart';
import 'package:smartsocietyadvertisement/Common/constant.dart' as cnst;

// import 'package:smartsocietyadvertisement/Common/constant.dart';
import 'package:smartsocietyadvertisement/Pages/Home.dart';
import 'package:smartsocietyadvertisement/Screens/UpdateAdScreen.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:weekday_selector/weekday_selector.dart';

class ViewAdComponent extends StatefulWidget {
  var AdList;
  final Function onChange;

  ViewAdComponent(this.AdList, this.onChange);

  @override
  _ViewAdComponentState createState() => _ViewAdComponentState();
}

class _ViewAdComponentState extends State<ViewAdComponent> {
  ProgressDialog pr;
  bool isLoading = false;
  bool isSwitched = false;
  bool visibility = false;
  List images;

  _publishedStatus() async {
    try {
      setState(() {
        isLoading = true;
      });
      final internetResult = await InternetAddress.lookup('google.com');
      if (internetResult.isNotEmpty &&
          internetResult[0].rawAddress.isNotEmpty) {
        var body = {"memberId": cnst.Session.VendorId};
        Services.responseHandler(apiName: "member/getInvoiceNo", body: body)
            .then((responseData) {
          if (responseData.Data.length == 0) {
            // print(responseData.IsSuccess);
            // print(responseData.Message);
            // print('--');
            setState(() {
              isLoading = false;
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
        msg: "You aren't connected to the Internet !",
        backgroundColor: Colors.white,
        textColor: cnst.appPrimaryMaterialColor,
      );
    }
  }

  isPublish() async {
    await setState(() {
      isSwitched = widget.AdList["isActive"];
      // print(isSwitched);
    });
  }

  _publish() async {
    try {
      setState(() {
        isLoading = true;
      });
      final internetResult = await InternetAddress.lookup('google.com');
      if (internetResult.isNotEmpty &&
          internetResult[0].rawAddress.isNotEmpty) {
        var body = {"dealId": widget.AdList["_id"], "isActive": !isSwitched};
        Services.responseHandler(
                apiName: "adsVendor/updateDealStatus", body: body)
            .then((responseData) {
          if (responseData.Data == 1) {
            print('Message:' + responseData.Message.toString());
            Fluttertoast.showToast(msg: responseData.Message.toString());
            setState(() {
              isLoading = false;
              isSwitched = !isSwitched;
              print("deal Id");
              print(widget.AdList["_id"].toString());
              print(isSwitched);
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
    // value=isSwitched;
  }

  @override
  void initState() {
    images = widget.AdList["Image"];
    print(images);
    isPublish();
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(
        message: "Please Wait",
        borderRadius: 10.0,
        progressWidget: Container(
          padding: EdgeInsets.all(15),
          child: CircularProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(cnst.appPrimaryMaterialColor),
          ),
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w600));
    // TODO: implement initState
    super.initState();
    // _publishedStatus();
  }

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
                widget.onChange();
                Navigator.of(context).pop(MaterialPageRoute(
                    builder: (BuildContext context) => Home()));
                _deleteAd();
              },
            ),
          ],
        );
      },
    );
  }

  _deleteAd() async {
    try {
      setState(() {
        isLoading = true;
      });
      final internetResult = await InternetAddress.lookup('google.com');
      if (internetResult.isNotEmpty &&
          internetResult[0].rawAddress.isNotEmpty) {
        var body = {"dealId": "${widget.AdList["_id"]}"};
        Services.responseHandler(apiName: "adsVendor/deleteDeal", body: body)
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
    return Padding(
      padding:
          const EdgeInsets.all(8),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(alignment: Alignment.topRight, children: [
              Container(
                margin: EdgeInsets.all(2),
                child: widget.AdList["Image"] != "" &&
                        widget.AdList["Image"] != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(13),
                        child: Container(
                          height: 180,
                          child: Swiper(
                            // containerHeight: 150,
                            autoplay: true,
                            autoplayDelay: 5000,
                            pagination: SwiperPagination(margin: EdgeInsets.all(2),builder: SwiperPagination.dots),
                            itemBuilder: (context, index) {
                              return Container(
                                              width: MediaQuery.of(context).size.width,
                                              decoration: BoxDecoration(
                                                  color: cnst.appPrimaryMaterialColor),
                                              child: GestureDetector(
                                                  child: FadeInImage.assetNetwork(
                                                    placeholder: "images/Ad1.jpg",
                                                    width: MediaQuery.of(context).size.width,
                                                    height: 150,
                                                    fit: BoxFit.fitWidth,
                                                    image: cnst.API_URL1 + images[index],
                                                  ),
                                                  onTap: () {}));
                            },
                            itemCount: images.length,
                          ),
                        ),
                        // child: CarouselSlider(
                        //   options: CarouselOptions(
                        //     height: 150.0,
                        //     // aspectRatio: 16/9,
                        //     autoPlayInterval: Duration(seconds: 5),
                        //     viewportFraction: 0.8,
                        //     autoPlayAnimationDuration:
                        //         Duration(milliseconds: 1000),
                        //     autoPlay: true,
                        //     autoPlayCurve: Curves.fastOutSlowIn,
                        //     scrollDirection: Axis.horizontal,
                        //     // enlargeCenterPage: true,
                        //   ),
                        //   items: images.map((i) {
                        //     return Builder(
                        //       builder: (BuildContext context) {
                        //         return Container(
                        //             // width: MediaQuery.of(context).size.width+50,
                        //             // margin:
                        //             //     EdgeInsets.symmetric(horizontal: 1.0),
                        //             decoration: BoxDecoration(
                        //                 color:
                        //                     cnst.appPrimaryMaterialColor[500]),
                        //             child: FadeInImage.assetNetwork(
                        //               placeholder: "images/Ad1.jpg",
                        //               width: MediaQuery.of(context).size.width +
                        //                   1000,
                        //               height: 150,
                        //               fit: BoxFit.fitWidth,
                        //               image: cnst.API_URL1 + i,
                        //             ));
                        //       },
                        //     );
                        //   }).toList(),
                        // ),
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
              // CarouselSlider(
              //   options: CarouselOptions(height: 150.0),
              //   items: images.map((i) {
              //     return Builder(
              //       builder: (BuildContext context) {
              //         return Container(
              //             width: MediaQuery.of(context).size.width,
              //             margin: EdgeInsets.symmetric(horizontal: 5.0),
              //             decoration: BoxDecoration(
              //                 color: cnst.appPrimaryMaterialColor[200]),
              //             child: GestureDetector(
              //                 child: FadeInImage.assetNetwork(
              //                   placeholder: "images/Ad1.jpg",
              //                   width: MediaQuery.of(context).size.width,
              //                   height: 150,
              //                   fit: BoxFit.fitWidth,
              //                   image: cnst.API_URL1 + i,
              //                 ),
              //                 onTap: () {}));
              //       },
              //     );
              //   }).toList(),
              // ),
              Container(
                margin: EdgeInsets.only(right: 6),
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        //Navigator.pushNamed(context, "/UpdateAdScreen");
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    UpdateAdScreen(widget.AdList)));
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
            ]),
            Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: MyExpansionTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "${widget.AdList["DealName"]}",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            " " +
                                cnst.Inr_Rupee +
                                "${widget.AdList["ActualPrice"]} ",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[400],
                                decoration: TextDecoration.lineThrough),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            cnst.Inr_Rupee + "${widget.AdList["OfferPrice"]} ",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.greenAccent[700]),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                  height: 30,
                                  width: 30,
                                  child: Image.asset("assets/offer.png")),
                              Text(
                                "${widget.AdList["Discount"]}%",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8, right: 8, left: 8),
                    child: TextFieldTags(
                      initialTags: List<String>.from(widget.AdList["Keywords"]),
                      tagsStyler: TagsStyler(
                          tagTextStyle: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                          tagCancelIcon: Icon(Icons.cancel_rounded,
                              size: 0.0, color: Colors.transparent),
                          tagPadding: const EdgeInsets.all(10.0),
                          showHashtag: true,
                          tagDecoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Color.fromRGBO(134, 34, 169, .7))),
                      textFieldStyler: TextFieldStyler(
                          textFieldEnabled: false,
                          helperStyle: TextStyle(
                            fontSize: 0,
                          )),
                      onTag: (tag) {},
                      onDelete: (tag) {},
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            "Start: ${widget.AdList["StartDate"][0].toString()}"),
                        Text(
                            "End: ${widget.AdList["ExpiryDate"][0].toString()}"),
                      ],
                    ),
                  ),
                  Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.transparent),
                    child: MyExpansionTile(
                        title: Container(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: Stack(
                            children: [
                              WeekdaySelector(
                                // onChanged: null,
                                values: [
                                  widget.AdList["weekSchedule"]["Sunday"]
                                      ["Active"],
                                  widget.AdList["weekSchedule"]["Monday"]
                                      ["Active"],
                                  widget.AdList["weekSchedule"]["Tuesday"]
                                      ["Active"],
                                  widget.AdList["weekSchedule"]["Wednesday"]
                                      ["Active"],
                                  widget.AdList["weekSchedule"]["Thursday"]
                                      ["Active"],
                                  widget.AdList["weekSchedule"]["Friday"]
                                      ["Active"],
                                  widget.AdList["weekSchedule"]["Saturday"]
                                      ["Active"]
                                ],
                                selectedFillColor:
                                    Color.fromRGBO(134, 34, 169, .9),
                                selectedTextStyle:
                                    TextStyle(fontWeight: FontWeight.bold),
                                textStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              Container(
                                width: 400,
                                height: 50,
                                color: Colors.transparent,
                              ),
                            ],
                          ),
                        ),
                        tilePadding: EdgeInsets.all(0),
                        children: [
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: .0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          'Mon:'.toUpperCase(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          'Tue:'.toUpperCase(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          'Wed:'.toUpperCase(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          'Thu:'.toUpperCase(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          'Fri:'.toUpperCase(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          'Sat:'.toUpperCase(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          'Sun:'.toUpperCase(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              widget.AdList["weekSchedule"]
                                                  ["Monday"]["StartTime"],
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text("-"),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              widget.AdList["weekSchedule"]
                                                  ["Monday"]["EndTime"],
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              widget.AdList["weekSchedule"]
                                                  ["Tuesday"]["StartTime"],
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text("-"),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              widget.AdList["weekSchedule"]
                                                  ["Tuesday"]["EndTime"],
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              widget.AdList["weekSchedule"]
                                                  ["Wednesday"]["StartTime"],
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text("-"),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              widget.AdList["weekSchedule"]
                                                  ["Wednesday"]["EndTime"],
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              widget.AdList["weekSchedule"]
                                                  ["Thursday"]["StartTime"],
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text("-"),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              widget.AdList["weekSchedule"]
                                                  ["Thursday"]["EndTime"],
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              widget.AdList["weekSchedule"]
                                                  ["Friday"]["StartTime"],
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text("-"),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              widget.AdList["weekSchedule"]
                                                  ["Friday"]["EndTime"],
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              widget.AdList["weekSchedule"]
                                                  ["Saturday"]["StartTime"],
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text("-"),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              widget.AdList["weekSchedule"]
                                                  ["Saturday"]["EndTime"],
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              widget.AdList["weekSchedule"]
                                                  ["Sunday"]["StartTime"],
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text("-"),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              widget.AdList["weekSchedule"]
                                                  ["Sunday"]["EndTime"],
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ]),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Offer Type: " +
                          "${widget.AdList["OfferType"] ? "OneTime" : "Multiple"}",
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  // Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Category: " +
                          "${widget.AdList["DealCategoryIs"][0]["DealCategoryName"]}",
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  // Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Link : " + "${widget.AdList["DealLink"]}",
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  // Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Description: " + "${widget.AdList["Description"]}",
                      style: TextStyle(fontSize: 15),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  // Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Terms & Conditions: ${widget.AdList["TermsAndCondition"]}",
                      style: TextStyle(fontSize: 15),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  Divider(
                    height: 1,
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(left:8.0,right: 20,bottom: 0,top: 8),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       Text('Status:',style: TextStyle(fontSize: 15),),
                  //       Text("${widget.AdList["status"]}",style: TextStyle(color: Colors.grey),),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(top: 8, right: 8, left: 8),
            //   child: TextFieldTags(
            //     initialTags: List<String>.from(widget.AdList["Keywords"]),
            //     tagsStyler: TagsStyler(
            //         tagTextStyle: TextStyle(
            //             fontWeight: FontWeight.bold, color: Colors.white),
            //         tagCancelIcon: Icon(Icons.cancel_rounded,
            //             size: 0.0, color: Colors.transparent),
            //         tagPadding: const EdgeInsets.all(10.0),
            //         showHashtag: true,
            //         tagDecoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(4),
            //             color: Color.fromRGBO(134, 34, 169, .7))),
            //     textFieldStyler: TextFieldStyler(
            //         textFieldEnabled: false,
            //         helperStyle: TextStyle(
            //           fontSize: 0,
            //         )),
            //     onTag: (tag) {},
            //     onDelete: (tag) {},
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(10.0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Text("Start: ${widget.AdList["StartDate"][0].toString()}"),
            //       Text("End: ${widget.AdList["ExpiryDate"][0].toString()}"),
            //     ],
            //   ),
            // ),
            // Theme(
            //   data:
            //       Theme.of(context).copyWith(dividerColor: Colors.transparent),
            //   child: MyExpansionTile(
            //       title: Container(
            //         padding: const EdgeInsets.only(left: 8, right: 8),
            //         child: Stack(
            //           children: [
            //             WeekdaySelector(
            //               // onChanged: null,
            //               values: [
            //                 widget.AdList["weekSchedule"]["Sunday"]["Active"],
            //                 widget.AdList["weekSchedule"]["Monday"]["Active"],
            //                 widget.AdList["weekSchedule"]["Tuesday"]["Active"],
            //                 widget.AdList["weekSchedule"]["Wednesday"]
            //                     ["Active"],
            //                 widget.AdList["weekSchedule"]["Thursday"]["Active"],
            //                 widget.AdList["weekSchedule"]["Friday"]["Active"],
            //                 widget.AdList["weekSchedule"]["Saturday"]["Active"]
            //               ],
            //               selectedFillColor: Color.fromRGBO(134, 34, 169, .9),
            //               selectedTextStyle:
            //                   TextStyle(fontWeight: FontWeight.bold),
            //               textStyle: TextStyle(
            //                   fontWeight: FontWeight.bold, color: Colors.black),
            //             ),
            //             Container(
            //               width: 400,
            //               height: 50,
            //               color: Colors.transparent,
            //             ),
            //           ],
            //         ),
            //       ),
            //       tilePadding: EdgeInsets.all(0),
            //       children: [
            //         Column(
            //           children: [
            //             Padding(
            //               padding: const EdgeInsets.only(bottom: .0),
            //               child: Row(
            //                 mainAxisAlignment: MainAxisAlignment.center,
            //                 children: [
            //                   Column(
            //                     crossAxisAlignment: CrossAxisAlignment.end,
            //                     children: [
            //                       Text(
            //                         'Mon:'.toUpperCase(),
            //                         style: TextStyle(
            //                           fontWeight: FontWeight.w600,
            //                         ),
            //                       ),
            //                       Text(
            //                         'Tue:'.toUpperCase(),
            //                         style: TextStyle(
            //                           fontWeight: FontWeight.w600,
            //                         ),
            //                       ),
            //                       Text(
            //                         'Wed:'.toUpperCase(),
            //                         style: TextStyle(
            //                           fontWeight: FontWeight.w600,
            //                         ),
            //                       ),
            //                       Text(
            //                         'Thu:'.toUpperCase(),
            //                         style: TextStyle(
            //                           fontWeight: FontWeight.w600,
            //                         ),
            //                       ),
            //                       Text(
            //                         'Fri:'.toUpperCase(),
            //                         style: TextStyle(
            //                           fontWeight: FontWeight.w600,
            //                         ),
            //                       ),
            //                       Text(
            //                         'Sat:'.toUpperCase(),
            //                         style: TextStyle(
            //                           fontWeight: FontWeight.w600,
            //                         ),
            //                       ),
            //                       Text(
            //                         'Sun:'.toUpperCase(),
            //                         style: TextStyle(
            //                           fontWeight: FontWeight.w600,
            //                         ),
            //                       ),
            //                     ],
            //                   ),
            //                   Column(
            //                     children: [
            //                       Row(
            //                         children: [
            //                           SizedBox(
            //                             width: 10,
            //                           ),
            //                           Text(
            //                             widget.AdList["weekSchedule"]["Monday"]
            //                                 ["StartTime"],
            //                           ),
            //                           SizedBox(
            //                             width: 10,
            //                           ),
            //                           Text("-"),
            //                           SizedBox(
            //                             width: 10,
            //                           ),
            //                           Text(
            //                             widget.AdList["weekSchedule"]["Monday"]
            //                                 ["EndTime"],
            //                           ),
            //                           SizedBox(
            //                             width: 10,
            //                           ),
            //                         ],
            //                       ),
            //                       Row(
            //                         children: [
            //                           SizedBox(
            //                             width: 10,
            //                           ),
            //                           Text(
            //                             widget.AdList["weekSchedule"]["Tuesday"]
            //                                 ["StartTime"],
            //                           ),
            //                           SizedBox(
            //                             width: 10,
            //                           ),
            //                           Text("-"),
            //                           SizedBox(
            //                             width: 10,
            //                           ),
            //                           Text(
            //                             widget.AdList["weekSchedule"]["Tuesday"]
            //                                 ["EndTime"],
            //                           ),
            //                           SizedBox(
            //                             width: 10,
            //                           ),
            //                         ],
            //                       ),
            //                       Row(
            //                         children: [
            //                           SizedBox(
            //                             width: 10,
            //                           ),
            //                           Text(
            //                             widget.AdList["weekSchedule"]
            //                                 ["Wednesday"]["StartTime"],
            //                           ),
            //                           SizedBox(
            //                             width: 10,
            //                           ),
            //                           Text("-"),
            //                           SizedBox(
            //                             width: 10,
            //                           ),
            //                           Text(
            //                             widget.AdList["weekSchedule"]
            //                                 ["Wednesday"]["EndTime"],
            //                           ),
            //                           SizedBox(
            //                             width: 10,
            //                           ),
            //                         ],
            //                       ),
            //                       Row(
            //                         children: [
            //                           SizedBox(
            //                             width: 10,
            //                           ),
            //                           Text(
            //                             widget.AdList["weekSchedule"]
            //                                 ["Thursday"]["StartTime"],
            //                           ),
            //                           SizedBox(
            //                             width: 10,
            //                           ),
            //                           Text("-"),
            //                           SizedBox(
            //                             width: 10,
            //                           ),
            //                           Text(
            //                             widget.AdList["weekSchedule"]
            //                                 ["Thursday"]["EndTime"],
            //                           ),
            //                           SizedBox(
            //                             width: 10,
            //                           ),
            //                         ],
            //                       ),
            //                       Row(
            //                         children: [
            //                           SizedBox(
            //                             width: 10,
            //                           ),
            //                           Text(
            //                             widget.AdList["weekSchedule"]["Friday"]
            //                                 ["StartTime"],
            //                           ),
            //                           SizedBox(
            //                             width: 10,
            //                           ),
            //                           Text("-"),
            //                           SizedBox(
            //                             width: 10,
            //                           ),
            //                           Text(
            //                             widget.AdList["weekSchedule"]["Friday"]
            //                                 ["EndTime"],
            //                           ),
            //                           SizedBox(
            //                             width: 10,
            //                           ),
            //                         ],
            //                       ),
            //                       Row(
            //                         children: [
            //                           SizedBox(
            //                             width: 10,
            //                           ),
            //                           Text(
            //                             widget.AdList["weekSchedule"]
            //                                 ["Saturday"]["StartTime"],
            //                           ),
            //                           SizedBox(
            //                             width: 10,
            //                           ),
            //                           Text("-"),
            //                           SizedBox(
            //                             width: 10,
            //                           ),
            //                           Text(
            //                             widget.AdList["weekSchedule"]
            //                                 ["Saturday"]["EndTime"],
            //                           ),
            //                           SizedBox(
            //                             width: 10,
            //                           ),
            //                         ],
            //                       ),
            //                       Row(
            //                         children: [
            //                           SizedBox(
            //                             width: 10,
            //                           ),
            //                           Text(
            //                             widget.AdList["weekSchedule"]["Sunday"]
            //                                 ["StartTime"],
            //                           ),
            //                           SizedBox(
            //                             width: 10,
            //                           ),
            //                           Text("-"),
            //                           SizedBox(
            //                             width: 10,
            //                           ),
            //                           Text(
            //                             widget.AdList["weekSchedule"]["Sunday"]
            //                                 ["EndTime"],
            //                           ),
            //                           SizedBox(
            //                             width: 10,
            //                           ),
            //                         ],
            //                       ),
            //                     ],
            //                   ),
            //                 ],
            //               ),
            //             ),
            //           ],
            //         ),
            //       ]),
            // ),
            // Divider(),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Text(
            //     "Offer Type: " +
            //         "${widget.AdList["OfferType"] ? "OneTime" : "Multiple"}",
            //     style: TextStyle(fontSize: 15),
            //   ),
            // ),
            // Divider(),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Text(
            //     "Categoty: " +
            //         "${widget.AdList["DealCategoryIs"][0]["DealCategoryName"]}",
            //     style: TextStyle(fontSize: 15),
            //   ),
            // ),
            // Divider(),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Text(
            //     "Link : " + "${widget.AdList["DealLink"]}",
            //     style: TextStyle(fontSize: 15),
            //   ),
            // ),
            // Divider(),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Text(
            //     "Description: " + "${widget.AdList["Description"]}",
            //     style: TextStyle(fontSize: 15),
            //   ),
            // ),
            // Divider(),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Text(
            //     "Terms & Conditions: ${widget.AdList["TermsAndCondition"]}",
            //     style: TextStyle(fontSize: 15),
            //   ),
            // ),
            // Divider(
            //   height: 1,
            // ),
            // Padding(
            //   padding: const EdgeInsets.only(left:8.0,right: 20,bottom: 0,top: 8),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Text('Status:',style: TextStyle(fontSize: 15),),
            //       Text("${widget.AdList["status"]}",style: TextStyle(color: Colors.grey),),
            //     ],
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.only(
                left: 24,
                right: 16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Publish Status:',
                    style: TextStyle(fontSize: 15),
                  ),
                  Switch(
                    value: isSwitched,
                    onChanged: (value) {
                      _publish();
                    },
                    activeColor: Colors.green,
                    activeTrackColor: Colors.lightGreen,
                    inactiveTrackColor: Colors.red[400],
                  ),
                ],
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(bottom: 8.0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.end,
            //     children: <Widget>[
            //       GestureDetector(
            //         onTap: () {
            //           //Navigator.pushNamed(context, "/UpdateAdScreen");
            //           Navigator.push(
            //               context,
            //               MaterialPageRoute(
            //                   builder: (context) =>
            //                       UpdateAdScreen(widget.AdList)));
            //         },
            //         child: Padding(
            //           padding: const EdgeInsets.only(right: 8.0),
            //           child: Icon(
            //             Icons.edit,
            //             color: cnst.appPrimaryMaterialColor[700],
            //           ),
            //         ),
            //       ),
            //       GestureDetector(
            //         onTap: () {
            //           _showConfirmDialog();
            //         },
            //         child: Padding(
            //           padding: const EdgeInsets.only(right: 8.0),
            //           child: Icon(
            //             Icons.delete,
            //             color: Colors.red,
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
