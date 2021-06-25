import 'package:flutter/material.dart';
import 'package:smartsocietyadvertisement/Common/constant.dart' as cnst;


class FAQPage extends StatefulWidget {
  @override
  _FAQPageState createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: cnst.appPrimaryMaterialColor,
        title: Text("FAQ"),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Column(
                children: <Widget>[
                  InkWell(
                    onTap: (){
                      Navigator.pushNamed(context, '/AddProduct');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "How to add product",
                            style: TextStyle(
                                fontSize: 17),
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          size: 30,
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  InkWell(
                    onTap: (){
                      Navigator.pushNamed(context, '/ViewProduct');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "How to view product listing",
                              style: TextStyle(
                                  fontSize: 17),
                            ),
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          size: 30,
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  InkWell(
                    onTap: (){
                      Navigator.pushNamed(context, '/Ad');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "How to add new AD",
                            style: TextStyle(
                                fontSize: 17),
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          size: 30,
                        ),
                      ],
                    ),
                  ),


                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
