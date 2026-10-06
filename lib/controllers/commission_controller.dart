import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vlr/data/models/response/response_model.dart';
import 'package:vlr/data/repositories/commission_repo.dart';

class CommissionController extends GetxController implements GetxService {
  final CommissionRepo commissionRepo;

  CommissionController({required this.commissionRepo});

  bool isLoading = false;
  List<dynamic> commissionHistoryList = [];

  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;

  final List<String> months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  Future<ResponseModel> getCommissionHistory({String? search}) async {
    isLoading = true;
    update();

    try {
      Map<String, dynamic> query = {};
      if (search != null && search.isNotEmpty) query['search'] = search;

      Response response = await commissionRepo.getCommissionHistory(query);

      if (response.body != null && response.body['status'] == "success") {
        commissionHistoryList = response.body['data'] ?? [];
        isLoading = false;
        update();
        return ResponseModel(true, response.body['message'] ?? "Commission history fetched successfully");
      } else {
        isLoading = false;
        update();
        return ResponseModel(false, response.body?['message'] ?? "Failed to fetch history");
      }
    } catch (e) {
      log("ERROR AT getCommissionHistory: $e");
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  Future<ResponseModel> processCommission() async {
    isLoading = true;
    update();

    try {
      Map<String, dynamic> body = {
        "month": selectedMonth,
        "year": selectedYear,
      };

      Response response = await commissionRepo.processCommission(body);

      if (response.body != null && (response.body['status'] == "success" || response.body['status'] == "info")) {
        isLoading = false;
        getCommissionHistory();
        update();
        return ResponseModel(true, response.body['message'] ?? "Processed successfully.");
      } else {
        isLoading = false;
        update();
        return ResponseModel(false, response.body?['message'] ?? "Failed to process commission");
      }
    } catch (e) {
      log("ERROR AT processCommission: $e");
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  void setMonth(int month) {
    selectedMonth = month;
    update();
  }

  void setYear(int year) {
    selectedYear = year;
    update();
  }
}
