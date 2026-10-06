import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vlr/data/models/response/response_model.dart';
import 'package:vlr/data/models/staff_model.dart';
import 'package:vlr/data/models/performance_staff_model.dart';
import 'package:vlr/data/models/performance_detail_model.dart';
import 'package:vlr/data/repositories/staff_repo.dart';
import 'package:vlr/services/constants.dart';

class StaffController extends GetxController implements GetxService {
  final StaffRepo staffRepo;

  StaffController({required this.staffRepo});

  bool isLoading = false;
  List<StaffModel> staffList = [];
  List<StaffModel> employeeListing = [];
  List<PerformanceStaffModel> performanceStaffList = [];
  PerformanceDetailModel? performanceDetail;
  StaffModel? staffProfile;

  // Tabs
  List<String> statusTabs = ['all', 'active', 'inactive', 'on_leave', 'resigned', 'terminated'];
  int selectedTabIndex = 0;

  // Controllers for Add/Edit
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController employeeCodeController = TextEditingController();
  final TextEditingController basicSalaryController = TextEditingController();
  final TextEditingController joiningDateController = TextEditingController();
  final TextEditingController roleIdController = TextEditingController();
  final TextEditingController departmentIdController = TextEditingController();
  final TextEditingController branchIdController = TextEditingController();
  final TextEditingController shiftIdController = TextEditingController();
  final TextEditingController reportingToController = TextEditingController();

  String? selectedRoleId;
  String? selectedDepartmentId;
  String? selectedReportingToId;
  String? selectedBranchId;
  String? selectedShiftId;
  String? selectedEmploymentStatus;
  String? selectedStatus;

  void updateTabIndex(int index) {
    selectedTabIndex = index;
    getStaffList(status: statusTabs[index]);
  }

