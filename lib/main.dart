import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:smartsocietyadvertisement/Common/constant.dart';
import 'package:smartsocietyadvertisement/FAQPages/Ad.dart';
import 'package:smartsocietyadvertisement/FAQPages/AddProduct.dart';
import 'package:smartsocietyadvertisement/FAQPages/ViewProduct.dart';
import 'package:smartsocietyadvertisement/Pages/Home.dart';
import 'package:smartsocietyadvertisement/Pages/Menu.dart';
import 'package:smartsocietyadvertisement/Pages/Profile.dart';
import 'package:smartsocietyadvertisement/Screens/AdvertisementCreate.dart';
import 'package:smartsocietyadvertisement/Screens/ContactMyjini.dart';
import 'package:smartsocietyadvertisement/Screens/FAQPage.dart';
import 'package:smartsocietyadvertisement/Screens/ListProduct.dart';
import 'package:smartsocietyadvertisement/Screens/OTPScreen.dart';
import 'package:smartsocietyadvertisement/Screens/PaymentGateWay.dart';
import 'package:smartsocietyadvertisement/Screens/PdfGenerate.dart';
import 'package:smartsocietyadvertisement/Screens/PostAdScreen.dart';
import 'package:smartsocietyadvertisement/Screens/PrivacyPolicy.dart';
import 'package:smartsocietyadvertisement/Screens/ReferAndEarn.dart';
import 'package:smartsocietyadvertisement/Screens/RefundPolicy.dart';
import 'package:smartsocietyadvertisement/Screens/TermsAndCondition.dart';
import 'package:smartsocietyadvertisement/Screens/TermsOfService.dart';
import 'package:smartsocietyadvertisement/Screens/UpdateAdScreen.dart';
import 'package:smartsocietyadvertisement/Screens/UpdateProduct.dart';
import 'package:smartsocietyadvertisement/Screens/Offers.dart';

import 'Screens/Dashboard.dart';
import 'Screens/LoginScreen.dart';
import 'Screens/Notifications.dart';
import 'Screens/OTPVerification.dart';
import 'Screens/RegistrationScreen.dart';
import 'Screens/Splashscreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My JINI Advertisement',
      theme: ThemeData(primaryColor: appPrimaryMaterialColor),
      initialRoute: '/',
      routes: {
        '/': (context) => Splashscreen(),
        // '/': (context) => PdfGenerate(),
        // '/': (context) => Dashboard(),
        // '/': (context) => ContactMyjini(),
        '/LoginScreen': (context) => LoginScreen(),
        '/RegistrationScreen': (context) => RegistrationScreen(),
        '/Dashboard': (context) => Dashboard(),
        '/OTPVerification': (context) => OTPVerification(),
        '/Notifications': (context) => Notifications(),
        '/PostAdScreen': (context) => PostAdScreen(),
        '/TermsAndCondition': (context) => TermsAndCondition(),
        '/ReferAndEarn': (context) => ReferAndEarn(),
        //'/UpdateProduct': (context) => UpdateProduct(),
        '/FAQPage': (context) => FAQPage(),
        '/ViewProduct': (context) => ViewProduct(),
        '/AddProduct': (context) => AddProduct(),
        '/Ad': (context) => Ad(),
        '/ListProduct': (context) => ListProduct(),
        '/AdvertisementCreate': (context) => AdvertisementCreate(),
        '/PaymentGateWay':(context)=>RazorPayScreen(),
        '/ContactMyjini':(context)=>ContactMyjini(),
        '/PdfGenerate':(context)=>PdfGenerate(),
        '/Offers':(context)=>Offers(),
        '/TermsOfService':(context)=>TermsOfService(),
        '/PrivacyPolicy':(context)=>PrivacyPolicy(),
        '/RefundPolicy':(context)=>RefundPolicy(),
      },
    );
  }
}
