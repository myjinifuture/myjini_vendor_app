import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsocietyadvertisement/Common/Services.dart';
import 'package:smartsocietyadvertisement/Common/constant.dart' as cnst;
import 'package:smartsocietyadvertisement/Common/constant.dart';

class AddServices extends StatefulWidget {
  var Id;

  AddServices({this.Id});

  @override
  _AddServicesState createState() => _AddServicesState();
}

class _AddServicesState extends State<AddServices> {
  bool isLoading = false;
  TextEditingController title = TextEditingController();
  TextEditingController des = TextEditingController();

  addService() async {
    if (title.text == null ||
        title.text == '' ||
        des.text == null ||
        des.text == '') {
      Fluttertoast.showToast(msg: 'Enter all mandatory fields');
    } else {
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
          var body = {
            "advertiseId": "${widget.Id}",
            "Title": "${title.text}",
            "Body": "${des.text}"
          };
          Services.responseHandler(
                  apiName: "adsVendor/addAdvertiseServices", body: body)
              .then((responseData) {
            if (responseData.Data.length > 0) {
              print('Message:' + responseData.Message.toString());
              Fluttertoast.showToast(msg: responseData.Message.toString());
              print(responseData.Data);
              setState(() {
                isLoading = false;
                print(responseData.Data);
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
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.Id);
    return Scaffold(
      appBar: AppBar(
        title: Text(" Create Service"),
        centerTitle: true,
        backgroundColor: appPrimaryMaterialColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
              // bottom: Radius.circular(10),
              ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Cmnt(
                  title: 'Title*',
                  controller: title,
                ),
                Cmnt(
                  title: 'Description*',
                  controller: des,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: GestureDetector(
                    onTap: addService,
                    child: Container(
                      margin: EdgeInsets.all(7),
                      padding: EdgeInsets.symmetric(vertical: 13),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: appPrimaryMaterialColor),
                      child: Text(
                        "Add Service",
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
    );
  }
}

class Cmnt extends StatefulWidget {
  String title;
  TextEditingController controller;
  TextInputType keyboardtype;
  double height;

  Cmnt({this.title, this.controller, this.height, this.keyboardtype});

  @override
  _CmntState createState() => _CmntState();
}

class _CmntState extends State<Cmnt> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0, right: 10, left: 10),
          child: Row(
            children: <Widget>[
              Text(widget.title,
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500))
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 5.0),
          child: SizedBox(
            height: 50,
            child: TextFormField(
              autofocus: false,
              keyboardType: widget.keyboardtype,
              validator: (value) {
                if (value.trim() == "") {
                  return 'Please Enter ${widget.title}';
                }
                return null;
              },
              // focusNode: FocusNode(),
              controller: widget.controller,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(5.0),
                    borderSide: new BorderSide(),
                  ),
                  labelText:
                      "${widget.title.substring(0, int.parse(widget.title.length.toString()) - 1)}",
                  hintStyle: TextStyle(fontSize: 13)),
            ),
          ),
        ),
      ],
    );
  }
}
