import 'package:get/get.dart';
import 'package:vlr/data/api/api_client.dart';
import 'package:vlr/services/constants.dart';

class PayslipConfigRepo {
  final ApiClient apiClient;

  PayslipConfigRepo({required this.apiClient});

  Future<Response> getPayslipConfig() async {
    return await apiClient.getData(AppConstants.payslipConfig, "getPayslipConfig");
  }

  Future<Response> updatePayslipConfig(dynamic body) async {
    return await apiClient.putData(AppConstants.payslipConfig, "updatePayslipConfig", body);
  }
}
