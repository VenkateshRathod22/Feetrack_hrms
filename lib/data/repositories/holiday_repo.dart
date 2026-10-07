import 'package:get/get.dart';
import 'package:vlr/data/api/api_client.dart';
import 'package:vlr/services/constants.dart';

class HolidayRepo {
  final ApiClient apiClient;

  HolidayRepo({required this.apiClient});

  Future<Response> getHolidays(Map<String, dynamic> query) async {
    return await apiClient.getData(AppConstants.holidays, "getHolidays", query: query);
  }

  Future<Response> addHoliday(Map<String, dynamic> body) async {
    return await apiClient.postData(AppConstants.holidays, "addHoliday", body);
  }

  Future<Response> updateHoliday(int id, Map<String, dynamic> body) async {
    return await apiClient.putData("${AppConstants.holidays}/$id", "updateHoliday", body);
  }

  Future<Response> deleteHoliday(int id) async {
    return await apiClient.deleteData("${AppConstants.holidays}/$id", "deleteHoliday");
  }
}
