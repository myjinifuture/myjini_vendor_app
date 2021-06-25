import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsocietyadvertisement/Common/ClassList.dart';
import 'package:smartsocietyadvertisement/Common/Services.dart';
import 'package:smartsocietyadvertisement/Common/constant.dart' as cnst;

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  File ProductImage;
  String _categoryDropdownError, _subcategoryDropdownError;

  int count=0;


  bool categoryLoading = false;
  bool subCategoryLoading = false;


  List<categoryClass> categoryClassList = [];
  categoryClass _categoryClass;

  List<subCategoryClass> subCategoryClassList = [];
  subCategoryClass _subCategoryClass;

  //List addProductList =[];

  ProgressDialog pr;

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  TextEditingController txtName = new TextEditingController();
  TextEditingController txtPrice = new TextEditingController();
  TextEditingController txtDiscount = new TextEditingController();


  @override
  void initState() {
    getCategory();
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

  getCategory() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          categoryLoading = true;
        });
        Future res = Services.GetCategory();
        res.then((data) async {
          setState(() {
            categoryLoading = false;
          });
          if (data != null && data.length > 0) {
            setState(() {
              categoryClassList = data;
            });
          }
        }, onError: (e) {
          showMsg("$e");
          setState(() {
            categoryLoading = false;
          });
        });
      } else {
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("Something Went Wrong");
      setState(() {
        categoryLoading = false;
      });
    }
  }

  getSubCategory(String id) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          subCategoryLoading = true;
        });
        Future res = Services.GetSubCategory(id);
        res.then((data) async {
          setState(() {
            subCategoryLoading = false;
          });
          if (data != null && data.length > 0) {
            setState(() {
              subCategoryClassList = data;
            });
          }
        }, onError: (e) {
          showMsg("$e");
          setState(() {
            subCategoryLoading = false;
          });
        });
      } else {
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("Something Went Wrong");
      setState(() {
        categoryLoading = false;
      });
    }
  }

  _addProduct() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        pr.show();
        String filename = "";
        String filePath = "";
        File compressedFile;

        if (ProductImage != null) {
          ImageProperties properties =
          await FlutterNativeImage.getImageProperties(ProductImage.path);

          compressedFile = await FlutterNativeImage.compressImage(
            ProductImage.path,
            quality: 80,
            targetWidth: 600,
            targetHeight: (properties.height * 600 / properties.width).round(),
          );

          filename = ProductImage.path
              .split('/')
              .last;
          filePath = compressedFile.path;
        }

        SharedPreferences preferences = await SharedPreferences.getInstance();
        FormData data = FormData.fromMap({
          "Id": 0,
          "CategoryId": _subCategoryClass.id,
          //"SubCategoryId":0,
          //"CategoryId": _categoryClass.id,
          //"SubCategoryId": _subCategoryClass.id,
          "VendorId": preferences.getString(cnst.Session.VendorId),
          "Name": txtName.text,
          "Price": txtPrice.text,
          "Discount": txtDiscount.text==null||txtDiscount.text==""?0:txtDiscount.text,
          "Image": (filePath != null && filePath != '')
              ? await MultipartFile.fromFile(filePath,
              filename: filename.toString())
              : null,
        });

        Services.AddProduct(data).then((data) async {
          pr.hide();
          if (data.Data != "0" && data.IsSuccess == true) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString(cnst.Session.AdImage, "${data.Data}");

            Fluttertoast.showToast(
                msg: "Product Added Successfully !",
                toastLength: Toast.LENGTH_SHORT,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                gravity: ToastGravity.TOP);

            Navigator.pushNamedAndRemoveUntil(
                context, "/Dashboard", (Route<dynamic> route) => false);
          }
        }, onError: (e) {
          pr.hide();
          showMsg("Try Again.");
        });
      } else
        showMsg("No Internet Connection.");
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  pickProduct(source) async {
    var picture = await ImagePicker.pickImage(source: source);
    this.setState(() {
      ProductImage = picture;
    });
    Navigator.pop(context);
  }

  Future<void> _chooseProductImage(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Make Choice"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Text("Gallery"),
                    onTap: () {
                      pickProduct(ImageSource.gallery);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  GestureDetector(
                    child: Text("Camera"),
                    onTap: () {
                      pickProduct(ImageSource.camera);
                    },
                  ),
                ],
              ),
            ),
          );
        });
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

      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Card(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Category",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                               /* Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      //Navigator.pushNamed(context, "/AddOtherService");
                                    },
                                    child: Image.asset(
                                      "images/addphoto.png",
                                      width: 25,
                                      height: 25,
                                    ),
                                  ),
                                ),*/
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width,
                                decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(6))),
                                child: DropdownButtonHideUnderline(
                                    child: DropdownButton<categoryClass>(
                                      isExpanded: true,
                                      hint: categoryClassList.length > 0
                                          ? Text(
                                        ' Select Category',
                                        style: TextStyle(fontSize: 15),
                                      )
                                          : Text(
                                        " Category Not Found",
                                        style: TextStyle(fontSize: 15),
                                      ),
                                      value: _categoryClass,
                                      onChanged: (newValue) {
                                        setState(() {
                                          _categoryClass = newValue;
                                          _categoryDropdownError = null;
                                          _subCategoryClass = null;
                                          subCategoryClassList = [];
                                        });
                                        getSubCategory(newValue.id);
                                      },
                                      items: categoryClassList.map((
                                          categoryClass value) {
                                        return DropdownMenuItem<
                                            categoryClass>(
                                          value: value,
                                          child: Text(" " + value.Title),
                                        );
                                      }).toList(),
                                    )),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left:8.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: _categoryDropdownError == null
                                    ? Text(
                                  "",
                                  textAlign:
                                  TextAlign.start,
                                )
                                    : Text(
                                  _categoryDropdownError ?? "",
                                  style: TextStyle(
                                      color:
                                      Colors.red[700],
                                      fontSize: 12),
                                  textAlign:
                                  TextAlign.start,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Sub Category",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width:
                                      MediaQuery
                                          .of(context)
                                          .size
                                          .width,
                                      decoration: BoxDecoration(
                                          border: Border.all(),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(6))),
                                      child: DropdownButtonHideUnderline(
                                          child: DropdownButton<
                                              subCategoryClass>(
                                            isExpanded: true,
                                            hint: subCategoryClassList
                                                .length > 0
                                                ? Text(
                                              ' Select Sub Category',
                                              style: TextStyle(fontSize: 15),
                                            )
                                                : Text(
                                              " Sub Category Not Found",
                                              style: TextStyle(fontSize: 15),
                                            ),
                                            value: _subCategoryClass,
                                            onChanged: (newValue) {
                                              setState(() {
                                                _subCategoryClass = newValue;
                                                _subcategoryDropdownError =
                                                null;
                                              });
                                            },
                                            items: subCategoryClassList.map((
                                                subCategoryClass value) {
                                              return DropdownMenuItem<
                                                  subCategoryClass>(
                                                value: value,
                                                child: Text(
                                                    " " + value.Title),
                                              );
                                            }).toList(),
                                          )),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left:8.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: _subcategoryDropdownError == null
                                    ? Text(
                                  "",
                                  textAlign:
                                  TextAlign.start,
                                )
                                    : Text(
                                  _subcategoryDropdownError ?? "",
                                  style: TextStyle(
                                      color:
                                      Colors.red[700],
                                      fontSize: 12),
                                  textAlign:
                                  TextAlign.start,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(bottom: 10.0),
                                    child: Text(
                                      "Title",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 50,
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value.trim() == "") {
                                          return 'Please Enter Valid Name';
                                        }
                                        return null;
                                      },
                                      controller: txtName,
                                      textInputAction: TextInputAction.next,
                                      decoration: InputDecoration(
                                          border: new OutlineInputBorder(
                                            borderRadius:
                                            new BorderRadius.circular(
                                                5.0),
                                            borderSide: new BorderSide(),
                                          ),
                                          labelText: "Enter Name",
                                          hintStyle: TextStyle(fontSize: 13)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(bottom: 10.0),
                                    child: Text(
                                      "Price",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 50,
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value.trim() == "") {
                                          return 'Please Enter Price';
                                        }
                                        return null;
                                      },
                                      controller: txtPrice,
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          border: new OutlineInputBorder(
                                            borderRadius:
                                            new BorderRadius.circular(
                                                5.0),
                                            borderSide: new BorderSide(),
                                          ),
                                          labelText: "Enter Price",
                                          hintStyle: TextStyle(fontSize: 13)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(bottom: 10.0),
                                    child: Text(
                                      "Discount(%)",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 50,
                                    child: TextFormField(
                                      /*validator: (value) {
                                        if (value.trim() == "") {
                                          return 'Please Enter Valid Name';
                                        }
                                        return null;
                                      },*/
                                      controller: txtDiscount,
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          border: new OutlineInputBorder(
                                            borderRadius:
                                            new BorderRadius.circular(
                                                5.0),
                                            borderSide: new BorderSide(),
                                          ),
                                          labelText: "Enter Discount",
                                          hintStyle: TextStyle(fontSize: 13)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: GestureDetector(
                                onTap: () {
                                  _chooseProductImage(context);
                                },
                                child: ProductImage == null
                                    ? Container(
                                  height: 150,
                                  width:
                                  MediaQuery
                                      .of(context)
                                      .size
                                      .width,
                                  child: DottedBorder(
                                      dashPattern: [8, 4],
                                      borderType: BorderType.RRect,
                                      radius: Radius.circular(5),
                                      padding: EdgeInsets.all(6),
                                      color: Colors.grey,
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: <Widget>[
                                          Align(
                                            alignment: Alignment.center,
                                            child: Image.asset(
                                              "images/addphoto.png",
                                              width: 25,
                                              height: 25,
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                            const EdgeInsets.only(
                                                top: 8.0),
                                            child: Text(
                                              "Add Photo",
                                              style: TextStyle(
                                                  color:
                                                  Colors.grey[600]),
                                            ),
                                          ),
                                        ],
                                      )),
                                )
                                    : Container(
                                  child: ProductImage != null
                                      ? Image.file(
                                    ProductImage,
                                    height: 150,
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width,
                                    fit: BoxFit.fill,
                                  )
                                      : DottedBorder(
                                    dashPattern: [8, 4],
                                    borderType: BorderType.RRect,
                                    radius: Radius.circular(5),
                                    padding: EdgeInsets.all(6),
                                    color: Colors.blue,
                                    child: Image.asset(
                                      "images/user1.png",
                                      height: 150,
                                      width:
                                      MediaQuery
                                          .of(context)
                                          .size
                                          .width,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 18.0, left: 8, right: 8, bottom: 8.0),
                              child: SizedBox(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width,
                                height: 50,
                                child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(5)),
                                    color: cnst.appPrimaryMaterialColor,
                                    textColor: Colors.white,
                                    splashColor: Colors.white,
                                    child: Text("Add Product",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600)),
                                    onPressed: () {
                                      bool isValidate = true;
                                      setState(() {
                                        if (_categoryClass == null) {
                                          isValidate = false;
                                          _categoryDropdownError =
                                          "Please Select State";
                                        }
                                        if (_subcategoryDropdownError == null) {
                                          isValidate = false;
                                          _subcategoryDropdownError =
                                          "Please Select City";
                                        }

                                      });
                                      if (_formkey.currentState.validate()) {
                                        _addProduct();
                                      }

                                    }),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}
