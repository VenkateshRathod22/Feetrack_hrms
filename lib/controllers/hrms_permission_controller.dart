import 'dart:developer';
import 'package:get/get.dart';
import 'package:vlr/data/models/role_model.dart';
import 'package:vlr/data/models/response/response_model.dart';
import 'package:vlr/data/repositories/permission_repo.dart';

class HrmsPermissionController extends GetxController implements GetxService {
  final PermissionRepo permissionRepo;

  HrmsPermissionController({required this.permissionRepo});

  bool isLoading = false;
  List<PermissionModuleModel> permissionModuleList = [];
  List<PermissionModel> permissionList = [];

  Future<ResponseModel> getPermissionList({String? search}) async {
    isLoading = true;
    update();

    try {
      Response response = await permissionRepo.getPermissions(search: search);

      if (response.body != null && response.body['status'] == "success") {
        final data = response.body['data'];
        if (data is List) {
          permissionModuleList = data
              .map((e) =>
                  PermissionModuleModel.fromJson(Map<String, dynamic>.from(e)))
              .toList();

          // Populate flat list for compatibility
          permissionList = [];
          for (var module in permissionModuleList) {
            if (module.permissions != null) {
              permissionList.addAll(module.permissions!);
            }
          }
        }

        isLoading = false;
        update();
        return ResponseModel(true, response.body['message'] ?? "Permissions fetched successfully");
      } else {
        isLoading = false;
        update();
        return ResponseModel(false, response.body?['message'] ?? "Failed to fetch permissions");
      }
    } catch (e) {
      log("ERROR AT getPermissionList: $e");
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }
}
