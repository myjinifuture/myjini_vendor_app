import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsocietyadvertisement/Common/Services.dart';
import 'package:smartsocietyadvertisement/Common/constant.dart' as cnst;
import 'package:smartsocietyadvertisement/Screens/UpdateAdScreen.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewMemberComponent extends StatefulWidget {
  var ScannedList;

  ViewMemberComponent(this.ScannedList);

  @override
  _ViewMemberComponentState createState() => _ViewMemberComponentState();
}

class _ViewMemberComponentState extends State<ViewMemberComponent> {
  ProgressDialog pr;
  bool isLoading = false;

  @override
  void initState() {
    getdata();
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
  }

  getdata() {
    print("jjjj---> "+widget.ScannedList.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 3.0, right: 3.0, top: 5.0, bottom: 5.0),
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
             //mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
             /*   Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Member Name",
                    //"${widget.AdList["Title"]}",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                ),*/

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${widget.ScannedList["Title"]}",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right:15.0),
                  child: GestureDetector(
                      onTap: () {
                        launch("tel:${widget.ScannedList["MemberMobile"]}");
                      },
                      child: Image.asset("images/call.png",width: 25,height: 25,)),
                ),
                Padding(
                  padding: const EdgeInsets.only(right:8.0),
                  child: GestureDetector(
                      onTap: () {
                       /* launch(
                            "https://wa.me/+91${widget.ScannedList["MemberMobile"]}?text= hi \n ");*/
                        FlutterOpenWhatsapp.sendSingleMessage("91${widget.ScannedList["MemberMobile"]}", "Hello");
                        //print("91${widget.ScannedList["MemberMobile"]}");
                      },
                      child: Image.asset("images/whatsapplogo1.png",width: 25,height: 25)),
                ),
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "${widget.ScannedList["MemberAddress"]}",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "${widget.ScannedList["Title"]}",
                    style: TextStyle(fontSize: 15,),
                  ),
                ),
              ],
            ),
            /* Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Member Mobile",
                    //"${widget.AdList["Title"]}",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "${widget.ScannedList["MemberMobile"]}",
                    style: TextStyle(fontSize: 15,),
                  ),
                ),
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Ad Title",
                    //"${widget.AdList["Title"]}",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                   "${widget.ScannedList["Title"]}",
                    style: TextStyle(fontSize: 15,),
                  ),
                ),
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Ad Price",
                    //"${widget.AdList["Title"]}",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    cnst.Inr_Rupee+
                    "${widget.ScannedList["Price"]}",
                    style: TextStyle(fontSize: 15,),
                  ),
                ),
              ],
            ),
            Divider(),
*/
          ],
        ),
      ),
    );
  }
}
