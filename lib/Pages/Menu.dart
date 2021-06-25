import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsocietyadvertisement/Common/constant.dart' as cnst;
import 'package:smartsocietyadvertisement/Screens/LoginScreen.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  DateTime currentBackPressTime;

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

  void _showConfirmDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          //title: new Text("MyJINI Vendor"),
          content: new Text("Are You Sure You Want To Logout ?"),
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
                Navigator.of(context).pop();
                _logout();
              },
            ),
          ],
        );
      },
    );
  }

  _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: cnst.appPrimaryMaterialColor,
          title: Text("Menu"),
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            /*Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Column(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/SelectLanguage');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Select Language",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w600),
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            size: 30,
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/TermsAndCondition');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Terms & Conditions",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w600),
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            size: 30,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),*/
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Column(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/TermsAndCondition');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Terms & Conditions",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w600),
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            size: 30,
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/TermsOfService');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Terms Of Service",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w600),
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            size: 30,
                          ),
                        ],
                      ),
                    ),
                    Divider(),InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/PrivacyPolicy');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Privacy Policy",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w600),
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            size: 30,
                          ),
                        ],
                      ),
                    ),
                    Divider(),InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/RefundPolicy');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Refund Policy",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w600),
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            size: 30,
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                   /* InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/ReferAndEarn');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Refer & Earn",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w600),
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            size: 30,
                          ),
                        ],
                      ),
                    ),
                    Divider(),*/
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/FAQPage');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "FAQ",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w600),
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            size: 30,
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    InkWell(
                      onTap: () {
                        _showConfirmDialog();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Logout",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w600),
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            size: 30,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class LogoutDialog extends StatefulWidget {
  @override
  _LogoutDialogState createState() => _LogoutDialogState();
}

class _LogoutDialogState extends State<LogoutDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: new Text("MyJINI"),
      content: new Text("Are You Sure ?"),
      actions: <Widget>[
        // usually buttons at the bottom of the dialog
        FlatButton(
          child: new Text("YES"),
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => LoginScreen()));
          },
        ),
        FlatButton(
          child: new Text("NO"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
