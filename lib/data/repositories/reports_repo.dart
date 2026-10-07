import 'package:get/get_connect/http/src/response/response.dart';
import 'package:vlr/data/api/api_client.dart';
import 'package:vlr/services/constants.dart';

class ReportsRepo {
  final ApiClient apiClient;

  ReportsRepo({required this.apiClient});

  // Analytics Reports
  Future<Response> getStaffReport(Map<String, dynamic> query) async {
    return await apiClient.getData(AppConstants.staffReport, "getStaffReport", query: query);
  }

  Future<Response> getAttendanceReport(Map<String, dynamic> query) async {
    return await apiClient.getData(AppConstants.attendanceReport, "getAttendanceReport", query: query);
  }

  Future<Response> getLeaveReport(Map<String, dynamic> query) async {
    return await apiClient.getData(AppConstants.leaveReport, "getLeaveReport", query: query);
  }

  Future<Response> getExpenseReport(Map<String, dynamic> query) async {
    return await apiClient.getData(AppConstants.expenseReport, "getExpenseReport", query: query);
  }

  Future<Response> getTaskReport(Map<String, dynamic> query) async {
    return await apiClient.getData(AppConstants.taskReport, "getTaskReport", query: query);
  }

  Future<Response> getLeadReport(Map<String, dynamic> query) async {
    return await apiClient.getData(AppConstants.leadReport, "getLeadReport", query: query);
  }

  Future<Response> getOrderReport(Map<String, dynamic> query) async {
    return await apiClient.getData(AppConstants.orderReport, "getOrderReport", query: query);
  }

  Future<Response> getPayrollReport(Map<String, dynamic> query) async {
    return await apiClient.getData(AppConstants.payrollReport, "getPayrollReport", query: query);
  }

  Future<Response> getRecoveryReport(Map<String, dynamic> query) async {
    return await apiClient.getData(AppConstants.recoveryReport, "getRecoveryReport", query: query);
  }

  Future<Response> getNoticeReport(Map<String, dynamic> query) async {
    return await apiClient.getData(AppConstants.noticeReport, "getNoticeReport", query: query);
  }

  Future<Response> getProductCategoryReport(Map<String, dynamic> query) async {
    return await apiClient.getData(AppConstants.productCategoryReport, "getProductCategoryReport", query: query);
  }

  Future<Response> getProductReport(Map<String, dynamic> query) async {
    return await apiClient.getData(AppConstants.productReport, "getProductReport", query: query);
  }

  Future<Response> getSalaryReport(Map<String, dynamic> query) async {
    return await apiClient.getData(AppConstants.salaryReport, "getSalaryReport", query: query);
  }

  Future<Response> getCommissionReport(Map<String, dynamic> query) async {
    return await apiClient.getData(AppConstants.commissionReport, "getCommissionReport", query: query);
  }

  Future<Response> getPipReport(Map<String, dynamic> query) async {
    return await apiClient.getData(AppConstants.pipReport, "getPipReport", query: query);
  }

  Future<Response> getRecruitmentReport(Map<String, dynamic> query) async {
    return await apiClient.getData(AppConstants.recruitmentReport, "getRecruitmentReport", query: query);
  }

  Future<Response> getProbationReport(Map<String, dynamic> query) async {
    return await apiClient.getData(AppConstants.probationReport, "getProbationReport", query: query);
  }

  Future<Response> getResignationExitReport(Map<String, dynamic> query) async {
    return await apiClient.getData(AppConstants.resignationExitReport, "getResignationExitReport", query: query);
  }

  Future<Response> getDocumentReport(Map<String, dynamic> query) async {
    return await apiClient.getData(AppConstants.documentReport, "getDocumentReport", query: query);
  }

  Future<Response> getGrievanceDisciplineReport(Map<String, dynamic> query) async {
    return await apiClient.getData(AppConstants.grievanceDisciplineReport, "getGrievanceDisciplineReport", query: query);
  }

  Future<Response> getAttritionReport(Map<String, dynamic> query) async {
    return await apiClient.getData(AppConstants.attritionReport, "getAttritionReport", query: query);
  }

  Future<Response> getExitReasonsReport(Map<String, dynamic> query) async {
    return await apiClient.getData(AppConstants.exitReasonsReport, "getExitReasonsReport", query: query);
  }

  Future<Response> getEmployeeCostReport(Map<String, dynamic> query) async {
    return await apiClient.getData(AppConstants.employeeCostReport, "getEmployeeCostReport", query: query);
  }

  Future<Response> getTrainingReport(Map<String, dynamic> query) async {
    return await apiClient.getData(AppConstants.trainingReport, "getTrainingReport", query: query);
  }

