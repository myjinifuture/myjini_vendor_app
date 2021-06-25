import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsocietyadvertisement/Common/Services.dart';
import 'package:smartsocietyadvertisement/Common/constant.dart' as cnst;

class PostAdScreen extends StatefulWidget {
  @override
  _PostAdScreenState createState() => _PostAdScreenState();
}

class _PostAdScreenState extends State<PostAdScreen> {
  File AdImage;

  ProgressDialog pr;

  TextEditingController txtTitle = new TextEditingController();
  TextEditingController txtDescription = new TextEditingController();
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  void initState() {


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

  _addPost() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        pr.show();
        String filename = "";
        String filePath = "";
        File compressedFile;

        if (AdImage != null) {
          ImageProperties properties =
          await FlutterNativeImage.getImageProperties(AdImage.path);

          compressedFile = await FlutterNativeImage.compressImage(
            AdImage.path,
            quality: 80,
            targetWidth: 600,
            targetHeight: (properties.height * 600 / properties.width).round(),
          );

          filename = AdImage.path
              .split('/')
              .last;
          filePath = compressedFile.path;
        }

        SharedPreferences preferences = await SharedPreferences.getInstance();
        FormData data = FormData.fromMap({
          "Id": 0,
          "Title": txtTitle.text,
          "Description": txtDescription.text,
          "Image": (filePath != null && filePath != '')
              ? await MultipartFile.fromFile(filePath,
              filename: filename.toString())
              : null,
          "UserId": "${preferences.getString(cnst.Session.VendorId)}",
        });

        Services.AdPost(data).then((data) async {
          pr.hide();
          if (data.Data != "0" && data.IsSuccess == true) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString(cnst.Session.AdImage, "${data.Data}");

            Fluttertoast.showToast(
                msg: "Ad Successfully Posted",
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


  Future<void> _choosePanImage(BuildContext context) {
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
                      pickPan(ImageSource.gallery);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  GestureDetector(
                    child: Text("Camera"),
                    onTap: () {
                      pickPan(ImageSource.camera);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  pickPan(source) async {
    var picture = await ImagePicker.pickImage(source: source);
    this.setState(() {
      AdImage = picture;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Post Ad"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.white,),
          color: cnst.appPrimaryMaterialColor,
          onPressed: () {
          Navigator.pop(context);
          },
        ),
        backgroundColor: cnst.appPrimaryMaterialColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Advertisement Title",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 50,
                            child: TextFormField(
                              validator: (value) {
                                if (value.trim() == "") {
                                  return 'Please Enter Title';
                                }
                                return null;
                              },
                              controller: txtTitle,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                  labelStyle: TextStyle(
                                      color: cnst
                                          .appPrimaryMaterialColor),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: cnst
                                              .appPrimaryMaterialColor)),
                                  border: new OutlineInputBorder(
                                    borderRadius:
                                    new BorderRadius.circular(
                                        5.0),
                                    borderSide: new BorderSide(),
                                  ),
                                  labelText: "Title",
                                  hintStyle: TextStyle(fontSize: 13)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Description",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            child: TextFormField(
                              validator: (value) {
                                if (value.trim() == "") {
                                  return 'Please Enter Description';
                                }
                                return null;
                              },
                              controller: txtDescription,
                              maxLines: 5,
                              maxLengthEnforced: true,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                  labelStyle: TextStyle(
                                      color: cnst
                                          .appPrimaryMaterialColor),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: cnst
                                              .appPrimaryMaterialColor)),
                                  border: new OutlineInputBorder(
                                    borderRadius:
                                    new BorderRadius.circular(
                                        5.0),
                                    borderSide: new BorderSide(),
                                  ),
                                  labelText: "Description",
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
                          _choosePanImage(context);
                        },
                        child: AdImage == null
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
                          child: AdImage != null
                              ? Image.file(
                            AdImage,
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
                                borderRadius: BorderRadius.circular(5)),
                            color: cnst.appPrimaryMaterialColor,
                            textColor: Colors.white,
                            splashColor: Colors.white,
                            child: Text("Add Post",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600)),
                            onPressed: () {
                              if (_formkey.currentState.validate()) {
                                _addPost();
                              }

                            }),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
