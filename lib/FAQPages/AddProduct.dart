import 'package:flutter/material.dart';
import 'package:smartsocietyadvertisement/Common/constant.dart' as cnst;


class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: cnst.appPrimaryMaterialColor,
        title: Text("How to add product"),
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
                      Icon(Icons.add_circle_outline),
                      Text(
                        " symbol in bottom.",
                        style: TextStyle(fontSize: 17),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                  ),
                  Text(
                    "2. Slide tab to Add Product.",
                    style: TextStyle(fontSize: 17),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                  ),
                  Text(
                    "3. Enter your product details.",
                    style: TextStyle(fontSize: 17),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                  ),
                  Text(
                    "4. Click on Add Product.",
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
