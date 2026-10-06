import 'package:get/get.dart';
import 'package:vlr/data/api/api_client.dart';
import 'package:vlr/services/constants.dart';

class AttendanceChecklistRepo {
  final ApiClient apiClient;

  AttendanceChecklistRepo({required this.apiClient});

  Future<Response> getChecklists(Map<String, dynamic> query) async {
    return await apiClient.getData(AppConstants.attendanceChecklists, "getChecklists", query: query);
  }

  Future<Response> addChecklist(Map<String, dynamic> body) async {
    return await apiClient.postData(AppConstants.attendanceChecklists, "addChecklist", body);
  }

  Future<Response> toggleChecklistStatus(int id) async {
    return await apiClient.putData("${AppConstants.attendanceChecklists}/$id/toggle", "toggleChecklistStatus", {});
  }

  Future<Response> deleteChecklist(int id) async {
    return await apiClient.deleteData("${AppConstants.attendanceChecklists}/$id", "deleteChecklist");
  }
}
