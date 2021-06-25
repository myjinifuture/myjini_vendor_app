class ResponseDataClass {
  String Message;
  bool IsSuccess;
  var Data;

  ResponseDataClass({this.Message, this.IsSuccess, this.Data});

  factory ResponseDataClass.fromJson(Map<String, dynamic> json) {
    return ResponseDataClass(
      Message: json['Message'] as String,
      IsSuccess: json['IsSuccess'] as bool,
      Data: json['Data'] as dynamic,
    );
  }
}

class APIURL {
  static const String API_URL =
      "http://digitalcard.co.in/DigitalcardService.asmx/";
  static const String API_URL_RazorPay_Order =
      "http://razorpayapi.itfuturz.com/Service.asmx/";
}

class PackageClass {
  String id='123';
  String name='hope', durationYears='1', amount='1';

  PackageClass({
    this.id,
    this.name,
    this.durationYears,
    this.amount,
  });

  factory PackageClass.fromJson(Map<String, dynamic> json) {
    return PackageClass(
      id: json["Id"] as String,
      name: json['Name'] as String,
      durationYears: json['DurationYears'] as String,
      amount: json['Amount'] as String,
    );
  }
}

class CouponClass {
  String CouponId;
  String CouponCode;
  String CouponType;
  String CouponAmt;
  String StartDate;
  String EndDate;

  CouponClass({
    this.CouponId,
    this.CouponCode,
    this.CouponType,
    this.CouponAmt,
    this.StartDate,
    this.EndDate,
  });

  factory CouponClass.fromJson(Map<String, dynamic> json) {
    return CouponClass(
      CouponId: json['CouponId'] as String,
      CouponCode: json['CouponCode'] as String,
      CouponType: json['CouponType'] as String,
      CouponAmt: json['CouponAmt'] as String,
      StartDate: json['StartDate'] as String,
      EndDate: json['EndDate'] as String,
    );
  }
}

class SaveDataClass {
  String Message;
  bool IsSuccess;
  bool IsRecord;
  String Data;

  SaveDataClass({this.Message, this.IsSuccess, this.IsRecord, this.Data});

  factory SaveDataClass.fromJson(Map<String, dynamic> json) {
    return SaveDataClass(
        Message: json['Message'] as String,
        IsSuccess: json['IsSuccess'] as bool,
        IsRecord: json['IsRecord'] as bool,
        Data: json['Data'] as String);
  }
}

class stateClassData {
  String message;
  bool isSuccess;
  List<stateClass> data = [];

  stateClassData({this.message, this.isSuccess, this.data});

  factory stateClassData.fromJson(Map<String, dynamic> json) {
    return stateClassData(
        message: json['Message'] as String,
        isSuccess: json['IsSuccess'] as bool,
        data: json['Data']
            .map<stateClass>((json) => stateClass.fromJson(json))
            .toList());
  }
}

class stateClass {
  String id;
  String Name;

  stateClass({this.id, this.Name});

  factory stateClass.fromJson(Map<String, dynamic> json) {
    return stateClass(
        id: json['Id'].toString() as String,
        Name: json['Name'].toString() as String);
  }
}

class cityClassData {
  String message;
  bool isSuccess;
  List<cityClass> data = [];

  cityClassData({this.message, this.isSuccess, this.data});

  factory cityClassData.fromJson(Map<String, dynamic> json) {
    return cityClassData(
        message: json['Message'] as String,
        isSuccess: json['IsSuccess'] as bool,
        data: json['Data']
            .map<cityClass>((json) => cityClass.fromJson(json))
            .toList());
  }
}

class cityClass {
  String id;
  String StateId;
  String Name;

  cityClass({this.id,this.StateId, this.Name});

  factory cityClass.fromJson(Map<String, dynamic> json) {
    return cityClass(
        id: json['Id'].toString() as String,
        StateId: json['StateId'].toString() as String,
        Name: json['Name'].toString() as String);
  }
}

class categoryClassData {
  String message;
  bool isSuccess;
  List<categoryClass> data = [];

  categoryClassData({this.message, this.isSuccess, this.data});

  factory categoryClassData.fromJson(Map<String, dynamic> json) {
    return categoryClassData(
        message: json['Message'] as String,
        isSuccess: json['IsSuccess'] as bool,
        data: json['Data']
            .map<categoryClass>((json) => categoryClass.fromJson(json))
            .toList());
  }
}

class categoryClass {
  String id;
  String ParentId;
  String Title;

  categoryClass({this.id,this.ParentId, this.Title});

  factory categoryClass.fromJson(Map<String, dynamic> json) {
    return categoryClass(
        id: json['Id'].toString() as String,
        ParentId: json['ParentId'].toString() as String,
        Title: json['Title'].toString() as String);
  }
}

class subCategoryClassData {
  String message;
  bool isSuccess;
  List<subCategoryClass> data = [];

  subCategoryClassData({this.message, this.isSuccess, this.data});

  factory subCategoryClassData.fromJson(Map<String, dynamic> json) {
    return subCategoryClassData(
        message: json['Message'] as String,
        isSuccess: json['IsSuccess'] as bool,
        data: json['Data']
            .map<subCategoryClass>((json) => subCategoryClass.fromJson(json))
            .toList());
  }
}

class subCategoryClass {
  String id;
  String ParentId;
  String Title;

  subCategoryClass({this.id,this.ParentId, this.Title});

  factory subCategoryClass.fromJson(Map<String, dynamic> json) {
    return subCategoryClass(
        id: json['Id'].toString() as String,
        ParentId: json['ParentId'].toString() as String,
        Title: json['Title'].toString() as String);
  }
}


