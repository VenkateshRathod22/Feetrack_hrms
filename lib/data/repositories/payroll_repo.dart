import 'package:get/get.dart';
import 'package:vlr/data/api/api_client.dart';
import 'package:vlr/services/constants.dart';

class PayrollRepo {
  final ApiClient apiClient;

  PayrollRepo({required this.apiClient});

  Future<Response> getMyPayroll(Map<String, dynamic> query) async {
    return await apiClient.getData(AppConstants.myPayroll, "getMyPayroll", query: query);
  }

  Future<Response> processPayroll(Map<String, dynamic> body) async {
    return await apiClient.postData(AppConstants.processPayroll, "processPayroll", body);
  }

  Future<Response> getPayrollDrafts(Map<String, dynamic> query) async {
    return await apiClient.getData(AppConstants.payrollDrafts, "getPayrollDrafts", query: query);
  }

  Future<Response> getPayrollApprovals(Map<String, dynamic> query) async {
    return await apiClient.getData(AppConstants.payrollApproval, "getPayrollApprovals", query: query);
  }

  Future<Response> adjustPayroll(int payrollId, Map<String, dynamic> body) async {
    return await apiClient.postData("/hrms/payroll/$payrollId/adjust", "adjustPayroll", body);
  }

  Future<Response> getAdvancePayments(Map<String, dynamic> body) async {
    return await apiClient.postData(AppConstants.advancePaymentsList, "getAdvancePayments", body);
  }

  Future<Response> getAdvanceReports(Map<String, dynamic> body) async {
    return await apiClient.postData(AppConstants.advanceReports, "getAdvanceReports", body);
  }

  Future<Response> approvePayroll(int payrollId) async {
    return await apiClient.postData("/hrms/payroll/$payrollId/approve", "approvePayroll", {});
  }
}
