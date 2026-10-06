import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vlr/data/models/leave_category_model.dart';
import 'package:vlr/data/models/response/leave_model.dart';
import 'package:vlr/data/repositories/leave_repo.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/date_formatters_and_converters.dart';

class LeaveController extends GetxController implements GetxService {
  final LeaveRepo leaveRepo;

  LeaveController({required this.leaveRepo});

  bool isLoading = false;

  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController reasonForLeaveController = TextEditingController();

  LeaveCategoryModel? selectedLeaveCategory;
  List<LeaveCategoryModel> leaveCategoryList = [];

  String? leaveType;
  List<String> leaveTypeList = [
    "Casual Leave (CL)",
    "Sick Leave (SL)",
    "Unpaid Leave (UL)",
  ];

  Map<String, String> leaveTypeMapping = {
    "Casual Leave (CL)": "casual",
    "Sick Leave (SL)": "sick",
    "Unpaid Leave (UL)": "unpaid",
  };

  List<LeaveModel> leaveList = [];
  List<LeaveModel> teamLeaveList = [];

  Future<void> fetchLeaveCategories() async {
    Response response = await leaveRepo.getLeaveCategories();
    if (response.statusCode == 200) {
      leaveCategoryList = [];
      if (response.body['data'] != null) {
        response.body['data'].forEach((v) {
          leaveCategoryList.add(LeaveCategoryModel.fromJson(v));
        });
      }
      update();
    }
  }

  Future<void> fetchLeaves() async {
    isLoading = true;
    update();

    try {
      Response response = await leaveRepo.getLeaves();

      if (response.statusCode == 200) {
        leaveList = [];
        response.body['data'].forEach((v) {
          leaveList.add(LeaveModel.fromJson(v));
        });
      } else {
        showToast(message: response.statusText ?? "Something went wrong", toastType: ToastType.error);
      }
    } catch (e) {
      showToast(message: "An error occurred: $e", toastType: ToastType.error);
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> fetchTeamLeaves(String status) async {
    isLoading = true;
    update();

    try {
      Response response = await leaveRepo.getTeamLeaves(status);

      if (response.statusCode == 200) {
        teamLeaveList = [];
        // The data is inside data.data because it's paginated
        if (response.body['data']['data'] != null) {
          response.body['data']['data'].forEach((v) {
            teamLeaveList.add(LeaveModel.fromJson(v));
          });
        }
      } else {
        showToast(message: response.statusText ?? "Something went wrong", toastType: ToastType.error);
      }
    } catch (e) {
      showToast(message: "An error occurred: $e", toastType: ToastType.error);
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> updateLeaveStatus(int leaveId, String status, {String? currentTabStatus}) async {
    isLoading = true;
    update();

    try {
      Response response = await leaveRepo.updateLeaveStatus(leaveId, status);

      if (response.statusCode == 200) {
        showToast(message: response.body['message'] ?? "Leave status updated", toastType: ToastType.success);
        if (currentTabStatus != null) {
          fetchTeamLeaves(currentTabStatus);
        }
      } else {
        showToast(message: response.statusText ?? "Something went wrong", toastType: ToastType.error);
      }
    } catch (e) {
      showToast(message: "An error occurred: $e", toastType: ToastType.error);
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> applyLeave() async {
    isLoading = true;
    update();

    try {
      String startDate = DateFormatters().yMD.format(DateFormatters().dMyDash.parse(startDateController.text));
      String endDate = DateFormatters().yMD.format(DateFormatters().dMyDash.parse(endDateController.text));

      Map<String, dynamic> body = {
        "start_date": startDate,
        "end_date": endDate,
        "type": selectedLeaveCategory?.name?.toLowerCase() ?? "casual",
        "leave_category_id": selectedLeaveCategory?.id,
        "reason": reasonForLeaveController.text,
      };

      Response response = await leaveRepo.applyLeave(body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        showToast(message: response.body['message'] ?? "Leave applied successfully", toastType: ToastType.success);
        clearFields();
        Get.back();
      } else {
        showToast(message: response.statusText ?? "Something went wrong", toastType: ToastType.error);
      }
    } catch (e) {
      showToast(message: "An error occurred: $e", toastType: ToastType.error);
    } finally {
      isLoading = false;
      update();
    }
  }

  void clearFields() {
    startDateController.clear();
    endDateController.clear();
    reasonForLeaveController.clear();
    leaveType = null;
    selectedLeaveCategory = null;
    update();
  }

  @override
  void dispose() {
    super.dispose();
    startDateController.dispose();
    endDateController.dispose();
    reasonForLeaveController.dispose();
  }
}
