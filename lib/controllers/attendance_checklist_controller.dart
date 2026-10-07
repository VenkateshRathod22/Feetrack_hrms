import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vlr/data/models/attendance_checklist_model.dart';
import 'package:vlr/data/models/response/response_model.dart';
import 'package:vlr/data/repositories/attendance_checklist_repo.dart';

class AttendanceChecklistController extends GetxController implements GetxService {
  final AttendanceChecklistRepo attendanceChecklistRepo;

  AttendanceChecklistController({required this.attendanceChecklistRepo});

  bool isLoading = false;
  List<AttendanceChecklistModel> checklist = [];

  final TextEditingController questionController = TextEditingController();
  String selectedMode = 'both';
  final List<String> modeList = ['punch_in', 'punch_out', 'both'];

  Future<ResponseModel> getChecklist({String? search}) async {
    isLoading = true;
    update();

    try {
      Map<String, dynamic> query = {};
      if (search != null) query['search'] = search;

      Response response = await attendanceChecklistRepo.getChecklists(query);

      if (response.body != null && response.body['status'] == "success") {
        final List data = response.body['data'];
        checklist = data.map((e) => AttendanceChecklistModel.fromJson(e)).toList();
        isLoading = false;
        update();
        return ResponseModel(true, response.body['message'] ?? "Checklist fetched successfully");
      } else {
        isLoading = false;
        update();
        return ResponseModel(false, response.body?['message'] ?? "Failed to fetch checklist");
      }
    } catch (e) {
      log("ERROR AT getChecklist: $e");
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  Future<ResponseModel> addChecklist() async {
    isLoading = true;
    update();

    try {
      Map<String, dynamic> body = {
        "question": questionController.text,
        "mode": selectedMode,
      };

      Response response = await attendanceChecklistRepo.addChecklist(body);

      if (response.body != null && response.body['status'] == "success") {
        isLoading = false;
        getChecklist();
        update();
        return ResponseModel(true, response.body['message'] ?? "Checklist question added successfully");
      } else {
        isLoading = false;
        update();
        return ResponseModel(false, response.body?['message'] ?? "Failed to add checklist question");
      }
    } catch (e) {
      log("ERROR AT addChecklist: $e");
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  Future<ResponseModel> toggleStatus(int id) async {
    // Optimistic UI update
    final index = checklist.indexWhere((element) => element.id == id);
    if (index != -1) {
      checklist[index].isActive = !(checklist[index].isActive ?? false);
      update();
    }

    try {
      Response response = await attendanceChecklistRepo.toggleChecklistStatus(id);

      if (response.body != null && response.body['status'] == "success") {
        return ResponseModel(true, response.body['message'] ?? "Status updated successfully");
      } else {
        // Revert on failure
        if (index != -1) {
          checklist[index].isActive = !(checklist[index].isActive ?? false);
          update();
        }
        return ResponseModel(false, response.body?['message'] ?? "Failed to update status");
      }
    } catch (e) {
      log("ERROR AT toggleStatus: $e");
      // Revert on error
      if (index != -1) {
        checklist[index].isActive = !(checklist[index].isActive ?? false);
        update();
      }
      return ResponseModel(false, "Error: $e");
    }
  }

  Future<ResponseModel> deleteChecklist(int id) async {
    isLoading = true;
    update();

    try {
      Response response = await attendanceChecklistRepo.deleteChecklist(id);

      if (response.body != null && response.body['status'] == "success") {
        isLoading = false;
        checklist.removeWhere((element) => element.id == id);
        update();
        return ResponseModel(true, response.body['message'] ?? "Checklist question deleted successfully");
      } else {
        isLoading = false;
        update();
        return ResponseModel(false, response.body?['message'] ?? "Failed to delete checklist question");
      }
    } catch (e) {
      log("ERROR AT deleteChecklist: $e");
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  void clearControllers() {
    questionController.clear();
    selectedMode = 'both';
    update();
  }

  @override
  void onClose() {
    questionController.dispose();
    super.onClose();
  }
}