  Future<Response> getAssetReport(Map<String, dynamic> query) async {
    return await apiClient.getData(AppConstants.assetReport, "getAssetReport", query: query);
  }

  // Training Management
  Future<Response> getTrainingDashboard(Map<String, dynamic> query) async {
    return await apiClient.getData(AppConstants.trainingDashboard, "getTrainingDashboard", query: query);
  }

  Future<Response> getTrainingPrograms(Map<String, dynamic> query) async {
    return await apiClient.getData(AppConstants.trainingPrograms, "getTrainingPrograms", query: query);
  }

  Future<Response> createTrainingProgram(Map<String, dynamic> body) async {
    return await apiClient.postData(AppConstants.trainingPrograms, "createTrainingProgram", body);
  }

  Future<Response> updateTrainingProgram(int id, Map<String, dynamic> body) async {
    return await apiClient.putData("${AppConstants.trainingPrograms}/$id", "updateTrainingProgram", body);
  }

  Future<Response> deleteTrainingProgram(int id) async {
    return await apiClient.deleteData("${AppConstants.trainingPrograms}/$id", "deleteTrainingProgram");
  }

  Future<Response> assignTraining(Map<String, dynamic> body) async {
    return await apiClient.postData(AppConstants.trainingAssignments, "assignTraining", body);
  }

  // Asset Management
  Future<Response> getAssetsList(Map<String, dynamic> query) async {
    return await apiClient.getData(AppConstants.assets, "getAssetsList", query: query);
  }

  Future<Response> generateAssetCode() async {
    return await apiClient.getData(AppConstants.assetGenerateCode, "generateAssetCode");
  }

  Future<Response> addAsset(Map<String, dynamic> body) async {
    return await apiClient.postData(AppConstants.assets, "addAsset", body);
  }

  Future<Response> updateAsset(int id, Map<String, dynamic> body) async {
    return await apiClient.putData("${AppConstants.assets}/$id", "updateAsset", body);
  }

  Future<Response> deleteAsset(int id) async {
    return await apiClient.deleteData("${AppConstants.assets}/$id", "deleteAsset");
  }

  // PIP Management
  Future<Response> getPipsList(Map<String, dynamic> query) async {
    return await apiClient.getData(AppConstants.pips, "getPipsList", query: query);
  }

  Future<Response> createPip(Map<String, dynamic> body) async {
    return await apiClient.postData(AppConstants.pips, "createPip", body);
  }

  Future<Response> updatePip(int id, Map<String, dynamic> body) async {
    return await apiClient.putData("${AppConstants.pips}/$id", "updatePip", body);
  }

  Future<Response> deletePip(int id) async {
    return await apiClient.deleteData("${AppConstants.pips}/$id", "deletePip");
  }

  // Recruitment Management
  Future<Response> getRecruitmentsList(Map<String, dynamic> query) async {
    return await apiClient.getData(AppConstants.recruitments, "getRecruitmentsList", query: query);
  }

  Future<Response> getRecruitmentDetails(int id) async {
    return await apiClient.getData("${AppConstants.recruitments}/$id", "getRecruitmentDetails");
  }

  Future<Response> createRecruitment(Map<String, dynamic> body) async {
    return await apiClient.postData(AppConstants.recruitments, "createRecruitment", body);
  }

  Future<Response> createJobPost(dynamic body) async {
    return await apiClient.postData(AppConstants.jobPosts, "createJobPost", body);
  }

  Future<Response> getJobPlans() async {
    return await apiClient.getData(AppConstants.jobPlans, "getJobPlans");
  }

  Future<Response> getJobTemplates() async {
    return await apiClient.getData(AppConstants.jobTemplates, "getJobTemplates");
  }

  Future<Response> getJobTemplateDetails(int id) async {
    return await apiClient.getData("${AppConstants.jobTemplates}/$id", "getJobTemplateDetails");
  }

  Future<Response> getJobPostsHistory() async {
    return await apiClient.getData(AppConstants.jobPostsHistory, "getJobPostsHistory");
  }

  Future<Response> updateRecruitment(int id, Map<String, dynamic> body) async {
    return await apiClient.putData("${AppConstants.recruitments}/$id", "updateRecruitment", body);
  }

  Future<Response> deleteRecruitment(int id) async {
    return await apiClient.deleteData("${AppConstants.recruitments}/$id", "deleteRecruitment");
  }

  // Applied Jobs
  Future<Response> getAppliedJobsList(Map<String, dynamic> query) async {
    return await apiClient.getData(AppConstants.appliedJobs, "getAppliedJobsList", query: query);
  }

  Future<Response> updateAppliedJobStatus(int id, Map<String, dynamic> body) async {
    return await apiClient.putData("${AppConstants.appliedJobs}/$id/status", "updateAppliedJobStatus", body);
  }

