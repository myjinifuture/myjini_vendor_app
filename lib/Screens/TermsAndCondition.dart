import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsocietyadvertisement/Common/Services.dart';
import 'package:smartsocietyadvertisement/Common/constant.dart' as cnst;

class TermsAndCondition extends StatefulWidget {
  @override
  _TermsAndConditionState createState() => _TermsAndConditionState();
}

class _TermsAndConditionState extends State<TermsAndCondition> {
  List _termsAndConditionData = [];
  bool isLoading = false;

  @override
  void initState() {
    GetTermsandCondition();
  }

  GetTermsandCondition() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.GetTermsandCondition();
        setState(() {
          isLoading = true;
        });
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              _termsAndConditionData = data;
              isLoading = false;
            });

            // print("Identity Status =>" + _termsAndConditionData[0]["Status"].toString());
          } else {
            setState(() {
              _termsAndConditionData = [];
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

  showMsg(String msg, {String title = "MyJINI Vendor"}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("MyJINI Vendor"),
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
        title: Text("Terms & Conditions"),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _termsAndConditionData.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "${_termsAndConditionData[index]["Id"]}. ",
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w500),
                      ),
                      Expanded(
                          child: Text(
                              "${_termsAndConditionData[index]["Title"]}",
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500))),
                    ],
                  ),
                );
              }),
    );
  }
}
