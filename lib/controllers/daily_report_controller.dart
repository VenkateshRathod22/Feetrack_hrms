import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vlr/data/models/reports/daily_report_model.dart';
import 'package:vlr/data/models/response/response_model.dart';
import 'package:vlr/data/models/response/task_model.dart';
import 'package:vlr/data/repositories/daily_report_repo.dart';

class DailyReportController extends GetxController implements GetxService {
  final DailyReportRepo dailyReportRepo;

  DailyReportController({required this.dailyReportRepo});

  bool isLoading = false;
  List<DailyReportModel> dailyReports = [];
  List<DailyReportModel> teamReports = [];
  DailyReportModel? selectedReport;
  List<TaskModel> pendingTasks = [];

  // Form fields for AddDailyReport
  final TextEditingController reportDateController = TextEditingController();
  final TextEditingController summaryController = TextEditingController();
  List<DailyReportItemModel> items = [];

  // Pagination for list
  int currentPage = 1;
  bool hasNextPage = true;

  int teamCurrentPage = 1;
  bool teamHasNextPage = true;

  Future<ResponseModel> getDailyReports({String? date, bool reload = true}) async {
    if (reload) {
      currentPage = 1;
      dailyReports = [];
      isLoading = true;
      update();
    }

    try {
      Response response = await dailyReportRepo.getDailyReports(date: date, page: currentPage);

      if (response.body != null && response.body['status'] == "success") {
        final dynamic responseData = response.body['data'];
        List<dynamic> dataList = [];

        if (responseData is List) {
          dataList = responseData;
        } else if (responseData is Map && responseData['data'] is List) {
          dataList = responseData['data'];
          currentPage = responseData['current_page'] ?? 1;
          hasNextPage = responseData['next_page_url'] != null;
        }

        List<DailyReportModel> fetchedReports = dataList.map((e) => DailyReportModel.fromJson(e)).toList();
        
        if (reload) {
          dailyReports = fetchedReports;
        } else {
          dailyReports.addAll(fetchedReports);
        }

        isLoading = false;
        update();
        return ResponseModel(true, response.body['message'] ?? "Reports fetched successfully");
      } else {
        isLoading = false;
        update();
        return ResponseModel(false, response.body?['message'] ?? "Failed to fetch reports");
      }
    } catch (e) {
      log("ERROR AT getDailyReports: $e");
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  Future<ResponseModel> getTeamReports({String? search, String? status, String? date, bool reload = true}) async {
    if (reload) {
      teamCurrentPage = 1;
      teamReports = [];
      isLoading = true;
      update();
    }

    try {
      Response response = await dailyReportRepo.getTeamReports(
        search: search,
        status: status,
        date: date,
        page: teamCurrentPage,
      );

      if (response.body != null && response.body['status'] == "success") {
        final dynamic responseData = response.body['data'];
        List<dynamic> dataList = [];

        if (responseData is List) {
          dataList = responseData;
        } else if (responseData is Map) {
          if (responseData['data'] is List) {
            dataList = responseData['data'];
          } else {
            // It could be an object wrap, as shown in sample response:
            // "data": { "id": 1, ... } or a single report object.
            // Let's check if it's a single item or wrapped.
            dataList = [responseData];
          }
          teamCurrentPage = responseData['current_page'] ?? 1;
          teamHasNextPage = responseData['next_page_url'] != null;
        }

        List<DailyReportModel> fetchedReports = [];
        for (var item in dataList) {
          if (item != null && item is Map<String, dynamic>) {
            fetchedReports.add(DailyReportModel.fromJson(item));
          }
        }

        if (reload) {
          teamReports = fetchedReports;
        } else {
          teamReports.addAll(fetchedReports);
        }

        isLoading = false;
        update();
        return ResponseModel(true, response.body['message'] ?? "Team reports fetched successfully");
      } else {
        isLoading = false;
        update();
        return ResponseModel(false, response.body?['message'] ?? "Failed to fetch team reports");
      }
    } catch (e) {
      log("ERROR AT getTeamReports: $e");
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  Future<ResponseModel> approveTeamReport(int id) async {
    isLoading = true;
    update();

    try {
      Response response = await dailyReportRepo.approveTeamReport(id);

      isLoading = false;
      update();
      if (response.body != null && response.body['status'] == "success") {
        return ResponseModel(true, response.body['message'] ?? "Report approved successfully");
      } else {
        return ResponseModel(false, response.body?['message'] ?? "Failed to approve report");
      }
    } catch (e) {
      log("ERROR AT approveTeamReport: $e");
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  Future<ResponseModel> rejectTeamReport(int id) async {
    isLoading = true;
    update();

    try {
      Response response = await dailyReportRepo.rejectTeamReport(id);

      isLoading = false;
      update();
      if (response.body != null && response.body['status'] == "success") {
        return ResponseModel(true, response.body['message'] ?? "Report rejected successfully");
      } else {
        return ResponseModel(false, response.body?['message'] ?? "Failed to reject report");
      }
    } catch (e) {
      log("ERROR AT rejectTeamReport: $e");
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  Future<ResponseModel> getDailyReportDetails(int id) async {
    isLoading = true;
    selectedReport = null;
    update();

    try {
      Response response = await dailyReportRepo.getDailyReportDetails(id);

      if (response.body != null && response.body['status'] == "success") {
        selectedReport = DailyReportModel.fromJson(response.body['data']);
        isLoading = false;
        update();
        return ResponseModel(true, response.body['message'] ?? "Report details fetched successfully");
      } else {
        isLoading = false;
        update();
        return ResponseModel(false, response.body?['message'] ?? "Failed to fetch report details");
      }
    } catch (e) {
      log("ERROR AT getDailyReportDetails: $e");
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  Future<ResponseModel> getPendingTasks({String? search}) async {
    isLoading = true;
    update();

    try {
      Response response = await dailyReportRepo.getPendingTasks(search: search);

      if (response.body != null && response.body['status'] == "success") {
        final List<dynamic> data = response.body['data'];
        pendingTasks = data.map((e) => TaskModel.fromJson(e)).toList();
        isLoading = false;
        update();
        return ResponseModel(true, response.body['message'] ?? "Pending tasks fetched successfully");
      } else {
        isLoading = false;
        update();
        return ResponseModel(false, response.body?['message'] ?? "Failed to fetch pending tasks");
      }
    } catch (e) {
      log("ERROR AT getPendingTasks: $e");
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  Future<ResponseModel> submitDailyReport() async {
    isLoading = true;
    update();

    try {
      Map<String, dynamic> body = {
        "report_date": reportDateController.text,
        "summary": summaryController.text,
        "items": items.map((e) => {
          "title": e.title,
          "details": e.details,
          "category": e.category,
          "status": e.status,
          "priority": e.priority,
          "time_spent_hours": e.timeSpentHours,
          "time_spent_minutes": e.timeSpentMinutes,
          "task_id": e.taskId,
        }).toList(),
      };

      Response response = await dailyReportRepo.submitDailyReport(body);

      if (response.body != null && response.body['status'] == "success") {
        isLoading = false;
        update();
        return ResponseModel(true, response.body['message'] ?? "Report submitted successfully");
      } else {
        isLoading = false;
        update();
        return ResponseModel(false, response.body?['message'] ?? "Failed to submit report");
      }
    } catch (e) {
      log("ERROR AT submitDailyReport: $e");
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  void addItem(DailyReportItemModel item) {
    items.add(item);
    update();
  }

  void removeItem(int index) {
    items.removeAt(index);
    update();
  }

  void clearFormData() {
    reportDateController.clear();
    summaryController.clear();
    items.clear();
    update();
  }
}
