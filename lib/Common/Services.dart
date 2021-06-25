import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsocietyadvertisement/Common/ClassList.dart';
import 'package:smartsocietyadvertisement/Common/constant.dart';
import 'package:xml2json/xml2json.dart';
// import 'package:smartsocietyadvertisement/Common/Constant.dart';
import 'package:smartsocietyadvertisement/Common/Constant.dart' as cnst;

Dio dio = new Dio();
Xml2Json xml2json = new Xml2Json();

class Services {
  static Future<ResponseDataClass> responseHandler(
      {@required apiName, body}) async {
    String url = API_URL1 + "$apiName";
    var header = Options(
      headers: {
        "authorization": "$Access_Token" // set content-length
      },
    );
    var response;
    try {
      if (body == null) {
        response = await dio.post(url, options: header);
      } else {
        response = await dio.post(url, data: body, options: header);
      }
      if (response.statusCode == 200) {
        ResponseDataClass responseData = new ResponseDataClass(
            Message: "No Data", IsSuccess: false, Data: "");
        var data = response.data;
        responseData.Message = data["Message"];
        responseData.IsSuccess = data["IsSuccess"];
        responseData.Data = data["Data"];

        return responseData;
      } else {
        print("error ->" + response.data.toString());
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Catch error -> ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<ResponseDataClass> responseHandlerForBase64(
      {@required apiName, body}) async {
    String url = API_URL1 + "$apiName";
    var header = Options(
        headers: {
          "authorization": "$Access_Token" ,
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        contentType: Headers.formUrlEncodedContentType
    );
    String jsonString = json.encode(body); // encode map to json
    // String paramName = 'param'; // give the post param a name
    // String formBody = paramName + '=' + Uri.encodeQueryComponent(jsonString);
    var response;
    //Instance level
    dio.options.contentType= Headers.formUrlEncodedContentType;
    try {
      if (jsonString == null) {
        response = await dio.post(url);
      } else {
        response = await dio.post(url, data: body,options:header);
      }
      print(body);
      print(apiName);
      if (response.statusCode == 200) {
        ResponseDataClass responseData = new ResponseDataClass(
            Message: "No Data", IsSuccess: false, Data: "");
        var data = response.data;
        print(response.data["Data"]);
        responseData.Message = data["Message"];
        responseData.IsSuccess = data["IsSuccess"];
        responseData.Data = data["Data"];

        return ResponseDataClass.fromJson(data);
      } else {
        print("error ->" + response.data.toString());
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Catch error -> ${e.toString()}");
      throw Exception(e.toString());
    }
  }


  static Future<SaveDataClass> AdRegister(body) async {
    print(body.toString());
    String url = cnst.API_URL + 'AdRegister';
    print("AdRegister : " + url);

    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveData =
            new SaveDataClass(Message: 'No Data', IsSuccess: false, Data: '0');

        var responseData = response.data;

        print("AdRegister Response: " + responseData.toString());

        saveData.Message = responseData["Message"].toString();
        saveData.IsSuccess = responseData["IsSuccess"];
        saveData.Data = responseData["Data"].toString();

        return saveData;
      } else {
        print("Server Error");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("App Error ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<List<stateClass>> GetState() async {
    String url = cnst.API_URL + "GetStates";
    print("GetState url = " + url);
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        List<stateClass> list = [];
        print("GetState Response: " + response.data.toString());
        var responseData = response.data;
        if (responseData["IsSuccess"] == true) {
          final jsonResponse = response.data;
          stateClassData stateclassdata =
              new stateClassData.fromJson(jsonResponse);

          list = stateclassdata.data;

          return list;
        }
      }
    } catch (e) {
      print("GetState error" + e);
      throw Exception(e);
    }
  }

  static Future<List<cityClass>> GetCity(String stateId) async {
    String url = cnst.API_URL + "GetCity?StateId=$stateId";
    print("GetCity url = " + url);
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        List<cityClass> list = [];
        print("GetCity Response: " + response.data.toString());
        var responseData = response.data;
        if (responseData["IsSuccess"] == true) {
          final jsonResponse = response.data;
          cityClassData cityclassdata =
              new cityClassData.fromJson(jsonResponse);
          list = cityclassdata.data;

          return list;
        }
      }
    } catch (e) {
      print("GetCity error" + e);
      throw Exception(e);
    }
  }

  static Future<List> Login(String mobile) async {
    String url = cnst.API_URL + 'AdLogin?MobileNo=$mobile';
    print("Login URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("Login Response: " + response.data.toString());
        var responseData = response.data;
        if (responseData["IsSuccess"] == true) {
          list = responseData["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception("Something Went Wrong");
      }
    } catch (e) {
      print("Login Erorr : " + e.toString());
      throw Exception(e);
    }
  }

  static Future<SaveDataClass> AdPost(body) async {
    print(body.toString());
    String url = cnst.API_URL + 'AdPost';
    print("AdPost : " + url);
    dio.options.contentType = Headers.formUrlEncodedContentType;
    dio.options.responseType = ResponseType.json;
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveData =
            new SaveDataClass(Message: 'No Data', IsSuccess: false, Data: '0');

        xml2json.parse(response.data.toString());
        var jsonData = xml2json.toParker();
        var responseData = json.decode(jsonData);

        print("AdPost Response: " + responseData["ResultData"].toString());
        print("Res:  ${responseData}");
        saveData.Message = responseData["ResultData"]["Message"].toString();
        saveData.IsSuccess = responseData["ResultData"]["IsSuccess"] == "true";
        saveData.Data = responseData["ResultData"]["Data"].toString();

        return saveData;
      } else {
        print("Server Error");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("App Error ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<List> GetAd(String id) async {
    String url = cnst.API_URL + 'GetAd?id=$id';
    print("GetAd URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("GetAd Response: " + response.data.toString());
        var responseData = response.data;
        if (responseData["IsSuccess"] == true) {
          list = responseData["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception("Something Went Wrong");
      }
    } catch (e) {
      print("GetAd Erorr : " + e.toString());
      throw Exception(e);
    }
  }

  static Future<List> GetAdvertisement(String id) async {
    String url = cnst.API_URL + 'GetAdvertiserAds?advertiserid=$id';
    print("GetAdvertisement URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("GetAdvertisement Response: " + response.data.toString());
        var responseData = response.data;
        if (responseData["IsSuccess"] == true) {
          list = responseData["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception("Something Went Wrong");
      }
    } catch (e) {
      print("GetAdvertisement Erorr : " + e.toString());
      throw Exception(e);
    }
  }

  static Future<List<categoryClass>> GetCategory() async {
    String url = cnst.API_URL + "GetAdCategory";
    print("GetAdCategory url = " + url);
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        List<categoryClass> list = [];
        print("GetAdCategory Response: " + response.data.toString());
        var responseData = response.data;
        if (responseData["IsSuccess"] == true) {
          final jsonResponse = response.data;
          categoryClassData categoryclassdata =
              new categoryClassData.fromJson(jsonResponse);

          list = categoryclassdata.data;

          return list;
        }
      }
    } catch (e) {
      print("GetAdCategory error" + e);
      throw Exception(e);
    }
  }

  static Future<List<subCategoryClass>> GetSubCategory(String ParentId) async {
    String url = cnst.API_URL + "GetAdSubCategory?ParentId=$ParentId";
    print("GetAdSubCategory url = " + url);
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        List<subCategoryClass> list = [];
        print("GetAdSubCategory Response: " + response.data.toString());
        var responseData = response.data;
        if (responseData["IsSuccess"] == true) {
          final jsonResponse = response.data;
          subCategoryClassData subcategoryclassdata =
              new subCategoryClassData.fromJson(jsonResponse);

          list = subcategoryclassdata.data;

          return list;
        }
      }
    } catch (e) {
      print("GetAdCategory error" + e);
      throw Exception(e);
    }
  }

  static Future<SaveDataClass> AddProduct(body) async {
    print(body.toString());
    String url = cnst.API_URL + 'AddProduct';
    print("AddProduct : " + url);
    dio.options.contentType = Headers.formUrlEncodedContentType;
    dio.options.responseType = ResponseType.json;
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveData =
            new SaveDataClass(Message: 'No Data', IsSuccess: false, Data: '0');

        xml2json.parse(response.data.toString());
        var jsonData = xml2json.toParker();
        var responseData = json.decode(jsonData);

        print("AddProduct Response: " + responseData["ResultData"].toString());
        print("Res:  ${responseData}");
        saveData.Message = responseData["ResultData"]["Message"].toString();
        saveData.IsSuccess = responseData["ResultData"]["IsSuccess"] == "true";
        saveData.Data = responseData["ResultData"]["Data"].toString();

        return saveData;
      } else {
        print("Server Error");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("App Error ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<List> GetProduct(String id) async {
    String url = cnst.API_URL + 'GetProduct?id=$id';
    print("GetProduct URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("GetProduct Response: " + response.data.toString());
        var responseData = response.data;
        if (responseData["IsSuccess"] == true) {
          list = responseData["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception("Something Went Wrong");
      }
    } catch (e) {
      print("GetProduct Erorr : " + e.toString());
      throw Exception(e);
    }
  }

  static Future<SaveDataClass> UploadVendorPhoto(body) async {
    print(body.toString());
    String url = cnst.API_URL + 'UploadAdVendorPhoto';
    print("UploadAdVendorPhoto : " + url);
    dio.options.contentType = Headers.formUrlEncodedContentType;
    dio.options.responseType = ResponseType.json;
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveData =
            new SaveDataClass(Message: 'No Data', IsSuccess: false, Data: '0');

        xml2json.parse(response.data.toString());
        var jsonData = xml2json.toParker();
        var responseData = json.decode(jsonData);

        print("UploadAdVendorPhoto Response: " +
            responseData["ResultData"].toString());

        saveData.Message = responseData["ResultData"]["Message"].toString();
        saveData.IsSuccess = responseData["ResultData"]["IsSuccess"] == "true";
        saveData.Data = responseData["ResultData"]["Data"].toString();

        return saveData;
      } else {
        print("Server Error");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("App Error ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<SaveDataClass> SendOtpToAdVendor(
      String MobileNo, String Code) async {
    String url = cnst.API_URL + 'SendOtpToAdVendor?mobile=$MobileNo&Code=$Code';
    print("SendOtpToAdVendor : " + url);

    try {
      final response = await dio.post(url);
      if (response.statusCode == 200) {
        SaveDataClass saveData =
            new SaveDataClass(Message: 'No Data', IsSuccess: false, Data: '0');

        var responseData = response.data;

        print("SendOtpToAdVendor Response: " + responseData.toString());

        saveData.Message = responseData["Message"].toString();
        saveData.IsSuccess = responseData["IsSuccess"];
        saveData.Data = responseData["Data"].toString();

        return saveData;
      } else {
        print("Server Error");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("App Error ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<SaveDataClass> VerifyAdVendor(String MobileNo) async {
    String url = cnst.API_URL + 'VerifyAdVendor?mobile=$MobileNo';
    print("VerifyAdVendor : " + url);

    try {
      final response = await dio.post(url);
      if (response.statusCode == 200) {
        SaveDataClass saveData =
            new SaveDataClass(Message: 'No Data', IsSuccess: false, Data: '0');

        var responseData = response.data;

        print("VerifyAdVendor Response: " + responseData.toString());

        saveData.Message = responseData["Message"].toString();
        saveData.IsSuccess = responseData["IsSuccess"];
        saveData.Data = responseData["Data"].toString();

        return saveData;
      } else {
        print("Server Error");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("App Error ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<List> GetTermsandCondition() async {
    String url = cnst.API_URL + 'GetVendorTermsConditions';
    print("GetVendorTermsConditions URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("GetVendorTermsConditions Response: " + response.data.toString());
        var responseData = response.data;
        if (responseData["IsSuccess"] == true) {
          list = responseData["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception("Something Went Wrong");
      }
    } catch (e) {
      print("GetVendorTermsConditions Erorr : " + e.toString());
      throw Exception(e);
    }
  }

  /*static Future<SaveDataClass> DeleteProduct(body) async {
    String url = cnst.API_URL + 'DeleteProduct';
    print("DeleteProduct Url url : " + url);
    try {
      final response = await dio.post(url,data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveData = new SaveDataClass(
            Message: 'No Data', IsSuccess: false, Data: '0');

        var responseData = response.data;

        print("DeleteProduct Response: " + responseData.toString());

        saveData.Message = responseData["Message"].toString();
        print("msg: ${saveData.Message}");
        saveData.IsSuccess =
        responseData["IsSuccess"].toString().toLowerCase() == "true"
            ? true
            : false;
        saveData.Data = responseData["Data"].toString();

        return saveData;
      } else {
        print("Error DeleteProduct Url");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error DeleteProduct Url : ${e.toString()}");
      throw Exception(e.toString());
    }
  }*/

  static Future<SaveDataClass> DeleteProduct(String id) async {
    String url = cnst.API_URL + 'DeleteProduct?id=$id';
    print("DeleteProduct URL: " + url);
    try {
      final response = await dio.post(url);
      if (response.statusCode == 200) {
        SaveDataClass saveData = new SaveDataClass(
            Message: 'No Data', IsSuccess: false, Data: '0');

        var responseData = response.data;

        print("DeleteProduct Response: " + responseData.toString());

        saveData.Message = responseData["Message"].toString();
        print("msg: ${saveData.Message}");
        saveData.IsSuccess =
        responseData["IsSuccess"].toString().toLowerCase() == "true"
            ? true
            : false;
        saveData.Data = responseData["Data"].toString();

        return saveData;
      } else {
        print("Error DeleteProduct Url");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("DeleteProduct Erorr : " + e.toString());
      throw Exception(e);
    }
  }



  /*static Future<SaveDataClass> DeleteAd(body) async {
    String url = cnst.API_URL + 'DeleteAd';
    print("DeleteAd Url url : " + url);
    try {
      final response = await dio.post(url,data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveData = new SaveDataClass(
            Message: 'No Data', IsSuccess: false, Data: '0');

        var responseData = response.data;

        print("DeleteAd Response: " + responseData.toString());

        saveData.Message = responseData["Message"].toString();
        print("msg: ${saveData.Message}");
        saveData.IsSuccess =
        responseData["IsSuccess"].toString().toLowerCase() == "true"
            ? true
            : false;
        saveData.Data = responseData["Data"].toString();

        return saveData;
      } else {
        print("Error DeleteAd Url");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error DeleteAd Url : ${e.toString()}");
      throw Exception(e.toString());
    }
  }*/

  static Future<SaveDataClass> DeleteAd(String id) async {
    String url = cnst.API_URL + 'DeleteAd?id=$id';
    print("DeleteAd URL: " + url);
    try {
      final response = await dio.post(url);
      if (response.statusCode == 200) {
        SaveDataClass saveData = new SaveDataClass(
            Message: 'No Data', IsSuccess: false, Data: '0');

        var responseData = response.data;

        print("DeleteAd Response: " + responseData.toString());

        saveData.Message = responseData["Message"].toString();
        print("msg: ${saveData.Message}");
        saveData.IsSuccess =
        responseData["IsSuccess"].toString().toLowerCase() == "true"
            ? true
            : false;
        saveData.Data = responseData["Data"].toString();

        return saveData;
      } else {
        print("Error DeleteAd Url");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("DeleteAd Erorr : " + e.toString());
      throw Exception(e);
    }
  }

  static Future<SaveDataClass> UpdateAd(body) async {
    print(body.toString());
    String url = cnst.API_URL + 'EditAd';
    print("EditAd : " + url);
    dio.options.contentType = Headers.formUrlEncodedContentType;
    dio.options.responseType = ResponseType.json;
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveData =
        new SaveDataClass(Message: 'No Data', IsSuccess: false, Data: '0');

        xml2json.parse(response.data.toString());
        var jsonData = xml2json.toParker();
        var responseData = json.decode(jsonData);

        print("EditAd Response: " + responseData["ResultData"].toString());
        print("Res:  ${responseData}");
        saveData.Message = responseData["ResultData"]["Message"].toString();
        saveData.IsSuccess = responseData["ResultData"]["IsSuccess"] == "true";
        saveData.Data = responseData["ResultData"]["Data"].toString();

        return saveData;
      } else {
        print("Server Error");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("App Error ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<SaveDataClass> UpdateProduct(body) async {
    print(body.toString());
    String url = cnst.API_URL + 'EditProduct';
    print("EditProduct : " + url);
    dio.options.contentType = Headers.formUrlEncodedContentType;
    dio.options.responseType = ResponseType.json;
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveData =
        new SaveDataClass(Message: 'No Data', IsSuccess: false, Data: '0');

        xml2json.parse(response.data.toString());
        var jsonData = xml2json.toParker();
        var responseData = json.decode(jsonData);

        print("EditProduct Response: " + responseData["ResultData"].toString());
        print("Res:  ${responseData}");
        saveData.Message = responseData["ResultData"]["Message"].toString();
        saveData.IsSuccess = responseData["ResultData"]["IsSuccess"] == "true";
        saveData.Data = responseData["ResultData"]["Data"].toString();

        return saveData;
      } else {
        print("Server Error");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("App Error ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<SaveDataClass> AdvertiseScan(body) async {
    print(body.toString());
    String url = cnst.API_URL + 'AdvertisementOfferRedeem';
    print("AdvertisementOfferRedeem : " + url);

    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveData =
        new SaveDataClass(Message: 'No Data', IsSuccess: false, Data: '0');

        var responseData = response.data;

        print("AdvertisementOfferRedeem Response: " + responseData.toString());

        saveData.Message = responseData["Message"].toString();
        saveData.IsSuccess = responseData["IsSuccess"];
        saveData.Data = responseData["Data"].toString();

        return saveData;
      } else {
        print("Server Error");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("App Error ${e.toString()}");
      throw Exception(e.toString());
    }
  }


  static Future<List> GetAdScanData(String advertiserId) async {
    String url = cnst.API_URL + 'GetAdScanData?advertiserId=$advertiserId';
    print("GetAdScanData URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("GetAdScanData Response: " + response.data.toString());
        var responseData = response.data;
        if (responseData["IsSuccess"] == true) {
          list = responseData["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception("Something Went Wrong");
      }
    } catch (e) {
      print("GetAdScanData Erorr : " + e.toString());
      throw Exception(e);
    }
  }

  static Future<List> GetVendorProductInquiry(String advertiserid) async {
    String url = cnst.API_URL + 'GetVendorProductInquiry?advertiserid=$advertiserid';
    print("GetVendorProductInquiry URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("GetVendorProductInquiry Response: " + response.data.toString());
        var responseData = response.data;
        if (responseData["IsSuccess"] == true) {
          list = responseData["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception("Something Went Wrong");
      }
    } catch (e) {
      print("GetVendorProductInquiry Erorr : " + e.toString());
      throw Exception(e);
    }
  }

  static Future<List> GetPackages() async {
    String url = API_URL + 'GetPackage';
    print("GetPackage Url:" + url);

    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        List list = [];
        print("GetPackage Response: " + response.data.toString());
        var responseData = response.data;
        if (responseData["IsSuccess"] == true) {
          list = responseData["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception("No Internet Connection");
      }
    } catch (e) {
      print("Check GetPackage Erorr : " + e.toString());
      throw Exception(e);
    }
  }

  static Future<List> GetAdvertiseFor(String type) async {
   // SharedPreferences prefs = await SharedPreferences.getInstance();
   // String SocietyId = prefs.getString(constant.Session.SocietyId);
    String SocietyId = "12";
    String url = API_URL +
        'GetAdvertisementDropDownDataByType?societyId=$SocietyId&type=$type';
    print("GetAdvertiseFor Url:" + url);

    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        List list = [];
        print("GetAdvertiseFor Response: " + response.data.toString());
        var responseData = response.data;
        if (responseData["IsSuccess"] == true) {
          list = responseData["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception("No Internet Connection");
      }
    } catch (e) {
      print("Check GetAdvertiseFor Erorr : " + e.toString());
      throw Exception(e);
    }
  }

  static Future<SaveDataClass> AddAdvertisement(body) async {
    print(body.toString());
    String url = cnst.API_URL + 'AddAdvertisement';
    print("AddAdvertisement : " + url);
    dio.options.contentType = Headers.formUrlEncodedContentType;
    dio.options.responseType = ResponseType.json;
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveData =
        new SaveDataClass(Message: 'No Data', IsSuccess: false, Data: '0');

        xml2json.parse(response.data.toString());
        var jsonData = xml2json.toParker();
        var responseData = json.decode(jsonData);

        print("AddAdvertisement Response: " + responseData["ResultData"].toString());
        print("Res:  ${responseData}");
        saveData.Message = responseData["ResultData"]["Message"].toString();
        saveData.IsSuccess = responseData["ResultData"]["IsSuccess"] == "true";
        saveData.Data = responseData["ResultData"]["Data"].toString();

        return saveData;
      } else {
        print("Server Error");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("App Error ${e.toString()}");
      throw Exception(e.toString());
    }
  }
}
