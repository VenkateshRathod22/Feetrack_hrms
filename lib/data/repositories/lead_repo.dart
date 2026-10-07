import 'package:get/get_connect/http/src/response/response.dart';
import 'package:vlr/data/api/api_client.dart';
import 'package:vlr/services/constants.dart';

class LeadRepo {
  final ApiClient apiClient;

  LeadRepo({required this.apiClient});

  Future<Response> addLead(dynamic body) async {
    return await apiClient.postData(AppConstants.addLead, "addLead", body);
  }

  Future<Response> updateLead(String leadId, dynamic body) async {
    return await apiClient.putData("${AppConstants.addLead}/$leadId", "updateLead", body);
  }

  Future<Response> getLeads() async {
    return await apiClient.getData(AppConstants.addLead, "getLeads");
  }

  Future<Response> getWonLeads() async {
    return await apiClient.getData(AppConstants.wonLeads, "getWonLeads");
  }

  Future<Response> getTeamEmployees() async {
    return await apiClient.getData(AppConstants.teamEmployeesListGet, "getTeamEmployees");
  }

  Future<Response> getCustomerVisits() async {
    return await apiClient.getData(AppConstants.customerVisits, "getCustomerVisits");
  }

  Future<Response> addCustomerVisit(dynamic body) async {
    return await apiClient.postData(AppConstants.customerVisits, "addCustomerVisit", body);
  }

  Future<Response> updateCustomerVisit(String visitId, dynamic body) async {
    return await apiClient.putData("${AppConstants.customerVisits}/$visitId", "updateCustomerVisit", body);
  }

  Future<Response> deleteCustomerVisit(String visitId) async {
    return await apiClient.deleteData("${AppConstants.customerVisits}/$visitId", "deleteCustomerVisit");
  }

  Future<Response> calculateLeadOrder(Map<String, dynamic> query) async {
    return await apiClient.getData(AppConstants.leadOrderCalculate, "calculateLeadOrder", query: query);
  }

  Future<Response> createLeadOrder(dynamic body) async {
    return await apiClient.postData(AppConstants.leadOrders, "createLeadOrder", body);
  }

  Future<Response> getLeadOrderTabs() async {
    return await apiClient.getData(AppConstants.leadOrderTabs, "getLeadOrderTabs");
  }

  Future<Response> getLeadOrders(Map<String, dynamic> query) async {
    return await apiClient.getData(AppConstants.leadOrders, "getLeadOrders", query: query);
  }

  Future<Response> getLeadOrderComments(String orderId) async {
    return await apiClient.getData("${AppConstants.leadOrders}/$orderId/comments", "getLeadOrderComments");
  }

  Future<Response> addLeadOrderComment(String orderId, dynamic body) async {
    return await apiClient.postData("${AppConstants.leadOrders}/$orderId/comments", "addLeadOrderComment", body);
  }

  Future<Response> approveLeadOrder(String orderId) async {
    return await apiClient.postData("${AppConstants.leadOrders}/$orderId/approve", "approveLeadOrder", {});
  }

  Future<Response> rejectLeadOrder(String orderId) async {
    return await apiClient.postData("${AppConstants.leadOrders}/$orderId/reject", "rejectLeadOrder", {});
  }

  Future<Response> getLeadOrderRecoveryHistory() async {
    return await apiClient.getData(AppConstants.leadOrderRecoveryHistory, "getLeadOrderRecoveryHistory");
  }

  Future<Response> getLeadOrderRecovery() async {
    return await apiClient.getData(AppConstants.leadOrderRecovery, "getLeadOrderRecovery");
  }

  Future<Response> saveRecoveryPayment(String orderId, dynamic body) async {
    return await apiClient.postData("${AppConstants.leadOrderRecovery}/$orderId/pay", "saveRecoveryPayment", body);
  }
}
