import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsocietyadvertisement/Common/Services.dart';
import 'package:smartsocietyadvertisement/Common/constant.dart' as cnst;
import 'package:smartsocietyadvertisement/Common/constant.dart';
import 'package:smartsocietyadvertisement/Screens/AddServices.dart';

class ManageService extends StatefulWidget {
  var Id;
  ManageService({this.Id});

  @override
  _ManageServiceState createState() => _ManageServiceState();
}

class _ManageServiceState extends State<ManageService> {
  bool isLoading=false;
  List Ser=[];

  getServices() async{
    try {
      setState(() {
        isLoading = true;
      });
      final internetResult = await InternetAddress.lookup('google.com');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String ven = prefs.getString(cnst.Session.VendorId);
      print(ven);

      if (internetResult.isNotEmpty &&
          internetResult[0].rawAddress.isNotEmpty) {
        var body = {
          "advertiseId": "${widget.Id}",
        };
        Services.responseHandler(
            apiName: "adsVendor/getAdvertiseServices", body: body)
            .then((responseData) {
          if (responseData.Data.length > 0) {
            print('Message:' + responseData.Message.toString());
            Fluttertoast.showToast(msg: responseData.Message.toString());
            print(responseData.Data);
            setState(() {
              isLoading = false;
              Ser=responseData.Data;
              print(Ser);

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
        msg: "You aren't connected to the Internet ! !",
        backgroundColor: Colors.white,
        textColor: appPrimaryMaterialColor,
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getServices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(" Create Service"),
        centerTitle: true,
        backgroundColor: appPrimaryMaterialColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            // bottom: Radius.circular(10),
          ),
        ),
      ),
      body:isLoading? Center(child: CircularProgressIndicator()):
      ListView.builder(physics: BouncingScrollPhysics(),shrinkWrap: true,itemCount: Ser.length,itemBuilder: (context, index) {
        return Card(
          shape: RoundedRectangleBorder(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${Ser[index]["Title"]}',style: TextStyle(fontSize: 22),),
                Text('${Ser[index]["Body"]}',textAlign: TextAlign.justify,style: TextStyle(fontSize: 15,color: Colors.grey),),
              ],
            ),
          ),
        );
      },),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return AddServices(Id: widget.Id,);
          },));
        },
        child: Icon(
          Icons.add,
          size: 32,
        ),
        backgroundColor: appPrimaryMaterialColor,
      ),
    );
  }
}
