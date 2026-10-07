import 'package:get/get.dart';
import 'package:vlr/data/api/api_client.dart';
import 'package:vlr/services/constants.dart';

class AttendanceRepo {
  final ApiClient apiClient;

  AttendanceRepo({required this.apiClient});

  Future<Response> punchInAttendance({required FormData data}) async =>
      await apiClient.postData(
        AppConstants.punchInAttendancePost,
        "punchInAttendance",
        data,
      );

  Future<Response> punchOutAttendance({required FormData data}) async =>
      await apiClient.postData(
        AppConstants.punchOutAttendancePost,
        "punchOutAttendance",
        data,
      );

  Future<Response> fetchTodayAttendance() async => await apiClient.getData(
        AppConstants.todayAttendanceGet,
        "fetchTodayAttendance",
      );
  Future<Response> fetchAttendanceHistory(
          {required Map<String, dynamic>? data}) async =>
      await apiClient.getData(
        AppConstants.attendanceHistoryGet,
        "fetchAttendanceHistory",
        query: data,
      );

  Future<Response> fetchTodayTeamAttendance(
          {required Map<String, dynamic>? data}) async =>
      await apiClient.getData(
        AppConstants.todayTeamAttendanceGet,
        "fetchTodayTeamAttendance",
        query: data,
      );

  Future<Response> fetchTeamEmployeesList(
          {required Map<String, dynamic>? data}) async =>
      await apiClient.getData(
        AppConstants.teamEmployeesListGet,
        "fetchTeamEmployeesList",
        query: data,
      );

  Future<Response> fetchCheckListPoint(
          {required Map<String, dynamic>? data}) async =>
      await apiClient.getData(
        AppConstants.checkListPointGet,
        "fetchCheckListPoint",
        query: data,
      );

  Future<Response> submitCheckListPoint(
          {required Map<String, dynamic>? data}) async =>
      await apiClient.postData(
          AppConstants.submitCheckListPointGet, "submitCheckListPoint", data);

  Future<Response> fetchTeamEmployeeAttendanceList(
          {required Map<String, dynamic>? data}) async =>
      await apiClient.getData(
        AppConstants.employeeAttendanceDetailsGet,
        "fetchTeamEmployeeAttendanceList",
        query: data,
      );

  Future<Response> fetchAttendanceDetails({required int attendanceId}) async =>
      await apiClient.getData(
        "${AppConstants.attendanceDetailsGet}/$attendanceId",
        "fetchAttendanceDetails",
      );

  Future<Response> fetchAttendanceCalendar(
          {required Map<String, dynamic>? data}) async =>
      await apiClient.getData(
        AppConstants.attendanceCalendarGet,
        "fetchAttendanceCalendar",
        query: data,
      );

  Future<Response> fetchAttendanceOverrides(
          {required Map<String, dynamic>? data}) async =>
      await apiClient.getData(
        AppConstants.attendanceOverride,
        "fetchAttendanceOverrides",
        query: data,
      );

  Future<Response> addAttendanceOverride(Map<String, dynamic> body) async =>
      await apiClient.postData(
          AppConstants.attendanceOverride, "addAttendanceOverride", body);
}
