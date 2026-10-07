import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vlr/data/models/response/response_model.dart';
import 'package:vlr/data/models/salary_model.dart';
import 'package:vlr/data/models/employee_salary_list_model.dart';
import 'package:vlr/data/repositories/salary_repo.dart';

class SalaryController extends GetxController implements GetxService {
  final SalaryRepo salaryRepo;

  SalaryController({required this.salaryRepo});

  bool isLoading = false;
  SalaryStructureModel? salaryStructure;
  List<EmployeeSalaryListModel> salaryStructuresList = [];

  // Form Controllers
  final TextEditingController monthlyTargetController = TextEditingController();
  final TextEditingController commissionPercentController = TextEditingController();
  final TextEditingController recoveryPercentController = TextEditingController();
  final TextEditingController basicSalaryController = TextEditingController();
  final TextEditingController merchantTargetController = TextEditingController();

  // Allowance Controllers
  final TextEditingController hraController = TextEditingController();
  final TextEditingController daController = TextEditingController();
  final TextEditingController conveyanceController = TextEditingController();
  final TextEditingController medicalController = TextEditingController();
  final TextEditingController specialController = TextEditingController();
  final TextEditingController travelController = TextEditingController();
  final TextEditingController internetController = TextEditingController();
  final TextEditingController foodController = TextEditingController();
  final TextEditingController performanceIncentiveController = TextEditingController();
  final TextEditingController salesIncentiveController = TextEditingController();
  final TextEditingController bonusController = TextEditingController();
  final TextEditingController overtimeController = TextEditingController();
  final TextEditingController shiftController = TextEditingController();
  final TextEditingController otherAllowanceController = TextEditingController();

  // Deduction Controllers
  final TextEditingController pfController = TextEditingController();
  final TextEditingController esiController = TextEditingController();
  final TextEditingController ptController = TextEditingController();
  final TextEditingController tdsController = TextEditingController();
  final TextEditingController lwfController = TextEditingController();
  final TextEditingController noticePeriodController = TextEditingController();
  final TextEditingController otherDeductionController = TextEditingController();

  String? selectedSalaryType;
  int? selectedCommissionLevelId;

  List<String> salaryTypes = ['base_only', 'base_plus_target', 'commission_only'];