  Future<ResponseModel> getStaffList({String? status, String? search}) async {
    isLoading = true;
    update();

    try {
      Map<String, dynamic> query = {};
      if (status != null && status != 'all') query['status'] = status;
      if (search != null) query['search'] = search;

      Response response = await staffRepo.getStaffList(query);

      if (response.body != null && response.body['status'] == "success") {
        final List data = response.body['data'];
        staffList = data.map((e) => StaffModel.fromJson(e)).toList();
        isLoading = false;
        update();
        return ResponseModel(true, response.body['message'] ?? "Staff fetched successfully");
      } else {
        isLoading = false;
        update();
        return ResponseModel(false, response.body?['message'] ?? "Failed to fetch staff");
      }
    } catch (e) {
      log("ERROR AT getStaffList: $e");
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  Future<ResponseModel> getPerformanceStaffList() async {
    isLoading = true;
    update();

    try {
      Response response = await staffRepo.getPerformanceStaffList();

      if (response.body != null && response.body['status'] == "success") {
        final List data = response.body['data'];
        performanceStaffList = data.map((e) => PerformanceStaffModel.fromJson(e)).toList();
        isLoading = false;
        update();
        return ResponseModel(true, response.body['message'] ?? "Performance staff fetched successfully");
      } else {
        isLoading = false;
        update();
        return ResponseModel(false, response.body?['message'] ?? "Failed to fetch performance staff");
      }
    } catch (e) {
      log("ERROR AT getPerformanceStaffList: $e");
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  Future<ResponseModel> getPerformanceStaffDetail(String id) async {
    isLoading = true;
    performanceDetail = null;
    update();

    try {
      Response response = await staffRepo.getPerformanceStaffDetail(id);

      if (response.body != null && response.body['status'] == "success") {
        performanceDetail = PerformanceDetailModel.fromJson(response.body['data']);
        isLoading = false;
        update();
        return ResponseModel(true, response.body['message'] ?? "Performance detail fetched successfully");
      } else {
        isLoading = false;
        update();
        return ResponseModel(false, response.body?['message'] ?? "Failed to fetch performance detail");
      }
    } catch (e) {
      log("ERROR AT getPerformanceStaffDetail: $e");
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  Future<ResponseModel> getEmployeesListing({String? search}) async {
    isLoading = true;
    update();

    try {
      Map<String, dynamic> query = {};
      if (search != null) query['search'] = search;

      Response response = await staffRepo.getEmployeesListing(query);

      if (response.body != null && response.body['status'] == "success") {
        final List data = response.body['data'];
        employeeListing = data.map((e) => StaffModel.fromJson(e)).toList();
        isLoading = false;
        update();
        return ResponseModel(true, response.body['message'] ?? "Employees fetched successfully");
      } else {
        isLoading = false;
        update();
        return ResponseModel(false, response.body?['message'] ?? "Failed to fetch employees");
      }
    } catch (e) {
      log("ERROR AT getEmployeesListing: $e");
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  Future<ResponseModel> getStaffProfile(String id) async {
    isLoading = true;
    update();

    try {
      Response response = await staffRepo.getStaffProfile(id);

      if (response.body != null && response.body['status'] == "success") {
        staffProfile = StaffModel.fromJson(response.body['data']);
        isLoading = false;
        update();
        return ResponseModel(true, response.body['message'] ?? "Profile fetched successfully");
      } else {
        isLoading = false;
        update();
        return ResponseModel(false, response.body?['message'] ?? "Failed to fetch profile");
      }
    } catch (e) {
      log("ERROR AT getStaffProfile: $e");
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  Future<ResponseModel> createStaff() async {
    isLoading = true;
    update();

    try {
      Map<String, dynamic> body = {
        "name": nameController.text,
        "email": emailController.text,
        "mobile": mobileController.text,
        "password": passwordController.text,
        "role_id": selectedRoleId,
        "employee_code": employeeCodeController.text,
        "basic_salary": basicSalaryController.text,
        "department_id": selectedDepartmentId,
        "reporting_to": selectedReportingToId,
        "branch_id": selectedBranchId,
        "shift_id": selectedShiftId,
        "joining_date": joiningDateController.text,
      };

      Response response = await staffRepo.createStaff(body);

      if (response.body != null && response.body['status'] == "success") {
        isLoading = false;
        getStaffList(status: statusTabs[selectedTabIndex]);
        update();
        return ResponseModel(true, response.body['message'] ?? "Staff created successfully");
      } else {
        isLoading = false;
        update();
        return ResponseModel(false, response.body?['message'] ?? "Failed to create staff");
      }
    } catch (e) {
      log("ERROR AT createStaff: $e");
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  Future<ResponseModel> updateStaff(String id) async {
    isLoading = true;
    update();

    try {
      Map<String, dynamic> body = {
        "name": nameController.text,
        "email": emailController.text,
        "mobile": mobileController.text,
        "employee_code": employeeCodeController.text,
        "role_id": selectedRoleId,
        "basic_salary": basicSalaryController.text,
        "department_id": selectedDepartmentId,
        "reporting_to": selectedReportingToId,
        "branch_id": selectedBranchId,
        "shift_id": selectedShiftId,
        "joining_date": joiningDateController.text,
        "employment_status": selectedEmploymentStatus,
        "status": selectedStatus,
      };

      Response response = await staffRepo.updateStaff(id, body);

      if (response.body != null && response.body['status'] == "success") {
        isLoading = false;
        getStaffList(status: statusTabs[selectedTabIndex]);
        update();
        return ResponseModel(true, response.body['message'] ?? "Staff updated successfully");
      } else {
        isLoading = false;
        update();
        return ResponseModel(false, response.body?['message'] ?? "Failed to update staff");
      }
    } catch (e) {
      log("ERROR AT updateStaff: $e");
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  Future<ResponseModel> deleteStaff(String id) async {
    isLoading = true;
    update();

    try {
      Response response = await staffRepo.deleteStaff(id);

      if (response.body != null && response.body['status'] == "success") {
        isLoading = false;
        staffList.removeWhere((element) => element.id == id);
        update();
        return ResponseModel(true, response.body['message'] ?? "Staff deleted successfully");
      } else {
        isLoading = false;
        update();
        return ResponseModel(false, response.body?['message'] ?? "Failed to delete staff");
      }
    } catch (e) {
      log("ERROR AT deleteStaff: $e");
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  void clearControllers() {
    nameController.clear();
    emailController.clear();
    mobileController.clear();
    passwordController.clear();
    employeeCodeController.clear();
    basicSalaryController.clear();
    joiningDateController.clear();
    roleIdController.clear();
    departmentIdController.clear();
    branchIdController.clear();
    shiftIdController.clear();
    reportingToController.clear();
    selectedRoleId = null;
    selectedDepartmentId = null;
    selectedBranchId = null;
    selectedShiftId = null;
    selectedReportingToId = null;
    selectedEmploymentStatus = null;
    selectedStatus = null;
  }

  void setEditData(StaffModel staff) {
    nameController.text = staff.name ?? "";
    emailController.text = staff.email ?? "";
    mobileController.text = staff.mobile ?? "";
    employeeCodeController.text = staff.employeeCode ?? "";
    basicSalaryController.text = staff.basicSalary ?? "";
    joiningDateController.text = staff.joiningDate ?? "";
    selectedRoleId = staff.roles?.isNotEmpty == true ? staff.roles![0].id?.toString() : null;
    selectedDepartmentId = staff.departmentId?.toString();
    selectedBranchId = staff.branchId?.toString();
    selectedShiftId = staff.shiftId?.toString();
    selectedReportingToId = staff.reportingTo;
    selectedEmploymentStatus = staff.employmentStatus;
    selectedStatus = staff.status;
    update();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    passwordController.dispose();
    employeeCodeController.dispose();
    basicSalaryController.dispose();
    joiningDateController.dispose();
    roleIdController.dispose();
    departmentIdController.dispose();
    branchIdController.dispose();
    shiftIdController.dispose();
    reportingToController.dispose();
    super.onClose();
  }
}