  // Probation Management
  Future<Response> getProbationsList(Map<String, dynamic> query) async {
    return await apiClient.getData(AppConstants.probations, "getProbationsList", query: query);
  }

  Future<Response> getProbationDetails(int id) async {
    return await apiClient.getData("${AppConstants.probations}/$id", "getProbationDetails");
  }

  Future<Response> createProbation(Map<String, dynamic> body) async {
    return await apiClient.postData(AppConstants.probations, "createProbation", body);
  }

  Future<Response> updateProbation(int id, Map<String, dynamic> body) async {
    return await apiClient.putData("${AppConstants.probations}/$id", "updateProbation", body);
  }

  Future<Response> deleteProbation(int id) async {
    return await apiClient.deleteData("${AppConstants.probations}/$id", "deleteProbation");
  }

  // Exits Management
  Future<Response> getExitsList(Map<String, dynamic> query) async {
    return await apiClient.getData(AppConstants.exits, "getExitsList", query: query);
  }

  Future<Response> getExitDetails(String id) async {
    return await apiClient.getData("${AppConstants.exits}/$id", "getExitDetails");
  }

  Future<Response> createExit(Map<String, dynamic> body) async {
    return await apiClient.postData(AppConstants.exits, "createExit", body);
  }

  Future<Response> updateExit(String id, Map<String, dynamic> body) async {
    return await apiClient.putData("${AppConstants.exits}/$id", "updateExit", body);
  }

  Future<Response> deleteExit(String id) async {
    return await apiClient.deleteData("${AppConstants.exits}/$id", "deleteExit");
  }

  // Document Management
  Future<Response> getDocumentsList(Map<String, dynamic> query) async {
    return await apiClient.getData(AppConstants.documents, "getDocumentsList", query: query);
  }

  Future<Response> getDocumentDetails(int id) async {
    return await apiClient.getData("${AppConstants.documents}/$id", "getDocumentDetails");
  }

  Future<Response> createDocument(dynamic body) async {
    return await apiClient.postData(AppConstants.documents, "createDocument", body);
  }

  Future<Response> updateDocument(int id, dynamic body) async {
    return await apiClient.putData("${AppConstants.documents}/$id", "updateDocument", body);
  }

  Future<Response> deleteDocument(int id) async {
    return await apiClient.deleteData("${AppConstants.documents}/$id", "deleteDocument");
  }

  // Grievance Management
  Future<Response> getGrievancesList(Map<String, dynamic> query) async {
    return await apiClient.getData(AppConstants.grievances, "getGrievancesList", query: query);
  }

  Future<Response> getGrievanceDetails(int id) async {
    return await apiClient.getData("${AppConstants.grievances}/$id", "getGrievanceDetails");
  }

  Future<Response> createGrievance(Map<String, dynamic> body) async {
    return await apiClient.postData(AppConstants.grievances, "createGrievance", body);
  }

  Future<Response> updateGrievance(int id, Map<String, dynamic> body) async {
    return await apiClient.putData("${AppConstants.grievances}/$id", "updateGrievance", body);
  }

  Future<Response> deleteGrievance(int id) async {
    return await apiClient.deleteData("${AppConstants.grievances}/$id", "deleteGrievance");
  }

  // Attrition Management
  Future<Response> getAttritionList(Map<String, dynamic> query) async {
    return await apiClient.getData(AppConstants.attrition, "getAttritionList", query: query);
  }

  Future<Response> createAttrition(Map<String, dynamic> body) async {
    return await apiClient.postData(AppConstants.attrition, "createAttrition", body);
  }

  Future<Response> updateAttrition(String id, Map<String, dynamic> body) async {
    return await apiClient.putData("${AppConstants.attrition}/$id", "updateAttrition", body);
  }

  Future<Response> deleteAttrition(String id) async {
    return await apiClient.deleteData("${AppConstants.attrition}/$id", "deleteAttrition");
  }

  // Attrition Exit Reasons
  Future<Response> getExitReasons() async {
    return await apiClient.getData(AppConstants.attritionExitReasons, "getExitReasons");
  }

  Future<Response> createExitReason(Map<String, dynamic> body) async {
    return await apiClient.postData(AppConstants.attritionExitReasons, "createExitReason", body);
  }

  Future<Response> updateExitReason(int id, Map<String, dynamic> body) async {
    return await apiClient.putData("${AppConstants.attritionExitReasons}/$id", "updateExitReason", body);
  }

  Future<Response> deleteExitReason(int id) async {
    return await apiClient.deleteData("${AppConstants.attritionExitReasons}/$id", "deleteExitReason");
  }

  // Export
  Future<Response> exportReport(String uri, Map<String, dynamic> query) async {
    return await apiClient.getData(uri, "exportReport", query: query);
  }
}