  Future<ResponseModel> getSalaryStructure(String employeeId) async {
    isLoading = true;
    salaryStructure = null; // Clear previous data
    update();

    try {
      Response response = await salaryRepo.getSalaryStructure(employeeId);

      if (response.body != null && response.body['status'] == "success") {
        salaryStructure = SalaryStructureModel.fromJson(response.body['data']);
        isLoading = false;
        update();
        return ResponseModel(true, response.body['message'] ?? "Salary structure fetched successfully");
      } else {
        isLoading = false;
        update();
        return ResponseModel(false, response.body?['message'] ?? "Failed to fetch salary structure");
      }
    } catch (e) {
      log("ERROR AT getSalaryStructure: $e");
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  Future<ResponseModel> getSalaryStructuresList({String? search, String? status}) async {
    isLoading = true;
    update();

    try {
      Map<String, dynamic> query = {};
      if (search != null && search.isNotEmpty) query['search'] = search;
      if (status != null && status != 'all') query['status'] = status;

      Response response = await salaryRepo.getSalaryStructuresList(query);

      if (response.body != null && response.body['status'] == "success") {
        final dynamic responseData = response.body['data'];
        List<dynamic> dataList = [];
        
        if (responseData is List) {
          dataList = responseData;
        } else if (responseData is Map && responseData['data'] is List) {
          dataList = responseData['data'];
        }

        salaryStructuresList = dataList.map((e) => EmployeeSalaryListModel.fromJson(e)).toList();
        isLoading = false;
        update();
        return ResponseModel(true, response.body['message'] ?? "Salary structures fetched successfully");
      } else {
        isLoading = false;
        update();
        return ResponseModel(false, response.body?['message'] ?? "Failed to fetch salary structures");
      }
    } catch (e) {
      log("ERROR AT getSalaryStructuresList: $e");
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  Future<ResponseModel> updateSalaryStructure(String employeeId) async {
    isLoading = true;
    update();

    try {
      Map<String, dynamic> body = {
        "salary_type": selectedSalaryType,
        "monthly_target": num.tryParse(monthlyTargetController.text) ?? 0,
        "merchant_target": num.tryParse(merchantTargetController.text) ?? 0,
        "commission_percent": num.tryParse(commissionPercentController.text) ?? 0,
        "recovery_percent": num.tryParse(recoveryPercentController.text) ?? 0,
        "commission_level_id": selectedCommissionLevelId,
        "basic_salary": num.tryParse(basicSalaryController.text) ?? 0,
        "allowances": {
          "hra": num.tryParse(hraController.text) ?? 0,
          "da": num.tryParse(daController.text) ?? 0,
          "conveyance": num.tryParse(conveyanceController.text) ?? 0,
          "medical": num.tryParse(medicalController.text) ?? 0,
          "special": num.tryParse(specialController.text) ?? 0,
          "travel": num.tryParse(travelController.text) ?? 0,
          "internet": num.tryParse(internetController.text) ?? 0,
          "food": num.tryParse(foodController.text) ?? 0,
          "performance_incentive": num.tryParse(performanceIncentiveController.text) ?? 0,
          "sales_incentive": num.tryParse(salesIncentiveController.text) ?? 0,
          "bonus": num.tryParse(bonusController.text) ?? 0,
          "overtime": num.tryParse(overtimeController.text) ?? 0,
          "shift": num.tryParse(shiftController.text) ?? 0,
          "other": num.tryParse(otherAllowanceController.text) ?? 0,
        },
        "deductions": {
          "pf": num.tryParse(pfController.text) ?? 0,
          "esi": num.tryParse(esiController.text) ?? 0,
          "pt": num.tryParse(ptController.text) ?? 0,
          "tds": num.tryParse(tdsController.text) ?? 0,
          "lwf": num.tryParse(lwfController.text) ?? 0,
          "notice_period": num.tryParse(noticePeriodController.text) ?? 0,
          "other": num.tryParse(otherDeductionController.text) ?? 0,
        }
      };

      Response response = await salaryRepo.updateSalaryStructure(employeeId, body);

      if (response.body != null && response.body['status'] == "success") {
        salaryStructure = SalaryStructureModel.fromJson(response.body['data']);
        isLoading = false;
        update();
        return ResponseModel(true, response.body['message'] ?? "Salary structure updated successfully");
      } else {
        isLoading = false;
        update();
        return ResponseModel(false, response.body?['message'] ?? "Failed to update salary structure");
      }
    } catch (e) {
      log("ERROR AT updateSalaryStructure: $e");
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  void setUpdateDataFromListModel(EmployeeSalaryListModel staff) {
    selectedSalaryType = staff.salaryType;
    monthlyTargetController.text = staff.monthlyTarget?.toString() ?? "0";
    commissionPercentController.text = staff.commissionPercent?.toString() ?? "0";
    recoveryPercentController.text = staff.recoveryPercent?.toString() ?? "0";
    selectedCommissionLevelId = staff.commissionLevelId;
    basicSalaryController.text = staff.basicSalary?.toString() ?? "0";
    merchantTargetController.text = staff.merchantTarget?.toString() ?? "0";

    if (staff.allowances != null) {
      hraController.text = staff.allowances!.hra?.toString() ?? "0";
      daController.text = staff.allowances!.da?.toString() ?? "0";
      conveyanceController.text = staff.allowances!.conveyance?.toString() ?? "0";
      medicalController.text = staff.allowances!.medical?.toString() ?? "0";
      specialController.text = staff.allowances!.special?.toString() ?? "0";
      travelController.text = staff.allowances!.travel?.toString() ?? "0";
      internetController.text = staff.allowances!.internet?.toString() ?? "0";
      foodController.text = staff.allowances!.food?.toString() ?? "0";
      performanceIncentiveController.text = staff.allowances!.performanceIncentive?.toString() ?? "0";
      salesIncentiveController.text = staff.allowances!.salesIncentive?.toString() ?? "0";
      bonusController.text = staff.allowances!.bonus?.toString() ?? "0";
      overtimeController.text = staff.allowances!.overtime?.toString() ?? "0";
      shiftController.text = staff.allowances!.shift?.toString() ?? "0";
      otherAllowanceController.text = staff.allowances!.other?.toString() ?? "0";
    } else {
      hraController.text = "0";
      daController.text = "0";
      conveyanceController.text = "0";
      medicalController.text = "0";
      specialController.text = "0";
      travelController.text = "0";
      internetController.text = "0";
      foodController.text = "0";
      performanceIncentiveController.text = staff.performanceIncentive?.toString() ?? "0";
      salesIncentiveController.text = staff.salesIncentive?.toString() ?? "0";
      bonusController.text = "0";
      overtimeController.text = "0";
      shiftController.text = "0";
      otherAllowanceController.text = "0";
    }

    if (staff.deductions != null) {
      pfController.text = staff.deductions!.pf?.toString() ?? "0";
      esiController.text = staff.deductions!.esi?.toString() ?? "0";
      ptController.text = staff.deductions!.pt?.toString() ?? "0";
      tdsController.text = staff.deductions!.tds?.toString() ?? "0";
      lwfController.text = staff.deductions!.lwf?.toString() ?? "0";
      noticePeriodController.text = staff.deductions!.noticePeriod?.toString() ?? "0";
      otherDeductionController.text = staff.deductions!.other?.toString() ?? "0";
    } else {
      pfController.text = "0";
      esiController.text = "0";
      ptController.text = "0";
      tdsController.text = "0";
      lwfController.text = "0";
      noticePeriodController.text = "0";
      otherDeductionController.text = "0";
    }
    
    update();
  }

  void setUpdateData(SalaryStructureModel structure) {
    selectedSalaryType = structure.salaryType;
    monthlyTargetController.text = structure.monthlyTarget?.toString() ?? "0";
    commissionPercentController.text = structure.commissionPercent?.toString() ?? "0";
    recoveryPercentController.text = structure.recoveryPercent?.toString() ?? "0";
    selectedCommissionLevelId = structure.commissionLevelId;
    basicSalaryController.text = structure.basicSalary?.toString() ?? "0";
    merchantTargetController.text = structure.merchantTarget?.toString() ?? "0";

    if (structure.allowances != null) {
      hraController.text = structure.allowances!.hra?.toString() ?? "0";
      daController.text = structure.allowances!.da?.toString() ?? "0";
      conveyanceController.text = structure.allowances!.conveyance?.toString() ?? "0";
      medicalController.text = structure.allowances!.medical?.toString() ?? "0";
      specialController.text = structure.allowances!.special?.toString() ?? "0";
      travelController.text = structure.allowances!.travel?.toString() ?? "0";
      internetController.text = structure.allowances!.internet?.toString() ?? "0";
      foodController.text = structure.allowances!.food?.toString() ?? "0";
      performanceIncentiveController.text = structure.allowances!.performanceIncentive?.toString() ?? "0";
      salesIncentiveController.text = structure.allowances!.salesIncentive?.toString() ?? "0";
      bonusController.text = structure.allowances!.bonus?.toString() ?? "0";
      overtimeController.text = structure.allowances!.overtime?.toString() ?? "0";
      shiftController.text = structure.allowances!.shift?.toString() ?? "0";
      otherAllowanceController.text = structure.allowances!.other?.toString() ?? "0";
    }

    if (structure.deductions != null) {
      pfController.text = structure.deductions!.pf?.toString() ?? "0";
      esiController.text = structure.deductions!.esi?.toString() ?? "0";
      ptController.text = structure.deductions!.pt?.toString() ?? "0";
      tdsController.text = structure.deductions!.tds?.toString() ?? "0";
      lwfController.text = structure.deductions!.lwf?.toString() ?? "0";
      noticePeriodController.text = structure.deductions!.noticePeriod?.toString() ?? "0";
      otherDeductionController.text = structure.deductions!.other?.toString() ?? "0";
    }
    update();
  }

  @override
  void onClose() {
    monthlyTargetController.dispose();
    commissionPercentController.dispose();
    recoveryPercentController.dispose();
    basicSalaryController.dispose();
    merchantTargetController.dispose();
    hraController.dispose();
    daController.dispose();
    conveyanceController.dispose();
    medicalController.dispose();
    specialController.dispose();
    travelController.dispose();
    internetController.dispose();
    foodController.dispose();
    performanceIncentiveController.dispose();
    salesIncentiveController.dispose();
    bonusController.dispose();
    overtimeController.dispose();
    shiftController.dispose();
    otherAllowanceController.dispose();
    pfController.dispose();
    esiController.dispose();
    ptController.dispose();
    tdsController.dispose();
    lwfController.dispose();
    noticePeriodController.dispose();
    otherDeductionController.dispose();
    super.onClose();
  }
}
