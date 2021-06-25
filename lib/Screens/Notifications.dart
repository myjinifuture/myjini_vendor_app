import 'package:flutter/material.dart';
import 'package:smartsocietyadvertisement/Common/constant.dart' as cnst;
import 'package:smartsocietyadvertisement/Component/NotificationComponent.dart';


class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.white,),
          color: cnst.appPrimaryMaterialColor,
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
                context, "/Dashboard", (Route<dynamic> route) => false);
          },
        ),
        backgroundColor: cnst.appPrimaryMaterialColor,
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
                itemCount:5,
                itemBuilder: (BuildContext context, int index) {
                  return NotificationComponent();/*NotificationExhibitorComponent(notificationList[index]);*/
                }),
          ),
        ],
      )
    );
  }
}
