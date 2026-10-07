import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vlr/data/models/holiday_model.dart';
import 'package:vlr/data/models/response/response_model.dart';
import 'package:vlr/data/repositories/holiday_repo.dart';

class HolidayController extends GetxController implements GetxService {
  final HolidayRepo holidayRepo;

  HolidayController({required this.holidayRepo});

  bool isLoading = false;
  List<HolidayModel> holidayList = [];

  final TextEditingController nameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  String? selectedBranchId;

  Future<ResponseModel> getHolidayList({String? search}) async {
    isLoading = true;
    update();

    try {
      Map<String, dynamic> query = {};
      if (search != null) query['search'] = search;

      Response response = await holidayRepo.getHolidays(query);

      if (response.body != null && response.body['status'] == "success") {
        final List data = response.body['data'];
        holidayList = data.map((e) => HolidayModel.fromJson(e)).toList();
        isLoading = false;
        update();
        return ResponseModel(true, response.body['message'] ?? "Holidays fetched successfully");
      } else {
        isLoading = false;
        update();
        return ResponseModel(false, response.body?['message'] ?? "Failed to fetch holidays");
      }
    } catch (e) {
      log("ERROR AT getHolidayList: $e");
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  Future<ResponseModel> addHoliday() async {
    isLoading = true;
    update();

    try {
      Map<String, dynamic> body = {
        "name": nameController.text,
        "date": dateController.text,
        "branch_id": selectedBranchId,
      };

      Response response = await holidayRepo.addHoliday(body);

      if (response.body != null && response.body['status'] == "success") {
        isLoading = false;
        getHolidayList();
        update();
        return ResponseModel(true, response.body['message'] ?? "Holiday added successfully");
      } else {
        isLoading = false;
        update();
        return ResponseModel(false, response.body?['message'] ?? "Failed to add holiday");
      }
    } catch (e) {
      log("ERROR AT addHoliday: $e");
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  Future<ResponseModel> updateHoliday(int id) async {
    isLoading = true;
    update();

    try {
      Map<String, dynamic> body = {
        "name": nameController.text,
        "date": dateController.text,
        "branch_id": selectedBranchId,
      };

      Response response = await holidayRepo.updateHoliday(id, body);

      if (response.body != null && response.body['status'] == "success") {
        isLoading = false;
        getHolidayList();
        update();
        return ResponseModel(true, response.body['message'] ?? "Holiday updated successfully");
      } else {
        isLoading = false;
        update();
        return ResponseModel(false, response.body?['message'] ?? "Failed to update holiday");
      }
    } catch (e) {
      log("ERROR AT updateHoliday: $e");
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  Future<ResponseModel> deleteHoliday(int id) async {
    isLoading = true;
    update();

    try {
      Response response = await holidayRepo.deleteHoliday(id);

      if (response.body != null && response.body['status'] == "success") {
        isLoading = false;
        holidayList.removeWhere((element) => element.id == id);
        update();
        return ResponseModel(true, response.body['message'] ?? "Holiday deleted successfully");
      } else {
        isLoading = false;
        update();
        return ResponseModel(false, response.body?['message'] ?? "Failed to delete holiday");
      }
    } catch (e) {
      log("ERROR AT deleteHoliday: $e");
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  void clearControllers() {
    nameController.clear();
    dateController.clear();
    selectedBranchId = null;
    update();
  }

  void setEditData(HolidayModel holiday) {
    nameController.text = holiday.name ?? "";
    dateController.text = holiday.date ?? "";
    selectedBranchId = holiday.branchId?.toString();
    update();
  }

  @override
  void onClose() {
    nameController.dispose();
    dateController.dispose();
    super.onClose();
  }
}
