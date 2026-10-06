import 'package:get/get.dart';
import 'package:vlr/data/api/api_client.dart';
import 'package:vlr/services/constants.dart';

class WorkShiftRepo {
  final ApiClient apiClient;

  WorkShiftRepo({required this.apiClient});

  Future<Response> getWorkShifts(Map<String, dynamic> query) async {
    return await apiClient.getData(AppConstants.workShifts, "getWorkShifts", query: query);
  }

  Future<Response> createWorkShift(Map<String, dynamic> body) async {
    return await apiClient.postData(AppConstants.workShifts, "createWorkShift", body);
  }

  Future<Response> updateWorkShift(int id, Map<String, dynamic> body) async {
    return await apiClient.putData("${AppConstants.workShifts}/$id", "updateWorkShift", body);
  }

  Future<Response> deleteWorkShift(int id) async {
    return await apiClient.deleteData("${AppConstants.workShifts}/$id", "deleteWorkShift");
  }
}
