import 'package:flutter/material.dart';

const Inr_Rupee = "₹";

const String whatsAppLink = "https://wa.me/#mobile?text=#msg";
const String playstoreUrl = "https://shorturl.at/iosL8";
const String inviteFriMsg =
    "smart & simple app to manage your digital visiting card & business profile.\nDownload the app from #appurl and use my refer code “#refercode” to get 15 days free trial.";

const String API_URL = "http://smartsociety.itfuturz.com/api/AppAPI/";
// const String API_URL1 = "https://myjini.herokuapp.com/";
// const String API_URL1 = "http://3.7.94.50/";
const String API_URL1 = "http://13.127.1.141/";
const String Access_Token='Mjdjhcbj43jkmsijkmjJKJKJoijlkmlkjo-HfdkvjDJjMoikjnNJn-JNFhukmk';
const String IMG_URL = "http://smartsociety.itfuturz.com/";



class Session {
  static const String VendorId = "VendorId";
  static const String Mobile = "MobileNo";
  static const String Name = "PersonName";
  static const String Email = "Email";
  static const String Address = "Address";
  static const String Pincode = "Pincode";
  static const String Area = "Area";
  static const String CityId = "CityId";
  static const String CityName = "CityName";
  static const String StateId = "StateId";
  static const String StateName = "StateName";
  static const String CompanyName = "CompanyName";
  static const String WebsiteURL = "WebsiteURL";
  static const String YoutubeURL = "YoutubeURL";
  static const String GSTNo = "GSTNo";
  static const String ReferalCode = "ReferalCode";
  static const String IsVerified = "IsVerified";
  static const String AdImage = "AdImage";
  static const String ProductImage = "ProductImage";
  static const String ProfileImage = "ProfileImage";
  static const String MemberId = "MemberId";
}

Map<int, Color> appprimarycolors = {
  50: Color.fromRGBO(114, 34, 169, .1),
  100: Color.fromRGBO(114, 34, 169, .2),
  200: Color.fromRGBO(114, 34, 169, .3),
  300: Color.fromRGBO(114, 34, 169, .4),
  400: Color.fromRGBO(114, 34, 169, .5),
  500: Color.fromRGBO(114, 34, 169, .6),
  600: Color.fromRGBO(114, 34, 169, .7),
  700: Color.fromRGBO(114, 34, 169, .8),
  800: Color.fromRGBO(114, 34, 169, .9),
  900: Color.fromRGBO(114, 34, 169, 1)
};

MaterialColor appPrimaryMaterialColor =
    MaterialColor(0xFF7222A9, appprimarycolors);
