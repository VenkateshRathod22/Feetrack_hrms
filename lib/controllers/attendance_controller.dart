import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vlr/data/models/attendance/attendance_calendar_model.dart';
import 'package:vlr/data/models/attendance/attendance_model.dart';
import 'package:vlr/data/models/attendance/employees_attendance_summary_model.dart';
import 'package:vlr/data/models/check_point_model.dart';
import 'package:vlr/data/models/employee_model.dart';
import 'package:vlr/data/models/pagination/pagination_state.dart';
import 'package:vlr/data/models/response/attendance_override_model.dart';
import 'package:vlr/data/models/response/response_model.dart';
import 'package:vlr/data/repositories/attendence_repo.dart';

class AttendanceController extends GetxController implements GetxService {
  final AttendanceRepo attendanceRepo;

  AttendanceController({required this.attendanceRepo});

  bool isLoading = false;

  Future<ResponseModel> punchInAttendance({
    required String lat,
    required String lng,
    required File? selfie,
  }) async {
    log('----------- punchInAttendance Called ----------');

    ResponseModel responseModel;
    isLoading = true;
    update();

    try {
      Map<String, dynamic> data = {
        "lat": lat,
        "lng": lng,
        "selfie": selfie == null
            ? null
            : MultipartFile(
                selfie,
                filename: selfie.path.split('/').last,
              ),
      };

      Response response =
          await attendanceRepo.punchInAttendance(data: FormData(data));

      if (response.body['status'] == "success") {
        attendanceModel = AttendanceModel.fromJson(response.body['data']);

        responseModel = ResponseModel(
          true,
          response.body['message'] ?? "punchInAttendance successful",
        );
      } else {
        String errorMessage =
            response.body['message'] ?? "Error while punchInAttendance user";

        if (response.body['errors'] != null) {
          final errors = response.body['errors'] as Map<String, dynamic>;
          if (errors.isNotEmpty) {
            errorMessage = (errors.values.first as List).first.toString();
          }
        }

        responseModel = ResponseModel(false, errorMessage);
      }
    } catch (e) {
      log('ERROR AT punchInAttendance(): $e');
      responseModel =
          ResponseModel(false, "Error while punchInAttendance user $e");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> punchOutAttendance({
    required String lat,
    required String lng,
    required File? selfie,
  }) async {
    log('----------- punchOutAttendance Called ----------');

    ResponseModel responseModel;
    isLoading = true;
    update();

    try {
      Map<String, dynamic> data = {
        "lat": lat,
        "lng": lng,
        "selfie": selfie == null
            ? null
            : MultipartFile(
                selfie,
                filename: selfie.path.split('/').last,
              ),
      };

      Response response =
          await attendanceRepo.punchOutAttendance(data: FormData(data));

      if (response.body['status'] == "success") {
        attendanceModel = AttendanceModel.fromJson(response.body['data']);

        responseModel = ResponseModel(
          true,
          response.body['message'] ?? "punchOutAttendance successful",
        );
      } else {
        String errorMessage =
            response.body['message'] ?? "Error while punchOutAttendance user";

        if (response.body['errors'] != null) {
          final errors = response.body['errors'] as Map<String, dynamic>;
          if (errors.isNotEmpty) {
            errorMessage = (errors.values.first as List).first.toString();
          }
        }

        responseModel = ResponseModel(false, errorMessage);
      }
    } catch (e) {
      log('ERROR AT punchOutAttendance(): $e');
      responseModel =
          ResponseModel(false, "Error while punchOutAttendance user $e");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  AttendanceModel? attendanceModel;
  Future<ResponseModel> fetchTodayAttendance() async {
    log('----------- fetchTodayAttendance Called ----------');

    ResponseModel responseModel;
    isLoading = true;
    update();

    try {
      Response response = await attendanceRepo.fetchTodayAttendance();

      if (response.body['status'] == "success") {
        responseModel = ResponseModel(
          true,
          response.body['message'] ?? "fetchTodayAttendance successful",
        );

        attendanceModel = AttendanceModel.fromJson(response.body['data']);
        log("message : attendanceModel ${attendanceModel?.checkIn}");

        // employeesStatus = attendanceModel.status ;
      } else {
        String errorMessage =
            response.body['message'] ?? "Error while fetchTodayAttendance user";

        if (response.body['errors'] != null) {
          final errors = response.body['errors'] as Map<String, dynamic>;
          if (errors.isNotEmpty) {
            errorMessage = (errors.values.first as List).first.toString();
          }
        }

        responseModel = ResponseModel(false, errorMessage);
      }
    } catch (e) {
      log('ERROR AT fetchTodayAttendance(): $e');
      responseModel =
          ResponseModel(false, "Error while fetchTodayAttendance user $e");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  List<AttendanceModel> attendanceList = [];
  EmployeesAttendanceSummaryModel? employeesAttendanceSummaryModel;
  EmployeesModel? employeesModel;

  DateTime selectedMonth = DateTime.now();
  DateTime? selectedDate;

  Future<ResponseModel> fetchAttendanceHistory({String? date}) async {
    log('----------- fetchAttendanceHistory Called ----------');

    ResponseModel responseModel;
    isLoading = true;
    update();

    try {
      Map<String, dynamic> query = {};
      if (date != null) {
        query["date"] = date;
      } else {
        query["month"] = selectedMonth.month.toString();
        query["year"] = selectedMonth.year.toString();
      }

      Response response =
          await attendanceRepo.fetchAttendanceHistory(data: query);

      if (response.body['status'] == "success") {
        responseModel = ResponseModel(
          true,
          response.body['message'] ?? "fetchAttendanceHistory successful",
        );

        final List data = response.body['data'] ?? [];
        final summaryData = response.body['summary'];
        final employeeData = response.body['employee'];

        if (employeeData != null) {
          employeesModel = EmployeesModel.fromJson(employeeData);
        }
        if (summaryData != null) {
          employeesAttendanceSummaryModel =
              EmployeesAttendanceSummaryModel.fromJson(summaryData);
        }
        
        attendanceList = data.map((e) => AttendanceModel.fromJson(e)).toList();

        if (employeesAttendanceSummaryModel != null) {
          attendancePerCal(employeesAttendanceSummaryModel?.punchOut ?? 0);
        }
      } else {
        String errorMessage = response.body['message'] ??
            "Error while fetchAttendanceHistory user";

        if (response.body['errors'] != null) {
          final errors = response.body['errors'] as Map<String, dynamic>;
          if (errors.isNotEmpty) {
            errorMessage = (errors.values.first as List).first.toString();
          }
        }

        responseModel = ResponseModel(false, errorMessage);
      }
    } catch (e) {
      log('ERROR AT fetchAttendanceHistory(): $e');
      responseModel =
          ResponseModel(false, "Error while fetchAttendanceHistory user $e");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  double attendancePer = 0.0;

  void attendancePerCal(int presentDays) {
    final now = DateTime.now();

    final int totalDays = DateTime(now.year, now.month + 1, 0).day;

    attendancePer = (presentDays / totalDays) * 100;
    attendancePer = attendancePer / 100;
    log("attendancePer : $attendancePer");
    update();
  }

  List<EmployeesModel> employeesModelTodayAttendanceList = [];
  Future<ResponseModel> fetchTodayTeamAttendance({
    String status = "all status",
    bool isShowAllStatusData = true,
  }) async {
    log('----------- fetchTodayTeamAttendance Called ----------');

    ResponseModel responseModel;
    isLoading = true;
    update();

    try {
      employeesAttendanceSummaryModel = null;
      employeesModelTodayAttendanceList.clear();

      Map<String, dynamic>? data = {
        "search": searchBarController.text,
        "status": isShowAllStatusData ? "all status" : status,
      };

      Response response =
          await attendanceRepo.fetchTodayTeamAttendance(data: data);

      if (response.body['status'] == "success") {
        responseModel = ResponseModel(
          true,
          response.body['message'] ?? "fetchTodayTeamAttendance successful",
        );

        final List<dynamic> data = response.body['data'] ?? [];
        final summar = response.body['summary'] ?? [];

        employeesAttendanceSummaryModel =
            EmployeesAttendanceSummaryModel.fromJson(summar);

        employeesModelTodayAttendanceList = data
            .map((e) => EmployeesModel.fromJson(e as Map<String, dynamic>))
            .toList();

        log(
          "employeesModelTodayAttendanceList : ${employeesModelTodayAttendanceList.length}",
        );
      } else {
        String errorMessage = response.body['message'] ??
            "Error while fetchTodayTeamAttendance user";

        if (response.body['errors'] != null) {
          final errors = response.body['errors'] as Map<String, dynamic>;
          if (errors.isNotEmpty) {
            errorMessage = (errors.values.first as List).first.toString();
          }
        }

        responseModel = ResponseModel(false, errorMessage);
      }
    } catch (e) {
      log('ERROR AT fetchTodayTeamAttendance(): $e');
      responseModel =
          ResponseModel(false, "Error while fetchTodayTeamAttendance user $e");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  final PaginationState<EmployeesModel> employeesModelState =
      PaginationState<EmployeesModel>();

  List<EmployeesModel> get employeesModelList => employeesModelState.items;

  Future<ResponseModel> fetchTeamEmployeesListPagination({
    bool loadMore = false,
    bool refresh = false,
  }) async {
    log('fetchTeamEmployeesList called '
        '(loadMore: $loadMore, refresh: $refresh)');

    Map<String, dynamic>? data = {
      "search": searchBarController.text,
    };
    ResponseModel responseModel = ResponseModel(false, "Unknown error");

    if (refresh) {
      employeesModelState.page = 1;
      employeesModelState.lastPage = 1;
      employeesModelState.items.clear();
      employeesModelState.dedupeIds.clear();
    }

    if (loadMore) {
      if (!employeesModelState.canLoadMore) {
        return ResponseModel(false, "No more pages");
      }
      employeesModelState.isMoreLoading = true;
      employeesModelState.page += 1;
    } else {
      employeesModelState.isInitialLoading = true;
      employeesModelState.page = 1;
      employeesModelState.items.clear();
      employeesModelState.dedupeIds.clear();
    }

    update();

    try {
      final Response response =
          await attendanceRepo.fetchTeamEmployeesList(data: data);

      if (response.statusCode != 200) {
        responseModel =
            ResponseModel(false, "Status code: ${response.statusCode}");
      } else if (response.body is Map<String, dynamic> &&
          response.body['status'] == "success") {
        final paginated = response.body['data'];

        if (paginated is Map<String, dynamic> && paginated['data'] is List) {
          final List itemsJson = paginated['data'] as List;

          final List<EmployeesModel> parsedData = itemsJson
              .map((e) => EmployeesModel.fromJson(e as Map<String, dynamic>))
              .toList();

          final int currentPage =
              int.tryParse(paginated['current_page'].toString()) ??
                  employeesModelState.page;
          final int lastPage =
              int.tryParse(paginated['last_page'].toString()) ?? currentPage;

          employeesModelState.lastPage = lastPage;
          employeesModelState.page = currentPage;

          if (loadMore) {
            for (final item in parsedData) {
              if (!employeesModelState.dedupeIds.contains(item.id)) {
                employeesModelState.dedupeIds.add(item.id);
                employeesModelState.items.add(item);
              }
            }
          } else {
            employeesModelState.items
              ..clear()
              ..addAll(parsedData);

            employeesModelState.dedupeIds
              ..clear()
              ..addAll(parsedData.map((e) => e.id));
          }

          log("Listing count: ${employeesModelState.items.length}");
          responseModel = ResponseModel(
            true,
            response.body['message'] ??
                "success fetchTeamEmployeesListPagination",
          );
        } else {
          responseModel =
              ResponseModel(false, "Invalid listing response format");
        }
      } else {
        responseModel = ResponseModel(
          false,
          response.body is Map<String, dynamic>
              ? (response.body['message'] ??
                  "Error while fetchTeamEmployeesListPagination")
              : "Invalid server response",
        );
      }
    } catch (e) {
      log('ERROR AT fetchTeamEmployeesListPagination(): $e');
      responseModel = ResponseModel(
          false, "Error while fetchTeamEmployeesListPagination $e");
    }

    employeesModelState.isInitialLoading = false;
    employeesModelState.isMoreLoading = false;
    update();
    return responseModel;
  }

  List<CheckPointModel> checkPointModelList = [];
  Future<ResponseModel> fetchCheckListPoint() async {
    log('----------- fetchCheckListPoint Called ----------');

    ResponseModel responseModel;
    isLoading = true;
    update();

    try {
      Map<String, dynamic>? data = {
        "mode": attendanceModel?.isNotPunchIn == true
            ? "punch_in"
            : attendanceModel?.isPunchIn == true
                ? "punch_out"
                : ""
      };
      Response response = await attendanceRepo.fetchCheckListPoint(data: data);

      if (response.body['status'] == "success") {
        responseModel = ResponseModel(
          true,
          response.body['message'] ?? "fetchCheckListPoint successful",
        );
        final List data = response.body['data'];

        checkPointModelList =
            data.map((e) => CheckPointModel.fromJson(e)).toList();

        log("checkPointModelList : ${checkPointModelList.length}");
      } else {
        String errorMessage =
            response.body['message'] ?? "Error while fetchCheckListPoint user";

        if (response.body['errors'] != null) {
          final errors = response.body['errors'] as Map<String, dynamic>;
          if (errors.isNotEmpty) {
            errorMessage = (errors.values.first as List).first.toString();
          }
        }

        responseModel = ResponseModel(false, errorMessage);
      }
    } catch (e) {
      log('ERROR AT fetchCheckListPoint(): $e');
      responseModel =
          ResponseModel(false, "Error while fetchCheckListPoint user $e");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  void updateCheckListPoint({
    required int id,
    required bool? value,
  }) {
    final index = checkPointModelList.indexWhere((e) => e.id == id);

    if (index != -1) {
      checkPointModelList[index].isChecked = value ?? false;

      for (final element in checkPointModelList) {
        log(element.toSubmitJson().toString());
      }

      update();
    }
  }

  Future<ResponseModel> submitCheckListPointForPunchIn() async {
    log('----------- submitCheckListPointForPunchIn Called ----------');

    ResponseModel responseModel;
    isLoading = true;
    update();

    try {
      Map<String, dynamic> data = {
        "mode": "punch_in",
        "checklistAnswers":
            checkPointModelList.map((e) => e.toSubmitJson()).toList(),
      };

      Response response = await attendanceRepo.submitCheckListPoint(
        data: data,
      );

      if (response.body['status'] == "success") {
        responseModel = ResponseModel(
          true,
          response.body['message'] ??
              "submitCheckListPointForPunchIn successful",
        );
        attendanceModel = AttendanceModel.fromJson(response.body['data']);
      } else {
        String errorMessage = response.body['message'] ??
            "Error while submitCheckListPointForPunchIn user";

        if (response.body['errors'] != null) {
          final errors = response.body['errors'] as Map<String, dynamic>;
          if (errors.isNotEmpty) {
            errorMessage = (errors.values.first as List).first.toString();
          }
        }

        responseModel = ResponseModel(false, errorMessage);
      }
    } catch (e) {
      log('ERROR AT submitCheckListPointForPunchIn(): $e');
      responseModel = ResponseModel(
          false, "Error while submitCheckListPointForPunchIn user $e");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> submitCheckListPointForPunchOut() async {
    log('----------- submitCheckListPointForPunchOut Called ----------');

    ResponseModel responseModel;
    isLoading = true;
    update();

    try {
      Map<String, dynamic> data = {
        "mode": "punch_out",
        "checklistAnswers":
            checkPointModelList.map((e) => e.toSubmitJson()).toList(),
      };

      Response response = await attendanceRepo.submitCheckListPoint(
        data: data,
      );

      if (response.body['status'] == "success") {
        responseModel = ResponseModel(
          true,
          response.body['message'] ??
              "submitCheckListPointForPunchOut successful",
        );
        attendanceModel = AttendanceModel.fromJson(response.body['data']);
      } else {
        String errorMessage = response.body['message'] ??
            "Error while submitCheckListPointForPunchOut user";

        if (response.body['errors'] != null) {
          final errors = response.body['errors'] as Map<String, dynamic>;
          if (errors.isNotEmpty) {
            errorMessage = (errors.values.first as List).first.toString();
          }
        }

        responseModel = ResponseModel(false, errorMessage);
      }
    } catch (e) {
      log('ERROR AT submitCheckListPointForPunchOut(): $e');
      responseModel = ResponseModel(
          false, "Error while submitCheckListPointForPunchOut user $e");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  List<AttendanceOverrideModel> overrideList = [];
  int overrideCurrentPage = 1;
  int overrideLastPage = 1;

  Future<void> fetchAttendanceOverrides({bool isRefresh = true}) async {
    if (isRefresh) {
      overrideCurrentPage = 1;
      overrideList = [];
    } else {
      if (overrideCurrentPage >= overrideLastPage) return;
      overrideCurrentPage++;
    }

    isLoading = true;
    update();

    try {
      Response response = await attendanceRepo.fetchAttendanceOverrides(
        data: {"page": overrideCurrentPage},
      );

      if (response.body != null && response.body['status'] == "success") {
        final List data = response.body['data'];
        final pagination = response.body['pagination'];
        
        for (var item in data) {
          overrideList.add(AttendanceOverrideModel.fromJson(item));
        }

        if (pagination != null) {
          overrideCurrentPage = int.tryParse(pagination['current_page'].toString()) ?? overrideCurrentPage;
          overrideLastPage = int.tryParse(pagination['last_page'].toString()) ?? overrideCurrentPage;
        }
      }
    } catch (e) {
      log("fetchAttendanceOverrides Error: $e");
    }

    isLoading = false;
    update();
  }

  Future<ResponseModel> addAttendanceOverride(Map<String, dynamic> body) async {
    isLoading = true;
    update();

    try {
      Response response = await attendanceRepo.addAttendanceOverride(body);
      isLoading = false;
      update();

      if (response.statusCode == 200 || response.statusCode == 201) {
        fetchAttendanceOverrides();
        return ResponseModel(true, response.body['message'] ?? "Override added successfully");
      } else {
        return ResponseModel(false, response.body?['message'] ?? response.statusText ?? "Failed to add override");
      }
    } catch (e) {
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  TextEditingController searchBarController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchBarController.dispose();
  }

  EmployeesModel? selectEmployeeModel;

  void updateSelectEmployeeModel({
    required EmployeesModel employeesModel,
  }) {
    selectEmployeeModel = employeesModel;
    update();
  }

  Future<ResponseModel> fetchTeamEmployeeAttendanceList() async {
    log('----------- fetchTeamEmployeeAttendanceList Called ----------');

    isLoading = true;
    update();

    try {
      attendanceList.clear();
      employeesAttendanceSummaryModel = null;
      employeesModel = null;

      final Map<String, dynamic> data = {
        "employee_id": selectEmployeeModel?.id.toString() ?? "",
        "month": selectedMonth.month.toString(),
        "year": selectedMonth.year.toString(),
      };

      final Response response =
          await attendanceRepo.fetchTeamEmployeeAttendanceList(data: data);

      if (response.body != null && response.body['status'] == "success") {
        final List<dynamic> list = response.body['data'] ?? [];
        final employee = response.body['employee'] ?? [];
        final summary = response.body['summary'] ?? [];

        employeesAttendanceSummaryModel =
            EmployeesAttendanceSummaryModel.fromJson(summary);

        employeesModel = EmployeesModel.fromJson(employee);

        attendanceList = list
            .map((e) => AttendanceModel.fromJson(e as Map<String, dynamic>))
            .toList();

        isLoading = false;
        update();

        return ResponseModel(
          true,
          response.body['message'] ?? "Attendance fetched successfully",
        );
      }

      String errorMessage = response.body?['message'] ?? "Something went wrong";

      if (response.body?['errors'] != null) {
        final errors = response.body['errors'] as Map<String, dynamic>;
        if (errors.isNotEmpty) {
          errorMessage = (errors.values.first as List).first.toString();
        }
      }

      isLoading = false;
      update();

      return ResponseModel(false, errorMessage);
    } catch (e, stackTrace) {
      log("fetchTeamEmployeeAttendanceList Error: $e");
      log(stackTrace.toString());

      isLoading = false;
      update();

      return ResponseModel(
        false,
        "Failed to fetch attendance.",
      );
    }
  }

  int? attendanceId;

  void updateAttendanceId({required int attendanceId}) {
    this.attendanceId = attendanceId;
    update();
  }

  Future<ResponseModel> fetchAttendanceDetails() async {
    log('----------- fetchAttendanceDetails Called ----------');

    ResponseModel responseModel;
    isLoading = true;
    update();

    try {
      Response response = await attendanceRepo.fetchAttendanceDetails(
        attendanceId: attendanceId ?? 0,
      );

      if (response.body['status'] == "success") {
        responseModel = ResponseModel(
          true,
          response.body['message'] ?? "fetchAttendanceDetails successful",
        );
        attendanceModel = AttendanceModel.fromJson(response.body['data']);
      } else {
        String errorMessage = response.body['message'] ??
            "Error while fetchAttendanceDetails user";

        if (response.body['errors'] != null) {
          final errors = response.body['errors'] as Map<String, dynamic>;
          if (errors.isNotEmpty) {
            errorMessage = (errors.values.first as List).first.toString();
          }
        }

        responseModel = ResponseModel(false, errorMessage);
      }
    } catch (e) {
      log('ERROR AT fetchAttendanceDetails(): $e');
      responseModel =
          ResponseModel(false, "Error while fetchAttendanceDetails user $e");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  void loadDemoAttendance() {
    attendanceModel = AttendanceModel.demoPunchIn();
    update();
  }

  void loadDemoAttendancePunchOut() {
    attendanceModel = AttendanceModel.demoPunchOut();
    update();
  }

  AttendanceCalendarModel? attendanceCalendar;
  CalendarEmployee? selectedCalendarEmployee;

  Future<ResponseModel> fetchAttendanceCalendar({
    String? employeeId,
    int? month,
    int? year,
  }) async {
    log('----------- fetchAttendanceCalendar Called ----------');

    ResponseModel responseModel;
    isLoading = true;
    update();

    try {
      Map<String, dynamic> data = {};
      if (employeeId != null) data['employee_id'] = employeeId;
      if (month != null) data['month'] = month;
      if (year != null) data['year'] = year;

      Response response = await attendanceRepo.fetchAttendanceCalendar(data: data);

      if (response.body != null && response.body['status'] == "success") {
        attendanceCalendar = AttendanceCalendarModel.fromJson(response.body['data']);
        
        if (attendanceCalendar?.employees != null && attendanceCalendar!.employees!.isNotEmpty) {
           if (employeeId == null) {
              selectedCalendarEmployee = attendanceCalendar!.employees!.firstWhere(
                (e) => e.id == attendanceCalendar!.selectedEmployeeId,
                orElse: () => attendanceCalendar!.employees!.first,
              );
           }
        }

        responseModel = ResponseModel(
          true,
          response.body['message'] ?? "fetchAttendanceCalendar successful",
        );
      } else {
        String errorMessage = response.body?['message'] ?? "Error while fetchAttendanceCalendar";
        responseModel = ResponseModel(false, errorMessage);
      }
    } catch (e) {
      log('ERROR AT fetchAttendanceCalendar(): $e');
      responseModel = ResponseModel(false, "Error while fetchAttendanceCalendar: $e");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  void updateSelectedCalendarEmployee(CalendarEmployee employee) {
    selectedCalendarEmployee = employee;
    fetchAttendanceCalendar(
      employeeId: employee.id,
      month: attendanceCalendar?.month,
      year: attendanceCalendar?.year,
    );
  }

  void changeCalendarMonth(bool next) {
    if (attendanceCalendar == null) return;
    
    int month = attendanceCalendar!.month!;
    int year = attendanceCalendar!.year!;
    
    if (next) {
      if (month == 12) {
        month = 1;
        year++;
      } else {
        month++;
      }
    } else {
      if (month == 1) {
        month = 12;
        year--;
      } else {
        month--;
      }
    }
    
    fetchAttendanceCalendar(
      employeeId: selectedCalendarEmployee?.id,
      month: month,
      year: year,
    );
  }
}
