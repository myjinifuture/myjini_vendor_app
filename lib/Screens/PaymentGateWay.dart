import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// import 'package:nb_utils/nb_utils.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsocietyadvertisement/Common/Services.dart';
import 'package:smartsocietyadvertisement/Common/constant.dart';
import 'package:smartsocietyadvertisement/Pages/Home.dart';
import 'package:smartsocietyadvertisement/Screens/PdfGenerate.dart';
import 'package:smartsocietyadvertisement/Common/constant.dart' as cnst;

class RazorPayScreen extends StatefulWidget {
  static String tag = '/RazorPayScreen';

  var id;

  RazorPayScreen({this.id});

  @override
  RazorPayScreenState createState() => RazorPayScreenState();
}

class RazorPayScreenState extends State<RazorPayScreen> {
  Razorpay _razorpay;
  bool isLoading = false;
  String orderId = "";
  String paymentId = "";
  String signature = "";

  TextEditingController contact = TextEditingController();
  TextEditingController mail = TextEditingController();
  TextEditingController name = TextEditingController();

  _sendPaymentDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String ven = prefs.getString(cnst.Session.VendorId);
    print(ven);
    try {
      setState(() {
        isLoading = true;
      });
      final internetResult = await InternetAddress.lookup('google.com');
      if (internetResult.isNotEmpty &&
          internetResult[0].rawAddress.isNotEmpty) {
        var body = {
          "advertiseId": "${widget.id}",
          "vendorId": "${ven}",
          "accountNo": "11515254524151",
          "paymentId": "${paymentId}",
          "signature": "${signature}",
          "amount": 21000,
          "orderId": "${orderId}"
        };
        Services.responseHandler(
                apiName: "adsVendor/addAdvertisePayment", body: body)
            .then((responseData) {
          if (responseData.Data.length == 0) {
            print(responseData.IsSuccess);
            print(responseData.Message);
            print(responseData.Data);
            print('--');
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
        msg: "You aren't connected to the Internet !",
        backgroundColor: Colors.white,
        textColor: appPrimaryMaterialColor,
      );
    }
  }

  _getSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String ven = prefs.getString(cnst.Session.VendorId);
    contact.text = await prefs.getString(cnst.Session.Mobile);
    mail.text = await prefs.getString(cnst.Session.Email);
    name.text = await prefs.getString(cnst.Session.Name);

    print(ven);
    print(contact.text);
    print(name.text);
  }

  @override
  void initState() {
    _getSharedPref();
    // _sendPaymentDetails();
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_CjIP1C7K4yRoqo',
      'amount': 2100000,
      'name': '${name.text}',
      'description': 'Advertisement',
      'prefill': {'contact': '${contact.text}', 'email': '${mail.text}'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(msg: "SUCCESS: " + response.paymentId);
    print("response.orderId");
    orderId = response.orderId;
    print(orderId);
    print("response.paymentId");
    paymentId = response.paymentId;
    print(paymentId);
    print('response.signature');
    signature = response.signature;
    print(signature);
    _sendPaymentDetails();
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
      return PdfGenerate(PaymentId: response.paymentId,);
    },),  ModalRoute.withName('/Dashboard'));
    // Navigator.pushNamedAndRemoveUntil(
    //     context, '/PdfGenerate', ModalRoute.withName('/Dashboard'));
    // Navigator.pushNamed(context, '/PdfGenerate',arguments: response.paymentId.toString());
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(msg: "EXTERNAL_WALLET: " + response.walletName);
  }

  @override
  void dispose() {
    super.dispose();
    // _razorpay.clear();
  }

  @override
  Widget build(BuildContext context) {
    // changeStatusColor(primaryColor);
    return Scaffold(
      appBar: AppBar(
        title: Text('MyJini Advertisement'),
        backgroundColor: Color.fromRGBO(114, 34, 169, 1),
      ),
      // appBar: getAppBar(context, 'RazorPay Payment checkout'),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            margin: EdgeInsets.only(top: 24, bottom: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        margin:
                            EdgeInsets.only(left: 16, right: 16, bottom: 28),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            color: Colors.white),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            'images/applogo.png',
                            width: 115,
                            height: 115,
                          ),
                        )),
                    SizedBox(height: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "MY JINI",
                            style: TextStyle(fontSize: 22),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                "Total Payment : ",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.grey),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "21000 \₹",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 18),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Divider(height: 0.5),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Name",
                    // textColor: primaryColor,
                    // fontFamily: fontSemibold,
                    // fontSize: textSizeLargeMedium,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 16, right: 16),
                  width: MediaQuery.of(context).size.width,
                  // padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: TextFormField(
                    // initialValue: "MyJini Advertisement",
                    controller: name,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(10.0),
                          borderSide: new BorderSide(),
                        ),
                        // labelText: "Enter Name",
                        hintStyle: TextStyle(fontSize: 13)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Email",
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 16, right: 16),
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(
                    controller: mail,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(10.0),
                          borderSide: new BorderSide(),
                        ),
                        // labelText: "Enter Name",
                        hintStyle: TextStyle(fontSize: 13)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Contact",
                    // textColor: primaryColor,
                    // fontFamily: fontSemibold,
                    // fontSize: textSizeLargeMedium,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 16, right: 16),
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(
                    // initialValue: "8488027477",
                    maxLength: 10,
                    controller: contact,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(10.0),
                          borderSide: new BorderSide(),
                        ),
                        // labelText: "Enter Name",
                        hintStyle: TextStyle(fontSize: 13)),
                  ),
                ),
                GestureDetector(
                  child: Container(
                    margin: EdgeInsets.only(left: 16, right: 16, top: 30),
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(114, 34, 169, 1),
                      // color: primaryColor,
                      // border: Border.all(width: 1),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Pay Now',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  onTap: () {
                    openCheckout();
                  },
                ),
              ],
            )

            /*MaterialButton(
              color: primaryColor,
              onPressed: () => openCheckout(),
              child: textPrimary('Pay with RazorPay'),
            )*/
            ,
          ),
        ),
      ),
    );
  }
}
