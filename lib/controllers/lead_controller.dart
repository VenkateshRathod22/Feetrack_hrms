import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:vlr/data/models/response/customer_visit_model.dart';
import 'package:vlr/data/models/response/lead_model.dart';
import 'package:vlr/data/models/response/lead_order_calculation_model.dart';
import 'package:vlr/data/models/response/lead_order_comment_model.dart';
import 'package:vlr/data/models/response/lead_order_model.dart';
import 'package:vlr/data/models/response/lead_order_tab_model.dart';
import 'package:vlr/data/models/response/lead_recovery_model.dart';
import 'package:vlr/data/models/response/recovery_history_model.dart';
import 'package:vlr/data/models/user_model.dart';
import 'package:vlr/data/repositories/lead_repo.dart';
import 'package:vlr/services/constants.dart';

import '../data/models/response/response_model.dart';
import '../main.dart';

class LeadController extends GetxController implements GetxService {
  final LeadRepo leadRepo;

  LeadController({required this.leadRepo});

  bool isLoading = false;
  bool isCalcLoading = false;
  LeadModel? selectedLead;
  List<LeadModel> leadsList = [];
  List<LeadModel> wonLeadsList = [];
  List<CustomerVisitModel> customerVisitList = [];
  List<UserModel> assignToList = [];
  LeadOrderCalculationModel? calculationData;
  List<LeadOrderTabModel> leadOrderTabs = [];
  int selectedOrderTabIndex = 0;
  List<LeadOrderModel> leadOrders = [];
  List<LeadOrderCommentModel> orderComments = [];
  List<RecoveryHistoryItem> recoveryHistory = [];
  RecoverySummary? recoverySummary;
  List<LeadRecoveryItem> pendingRecoveries = [];
  RecoveryListSummary? pendingRecoverySummary;

  TextEditingController nameLeadController = TextEditingController();
  TextEditingController businessNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController businessAmountController = TextEditingController();
  TextEditingController requirementController = TextEditingController();

  // Customer Visit Form
  TextEditingController visitDateController = TextEditingController();
  TextEditingController visitNotesController = TextEditingController();
  TextEditingController visitLocationController = TextEditingController();
  TextEditingController visitPurposeController = TextEditingController();
  LeadModel? selectedLeadForVisit;

  String? productInterest;
  String? status;
  UserModel? assignTo;

  List<String> productInterestList = [
    "Product 1",
    "Product 2",
    "Product 3",
  ];
  List<String> statusList = [
    "New",
    "First Call",
    "Interested",
    "Meeting Scheduled",
    "Customer Visit",
    "Quotation",
    "Negotiation",
    "Won",
    "Lost",
  ];

  void setLead(LeadModel lead) {
    selectedLead = lead;
    nameLeadController.text = lead.customerName ?? "";
    phoneController.text = lead.customerMobile ?? "";
    emailController.text = lead.email ?? "";
    businessNameController.text = lead.businessName ?? "";
    businessAmountController.text = lead.businessAmount ?? "0";
    requirementController.text = lead.notes ?? "";
    productInterest = lead.productInterest;
    
    // Set status
    if (lead.status != null) {
      status = statusList.firstWhereOrNull(
        (element) => element.toLowerCase() == lead.status!.toLowerCase(),
      ) ?? status;
    }

    // Set assignTo if available in assignToList
    if (lead.assignedTo != null) {
      String? assignedId;
      if (lead.assignedTo is UserModel) {
        assignedId = (lead.assignedTo as UserModel).id;
      } else {
        assignedId = lead.assignedTo.toString();
      }

      if (assignedId != null) {
        assignTo = assignToList.firstWhereOrNull((element) => element.id == assignedId);
      }
    }
    
    update();
  }

  Future<void> fetchEmployees() async {
    Response response = await leadRepo.getTeamEmployees();
    if (response.statusCode == 200) {
      assignToList = [];
      if (response.body['data'] != null && response.body['data']['data'] != null) {
        response.body['data']['data'].forEach((v) {
          assignToList.add(UserModel.fromJson(v));
        });
      }
      
      // If we are editing, re-resolve assignTo from the newly fetched list
      if (selectedLead != null && selectedLead!.assignedTo != null) {
        String? assignedId;
        if (selectedLead!.assignedTo is UserModel) {
          assignedId = (selectedLead!.assignedTo as UserModel).id;
        } else {
          assignedId = selectedLead!.assignedTo.toString();
        }
        if (assignedId != null) {
          assignTo = assignToList.firstWhereOrNull((element) => element.id == assignedId);
        }
      }

      update();
    }
  }

