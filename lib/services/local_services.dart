/*import 'dart:convert';
import 'package:cgp_driver_app/models/rider_model.dart';
import 'package:cgp_driver_app/models/single_vehicle_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalServices {
  static const _localStorage = FlutterSecureStorage();
  static const _keyToken = 'token';
  static const _keyUser = 'user';
  static const _keyVehicle = 'vehicle';
  static const _keyPreviousVersion = 'previousVersion';
  static const _keyOnGoingTripId = 'onGoingTripId';

  // Overwrite token directly without deleting first
  static Future<void> storeToken(String token) async {
    try {
      // Check if token already exists
      String? existingToken = await getToken();
      if (existingToken != token) {
        await _localStorage.write(key: _keyToken, value: token, iOptions: _getIOSOptions(), aOptions: _getAndroidOptions());
        print('Token stored successfully');
      } else {
        print('Token already exists and is the same.');
      }
    } catch (e) {
      print('Error storing token: $e');
    }
  }

  // Read token with error handling
  static Future<String?> getToken() async {
    try {
      return await _localStorage.read(key: _keyToken, iOptions: _getIOSOptions(), aOptions: _getAndroidOptions());
    } catch (e) {
      print('Error reading token: $e');
      return null;
    }
  }

  // Write onGoingTripId with error handling
  static Future<void> storeOnGoingTrip(String? tripId) async {
    try {
      String? existingTripId = await getOnGoingTrip();
      if (existingTripId != tripId) {
        await _localStorage.write(key: _keyOnGoingTripId, value: tripId, iOptions: _getIOSOptions(), aOptions: _getAndroidOptions());
        print('On-going trip stored successfully');
      } else {
        print('On-going trip already exists and is the same.');
      }
    } catch (e) {
      print('Error storing onGoingTripId: $e');
    }
  }

  // Read onGoingTripId with error handling
  static Future<String?> getOnGoingTrip() async {
    try {
      return await _localStorage.read(key: _keyOnGoingTripId, iOptions: _getIOSOptions(), aOptions: _getAndroidOptions());
    } catch (e) {
      print('Error reading onGoingTripId: $e');
      return null;
    }
  }

  // Store user with error handling
  Future<void> storeUser(RiderModel user) async {
    try {
      final value = json.encode(user);
      await _localStorage.write(key: _keyUser, value: value, iOptions: _getIOSOptions(), aOptions: _getAndroidOptions());
      if (kDebugMode) {
        print('User stored successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error storing user: $e');
      }
    }
  }

  // Read user with error handling
  static Future<RiderModel?> getUser() async {
    try {
      final value = await _localStorage.read(key: _keyUser, iOptions: _getIOSOptions(), aOptions: _getAndroidOptions());
      return value == null ? null : RiderModel.fromJson(json.decode(value));
    } catch (e) {
      if (kDebugMode) {
        print('Error reading user: $e');
      }
      return null;
    }
  }

  // Store vehicle with error handling
  Future<void> storeSelectedVehicle(SingleVehicleModel vehicle) async {
    try {
      final value = json.encode(vehicle);
      await _localStorage.write(key: _keyVehicle, value: value, iOptions: _getIOSOptions(), aOptions: _getAndroidOptions());
      print('Vehicle stored successfully');
    } catch (e) {
      print('Error storing vehicle: $e');
    }
  }

  // Read selected vehicle with error handling
  static Future<SingleVehicleModel?> getSelectedVehicle() async {
    try {
      final value = await _localStorage.read(key: _keyVehicle, iOptions: _getIOSOptions(), aOptions: _getAndroidOptions());
      return value == null ? null : SingleVehicleModel.fromJson(json.decode(value));
    } catch (e) {
      print('Error reading vehicle: $e');
      return null;
    }
  }

  // Store app version with error handling
  static Future<void> storeAppVersion(String appVersion) async {
    try {
      await _localStorage.write(key: _keyPreviousVersion, value: appVersion, iOptions: _getIOSOptions(), aOptions: _getAndroidOptions());
      print('App version stored successfully');
    } catch (e) {
      print('Error storing app version: $e');
    }
  }

  // Read app version with error handling
  static Future<String?> getPreviousAppVersion() async {
    try {
      return await _localStorage.read(key: _keyPreviousVersion, iOptions: _getIOSOptions(), aOptions: _getAndroidOptions());
    } catch (e) {
      print('Error reading app version: $e');
      return null;
    }
  }

  // Delete all stored data with error handling
  static Future<void> deleteData() async {
    try {
      await _localStorage.deleteAll(iOptions: _getIOSOptions(), aOptions: _getAndroidOptions());
      print('All data deleted successfully');
    } catch (e) {
      print('Error deleting data: $e');
    }
  }

  // Clear keychain data (used for testing or reset)
  static Future<void> clearAllKeychainData() async {
    try {
      await _localStorage.deleteAll(iOptions: _getIOSOptions(), aOptions: _getAndroidOptions());
      print('Keychain data cleared successfully');
    } catch (e) {
      print('Error clearing keychain data: $e');
    }
  }

  // iOS-specific secure storage options
  static IOSOptions _getIOSOptions() => const IOSOptions(
    accessibility: KeychainAccessibility.unlocked,
    synchronizable: true
  );

  // Android-specific secure storage options
  static AndroidOptions _getAndroidOptions() => const AndroidOptions(
    encryptedSharedPreferences: true,
  );
}*/


