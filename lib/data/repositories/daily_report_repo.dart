import 'package:get/get.dart';
import 'package:vlr/data/api/api_client.dart';
import 'package:vlr/services/constants.dart';

class DailyReportRepo {
  final ApiClient apiClient;

  DailyReportRepo({required this.apiClient});

  Future<Response> submitDailyReport(Map<String, dynamic> body) async {
    return await apiClient.postData(AppConstants.dailyWorkReports, "submitDailyReport", body);
  }

  Future<Response> getDailyReports({String? date, int page = 1}) async {
    Map<String, dynamic> query = {'page': page.toString()};
    if (date != null) {
      query['date'] = date;
    }
    return await apiClient.getData(AppConstants.dailyWorkReports, "getDailyReports", query: query);
  }

  Future<Response> getDailyReportDetails(int id) async {
    return await apiClient.getData("${AppConstants.dailyWorkReports}/$id", "getDailyReportDetails");
  }

  Future<Response> getPendingTasks({String? search}) async {
    Map<String, dynamic> query = {};
    if (search != null) {
      query['search'] = search;
    }
    return await apiClient.getData(AppConstants.pendingTasksForReport, "getPendingTasks", query: query);
  }

  Future<Response> getTeamReports({String? search, String? status, String? date, int page = 1}) async {
    Map<String, dynamic> query = {'page': page.toString()};
    if (search != null && search.isNotEmpty) query['search'] = search;
    if (status != null && status.isNotEmpty) query['status'] = status;
    if (date != null && date.isNotEmpty) query['date'] = date;
    
    return await apiClient.getData("/hrms/team-work-reports", "getTeamReports", query: query);
  }

  Future<Response> approveTeamReport(int id) async {
    return await apiClient.postData("/hrms/team-work-reports/$id/approve", "approveTeamReport", {});
  }

  Future<Response> rejectTeamReport(int id) async {
    return await apiClient.postData("/hrms/team-work-reports/$id/reject", "rejectTeamReport", {});
  }
}
