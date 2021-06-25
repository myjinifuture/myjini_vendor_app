import 'dart:io';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsocietyadvertisement/Common/Services.dart';
import 'package:smartsocietyadvertisement/Common/constant.dart' as cnst;
import 'package:smartsocietyadvertisement/Common/constant.dart';
import 'package:smartsocietyadvertisement/Screens/UpdateProduct.dart';

class ProductListComponent extends StatefulWidget {
  var ProductList;
  Function _onremove;

  ProductListComponent(this.ProductList, this._onremove);

  @override
  _ProductListComponentState createState() => _ProductListComponentState();
}

class _ProductListComponentState extends State<ProductListComponent> {
  ProgressDialog pr;

  @override
  void initState() {
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
                Navigator.of(context).pop();
                _deleteProduct();
              },
            ),
          ],
        );
      },
    );
  }

  _deleteProduct() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        pr.show();

        //print("Accept Payment Data = ${data}");
        Services.DeleteProduct(widget.ProductList["Id"].toString()).then(
            (data) async {
          pr.hide();

          if (data.Data != "0" && data.IsSuccess == true) {
            Fluttertoast.showToast(
                msg: "Deleted Successfully !",
                textColor: Colors.black,
                toastLength: Toast.LENGTH_LONG);

            // showDialog(context: context, child: AcceptedDialog());
            widget._onremove();

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
          const EdgeInsets.only(left: 3.0, right: 3.0, top: 5.0, bottom: 5.0),
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            widget.ProductList["Image"] != "" &&
                    widget.ProductList["Image"] != null
                ? FadeInImage.assetNetwork(
                    placeholder: "images/Ad1.jpg",
                    width: MediaQuery.of(context).size.width,
                    height: 150,
                    fit: BoxFit.fill,
                    image: "${cnst.IMG_URL}" + widget.ProductList["Image"])
                : Image.asset(
                    "images/Ad1.jpg",
                    width: MediaQuery.of(context).size.width,
                    height: 150,
                    fit: BoxFit.fill,
                  ),
            ExpansionTile(
              title: Center(
                child: Text(
                  "${widget.ProductList["Name"]}",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Category",
                          style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "${widget.ProductList["SubCategoryName"]}",
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
                Divider(
                  thickness: 1,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Sub-Category",
                          style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "${widget.ProductList["CategoryName"]}",
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
                Divider(
                  thickness: 1,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Price",
                          style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        cnst.Inr_Rupee + " ${widget.ProductList["Price"]}",
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
                Divider(
                  thickness: 1,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Discount",
                          style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "${(widget.ProductList["Discount"])} %",
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                       IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: Colors.blue,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UpdateProduct(
                              widget.ProductList,
                              widget.ProductList["CategoryId"].toString(),
                              widget.ProductList["SubCategoryId"].toString()),
                        ),
                      );
                    },
                  ),
                      GestureDetector(
                        onTap: () {
                          _showConfirmDialog();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