  Future<void> addLead() async {
    isLoading = true;
    update();

    Map<String, dynamic> body = {
      "customer_name": nameLeadController.text.trim(),
      "customer_mobile": phoneController.text.trim(),
      "email": emailController.text.trim(),
      "company_name": businessNameController.text.trim(),
      "business_amount": businessAmountController.text.trim(),
      "product_interest": productInterest ?? "",
      "notes": requirementController.text.trim(),
      "assigned_to": assignTo?.id ?? "",
      "status": status?.toLowerCase() ?? "new",
    };

    Response response = await leadRepo.addLead(FormData(body));
    debugPrint("ADD LEAD API URL: ${response.request?.url}");
    if (response.statusCode == 200 || response.statusCode == 201) {
      showToast(message: response.body['message'] ?? "Lead added successfully", toastType: ToastType.success);
      clearControllers();
      getLeads();
      pop(navigatorKey.currentContext!);
    } else {
      showToast(message: response.statusText ?? "Failed to add lead", toastType: ToastType.error);
    }
    isLoading = false;
    update();
  }

  Future<void> updateLead() async {
    if (selectedLead == null) return;
    isLoading = true;
    update();

    Map<String, dynamic> body = {
      "customer_name": nameLeadController.text.trim(),
      "customer_mobile": phoneController.text.trim(),
      "email": emailController.text.trim(),
      "company_name": businessNameController.text.trim(),
      "business_amount": businessAmountController.text.trim(),
      "product_interest": productInterest ?? "",
      "notes": requirementController.text.trim(),
      "assigned_to": assignTo?.id ?? "",
      "status": status?.toLowerCase() ?? "new",
    };

    Response response = await leadRepo.updateLead(selectedLead!.id!, FormData(body));
    debugPrint("UPDATE LEAD API URL: ${response.request?.url}");
    if (response.statusCode == 200) {
      showToast(message: response.body['message'] ?? "Lead updated successfully", toastType: ToastType.success);
      clearControllers();
      getLeads();
      pop(navigatorKey.currentContext!);
    } else {
      showToast(message: response.statusText ?? "Failed to update lead", toastType: ToastType.error);
    }
    isLoading = false;
    update();
  }

  Future<void> getLeads() async {
    isLoading = true;
    update();

    Response response = await leadRepo.getLeads();
    debugPrint("LEADS API URL: ${response.request?.url}");
    if (response.statusCode == 200) {
      leadsList = [];
      if (response.body['data'] != null) {
        response.body['data'].forEach((v) {
          leadsList.add(LeadModel.fromJson(v));
        });
      }
    } else {
      showToast(message: response.statusText ?? "Failed to fetch leads", toastType: ToastType.error);
    }
    isLoading = false;
    update();
  }

  Future<void> getWonLeads() async {
    isLoading = true;
    wonLeadsList = []; 
    update();

    try {
      debugPrint("FETCHING WON LEADS FROM: ${AppConstants.wonLeads}");
      Response response = await leadRepo.getWonLeads();
      debugPrint("WON LEADS STATUS CODE: ${response.statusCode}");
      debugPrint("WON LEADS RESPONSE BODY: ${response.bodyString}");
      
      if (response.statusCode == 200 && response.body != null) {
        final dynamic responseData = response.body['data'];
        if (responseData != null && responseData is List) {
          wonLeadsList = responseData.map((item) => LeadModel.fromJson(item)).toList();
          debugPrint("WON LEADS: Successfully loaded ${wonLeadsList.length} leads");
        } else {
          debugPrint("WON LEADS: 'data' field is null or not a List: $responseData");
        }
      } else {
        debugPrint("WON LEADS API ERROR: ${response.statusText}");
        showToast(message: response.statusText ?? "Failed to fetch won leads", toastType: ToastType.error);
      }
    } catch (e, stack) {
      debugPrint("CRITICAL ERROR IN getWonLeads: $e");
      debugPrint(stack.toString());
    }

    isLoading = false;
    update();
  }

