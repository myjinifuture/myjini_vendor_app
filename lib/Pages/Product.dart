import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsocietyadvertisement/Common/ClassList.dart';
import 'package:smartsocietyadvertisement/Common/Services.dart';
import 'package:smartsocietyadvertisement/Common/constant.dart' as cnst;
import 'package:smartsocietyadvertisement/Screens/AddProduct.dart';
import 'package:smartsocietyadvertisement/Screens/ListProduct.dart';
import 'package:smartsocietyadvertisement/Screens/ProductInquiry.dart';

class Product extends StatefulWidget {
  @override
  _ProductState createState() => _ProductState();
}

class _ProductState extends State<Product> with TickerProviderStateMixin {
  TabController _tabController;

  ProgressDialog pr;
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

  @override
  void initState() {

    _tabController = new TabController(vsync: this, length: 3);
    super.initState();
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



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: cnst.appPrimaryMaterialColor,
          title: Text("Product"),
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            TabBar(
              unselectedLabelColor: Colors.grey[500],
              indicatorColor: Colors.black,
              labelColor: Colors.black,
              controller: _tabController,
              tabs: [
                Tab(
                  child: Text(
                    "Products",
                  ),
                ),
                Tab(
                  child: Text(
                    "Add Product",
                  ),
                ),
                Tab(
                  child: Text(
                    "Inquiry",
                  ),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  ListProduct(),
                  AddProduct(),
                 ProductInquiry()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
