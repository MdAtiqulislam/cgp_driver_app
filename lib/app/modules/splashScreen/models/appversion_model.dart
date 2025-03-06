// To parse this JSON data, do
//
//     final appVersionModel = appVersionModelFromJson(jsonString);

import 'dart:convert';

AppVersionModel appVersionModelFromJson(String str) => AppVersionModel.fromJson(json.decode(str));

String appVersionModelToJson(AppVersionModel data) => json.encode(data.toJson());

class AppVersionModel {
  final String? current;
  final String? androidVersion;
  final dynamic androidTestVersion;
  final dynamic iosVersion;
  final dynamic iosTestVersion;
  final bool? enable;
  final OrMsg? majorMsg;
  final OrMsg? minorMsg;

  AppVersionModel({
    this.current,
    this.androidVersion,
    this.androidTestVersion,
    this.iosVersion,
    this.iosTestVersion,
    this.enable,
    this.majorMsg,
    this.minorMsg,
  });

  factory AppVersionModel.fromJson(Map<String, dynamic> json) => AppVersionModel(
    current: json["current"],
    androidVersion: json["android_version"],
    androidTestVersion: json["android_test_version"],
    iosVersion: json["ios_version"],
    iosTestVersion: json["ios_test_version"],
    enable: json["enable"],
    majorMsg: json["majorMsg"] == null ? null : OrMsg.fromJson(json["majorMsg"]),
    minorMsg: json["minorMsg"] == null ? null : OrMsg.fromJson(json["minorMsg"]),
  );

  Map<String, dynamic> toJson() => {
    "current": current,
    "android_version": androidVersion,
    "android_test_version": androidTestVersion,
    "ios_version": iosVersion,
    "ios_test_version": iosTestVersion,
    "enable": enable,
    "majorMsg": majorMsg?.toJson(),
    "minorMsg": minorMsg?.toJson(),
  };
}

class OrMsg {
  final String? title;
  final String? msg;
  final String? button;
  final Url? url;

  OrMsg({
    this.title,
    this.msg,
    this.button,
    this.url,
  });

  factory OrMsg.fromJson(Map<String, dynamic> json) => OrMsg(
    title: json["title"],
    msg: json["msg"],
    button: json["button"],
    url: json["url"] == null ? null : Url.fromJson(json["url"]),
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "msg": msg,
    "button": button,
    "url": url?.toJson(),
  };
}

class Url {
  final String? apk;
  final String? ios;

  Url({
    this.apk,
    this.ios,
  });

  factory Url.fromJson(Map<String, dynamic> json) => Url(
    apk: json["apk"],
    ios: json["ios"],
  );

  Map<String, dynamic> toJson() => {
    "apk": apk,
    "ios": ios,
  };
}