  Future<void> getCustomerVisits() async {
    isLoading = true;
    update();

    Response response = await leadRepo.getCustomerVisits();
    if (response.statusCode == 200) {
      customerVisitList = [];
      if (response.body['data'] != null) {
        response.body['data'].forEach((v) {
          customerVisitList.add(CustomerVisitModel.fromJson(v));
        });
      }
    } else {
      showToast(message: response.statusText ?? "Failed to fetch customer visits", toastType: ToastType.error);
    }
    isLoading = false;
    update();
  }

  Future<void> addCustomerVisit() async {
    if (selectedLeadForVisit == null || visitDateController.text.isEmpty) {
      showToast(message: "Please select a lead and visit date", toastType: ToastType.warning);
      return;
    }

    isLoading = true;
    update();

    Map<String, dynamic> body = {
      "lead_id": selectedLeadForVisit!.id,
      "visit_date": visitDateController.text,
      "Notes": visitNotesController.text.trim(),
      "location": visitLocationController.text.trim(),
      "purpose": visitPurposeController.text.trim(),
    };

    Response response = await leadRepo.addCustomerVisit(body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      showToast(message: response.body['message'] ?? "Visit scheduled successfully", toastType: ToastType.success);
      clearVisitControllers();
      getCustomerVisits();
      pop(navigatorKey.currentContext!);
    } else {
      showToast(message: response.statusText ?? "Failed to schedule visit", toastType: ToastType.error);
    }
    isLoading = false;
    update();
  }

  Future<void> updateCustomerVisit(String visitId) async {
    if (selectedLeadForVisit == null || visitDateController.text.isEmpty) {
      showToast(message: "Please select a lead and visit date", toastType: ToastType.warning);
      return;
    }

    isLoading = true;
    update();

    Map<String, dynamic> body = {
      "lead_id": selectedLeadForVisit!.id,
      "visit_date": visitDateController.text,
      "Notes": visitNotesController.text.trim(),
      "location": visitLocationController.text.trim(),
      "Purpose": visitPurposeController.text.trim(),
    };

    Response response = await leadRepo.updateCustomerVisit(visitId, body);
    if (response.statusCode == 200) {
      showToast(message: response.body['message'] ?? "Visit updated successfully", toastType: ToastType.success);
      clearVisitControllers();
      getCustomerVisits();
      pop(navigatorKey.currentContext!);
    } else {
      showToast(message: response.statusText ?? "Failed to update visit", toastType: ToastType.error);
    }
    isLoading = false;
    update();
  }

  Future<void> deleteCustomerVisit(String visitId) async {
    isLoading = true;
    update();

    Response response = await leadRepo.deleteCustomerVisit(visitId);
    if (response.statusCode == 200) {
      showToast(message: response.body['message'] ?? "Visit deleted successfully", toastType: ToastType.success);
      getCustomerVisits();
    } else {
      showToast(message: response.statusText ?? "Failed to delete visit", toastType: ToastType.error);
    }
    isLoading = false;
    update();
  }

  void setVisitData(CustomerVisitModel visit) {
    // Try to find the exact instance from the pre-loaded leads list to avoid dropdown selection errors
    if (visit.lead != null && leadsList.isNotEmpty) {
      selectedLeadForVisit = leadsList.firstWhereOrNull((e) => e.id == visit.lead!.id) ?? visit.lead;
    } else {
      selectedLeadForVisit = visit.lead;
    }
    
    if (visit.visitDate != null) {
      try {
        DateTime dt = DateTime.parse(visit.visitDate!);
        visitDateController.text = DateFormat('yyyy-MM-dd').format(dt);
      } catch (e) {
        try {
          DateTime dt = DateFormat("MMM dd, yyyy").parse(visit.visitDate!);
          visitDateController.text = DateFormat('yyyy-MM-dd').format(dt);
        } catch (e2) {
          visitDateController.text = visit.visitDate?.split("T").first ?? "";
        }
      }
    }

    visitNotesController.text = visit.notes ?? "";
    visitLocationController.text = visit.location ?? "";
    visitPurposeController.text = visit.purpose ?? "";
    update();
  }

