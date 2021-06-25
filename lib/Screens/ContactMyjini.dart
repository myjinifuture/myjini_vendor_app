import 'package:flutter/material.dart';
import 'package:smartsocietyadvertisement/Screens/PaymentGateWay.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactMyjini extends StatefulWidget {
  String id;
  ContactMyjini({this.id});
  @override
  _ContactMyjiniState createState() => _ContactMyjiniState();
}

class _ContactMyjiniState extends State<ContactMyjini> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("Id");
    print(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Contact Myjini'),backgroundColor: Color.fromRGBO(114, 34, 169, 1),),
      body: SafeArea(
        child: Center(
          child: Container(
            padding: EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Contact To MyJini Advertisement Team',
                  // style: TextStyle(fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('98765 43210',style: TextStyle(fontSize: 20),),
                    SizedBox(width: 10,),
                    IconButton(icon: Icon(Icons.call),color: Color.fromRGBO(114, 34, 169, 1),iconSize: 25, onPressed: (){
                      const url='tel:9876543210';
                      setState(() {
                        launch(url);
                      });
                    }),
                    // Icon(Icons.call),
                  ],
                ),
                SizedBox(height: 30,),
                Text('Or',style: TextStyle(fontWeight: FontWeight.bold),),
                GestureDetector(
                  child: Container(
                    margin: EdgeInsets.only(left: 16, right: 16, top: 50),
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(114, 34, 169, 1),
                      // color: primaryColor,
                      // border: Border.all(width: 1),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Pay Now',
                      style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                    ),
                  ),
                  onTap: () {
                    // Navigator.pushReplacementNamed(context, '/PaymentGateWay');
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                     return RazorPayScreen(id: widget.id,);
                    },));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
