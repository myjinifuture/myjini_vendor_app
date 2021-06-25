import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smartsocietyadvertisement/Common/constant.dart' as cnst;
import 'package:url_launcher/url_launcher.dart';

class ProductInquiryComponent extends StatefulWidget {
  var InquiryList;

  ProductInquiryComponent(this.InquiryList);

  @override
  _ProductInquiryComponentState createState() =>
      _ProductInquiryComponentState();
}

class _ProductInquiryComponentState extends State<ProductInquiryComponent> {
  String setDate(String date) {
    String final_date = "";
    var tempDate;
    if (date != "" || date != null) {
      tempDate = date.toString().split("-");
      if (tempDate[2].toString().length == 1) {
        tempDate[2] = "0" + tempDate[2].toString();
      }
      if (tempDate[1].toString().length == 1) {
        tempDate[1] = "0" + tempDate[1].toString();
      }
      final_date = "${tempDate[2].toString().substring(0, 2)}-"
              "${tempDate[1].toString().substring(0, 2)}-${tempDate[0].toString()}"
          .toString();
    }
    return final_date;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: SizedBox(
        height: 150,
        child: Row(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10)),
              child: widget.InquiryList["Image"] != "" &&
                      widget.InquiryList["Image"] != null
                  ? FadeInImage.assetNetwork(
                      placeholder: "images/Ad1.jpg",
                      width: 130,
                      height: 150,
                      fit: BoxFit.cover,
                      image: "${cnst.IMG_URL}" + widget.InquiryList["Image"])
                  : Image.asset(
                      "images/Ad1.jpg",
                      width: MediaQuery.of(context).size.width,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
            ),
            Flexible(
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: new BoxDecoration(
                    border: Border.all(color: Colors.grey[300]),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text("${widget.InquiryList["ProductName"]}",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right:8.0),
                          child: GestureDetector(
                              onTap: () {
                                if (widget.InquiryList["MemberMobile"] == "" ||
                                    widget.InquiryList["MemberMobile"] == null) {
                                  Fluttertoast.showToast(
                                      msg: "Mobile Number not available!!!",
                                      toastLength: Toast.LENGTH_SHORT);
                                } else {
                                  launch(
                                      'tel:${widget.InquiryList["MemberMobile"]}');
                                }
                                print("Mobile --> " +
                                    widget.InquiryList["MemberMobile"]);
                              },
                              child: Image.asset(
                                "images/telephone.png",
                                width: 20,
                                height: 20,
                              )),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        "${widget.InquiryList["MemberName"]}",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text("${setDate(widget.InquiryList["Date"])}",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w400)),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text("${widget.InquiryList["Description"]}",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