  Future<void> calculateLeadOrder({
    required int productId,
    required double amount,
    required int quantity,
    required double discount,
    required double paidAmount,
  }) async {
    isCalcLoading = true;
    update();

    // Convert all values to strings to avoid 'int is not a subtype of Iterable' error in GetX query parameters
    Map<String, dynamic> query = {
      "product_id": productId.toString(),
      "amount": amount.toString(),
      "quantity": quantity.toString(),
      "discount": discount.toString(),
      "paid_amount": paidAmount.toString(),
    };

    try {
      debugPrint(">>> STARTING CALCULATION REQUEST: $query");
      Response response = await leadRepo.calculateLeadOrder(query);
      
      debugPrint("---------------- CALCULATION API RAW RESPONSE ----------------");
      debugPrint("STATUS: ${response.statusCode}");
      debugPrint("BODY: ${response.bodyString}");
      debugPrint("--------------------------------------------------------------");

      if (response.statusCode == 200 && response.body != null && response.body['status'] == "success") {
        calculationData = LeadOrderCalculationModel.fromJson(response.body['data']);
        debugPrint(">>> CALCULATION SUCCESS. Final Amount: ${calculationData?.finalAmount}");
      } else {
        debugPrint(">>> CALCULATION FAILED. Status: ${response.statusCode}, Msg: ${response.statusText}");
      }
    } catch (e, stack) {
      debugPrint(">>> CRITICAL ERROR IN CALCULATION: $e");
      debugPrint(stack.toString());
    }

    isCalcLoading = false;
    update();
  }

  Future<ResponseModel> createLeadOrder({
    required String leadId,
    required int productId,
    required double amount,
    required int quantity,
    required double paidAmount,
  }) async {
    isLoading = true;
    update();

    Map<String, dynamic> body = {
      "lead_id": leadId,
      "product_id": productId,
      "amount": amount,
      "quantity": quantity,
      "paid_amount": paidAmount,
      "items": [
        {"product_id": productId, "quantity": quantity, "price": amount}
      ]
    };

    Response response = await leadRepo.createLeadOrder(body);
    isLoading = false;
    update();

    if (response.statusCode == 200 || response.statusCode == 201) {
      return ResponseModel(true, response.body['message'] ?? "Order created successfully");
    } else {
      return ResponseModel(false, response.statusText ?? "Failed to create order");
    }
  }

  Future<void> getLeadOrderTabs() async {
    isLoading = true;
    update();
    Response response = await leadRepo.getLeadOrderTabs();
    if (response.statusCode == 200 && response.body['status'] == "success") {
      leadOrderTabs = [];
      final List data = response.body['data'];
      for (var item in data) {
        leadOrderTabs.add(LeadOrderTabModel.fromJson(item));
      }
      
      if (leadOrderTabs.isNotEmpty) {
        getLeadOrders(leadOrderTabs[selectedOrderTabIndex].key ?? "all");
      }
    }
    isLoading = false;
    update();
  }

  Future<void> getLeadOrders(String tabKey) async {
    isLoading = true;
    update();
    
    Response response = await leadRepo.getLeadOrders({"tabs": tabKey});
    if (response.statusCode == 200 && response.body['status'] == "success") {
      leadOrders = [];
      final List data = response.body['data'];
      for (var item in data) {
        leadOrders.add(LeadOrderModel.fromJson(item));
      }
    } else {
      showToast(message: response.statusText ?? "Failed to fetch orders", toastType: ToastType.error);
    }
    
    isLoading = false;
    update();
  }

  void updateSelectedOrderTab(int index) {
    selectedOrderTabIndex = index;
    update();
    getLeadOrders(leadOrderTabs[index].key ?? "all");
  }

  Future<void> getOrderComments(String orderId) async {
    isCalcLoading = true;
    orderComments = [];
    update();

    Response response = await leadRepo.getLeadOrderComments(orderId);
    if (response.statusCode == 200 && response.body['status'] == "success") {
      final dynamic data = response.body['data'];
      if (data is List) {
        for (var item in data) {
          orderComments.add(LeadOrderCommentModel.fromJson(item));
        }
      } else if (data is Map) {
         // Some APIs return a single object instead of a list when only one item exists
         orderComments.add(LeadOrderCommentModel.fromJson(data as Map<String, dynamic>));
      }
    }
    isCalcLoading = false;
    update();
  }

