import 'dart:io';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsocietyadvertisement/Common/Services.dart';
import 'package:smartsocietyadvertisement/Common/constant.dart' as cnst;
import 'package:textfield_tags/textfield_tags.dart';
import 'package:weekday_selector/weekday_selector.dart';

class UpdateAdScreen extends StatefulWidget {
  var AdList;

  UpdateAdScreen(this.AdList);

  @override
  _UpdateAdScreenState createState() => _UpdateAdScreenState();
}

class _UpdateAdScreenState extends State<UpdateAdScreen> {
  File AdImage;
  String Id, _url;
  ProgressDialog pr;

  DateTime selectedDate = DateTime(2021, 10, 2);
  DateTime selectedDate1 = DateTime.now();

  // var Dealtype=widget.AdList["OfferType"];
  List Tags = [];
  bool checkBox1 = false;
  bool manualTime = false;
  bool isLoading = false;
  var values = List.filled(7, true);
  List dealCategory = [];
  String Dealtype;
  var category = "";

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  TextEditingController offerTitle = TextEditingController();
  TextEditingController offerDescription = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController offerPrice = TextEditingController();
  TextEditingController offerLink = TextEditingController();
  TextEditingController terms = TextEditingController();
  TextEditingController keyWord = TextEditingController();

  @override
  void initState() {
    _getData();
    print(widget.AdList.toString());
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

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  File _image;

  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = image;
    });
  }

  _imgFromGallery() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = image;
    });
  }

  TimeOfDay _time = TimeOfDay.now();
  TimeOfDay _time1 = TimeOfDay.now();

  TimeOfDay monFrom = TimeOfDay.now();
  TimeOfDay tueFrom = TimeOfDay.now();
  TimeOfDay wedFrom = TimeOfDay.now();
  TimeOfDay thuFrom = TimeOfDay.now();
  TimeOfDay friFrom = TimeOfDay.now();
  TimeOfDay satFrom = TimeOfDay.now();
  TimeOfDay sunFrom = TimeOfDay.now();

  TimeOfDay monTo = TimeOfDay.now();
  TimeOfDay tueTo = TimeOfDay.now();
  TimeOfDay wedTo = TimeOfDay.now();
  TimeOfDay thuTo = TimeOfDay.now();
  TimeOfDay friTo = TimeOfDay.now();
  TimeOfDay satTo = TimeOfDay.now();
  TimeOfDay sunTo = TimeOfDay.now();

  void selctMonFrom() async {
    final TimeOfDay newTime = await showTimePicker(
      context: context,
      initialTime: monFrom,
    );
    if (newTime != null) {
      setState(() {
        monFrom = newTime;
        print(monFrom.format(context).toString());
      });
    }
  }

  void selctTueFrom() async {
    final TimeOfDay newTime = await showTimePicker(
      context: context,
      initialTime: tueFrom,
    );
    if (newTime != null) {
      setState(() {
        tueFrom = newTime;
        print(tueFrom.format(context).toString());
      });
    }
  }

  void selctWedFrom() async {
    final TimeOfDay newTime = await showTimePicker(
      context: context,
      initialTime: wedFrom,
    );
    if (newTime != null) {
      setState(() {
        wedFrom = newTime;
        print(wedFrom.format(context).toString());
      });
    }
  }

  void selctThuFrom() async {
    final TimeOfDay newTime = await showTimePicker(
      context: context,
      initialTime: thuFrom,
    );
    if (newTime != null) {
      setState(() {
        thuFrom = newTime;
        print(thuFrom.format(context).toString());
      });
    }
  }

  void selctFriFrom() async {
    final TimeOfDay newTime = await showTimePicker(
      context: context,
      initialTime: friFrom,
    );
    if (newTime != null) {
      setState(() {
        friFrom = newTime;
        print(friFrom.format(context).toString());
      });
    }
  }

  void selctSatFrom() async {
    final TimeOfDay newTime = await showTimePicker(
      context: context,
      initialTime: satFrom,
    );
    if (newTime != null) {
      setState(() {
        satFrom = newTime;
        print(satFrom.format(context).toString());
      });
    }
  }

  void selctSunFrom() async {
    final TimeOfDay newTime = await showTimePicker(
      context: context,
      initialTime: sunFrom,
    );
    if (newTime != null) {
      setState(() {
        sunFrom = newTime;
        print(sunFrom.format(context).toString());
      });
    }
  }

  void selctMonTo() async {
    final TimeOfDay newTime = await showTimePicker(
      context: context,
      initialTime: monTo,
    );
    if (newTime != null) {
      setState(() {
        monTo = newTime;
        print(monTo.format(context).toString());
      });
    }
  }

  void selctTueTo() async {
    final TimeOfDay newTime = await showTimePicker(
      context: context,
      initialTime: tueTo,
    );
    if (newTime != null) {
      setState(() {
        tueTo = newTime;
        print(tueTo.format(context).toString());
      });
    }
  }

  void selctWedTo() async {
    final TimeOfDay newTime = await showTimePicker(
      context: context,
      initialTime: wedTo,
    );
    if (newTime != null) {
      setState(() {
        wedTo = newTime;
        print(wedTo.format(context).toString());
      });
    }
  }

  void selctThuTo() async {
    final TimeOfDay newTime = await showTimePicker(
      context: context,
      initialTime: thuTo,
    );
    if (newTime != null) {
      setState(() {
        thuTo = newTime;
        print(thuTo.format(context).toString());
      });
    }
  }

  void selctFriTo() async {
    final TimeOfDay newTime = await showTimePicker(
      context: context,
      initialTime: friTo,
    );
    if (newTime != null) {
      setState(() {
        friTo = newTime;
        print(friTo.format(context).toString());
      });
    }
  }

  void selctSatTo() async {
    final TimeOfDay newTime = await showTimePicker(
      context: context,
      initialTime: satTo,
    );
    if (newTime != null) {
      setState(() {
        satTo = newTime;
        print(satTo.format(context).toString());
      });
    }
  }

  void selctSunTo() async {
    final TimeOfDay newTime = await showTimePicker(
      context: context,
      initialTime: sunTo,
    );
    if (newTime != null) {
      setState(() {
        sunTo = newTime;
        print(sunTo.format(context).toString());
      });
    }
  }

  void _selectTime() async {
    final TimeOfDay newTime = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (newTime != null) {
      setState(() {
        _time = newTime;
        print(_time.format(context).toString());
      });
    }
  }

  void _selectTime1() async {
    final TimeOfDay newTime = await showTimePicker(
      context: context,
      initialTime: _time1,
    );
    if (newTime != null) {
      setState(() {
        _time1 = newTime;
      });
    }
  }

  List<Asset> images = <Asset>[];
  String _error = 'No Error Detected';

  Widget BuildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return AssetThumb(
          asset: asset,
          width: 300,
          height: 300,
        );
      }),
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 5,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#8522a9",
          actionBarTitle: "My JINI Advertisement",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;
    });
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      helpText: 'Select Validity Date',
      // Refer step 1
      firstDate: DateTime(2021),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  _selectDate1(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate1,
      helpText: 'Select Validity Date',
      // Refer step 1
      firstDate: DateTime(2021),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate1 = picked;
      });
  }

  _getData() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      print(selectedDate);
      // Id = widget.AdList["Id"];
      offerTitle.text = widget.AdList["DealName"];
      offerPrice.text = widget.AdList["OfferPrice"].toString();
      price.text = widget.AdList["ActualPrice"].toString();
      offerDescription.text = widget.AdList["Description"];
      values = [
        widget.AdList["weekSchedule"]["Sunday"]["Active"],
        widget.AdList["weekSchedule"]["Monday"]["Active"],
        widget.AdList["weekSchedule"]["Tuesday"]["Active"],
        widget.AdList["weekSchedule"]["Wednesday"]["Active"],
        widget.AdList["weekSchedule"]["Thursday"]["Active"],
        widget.AdList["weekSchedule"]["Friday"]["Active"],
        widget.AdList["weekSchedule"]["Saturday"]["Active"],
      ];
      terms.text = widget.AdList["TermsAndCondition"];
      offerLink.text = widget.AdList["DealLink"];
      checkBox1 = widget.AdList["OfferType"];
      selectedDate = DateTime(
        int.parse(widget.AdList["StartDate"][0]
            .toString()
            .split(",")[0]
            .split("/")[2]
            .toString()),
        int.parse(widget.AdList["StartDate"][0]
            .toString()
            .split(",")[0]
            .split("/")[1]
            .toString()),
        int.parse(widget.AdList["StartDate"][0]
            .toString()
            .split(",")[0]
            .split("/")[0]
            .toString()),
      );
      selectedDate1 = DateTime(
        int.parse(widget.AdList["ExpiryDate"][0]
            .toString()
            .split(",")[0]
            .split("/")[2]
            .toString()),
        int.parse(widget.AdList["ExpiryDate"][0]
            .toString()
            .split(",")[0]
            .split("/")[1]
            .toString()),
        int.parse(widget.AdList["ExpiryDate"][0]
            .toString()
            .split(",")[0]
            .split("/")[0]
            .toString()),
      );
      // selectedDate1=widget.AdList["ExpiryDate"];
      _url = widget.AdList[""];
    });
  }

  _updatePost() async {
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

          filename = AdImage.path.split('/').last;
          filePath = compressedFile.path;
        }

        SharedPreferences preferences = await SharedPreferences.getInstance();
        FormData data = FormData.fromMap({
          "Id": widget.AdList["_id"],
          "Title": offerTitle.text,
          "Description": offerDescription.text,
          "Price": offerPrice.text,
          "Image": (filePath != null && filePath != '')
              ? await MultipartFile.fromFile(filePath,
                  filename: filename.toString())
              : null,
          // "UserId": preferences.getString(cnst.Session.Id),
        });

        Services.UpdateAd(data).then((data) async {
          pr.hide();
          if (data.Data != "0" && data.IsSuccess == true) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString(cnst.Session.AdImage, "${data.Data}");

            Fluttertoast.showToast(
                msg: "Ad Successfully Updated",
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
      //  widget.AdList["Image"] = AdImage;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Post Ad"),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          color: cnst.appPrimaryMaterialColor,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: cnst.appPrimaryMaterialColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(right: 10, left: 10, bottom: 10),
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                Cmnt(
                  title: "Offer Title",
                  controller: offerTitle,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 15.0, right: 5.0, left: 5.0),
                  child: Row(
                    children: <Widget>[
                      Text('Tags',
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5, right: 5, left: 5),
                  child: TextFieldTags(
                    initialTags: List<String>.from(widget.AdList["Keywords"]),
                    tagsStyler: TagsStyler(
                        tagTextStyle: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                        tagCancelIcon: Icon(Icons.cancel_rounded,
                            size: 16.0,
                            color: Color.fromARGB(255, 235, 214, 214)),
                        tagPadding: const EdgeInsets.all(10.0),
                        showHashtag: true,
                        tagDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Color.fromRGBO(134, 34, 169, .7))),
                    textFieldStyler: TextFieldStyler(),
                    onTag: (tag) {
                      Tags.add(tag);
                      print(Tags);
                    },
                    onDelete: (tag) {
                      Tags.remove(tag);
                      print(Tags);
                    },
                  ),
                ),
                // Padding(
                //   padding:
                //   const EdgeInsets.only(top: 15.0, right: 5.0, left: 5.0),
                //   child: Row(
                //     children: <Widget>[
                //       Text("Select Category",
                //           style: TextStyle(
                //               fontSize: 15,
                //               color: Colors.grey[600],
                //               fontWeight: FontWeight.w500))
                //     ],
                //   ),
                // ),
                // Padding(
                //   padding: const EdgeInsets.only(top: 4.0, bottom: 6.0),
                //   child: Container(
                //     decoration: BoxDecoration(
                //         color: Colors.grey[200],
                //         borderRadius: BorderRadius.circular(8.0)),
                //     child: DropdownButtonHideUnderline(
                //       child: ButtonTheme(
                //         alignedDropdown: true,
                //         child: DropdownButton(
                //           isExpanded: true,
                //           value: widget.AdList[""],
                //           iconSize: 30,
                //           icon: (null),
                //           style: TextStyle(
                //             color: Colors.black54,
                //             fontSize: 16,
                //           ),
                //           hint: Text(
                //             'Select Category',
                //             style: TextStyle(
                //               fontSize: 13,
                //               color: Colors.grey,
                //             ),
                //             // style: fontConstants.formFieldLabel,
                //           ),
                //           onChanged: (var newValue) {
                //             setState(() {
                //               Dealtype = newValue;
                //               category = newValue.toString();
                //               print(Dealtype);
                //             });
                //           },
                //           items: dealCategory?.map((item) {
                //             return new DropdownMenuItem(
                //               child: new Text(item["DealCategoryName"]),
                //               value: item["_id"].toString(),
                //             );
                //           })?.toList() ??
                //               [],
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 15.0, right: 5.0, left: 5.0),
                  child: Row(
                    children: <Widget>[
                      Text("Offer Type",
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500))
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.zero,
                  margin: EdgeInsets.zero,
                  child: Row(
                    children: [
                      Checkbox(
                        value: checkBox1,
                        activeColor: Color.fromRGBO(134, 34, 169, 1),
                        onChanged: (bool newValue) {
                          setState(() {
                            checkBox1 = newValue;
                          });
                        },
                      ),
                      Text('One Time'),
                      Checkbox(
                          value: !checkBox1,
                          activeColor: Color.fromRGBO(134, 34, 169, 1),
                          onChanged: (bool newValue) {
                            setState(() {
                              checkBox1 = !newValue;
                            });
                          }),
                      Text('Multiple'),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 5.0, right: 5.0, left: 5.0),
                  child: Row(
                    children: <Widget>[
                      Text("validity Date",
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 5, left: 5, top: 5),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Start Date',
                          style: TextStyle(
                              fontWeight: FontWeight.w400, color: Colors.grey),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${DateFormat('dd/MM/yyyy').format(selectedDate)}",
                              style: TextStyle(
                                  fontSize: 24, color: Colors.grey[600]),
                            ),
                            RaisedButton(
                              onPressed: () =>
                                  _selectDate(context), // Refer step 3
                              child: Text(
                                'Select date',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              color: Color.fromRGBO(134, 34, 169, 1),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 5, left: 5, top: 5),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'End Date',
                          style: TextStyle(
                              fontWeight: FontWeight.w400, color: Colors.grey),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${DateFormat('dd/MM/yyyy').format(selectedDate1)}",
                              style: TextStyle(
                                  fontSize: 24, color: Colors.grey[600]),
                            ),
                            RaisedButton(
                              onPressed: () =>
                                  _selectDate1(context), // Refer step 3
                              child: Text(
                                'Select date',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              color: Color.fromRGBO(134, 34, 169, 1),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 5.0, right: 5.0, left: 5.0),
                  child: Row(
                    children: <Widget>[
                      Text("Valid Days & Time",
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: WeekdaySelector(
                    onChanged: (int hope) {
                      setState(() {
                        final index = hope % 7;
                        values[index] = !values[index];
                        print(values);
                      });
                    },
                    values: values,
                    selectedFillColor: Color.fromRGBO(134, 34, 169, .9),
                    selectedTextStyle: TextStyle(fontWeight: FontWeight.bold),
                    textStyle: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: _selectTime,
                      child: Container(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          'From : ${_time.format(context)}',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _selectTime1,
                      child: Container(
                        margin: EdgeInsets.only(right: 10),
                        child: Text(
                          'To : ${_time1.format(context)}',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Row(
                    children: [
                      Checkbox(
                          value: manualTime,
                          activeColor: Color.fromRGBO(134, 34, 169, 1),
                          onChanged: (bool newValue) {
                            setState(() {
                              manualTime = newValue;
                            });
                          }),
                      Text('Select Manual Time'),
                    ],
                  ),
                ),
                Visibility(
                  visible: manualTime,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.all(5),
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                            borderRadius: BorderRadius.circular(3),
                            color: Colors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Mon'),
                              GestureDetector(
                                onTap: selctMonFrom,
                                child: Container(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Text(
                                    'From : ${monFrom.format(context)}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: selctMonTo,
                                child: Container(
                                  margin: EdgeInsets.only(right: 10),
                                  child: Text(
                                    'To : ${monTo.format(context)}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(5),
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                            borderRadius: BorderRadius.circular(3),
                            color: Colors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Tue'),
                              GestureDetector(
                                onTap: selctTueFrom,
                                child: Container(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Text(
                                    'From : ${tueFrom.format(context)}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: selctTueTo,
                                child: Container(
                                  margin: EdgeInsets.only(right: 10),
                                  child: Text(
                                    'To : ${tueTo.format(context)}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(5),
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                            borderRadius: BorderRadius.circular(3),
                            color: Colors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('wed'),
                              GestureDetector(
                                onTap: selctWedFrom,
                                child: Container(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Text(
                                    'From : ${wedFrom.format(context)}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: selctWedTo,
                                child: Container(
                                  margin: EdgeInsets.only(right: 10),
                                  child: Text(
                                    'To : ${wedTo.format(context)}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(5),
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                            borderRadius: BorderRadius.circular(3),
                            color: Colors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Thu'),
                              GestureDetector(
                                onTap: selctThuFrom,
                                child: Container(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Text(
                                    'From : ${thuFrom.format(context)}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: selctThuTo,
                                child: Container(
                                  margin: EdgeInsets.only(right: 10),
                                  child: Text(
                                    'To : ${thuTo.format(context)}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(5),
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                            borderRadius: BorderRadius.circular(3),
                            color: Colors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Fri'),
                              GestureDetector(
                                onTap: selctFriFrom,
                                child: Container(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Text(
                                    'From : ${friFrom.format(context)}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: selctFriTo,
                                child: Container(
                                  margin: EdgeInsets.only(right: 10),
                                  child: Text(
                                    'To : ${friTo.format(context)}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(5),
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                            borderRadius: BorderRadius.circular(3),
                            color: Colors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Sat'),
                              GestureDetector(
                                onTap: selctSatFrom,
                                child: Container(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Text(
                                    'From : ${satFrom.format(context)}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: selctSatTo,
                                child: Container(
                                  margin: EdgeInsets.only(right: 10),
                                  child: Text(
                                    'To : ${satTo.format(context)}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(5),
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                            borderRadius: BorderRadius.circular(3),
                            color: Colors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Sun'),
                              GestureDetector(
                                onTap: selctSunFrom,
                                child: Container(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Text(
                                    'From : ${sunFrom.format(context)}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: selctSunTo,
                                child: Container(
                                  margin: EdgeInsets.only(right: 10),
                                  child: Text(
                                    'To : ${sunTo.format(context)}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Cmnt(
                  title: "Price",
                  controller: price,
                ),
                Cmnt(
                  title: "Offer Price",
                  controller: offerPrice,
                ),
                Cmnt(
                  title: "Offer Link",
                  controller: offerLink,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 15.0, right: 5.0, left: 5.0),
                  child: Row(
                    children: <Widget>[
                      Text("Description",
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500))
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 5.0, right: 5.0, top: 6.0),
                  child: SizedBox(
                    height: 100,
                    child: TextFormField(
                      textAlign: TextAlign.start,
                      maxLines: 4,
                      controller: offerDescription,
                      keyboardType: TextInputType.multiline,
                      validator: (value) {
                        if (value.trim() == "") {
                          return 'Please Enter Desription';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(5.0),
                            borderSide: new BorderSide(),
                          ),
                          labelText: "Description",
                          alignLabelWithHint: true,
                          hintStyle: TextStyle(fontSize: 13)),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 15.0, right: 5.0, left: 5.0),
                  child: Row(
                    children: <Widget>[
                      Text("Terms & Conditon",
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500))
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 5.0, right: 5.0, top: 6.0),
                  child: SizedBox(
                    height: 100,
                    child: TextFormField(
                      textAlign: TextAlign.start,
                      maxLines: 4,
                      controller: terms,
                      keyboardType: TextInputType.multiline,
                      validator: (value) {
                        if (value.trim() == "") {
                          return 'Please Enter Terms & Condition';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(5.0),
                            borderSide: new BorderSide(),
                          ),
                          labelText: "Terms & Condition",
                          alignLabelWithHint: true,
                          hintStyle: TextStyle(fontSize: 13)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 15.0, right: 5.0, left: 5.0),
                  child: Row(
                    children: <Widget>[
                      Text("Upload Image",
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500))
                    ],
                  ),
                ),
                // Center(
                //   child: GestureDetector(
                //     onTap: () {
                //       _showPicker(context);
                //     },
                //     child: Padding(
                //       padding: const EdgeInsets.all(15.0),
                //       child: Container(
                //         decoration: BoxDecoration(
                //             borderRadius: BorderRadius.circular(4),
                //             border: Border.all(
                //                 width: 4,
                //                 color: Color.fromRGBO(134, 34, 169, .7))),
                //         child: _image != null
                //             ? ClipRRect(
                //                 borderRadius: BorderRadius.circular(3),
                //                 child: Image.file(
                //                   _image,
                //                   // width: 100,
                //                   // height: 100,
                //                   fit: BoxFit.fitHeight,
                //                 ),
                //               )
                //             : Container(
                //                 decoration: BoxDecoration(
                //                     color: Colors.grey[200],
                //                     borderRadius: BorderRadius.circular(3)),
                //                 width: 100,
                //                 height: 100,
                //                 child: Icon(
                //                   Icons.camera_alt,
                //                   color: Colors.grey[800],
                //                 ),
                //               ),
                //       ),
                //     ),
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: GestureDetector(
                    onTap: loadAssets,
                    child: Container(
                      height: 200,
                      child: DottedBorder(
                          color: Colors.grey,
                          dashPattern: [4],
                          padding: EdgeInsets.all(6.0),
                          child: BuildGridView()),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: Color.fromRGBO(134, 34, 169, .6)),
                          ),
                        )),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        margin: EdgeInsets.only(right: 5),
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color.fromRGBO(134, 34, 169, .8)),
                        child: Text('Submit',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white)),
                      ),
                    ),
                    // ElevatedButton(onPressed: (){},style: ElevatedButton.styleFrom(primary: Color.fromRGBO(134, 34, 169, .8),minimumSize: Size(150, 50)),child: Text('Submit',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700),)),
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

class Cmnt extends StatefulWidget {
  String title;
  TextEditingController controller;
  double height;

  Cmnt({this.title, this.controller, this.height});

  @override
  _CmntState createState() => _CmntState();
}

class _CmntState extends State<Cmnt> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0, right: 5.0, left: 5.0),
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
          padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 6.0),
          child: SizedBox(
            height: 50,
            child: TextFormField(
              validator: (value) {
                if (value.trim() == "") {
                  return 'Please Enter ${widget.title}';
                }
                return null;
              },
              focusNode: FocusNode(),
              controller: widget.controller,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(5.0),
                    borderSide: new BorderSide(),
                  ),
                  labelText: "${widget.title}",
                  hintStyle: TextStyle(fontSize: 13)),
            ),
          ),
        ),
      ],
    );
  }
}