/*import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

import '../models/rider_model.dart';
import '../models/single_vehicle_model.dart';

class LocalServices {
  static const _localStorage = FlutterSecureStorage();
  static const _keyToken = 'token';
  static const _keyUser = 'user';
  static const _keyVehicle = 'vehicle';
  static const _keyPreviousVersion = 'previousVersion';
  static const _keyOnGoingTripId = 'onGoingTripId';
  static const _keyFirstInstall = 'is_first_install'; // SharedPreferences key

  /// Initialize storage: Checks first install & clears secure storage if needed.
  static Future<void> initializeStorage() async {
    await _checkFirstInstall();
  }

  /// Check if app is freshly installed and clear secure storage
  static Future<void> _checkFirstInstall() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isFirstInstall = prefs.getBool(_keyFirstInstall);

    if (isFirstInstall == null || isFirstInstall) {
      // First install detected, clear secure storage
      await _localStorage.deleteAll(iOptions: _getIOSOptions(), aOptions: _getAndroidOptions());
      print('Secure storage cleared on first install');

      // Mark the app as installed
      await prefs.setBool(_keyFirstInstall, false);
    }
  }

  // Overwrite token directly without deleting first
  static Future<void> storeToken(String token) async {
    try {
      String? existingToken = await getToken();
      if (existingToken != token) {
        await _localStorage.write(
            key: _keyToken,
            value: token,
            iOptions: _getIOSOptions(),
            aOptions: _getAndroidOptions());
        print('Token stored successfully');
      } else {
        print('Token already exists and is the same.');
      }
    } catch (e) {
      print('Error storing token: $e');
    }
  }

  static Future<String?> getToken() async {
    try {
      return await _localStorage.read(
          key: _keyToken,
          iOptions: _getIOSOptions(),
          aOptions: _getAndroidOptions());
    } catch (e) {
      print('Error reading token: $e');
      return null;
    }
  }

  static Future<void> storeOnGoingTrip(String? tripId) async {
    try {
      String? existingTripId = await getOnGoingTrip();
      if (existingTripId != tripId) {
        await _localStorage.write(
            key: _keyOnGoingTripId,
            value: tripId,
            iOptions: _getIOSOptions(),
            aOptions: _getAndroidOptions());
        print('On-going trip stored successfully');
      } else {
        print('On-going trip already exists and is the same.');
      }
    } catch (e) {
      print('Error storing onGoingTripId: $e');
    }
  }

  static Future<String?> getOnGoingTrip() async {
    try {
      return await _localStorage.read(
          key: _keyOnGoingTripId,
          iOptions: _getIOSOptions(),
          aOptions: _getAndroidOptions());
    } catch (e) {
      print('Error reading onGoingTripId: $e');
      return null;
    }
  }

  Future<void> storeUser(RiderModel user) async {
    try {
      final value = json.encode(user);
      await _localStorage.write(
          key: _keyUser,
          value: value,
          iOptions: _getIOSOptions(),
          aOptions: _getAndroidOptions());
      if (kDebugMode) {
        print('User stored successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error storing user: $e');
      }
    }
  }

  static Future<RiderModel?> getUser() async {
    try {
      final value = await _localStorage.read(
          key: _keyUser,
          iOptions: _getIOSOptions(),
          aOptions: _getAndroidOptions());
      return value == null ? null : RiderModel.fromJson(json.decode(value));
    } catch (e) {
      if (kDebugMode) {
        print('Error reading user: $e');
      }
      return null;
    }
  }

  Future<void> storeSelectedVehicle(SingleVehicleModel vehicle) async {
    try {
      final value = json.encode(vehicle);
      await _localStorage.write(
          key: _keyVehicle,
          value: value,
          iOptions: _getIOSOptions(),
          aOptions: _getAndroidOptions());
      print('Vehicle stored successfully');
    } catch (e) {
      print('Error storing vehicle: $e');
    }
  }

  static Future<SingleVehicleModel?> getSelectedVehicle() async {
    try {
      final value = await _localStorage.read(
          key: _keyVehicle,
          iOptions: _getIOSOptions(),
          aOptions: _getAndroidOptions());
      return value == null ? null : SingleVehicleModel.fromJson(json.decode(value));
    } catch (e) {
      print('Error reading vehicle: $e');
      return null;
    }
  }

  static Future<void> storeAppVersion(String appVersion) async {
    try {
      await _localStorage.write(
          key: _keyPreviousVersion,
          value: appVersion,
          iOptions: _getIOSOptions(),
          aOptions: _getAndroidOptions());
      print('App version stored successfully');
    } catch (e) {
      print('Error storing app version: $e');
    }
  }

  static Future<String?> getPreviousAppVersion() async {
    try {
      return await _localStorage.read(
          key: _keyPreviousVersion,
          iOptions: _getIOSOptions(),
          aOptions: _getAndroidOptions());
    } catch (e) {
      print('Error reading app version: $e');
      return null;
    }
  }

  static Future<void> deleteData() async {
    try {
      await _localStorage.deleteAll(iOptions: _getIOSOptions(), aOptions: _getAndroidOptions());
      print('All data deleted successfully');
    } catch (e) {
      print('Error deleting data: $e');
    }
  }

  static Future<void> clearAllKeychainData() async {
    try {
      await _localStorage.deleteAll(iOptions: _getIOSOptions(), aOptions: _getAndroidOptions());
      print('Keychain data cleared successfully');
    } catch (e) {
      print('Error clearing keychain data: $e');
    }
  }

  static IOSOptions _getIOSOptions() => const IOSOptions(
      accessibility: KeychainAccessibility.unlocked,
      synchronizable: true);

  static AndroidOptions _getAndroidOptions() => const AndroidOptions(
      encryptedSharedPreferences: true);
}*/



