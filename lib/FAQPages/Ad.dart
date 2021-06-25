import 'package:flutter/material.dart';
import 'package:smartsocietyadvertisement/Common/constant.dart' as cnst;


class Ad extends StatefulWidget {
  @override
  _AdState createState() => _AdState();
}

class _AdState extends State<Ad> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: cnst.appPrimaryMaterialColor,
        title: Text("How to add new AD"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        "1. Go to ",
                        style: TextStyle(fontSize: 17),
                      ),
                      Icon( Icons.home),
                      Text(
                        " symbol in bottom.",
                        style: TextStyle(fontSize: 17),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        "2. Click floating ADD button on screen.",
                        style: TextStyle(fontSize: 17),
                      ),

                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                  ),
                  Text(
                    "3. Enter your AD details.",
                    style: TextStyle(fontSize: 17),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                  ),
                  Text(
                    "4. Click on Add Post.",
                    style: TextStyle(fontSize: 17),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
