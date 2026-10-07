import 'package:get/get.dart';
import 'package:vlr/data/api/api_client.dart';
import 'package:vlr/services/constants.dart';

class SalaryRepo {
  final ApiClient apiClient;

  SalaryRepo({required this.apiClient});

  Future<Response> getSalaryStructure(String employeeId) async {
    return await apiClient.getData("${AppConstants.salaryStructure}$employeeId/salary-structure", "getSalaryStructure");
  }

  Future<Response> getSalaryStructuresList(Map<String, dynamic> query) async {
    return await apiClient.getData(AppConstants.salaryStructuresList, "getSalaryStructuresList", query: query);
  }

  Future<Response> updateSalaryStructure(String employeeId, Map<String, dynamic> body) async {
    return await apiClient.postData("${AppConstants.salaryStructure}$employeeId/salary-structure", "updateSalaryStructure", body);
  }
}
