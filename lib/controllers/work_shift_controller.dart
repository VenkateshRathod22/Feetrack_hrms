import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vlr/data/models/response/response_model.dart';
import 'package:vlr/data/models/work_shift_model.dart';
import 'package:vlr/data/repositories/work_shift_repo.dart';

class WorkShiftController extends GetxController implements GetxService {
  final WorkShiftRepo workShiftRepo;

  WorkShiftController({required this.workShiftRepo});

  bool isLoading = false;
  List<WorkShiftModel> workShiftList = [];

  final TextEditingController nameController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();
  final TextEditingController lateToleranceController = TextEditingController();
  final TextEditingController minPresentController = TextEditingController();
  final TextEditingController minHalfDayController = TextEditingController();
  final TextEditingController autoAbsentMarkController = TextEditingController();
  
  int? selectedBranchId;
  bool autoMarkAttendance = false;
  String selectedAutoMarkStatus = "absent";
  List<String> selectedWeekOffDays = [];

  final List<String> daysOfWeek = [
    "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"
  ];

  Future<ResponseModel> getWorkShifts({String? search}) async {
    isLoading = true;
    update();

    try {
      Map<String, dynamic> query = {};
      if (search != null && search.isNotEmpty) query['search'] = search;

      Response response = await workShiftRepo.getWorkShifts(query);

      if (response.body != null && response.body['status'] == "success") {
        final List data = response.body['data'];
        workShiftList = data.map((e) => WorkShiftModel.fromJson(e)).toList();
        isLoading = false;
        update();
        return ResponseModel(true, response.body['message'] ?? "Work shifts fetched successfully");
      } else {
        isLoading = false;
        update();
        return ResponseModel(false, response.body?['message'] ?? "Failed to fetch work shifts");
      }
    } catch (e) {
      log("ERROR AT getWorkShifts: $e");
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  Future<ResponseModel> createWorkShift() async {
    isLoading = true;
    update();

    try {
      Map<String, dynamic> body = {
        "name": nameController.text,
        "start_time": startTimeController.text,
        "end_time": endTimeController.text,
        "branch_id": selectedBranchId,
        "auto_mark_attendance": autoMarkAttendance,
        "auto_mark_status": selectedAutoMarkStatus,
        "late_tolerance_minutes": int.tryParse(lateToleranceController.text) ?? 0,
        "min_present_mins": int.tryParse(minPresentController.text) ?? 0,
        "min_half_day_mins": int.tryParse(minHalfDayController.text) ?? 0,
        "auto_absent_mark_mins": int.tryParse(autoAbsentMarkController.text) ?? 0,
        "week_off_days": selectedWeekOffDays,
      };

      Response response = await workShiftRepo.createWorkShift(body);

      if (response.body != null && response.body['status'] == "success") {
        isLoading = false;
        getWorkShifts();
        update();
        return ResponseModel(true, response.body['message'] ?? "Work shift created successfully");
      } else {
        isLoading = false;
        update();
        return ResponseModel(false, response.body?['message'] ?? "Failed to create work shift");
      }
    } catch (e) {
      log("ERROR AT createWorkShift: $e");
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  Future<ResponseModel> updateWorkShift(int id) async {
    isLoading = true;
    update();

    try {
      Map<String, dynamic> body = {
        "name": nameController.text,
        "start_time": startTimeController.text,
        "end_time": endTimeController.text,
        "branch_id": selectedBranchId,
        "auto_mark_attendance": autoMarkAttendance,
        "auto_mark_status": selectedAutoMarkStatus,
        "late_tolerance_minutes": int.tryParse(lateToleranceController.text) ?? 0,
        "min_present_mins": int.tryParse(minPresentController.text) ?? 0,
        "min_half_day_mins": int.tryParse(minHalfDayController.text) ?? 0,
        "auto_absent_mark_mins": int.tryParse(autoAbsentMarkController.text) ?? 0,
        "week_off_days": selectedWeekOffDays,
      };

      Response response = await workShiftRepo.updateWorkShift(id, body);

      if (response.body != null && response.body['status'] == "success") {
        isLoading = false;
        getWorkShifts();
        update();
        return ResponseModel(true, response.body['message'] ?? "Work shift updated successfully");
      } else {
        isLoading = false;
        update();
        return ResponseModel(false, response.body?['message'] ?? "Failed to update work shift");
      }
    } catch (e) {
      log("ERROR AT updateWorkShift: $e");
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  Future<ResponseModel> deleteWorkShift(int id) async {
    isLoading = true;
    update();

    try {
      Response response = await workShiftRepo.deleteWorkShift(id);

      if (response.body != null && response.body['status'] == "success") {
        isLoading = false;
        workShiftList.removeWhere((element) => element.id == id);
        update();
        return ResponseModel(true, response.body['message'] ?? "Work shift deleted successfully");
      } else {
        isLoading = false;
        update();
        return ResponseModel(false, response.body?['message'] ?? "Failed to delete work shift");
      }
    } catch (e) {
      log("ERROR AT deleteWorkShift: $e");
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  void toggleWeekOffDay(String day) {
    if (selectedWeekOffDays.contains(day)) {
      selectedWeekOffDays.remove(day);
    } else {
      selectedWeekOffDays.add(day);
    }
    update();
  }

  void clearControllers() {
    nameController.clear();
    startTimeController.clear();
    endTimeController.clear();
    lateToleranceController.clear();
    minPresentController.clear();
    minHalfDayController.clear();
    autoAbsentMarkController.clear();
    selectedBranchId = null;
    autoMarkAttendance = false;
    selectedAutoMarkStatus = "absent";
    selectedWeekOffDays = [];
  }

  void setEditData(WorkShiftModel shift) {
    nameController.text = shift.name ?? "";
    startTimeController.text = shift.startTime ?? "";
    endTimeController.text = shift.endTime ?? "";
    lateToleranceController.text = shift.lateToleranceMinutes?.toString() ?? "";
    minPresentController.text = shift.minPresentMins?.toString() ?? "";
    minHalfDayController.text = shift.minHalfDayMins?.toString() ?? "";
    autoAbsentMarkController.text = shift.autoAbsentMarkMins?.toString() ?? "";
    selectedBranchId = shift.branchId;
    autoMarkAttendance = shift.autoMarkAttendance == 1;
    selectedAutoMarkStatus = shift.autoMarkStatus ?? "absent";
    selectedWeekOffDays = shift.weekOffDays != null ? List.from(shift.weekOffDays!) : [];
    update();
  }

  @override
  void onClose() {
    nameController.dispose();
    startTimeController.dispose();
    endTimeController.dispose();
    lateToleranceController.dispose();
    minPresentController.dispose();
    minHalfDayController.dispose();
    autoAbsentMarkController.dispose();
    super.onClose();
  }
}
