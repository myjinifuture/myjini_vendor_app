import 'package:flutter/material.dart';

class NotificationComponent extends StatefulWidget {
  @override
  _NotificationComponentState createState() => _NotificationComponentState();
}

class _NotificationComponentState extends State<NotificationComponent> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Card(
            color: Colors.grey[200],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Title",
                    textDirection: TextDirection.ltr,
                    style: TextStyle(fontSize: 19.0, fontWeight: FontWeight.w700),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left:8.0,bottom: 8.0),
                  child: Text(
                    "Message",
                    textDirection: TextDirection.ltr,
                    style: TextStyle(fontSize: 14.0, color: Colors.grey[800]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Date",
                    textDirection: TextDirection.ltr,
                    style: TextStyle(
                        fontSize: 15.0, fontWeight: FontWeight.w700,color: Colors.grey[600]),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
