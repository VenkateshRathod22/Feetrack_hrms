import 'dart:developer';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:vlr/services/extensions.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/constants.dart';
import '../api/api_client.dart';

class AuthRepo {
  final SharedPreferences sharedPreferences;
  final ApiClient apiClient;
  AuthRepo({required this.sharedPreferences, required this.apiClient});

  Future<Response> postUserRegister({required FormData data}) async =>
      await apiClient.postData(
        AppConstants.registrationPost,
        "postUserRegister",
        data,
      );

  Future<Response> postUserLogin({required FormData data}) async =>
      await apiClient.postData(
        AppConstants.loginPost,
        "postUserLogin",
        data,
      );
  Future<Response> updateFCMToken({required FormData data}) async =>
      await apiClient.putData(
        AppConstants.updateFCMTokenPost,
        "updateFCMToken",
        data,
      );

  Future<Response> logOut({required FormData data}) async =>
      await apiClient.postData(
        AppConstants.logOutPost,
        "logOut",
        data,
      );
  Future<Response> accountDelete() async => await apiClient.deleteData(
        AppConstants.deleteAccountPost,
        "accountDelete",
      );

  Future<Response> fetchProfile() async => await apiClient.getData(
        AppConstants.getProfile,
        "fetchProfile",
      );

  Future<Response> updateProfile({required FormData data}) async =>
      await apiClient.putData(
        AppConstants.updateProfile,
        "updateProfile",
        data,
      );

  Future<bool> saveFCMToken({
    required String fcmToken,
  }) async {
    try {
      return await sharedPreferences.setString(AppConstants.fcmToken, fcmToken);
    } catch (e, st) {
      log('saveFCMToken error: $e\n$st');
      return false;
    }
  }

  String getFCMToken() {
    return sharedPreferences.getString(AppConstants.fcmToken) ?? "";
  }

  String getUserToken() {
    return sharedPreferences.getString(AppConstants.token) ?? "";
  }

  Future<void> setUserToken(String token) async {
    apiClient.updateHeader(token);
    await sharedPreferences.setString(AppConstants.token, token);
  }

  String getUserId() {
    return sharedPreferences.getString(AppConstants.userId) ?? "";
  }

  bool isLoggedIn() {
    return sharedPreferences.containsKey(AppConstants.token);
  }

  bool clearSharedData() {
    sharedPreferences.remove(AppConstants.token);
    sharedPreferences.remove(AppConstants.userId);
    apiClient.token = '';
    apiClient.updateHeader('');
    return true;
  }

  Future<String> getDeviceId() async {
    int count = 0;

    while (OneSignal.User.pushSubscription.id.isNotValid && count < 0) {
      await Future.delayed(const Duration(seconds: 1));
      count++;

      log(count.toString(), name: 'DeviceId Wait Count');
      log('${OneSignal.User.pushSubscription.id}', name: "12345678");
      log('${OneSignal.User.pushSubscription.token}', name: "12345678");
    }

    if (OneSignal.User.pushSubscription.id.isValid) {
      return OneSignal.User.pushSubscription.id!;
    } else {
      return '12345678';
    }
  }
}
