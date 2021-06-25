import 'dart:io';

import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsocietyadvertisement/Common/Services.dart';
import 'package:smartsocietyadvertisement/Component/ProductInquiryComponent.dart';
import 'package:smartsocietyadvertisement/Common/constant.dart' as cnst;

class ProductInquiry extends StatefulWidget {
  @override
  _ProductInquiryState createState() => _ProductInquiryState();
}

class _ProductInquiryState extends State<ProductInquiry> {
  ProgressDialog pr;
  bool isLoading = true;
  List InquiryList = [];

  @override
  void initState() {
    GetScannedAd();
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

  GetScannedAd() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        String advertiserId = await preferences.getString(cnst.Session.VendorId);
        Future res = Services.GetVendorProductInquiry(advertiserId);
        setState(() {
          isLoading = true;
        });
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              InquiryList = data;
              isLoading = false;
            });

            print("Scanned Details =>" + InquiryList.toString());
          } else {
            setState(() {
              InquiryList = [];
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
      body: Column(
        children: <Widget>[
          isLoading
              ? Center(child: CircularProgressIndicator())
              : InquiryList.length > 0
              ? Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                  itemCount: InquiryList.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return SingleChildScrollView(
                        child:
                        ProductInquiryComponent(InquiryList[index]));
                  }),
            ),
          )  : Center(
              child: Text(
                "No Data Found",
                style: TextStyle(
                    color: Colors.grey, fontWeight: FontWeight.w500),
              )),
        ],
      ),
    );
  }
}