// this is fully shared preferences

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

  /// Initialize storage: Checks first install & clears storage if needed.
  static Future<void> initializeStorage() async {
    await _checkFirstInstall();
  }

  /// Check if app is freshly installed and clear storage
  static Future<void> _checkFirstInstall() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isFirstInstall = prefs.getBool(_keyFirstInstall);

    if (isFirstInstall == null || isFirstInstall) {
      await prefs.clear();
      print('Storage cleared on first install');
      await prefs.setBool(_keyFirstInstall, false);
    }
  }

  static Future<void> storeToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
    print('Token stored successfully');
  }

  static Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  static Future<void> storeOnGoingTrip(String? tripId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyOnGoingTripId, tripId ?? '');
    print('On-going trip stored successfully');
  }

  static Future<String?> getOnGoingTrip() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyOnGoingTripId);
  }

  static Future<void> storeUser(RiderModel user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final value = json.encode(user);
    await prefs.setString(_keyUser, value);
    if (kDebugMode) print('User stored successfully');
  }

  static Future<RiderModel?> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_keyUser);
    return value == null ? null : RiderModel.fromJson(json.decode(value));
  }

  static Future<void> storeSelectedVehicle(SingleVehicleModel vehicle) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final value = json.encode(vehicle);
    await prefs.setString(_keyVehicle, value);
    print('Vehicle stored successfully');
  }

  static Future<SingleVehicleModel?> getSelectedVehicle() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_keyVehicle);
    return value == null ? null : SingleVehicleModel.fromJson(json.decode(value));
  }

  static Future<void> storeAppVersion(String appVersion) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyPreviousVersion, appVersion);
    print('App version stored successfully');
  }

  static Future<String?> getPreviousAppVersion() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyPreviousVersion);
  }

  static Future<void> deleteData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print('All data deleted successfully');
  }
}


