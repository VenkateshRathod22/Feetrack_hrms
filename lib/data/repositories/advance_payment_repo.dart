import 'package:get/get.dart';
import 'package:vlr/data/api/api_client.dart';
import 'package:vlr/services/constants.dart';

class AdvancePaymentRepo {
  final ApiClient apiClient;
  AdvancePaymentRepo({required this.apiClient});

  Future<Response> getAdvancePayments() async {
    return await apiClient.getData(AppConstants.advancePaymentsList, "getAdvancePayments");
  }

  Future<Response> addAdvancePayment({required FormData data}) async {
    return await apiClient.postData(AppConstants.advancePaymentsList, "addAdvancePayment", data);
  }
}
