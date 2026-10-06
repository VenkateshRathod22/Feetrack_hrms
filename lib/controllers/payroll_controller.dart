import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vlr/data/models/response/response_model.dart';
import 'package:vlr/data/repositories/payroll_repo.dart';

class PayrollController extends GetxController implements GetxService {
  final PayrollRepo payrollRepo;

  PayrollController({required this.payrollRepo});

  bool isLoading = false;
  List<dynamic> myPayrollList = [];
  List<dynamic> payrollDraftsList = [];
  List<dynamic> payrollApprovalsList = [];
  List<dynamic> advancePaymentsList = [];
  List<dynamic> advanceReportsList = [];
  Map<String, dynamic> advanceReportsSummary = {};

  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;

  final List<String> months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  Future<ResponseModel> getMyPayroll({String? search}) async {
    isLoading = true;
    update();

    try {
      Map<String, dynamic> query = {};
      if (search != null && search.isNotEmpty) query['search'] = search;

      Response response = await payrollRepo.getMyPayroll(query);

      if (response.body != null && response.body['status'] == "success") {
        myPayrollList = response.body['data'] ?? [];
        isLoading = false;
        update();
        return ResponseModel(true, response.body['message'] ?? "Payroll fetched successfully");
      } else {
        isLoading = false;
        update();
        return ResponseModel(false, response.body?['message'] ?? "Failed to fetch payroll");
      }
    } catch (e) {
      log("ERROR AT getMyPayroll: $e");
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  Future<ResponseModel> getPayrollDrafts({String? search}) async {
    isLoading = true;
    update();

    try {
      Map<String, dynamic> query = {};
      if (search != null && search.isNotEmpty) query['search'] = search;

      Response response = await payrollRepo.getPayrollDrafts(query);

      if (response.body != null && response.body['status'] == "success") {
        // The response for drafts seems to have a nested 'data' field due to pagination
        if (response.body['data'] is Map && response.body['data']['data'] != null) {
          payrollDraftsList = response.body['data']['data'];
        } else {
          payrollDraftsList = response.body['data'] ?? [];
        }
        isLoading = false;
        update();
        return ResponseModel(true, response.body['message'] ?? "Payroll drafts fetched successfully");
      } else {
        isLoading = false;
        update();
        return ResponseModel(false, response.body?['message'] ?? "Failed to fetch payroll drafts");
      }
    } catch (e) {
      log("ERROR AT getPayrollDrafts: $e");
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  Future<ResponseModel> getPayrollApprovals({String? search}) async {
    isLoading = true;
    update();

    try {
      Map<String, dynamic> query = {};
      if (search != null && search.isNotEmpty) query['search'] = search;

      Response response = await payrollRepo.getPayrollApprovals(query);

      if (response.body != null && response.body['status'] == "success") {
        if (response.body['data'] is Map && response.body['data']['data'] != null) {
          payrollApprovalsList = response.body['data']['data'];
        } else {
          payrollApprovalsList = response.body['data'] ?? [];
        }
        isLoading = false;
        update();
        return ResponseModel(true, response.body['message'] ?? "Payroll approvals fetched successfully");
      } else {
        isLoading = false;
        update();
        return ResponseModel(false, response.body?['message'] ?? "Failed to fetch payroll approvals");
      }
    } catch (e) {
      log("ERROR AT getPayrollApprovals: $e");
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  Future<ResponseModel> processPayroll() async {
    isLoading = true;
    update();

    try {
      Map<String, dynamic> body = {
        "month": selectedMonth,
        "year": selectedYear,
      };

      Response response = await payrollRepo.processPayroll(body);

      if (response.body != null && response.body['status'] == "success") {
        isLoading = false;
        getPayrollDrafts();
        update();
        return ResponseModel(true, response.body['message'] ?? "Payroll processed successfully.");
      } else {
        isLoading = false;
        update();
        return ResponseModel(false, response.body?['message'] ?? "Failed to process payroll");
      }
    } catch (e) {
      log("ERROR AT processPayroll: $e");
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  Future<ResponseModel> getAdvancePayments() async {
    isLoading = true;
    update();
    try {
      Response response = await payrollRepo.getAdvancePayments({});
      if (response.body != null && response.body['status'] == "success") {
        advancePaymentsList = response.body['data'] ?? [];
        isLoading = false;
        update();
        return ResponseModel(true, "Fetched successfully");
      } else {
        isLoading = false;
        update();
        return ResponseModel(false, response.body?['message'] ?? "Failed to fetch");
      }
    } catch (e) {
      log("ERROR AT getAdvancePayments: $e");
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  Future<ResponseModel> getAdvanceReports() async {
    isLoading = true;
    update();
    try {
      Response response = await payrollRepo.getAdvanceReports({});
      if (response.body != null && response.body['status'] == "success") {
        advanceReportsList = response.body['data']['data'] ?? [];
        advanceReportsSummary = response.body['summary'] ?? {};
        isLoading = false;
        update();
        return ResponseModel(true, "Fetched successfully");
      } else {
        isLoading = false;
        update();
        return ResponseModel(false, response.body?['message'] ?? "Failed to fetch");
      }
    } catch (e) {
      log("ERROR AT getAdvanceReports: $e");
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  Future<ResponseModel> approvePayroll(int payrollId) async {
    isLoading = true;
    update();

    try {
      Response response = await payrollRepo.approvePayroll(payrollId);

      if (response.body != null && response.body['status'] == "success") {
        isLoading = false;
        getPayrollDrafts();
        getPayrollApprovals();
        update();
        return ResponseModel(true, response.body['message'] ?? "Payroll approved successfully.");
      } else {
        isLoading = false;
        update();
        return ResponseModel(false, response.body?['message'] ?? "Failed to approve payroll");
      }
    } catch (e) {
      log("ERROR AT approvePayroll: $e");
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

  // Adjustment Controllers
  final TextEditingController basicSalaryController = TextEditingController();
  final TextEditingController bonusController = TextEditingController();
  final TextEditingController presentDaysController = TextEditingController();
  final TextEditingController halfDaysController = TextEditingController();
  final TextEditingController paidLeaveController = TextEditingController();
  final TextEditingController unpaidLeaveController = TextEditingController();
  final TextEditingController absentDaysController = TextEditingController();
  final TextEditingController advancePayController = TextEditingController();

  Map<String, TextEditingController> allowanceControllers = {};
  Map<String, TextEditingController> deductionControllers = {};

  void setAdjustmentData(dynamic draft) {
    basicSalaryController.text = draft['basic_salary']?.toString() ?? "0";
    bonusController.text = draft['bonuses']?.toString() ?? "0";
    presentDaysController.text = draft['present_days']?.toString() ?? "0";
    halfDaysController.text = draft['half_days']?.toString() ?? "0";
    paidLeaveController.text = draft['paid_leave_days']?.toString() ?? "0";
    unpaidLeaveController.text = draft['unpaid_leave_days']?.toString() ?? "0";
    absentDaysController.text = draft['absent_days']?.toString() ?? "0";
    advancePayController.text = draft['advance_pay']?.toString() ?? "0";

    allowanceControllers.clear();
    if (draft['allowances_breakdown'] != null && draft['allowances_breakdown'] is Map) {
      (draft['allowances_breakdown'] as Map).forEach((key, value) {
        allowanceControllers[key] = TextEditingController(text: value.toString());
      });
    }

    deductionControllers.clear();
    if (draft['deductions_breakdown'] != null && draft['deductions_breakdown'] is Map) {
      (draft['deductions_breakdown'] as Map).forEach((key, value) {
        if (key != 'salary_advance' && key != 'absent') {
          deductionControllers[key] = TextEditingController(text: value.toString());
          deductionControllers[key]!.addListener(calculateTotals);
        }
      });
      if (draft['deductions_breakdown']['salary_advance'] != null) {
        advancePayController.text = draft['deductions_breakdown']['salary_advance'].toString();
      }
    }

    if (draft['allowances_breakdown'] != null && draft['allowances_breakdown'] is Map) {
      (draft['allowances_breakdown'] as Map).forEach((key, value) {
        allowanceControllers[key]!.addListener(calculateTotals);
      });
    }

    basicSalaryController.addListener(calculateTotals);
    bonusController.addListener(calculateTotals);
    advancePayController.addListener(calculateTotals);

    calculateTotals();
    update();
  }

  double totalAllowances = 0;
  double totalDeductions = 0;
  double totalSalary = 0;
  double grossPay = 0;
  double netPay = 0;
  double dailyRate = 0;
  double thisMonthSalary = 0;

  void calculateTotals() {
    double basic = double.tryParse(basicSalaryController.text) ?? 0;
    double bonus = double.tryParse(bonusController.text) ?? 0;
    double advance = double.tryParse(advancePayController.text) ?? 0;

    totalAllowances = 0;
    allowanceControllers.forEach((key, controller) {
      totalAllowances += double.tryParse(controller.text) ?? 0;
    });

    totalDeductions = advance;
    deductionControllers.forEach((key, controller) {
      totalDeductions += double.tryParse(controller.text) ?? 0;
    });

    // Simple estimation for UI feedback
    // In a real app, this might be more complex based on attendance
    thisMonthSalary = basic; // Placeholder for attendance-based calc
    totalSalary = thisMonthSalary + totalAllowances + bonus;
    grossPay = totalSalary;
    netPay = grossPay - totalDeductions;

    update();
  }

  Future<ResponseModel> adjustPayroll(int payrollId) async {
    isLoading = true;
    update();

    try {
      Map<String, dynamic> allowances = {};
      allowanceControllers.forEach((key, controller) {
        allowances[key] = double.tryParse(controller.text) ?? 0;
      });

      Map<String, dynamic> deductions = {};
      deductionControllers.forEach((key, controller) {
        deductions[key] = double.tryParse(controller.text) ?? 0;
      });

      Map<String, dynamic> body = {
        "basic_salary": double.tryParse(basicSalaryController.text) ?? 0,
        "bonuses": double.tryParse(bonusController.text) ?? 0,
        "allowances": allowances,
        "deductions": deductions,
        "present_days": int.tryParse(presentDaysController.text) ?? 0,
        "half_days": int.tryParse(halfDaysController.text) ?? 0,
        "paid_leave_days": int.tryParse(paidLeaveController.text) ?? 0,
        "unpaid_leave_days": int.tryParse(unpaidLeaveController.text) ?? 0,
        "absent_days": int.tryParse(absentDaysController.text) ?? 0,
        "advance_pay": double.tryParse(advancePayController.text) ?? 0,
      };

      Response response = await payrollRepo.adjustPayroll(payrollId, body);

      if (response.body != null && response.body['status'] == "success") {
        isLoading = false;
        getPayrollDrafts();
        update();
        return ResponseModel(true, response.body['message'] ?? "Payroll adjusted successfully.");
      } else {
        isLoading = false;
        update();
        return ResponseModel(false, response.body?['message'] ?? "Failed to adjust payroll");
      }
    } catch (e) {
      log("ERROR AT adjustPayroll: $e");
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  void addAllowanceField(String name) {
    if (!allowanceControllers.containsKey(name)) {
      allowanceControllers[name] = TextEditingController(text: "0");
      update();
    }
  }

  void addDeductionField(String name) {
    if (!deductionControllers.containsKey(name)) {
      deductionControllers[name] = TextEditingController(text: "0");
      update();
    }
  }

  @override
  void onClose() {
    basicSalaryController.dispose();
    bonusController.dispose();
    presentDaysController.dispose();
    halfDaysController.dispose();
    paidLeaveController.dispose();
    unpaidLeaveController.dispose();
    absentDaysController.dispose();
    advancePayController.dispose();
    allowanceControllers.values.forEach((c) => c.dispose());
    deductionControllers.values.forEach((c) => c.dispose());
    super.onClose();
  }
}