  Future<ResponseModel> addOrderComment(String orderId, String comment) async {
    isLoading = true;
    update();

    Response response = await leadRepo.addLeadOrderComment(orderId, FormData({"comment": comment}));
    isLoading = false;
    update();

    if (response.statusCode == 200 || response.statusCode == 201) {
      getOrderComments(orderId);
      return ResponseModel(true, response.body['message'] ?? "Comment added successfully");
    } else {
      return ResponseModel(false, response.statusText ?? "Failed to add comment");
    }
  }

  Future<ResponseModel> approveOrder(String orderId) async {
    isLoading = true;
    update();

    Response response = await leadRepo.approveLeadOrder(orderId);
    isLoading = false;
    update();

    if (response.statusCode == 200) {
      getLeadOrders(leadOrderTabs[selectedOrderTabIndex].key ?? "all");
      return ResponseModel(true, response.body['message'] ?? "Order approved successfully");
    } else {
      return ResponseModel(false, response.statusText ?? "Failed to approve order");
    }
  }

  Future<ResponseModel> rejectOrder(String orderId) async {
    isLoading = true;
    update();

    Response response = await leadRepo.rejectLeadOrder(orderId);
    isLoading = false;
    update();

    if (response.statusCode == 200) {
      getLeadOrders(leadOrderTabs[selectedOrderTabIndex].key ?? "all");
      return ResponseModel(true, response.body['message'] ?? "Order rejected successfully");
    } else {
      return ResponseModel(false, response.statusText ?? "Failed to reject order");
    }
  }

  Future<void> getLeadOrderRecoveryHistory() async {
    isLoading = true;
    update();

    Response response = await leadRepo.getLeadOrderRecoveryHistory();
    if (response.statusCode == 200 && response.body['status'] == "success") {
      final model = RecoveryHistoryResponseModel.fromJson(response.body);
      recoveryHistory = model.data ?? [];
      recoverySummary = model.summary;
    } else {
      showToast(message: response.statusText ?? "Failed to fetch recovery history", toastType: ToastType.error);
    }

    isLoading = false;
    update();
  }

  Future<void> getLeadOrderRecovery() async {
    isLoading = true;
    update();

    Response response = await leadRepo.getLeadOrderRecovery();
    if (response.statusCode == 200 && response.body['status'] == "success") {
      final model = LeadRecoveryResponseModel.fromJson(response.body);
      pendingRecoveries = model.data ?? [];
      pendingRecoverySummary = model.summary;
    } else {
      showToast(message: response.statusText ?? "Failed to fetch recovery orders", toastType: ToastType.error);
    }

    isLoading = false;
    update();
  }

  Future<ResponseModel> saveRecoveryPayment({
    required String orderId,
    required double amount,
    required String method,
    required String date,
    String? reference,
    String? notes,
  }) async {
    isLoading = true;
    update();

    Map<String, dynamic> body = {
      "amount": amount,
      "payment_method": method,
      "payment_date": date,
      "reference": reference ?? "",
      "notes": notes ?? "",
    };

    Response response = await leadRepo.saveRecoveryPayment(orderId, FormData(body));
    isLoading = false;
    update();

    if (response.statusCode == 200 || response.statusCode == 201) {
      getLeadOrderRecovery(); // Refresh the list
      return ResponseModel(true, response.body['message'] ?? "Payment saved successfully");
    } else {
      return ResponseModel(false, response.statusText ?? "Failed to save payment");
    }
  }

  void clearVisitControllers() {
    selectedLeadForVisit = null;
    visitDateController.clear();
    visitNotesController.clear();
    visitLocationController.clear();
    visitPurposeController.clear();
    update();
  }

  void clearControllers() {
    selectedLead = null;
    nameLeadController.clear();
    businessNameController.clear();
    phoneController.clear();
    emailController.clear();
    businessAmountController.text = "0";
    requirementController.clear();
    productInterest = null;
    status = null;
    assignTo = null;
    update();
  }

  @override
  void dispose() {
    nameLeadController.dispose();
    businessNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    businessAmountController.dispose();
    requirementController.dispose();
    visitDateController.dispose();
    visitNotesController.dispose();
    visitLocationController.dispose();
    visitPurposeController.dispose();
    super.dispose();
  }
}
