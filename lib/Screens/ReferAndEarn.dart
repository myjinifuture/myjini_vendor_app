import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:smartsocietyadvertisement/Common/constant.dart' as cnst;

class ReferAndEarn extends StatefulWidget {
  @override
  _ReferAndEarnState createState() => _ReferAndEarnState();
}

class _ReferAndEarnState extends State<ReferAndEarn> {
  String ReferalCode = "AH0051";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: cnst.appPrimaryMaterialColor,
        title: Text("Refer & Earn"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  "images/referearn.png",
                  width: MediaQuery.of(context).size.width,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 8.0),
                child: Text(
                  "Refer Vendors",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                      fontSize: 24),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text(
                  "Get 50% off In Your Service Fee",
                  style: TextStyle(color: Colors.grey, fontSize: 16.0),
                ),
              ),
              Text(
                "or",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                    fontSize: 16),
              ),
              Text(
                "Get Free Hiring for Next Good",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              Text(
                "Opportunity",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 35, left: 15),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "SHARE YOUR INVITE CODE",
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              Container(
                margin:
                    EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 25),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.grey[400],
                    border: Border.all(
                        color: Colors.grey[400], // set border color
                        width: 3.0), // set border width
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                child: Center(
                  child: Text(
                    "${ReferalCode}",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        letterSpacing: 2),
                  ),
                ),
              ),
              SizedBox(
                height: 45,
                width: 350,
                child: RaisedButton(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(11.0),
                      side: BorderSide(color: cnst.appPrimaryMaterialColor)),
                  onPressed: () {
                    String withrefercode =
                        cnst.inviteFriMsg.replaceAll("#refercode", ReferalCode);
                    String withappurl =
                        withrefercode.replaceAll("#appurl", cnst.playstoreUrl);
                    Share.share(withappurl);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Refer ",
                        style: TextStyle(color: cnst.appPrimaryMaterialColor),
                      ),
                      Icon(
                        Icons.share,
                        color: cnst.appPrimaryMaterialColor,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 10, left: 10, right: 10, bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        "Note:",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "Discount/Free Hiring Shall be Approved Only After Your Reference Join The School",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
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
