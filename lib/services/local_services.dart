import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

import '../models/rider_model.dart';
import '../models/single_vehicle_model.dart';

class LocalServices {
  static const _keyToken = 'token';
  static const _keyUser = 'user';
  static const _keyVehicle = 'vehicle';
  static const _keyPreviousVersion = 'previousVersion';
  static const _keyOnGoingTripId = 'onGoingTripId';
  static const _keyFirstInstall = 'is_first_install';
  static const _keyAllowPermission = 'isPermitted';

  /// ✅ SAME as first code (lazy getter)
  static Future<SharedPreferences> get _prefs async =>
      await SharedPreferences.getInstance();

  /// Initialize storage
  static Future<void> initializeStorage() async {
    final prefs = await _prefs;
    bool? isFirstInstall = prefs.getBool(_keyFirstInstall);

    if (isFirstInstall == null || isFirstInstall) {
      await prefs.clear();
      if (kDebugMode) print('Storage cleared on first install');
      await prefs.setBool(_keyFirstInstall, false);
    }
  }

  /// Permission
  static Future<void> setPermission(bool value) async {
    final prefs = await _prefs;
    await prefs.setBool(_keyAllowPermission, value);
  }

  static Future<bool> getPermission() async {
    final prefs = await _prefs;
    return prefs.getBool(_keyAllowPermission) ?? false;
  }

  /// Token
  static Future<void> storeToken(String token) async {
    final prefs = await _prefs;
    await prefs.setString(_keyToken, token);
  }

  static Future<String?> getToken() async {
    final prefs = await _prefs;
    return prefs.getString(_keyToken);
  }

  /// Trip
  static Future<void> storeOnGoingTrip(String? tripId) async {
    final prefs = await _prefs;
    await prefs.setString(_keyOnGoingTripId, tripId ?? '');
  }

  static Future<String?> getOnGoingTrip() async {
    final prefs = await _prefs;
    return prefs.getString(_keyOnGoingTripId);
  }

  /// User
  static Future<void> storeUser(RiderModel user) async {
    final prefs = await _prefs;
    final value = json.encode(user);
    await prefs.setString(_keyUser, value);
  }

  static Future<RiderModel?> getUser() async {
    final prefs = await _prefs;
    final value = prefs.getString(_keyUser);
    return value == null ? null : RiderModel.fromJson(json.decode(value));
  }

  /// Vehicle
  static Future<void> storeSelectedVehicle(SingleVehicleModel vehicle) async {
    final prefs = await _prefs;
    final value = json.encode(vehicle);
    await prefs.setString(_keyVehicle, value);
  }

  static Future<SingleVehicleModel?> getSelectedVehicle() async {
    final prefs = await _prefs;
    final value = prefs.getString(_keyVehicle);
    return value == null
        ? null
        : SingleVehicleModel.fromJson(json.decode(value));
  }

  /// App version
  static Future<void> storeAppVersion(String appVersion) async {
    final prefs = await _prefs;
    await prefs.setString(_keyPreviousVersion, appVersion);
  }

  static Future<String?> getPreviousAppVersion() async {
    final prefs = await _prefs;
    return prefs.getString(_keyPreviousVersion);
  }

  /// Clear
  static Future<void> deleteData() async {
    final prefs = await _prefs;
    await prefs.clear();
  }
}