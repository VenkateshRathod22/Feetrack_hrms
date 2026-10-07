import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vlr/data/models/response/response_model.dart';
import 'package:vlr/data/models/user_model.dart';

import '../data/repositories/auth_repo.dart';
import '../services/constants.dart';

class AuthController extends GetxController implements GetxService {
  final AuthRepo authRepo;

  AuthController({required this.authRepo});

  bool isLoading = false;
  bool _acceptTerms = false;

  bool get acceptTerms => _acceptTerms;

  TextEditingController emailController =
      TextEditingController(text: "rahul@tpipay.ai");
  TextEditingController passwordController =
      TextEditingController(text: "TPIPAY1235");
  TextEditingController confirmPasswordController =
      TextEditingController(text: "Ven12345678");
  TextEditingController fullNameController =
      TextEditingController(text: "Venkatesh Rathod");
  TextEditingController mobileController =
      TextEditingController(text: "7972391843");

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    fullNameController.clear();
    mobileController.clear();
  }

  Future<ResponseModel> registerUser() async {
    log('----------- registerUser Called ----------');

    ResponseModel responseModel;
    isLoading = true;
    update();

    try {
      Map<String, dynamic> data = {
        "mobile": mobileController.text.trim(),
        "name": fullNameController.text.trim(),
        "email": emailController.text.trim(),
        "password": passwordController.text.trim(),
        "password_confirmation": confirmPasswordController.text.trim(),
      };

      log("Registration URL: ${AppConstants.baseUrl}${AppConstants.registrationPost}");
      log("Registration Body: $data");

      Response response = await authRepo.postUserRegister(
        data: FormData(data),
      );


      log("Registration Response: ${response.body}");

      //log("Raw Response: ${response.body}");

      if (response.body['status'] == "success") {
        responseModel = ResponseModel(
          true,
          response.body['message'] ?? "registerUser successful",
        );

        final token = response.body['data']?['token'];

        if (token != null && token.toString().isNotEmpty) {
          await authRepo.setUserToken(token);

          log("Saved Token: $token");
        }
      } else {
        String errorMessage =
            response.body['message'] ?? "Error while registering user";

        if (response.body['errors'] != null) {
          final errors = response.body['errors'] as Map<String, dynamic>;

          if (errors.isNotEmpty) {
            errorMessage = (errors.values.first as List).first.toString();
          }
        }
        responseModel = ResponseModel(false, errorMessage);
      }
    } catch (e) {
      log('ERROR AT registerUser(): $e');
      responseModel = ResponseModel(false, "Error while registering user $e");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> postUserLogin() async {
    log('----------- postUserLogin Called ----------');

    ResponseModel responseModel;
    isLoading = true;
    update();

    try {
      Map<String, dynamic> data = {
        "login": emailController.text.trim(),
        "password": passwordController.text.trim(),
      };

      log("Login URL: ${AppConstants.baseUrl}${AppConstants.loginPost}");
      log("Login Body: $data");

      Response response = await authRepo.postUserLogin(
        data: FormData(data),
      );

      log("Login Response: ${response.body}");

      if (response.body['status'] == "success") {
        responseModel = ResponseModel(
          true,
          response.body['message'] ?? "Login successful",
        );

        final token = response.body['data']?['token'];

        if (token != null && token.toString().isNotEmpty) {
          await authRepo.setUserToken(token);

          log("Saved Token: $token");
        }
      } else {
        String errorMessage =
            response.body['message'] ?? "Error while postUserLogin user";

        if (response.body['errors'] != null) {
          final errors = response.body['errors'] as Map<String, dynamic>;

          if (errors.isNotEmpty) {
            errorMessage = (errors.values.first as List).first.toString();
          }
        }
        responseModel = ResponseModel(false, errorMessage);
      }
    } catch (e) {
      log('ERROR AT postUserLogin(): $e');
      responseModel = ResponseModel(false, "Error while postUserLogin user $e");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> updateFCMToken() async {
    log('----------- updateFCMToken Called ----------');

    ResponseModel responseModel;
    isLoading = true;
    update();

    try {
      Map<String, dynamic> data = {
        "fcm_token": authRepo.getFCMToken(),
      };

      Response response = await authRepo.updateFCMToken(
        data: FormData(data),
      );

      //  log("Raw Response: ${response.body}");

      if (response.body['status'] == "success") {
        responseModel = ResponseModel(
          true,
          response.body['message'] ?? "update fcm token successful",
        );
      } else {
        String errorMessage =
            response.body['message'] ?? "Error while update fcm token user";

        if (response.body['errors'] != null) {
          final errors = response.body['errors'] as Map<String, dynamic>;

          if (errors.isNotEmpty) {
            errorMessage = (errors.values.first as List).first.toString();
          }
        }
        responseModel = ResponseModel(false, errorMessage);
      }
    } catch (e) {
      log('ERROR AT update fcm token(): $e');
      responseModel =
          ResponseModel(false, "Error while update fcm token user $e");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> logOutPost() async {
    log('----------- logOutPost Called ----------');

    ResponseModel responseModel;
    isLoading = true;
    update();

    try {
      Map<String, dynamic> data = {};

      Response response = await authRepo.logOut(
        data: FormData(data),
      );

      if (response.body['status'] == "success") {
        responseModel = ResponseModel(
          true,
          response.body['message'] ?? "logOut successful",
        );
      } else {
        String errorMessage =
            response.body['message'] ?? "Error while logOutPost user";

        if (response.body['errors'] != null) {
          final errors = response.body['errors'] as Map<String, dynamic>;

          if (errors.isNotEmpty) {
            errorMessage = (errors.values.first as List).first.toString();
          }
        }
        responseModel = ResponseModel(false, errorMessage);
      }
    } catch (e) {
      log('ERROR AT logOutPost): $e');
      responseModel = ResponseModel(false, "Error while logOutPost user $e");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> accountDelete() async {
    log('----------- accountDelete Called ----------');

    ResponseModel responseModel;
    isLoading = true;
    update();

    try {
      Response response = await authRepo.accountDelete();

      if (response.body['status'] == "success") {
        responseModel = ResponseModel(
          true,
          response.body['message'] ?? "accountDelete successful",
        );
      } else {
        String errorMessage =
            response.body['message'] ?? "Error while accountDelete user";

        if (response.body['errors'] != null) {
          final errors = response.body['errors'] as Map<String, dynamic>;
          log("Error of delete $errors");
          if (errors.isNotEmpty) {
            errorMessage = (errors.values.first as List).first.toString();
            log("errorMessage of delete $errorMessage");
          }
        }

        responseModel = ResponseModel(false, errorMessage);
      }
    } catch (e) {
      log('ERROR AT accountDelete): $e');
      responseModel = ResponseModel(false, "Error while accountDelete user $e");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  UserModel? userModel;

  Future<ResponseModel> fetchProfile() async {
    log('----------- fetchProfile Called ----------');

    ResponseModel responseModel;
    isLoading = true;
    update();

    try {
      Response response = await authRepo.fetchProfile();

      if (response.body['status'] == "success") {
        responseModel = ResponseModel(
          true,
          response.body['message'] ?? "fetchProfile successful",
        );
        userModel = UserModel.fromJson(response.body['data']);
        log('fetchProfile: role=${userModel?.role}, permissions count=${userModel?.permissions?.length}, roles=${userModel?.roles}');
      } else {
        String errorMessage =
            response.body['message'] ?? "Error while fetchProfile user";

        if (response.body['errors'] != null) {
          final errors = response.body['errors'] as Map<String, dynamic>;
          if (errors.isNotEmpty) {
            errorMessage = (errors.values.first as List).first.toString();
          }
        }

        responseModel = ResponseModel(false, errorMessage);
      }
    } catch (e) {
      log('ERROR AT fetchProfile): $e');
      responseModel = ResponseModel(false, "Error while fetchProfile user $e");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  File? profileImage;
  updateImages(File? image) {
    profileImage = image;
    update();
  }

  Future<ResponseModel> updateProfile({
    bool isUpdateFCMToken = false,
  }) async {
    log('----------- updateProfile Called ----------');

    ResponseModel responseModel;
    isLoading = true;
    update();

    try {
      log(profileImage.toString());
      Map<String, dynamic> data = {
        "name": fullNameController.text.trim(),
        "email": emailController.text.trim(),
        "mobile": mobileController.text.trim(),
        "profile_image": profileImage == null
            ? null
            : MultipartFile(
                profileImage,
                filename: profileImage?.path.split('/').last ?? "",
              ),
      };

      Map<String, dynamic> dataFCMToken = {
        "fcm_token": authRepo.getFCMToken(),
      };

      Response response = await authRepo.updateProfile(
          data: isUpdateFCMToken ? FormData(dataFCMToken) : FormData(data));

      if (response.body['status'] == "success") {
        responseModel = ResponseModel(
          true,
          response.body['message'] ?? "updateProfile successful",
        );
        updateImages(null);
      } else {
        String errorMessage =
            response.body['message'] ?? "Error while updateProfile user";

        if (response.body['errors'] != null) {
          final errors = response.body['errors'] as Map<String, dynamic>;
          if (errors.isNotEmpty) {
            errorMessage = (errors.values.first as List).first.toString();
          }
        }

        responseModel = ResponseModel(false, errorMessage);
      }
    } catch (e) {
      log('ERROR AT updateProfile()): $e');
      responseModel = ResponseModel(false, "Error while updateProfile user $e");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  Future<void> saveFMCToken(String fcmToken) async {
    final saveFCMToken = await authRepo.saveFCMToken(fcmToken: fcmToken);
    log('loginUser: saved FCM token: $saveFCMToken');
  }

  void toggleTerms() {
    _acceptTerms = !_acceptTerms;
    update();
  }

  bool isLoggedIn() {
    return authRepo.isLoggedIn();
  }

  bool clearSharedData() {
    return authRepo.clearSharedData();
  }

  String getUserToken() {
    return authRepo.getUserToken();
  }

  bool hasPermission(dynamic permission) {
    if (userModel == null) {
      log('hasPermission: userModel is NULL, returning false for: $permission');
      return false;
    }

    // If no permission required, allow access
    if (permission == null) return true;
    if (permission is String && permission.trim().isEmpty) return true;
    if (permission is List && permission.isEmpty) return true;

    // Check if role is partner, admin, director or owner — they get full permissions
    String role = (userModel?.role ?? "").toLowerCase().trim();
    if (role == 'partner' ||
        role == 'admin' ||
        role == 'super_admin' ||
        role == 'superadmin' ||
        role == 'director' ||
        role == 'owner') {
      return true;
    }

    // Check if roles list contains any high-level roles
    if (userModel?.roles != null && userModel!.roles!.isNotEmpty) {
      if (userModel!.roles!.any((r) {
        String lowerRole = r.toLowerCase();
        return lowerRole.contains('admin') ||
            lowerRole.contains('director') ||
            lowerRole.contains('partner') ||
            lowerRole.contains('owner') ||
            lowerRole.contains('super');
      })) {
        return true;
      }
    }

    // Handle List of permissions (any match = access granted)
    if (permission is List) {
      return permission.any((p) => _checkSinglePermission(p.toString()));
    }

    return _checkSinglePermission(permission.toString());
  }

  bool _checkSinglePermission(String permission) {
    if (userModel?.permissions == null || userModel!.permissions!.isEmpty) {
      log('_checkSinglePermission: permissions list is null/empty, denying: $permission');
      return false;
    }

    final rawReq = permission.trim().toLowerCase();
    if (rawReq.isEmpty) return true;

    // Build candidate variations for this requested permission
    final Set<String> candidates = {
      rawReq,
      rawReq.replaceAll('-', '_'),
      rawReq.replaceAll('_', '-'),
      rawReq.replaceAll(RegExp(r'[-_\s]'), ''),
    };

    // If permission requests viewown, having viewany or viewteam also grants access!
    if (rawReq.endsWith('_viewown') || rawReq.contains('viewown')) {
      candidates.add(rawReq.replaceAll('viewown', 'viewany'));
      candidates.add(rawReq.replaceAll('viewown', 'viewteam'));
    } else if (rawReq.endsWith('_viewteam') || rawReq.contains('viewteam')) {
      candidates.add(rawReq.replaceAll('viewteam', 'viewany'));
    }

    // Handle module alias variations
    // work_shift <-> shift
    if (rawReq.contains('work_shift') || rawReq.contains('workshift')) {
      candidates.add(rawReq.replaceAll('work_shift', 'shift').replaceAll('workshift', 'shift'));
    } else if (rawReq.contains('shift')) {
      candidates.add(rawReq.replaceAll('shift', 'work_shift'));
      candidates.add(rawReq.replaceAll('shift', 'workshift'));
    }

    // reports <-> report <-> view-own-reports
    if (rawReq.contains('report')) {
      candidates.add("reports_viewany");
      candidates.add("report_viewany");
      candidates.add("reports_viewown");
      candidates.add("report_viewown");
      candidates.add("view-own-reports");
      candidates.add("viewany-reports");
    }

    // salary <-> payroll
    if (rawReq.contains('salary')) {
      candidates.add(rawReq.replaceAll('salary', 'payroll'));
    } else if (rawReq.contains('payroll')) {
      candidates.add(rawReq.replaceAll('payroll', 'salary'));
    }

    // resignation_exit <-> resignationexit <-> resignation <-> exit
    if (rawReq.contains('resignation') || rawReq.contains('exit')) {
      candidates.add('resignationexit_viewany');
      candidates.add('resignation_viewany');
      candidates.add('exit_viewany');
      candidates.add('resignationexit_viewown');
      candidates.add('resignation_viewown');
      candidates.add('exit_viewown');
    }

    // Check if any candidate matches the user's permissions
    final userPerms = userModel!.permissions!;
    for (var p in userPerms) {
      final cleanP = p.trim().toLowerCase();
      final strippedP = cleanP.replaceAll(RegExp(r'[-_\s]'), '');

      if (candidates.contains(cleanP) ||
          candidates.any((c) => c.replaceAll(RegExp(r'[-_\s]'), '') == strippedP)) {
        return true;
      }
    }

    log('_checkSinglePermission: "$rawReq" NOT found in user permissions');
    return false;
  }
}
