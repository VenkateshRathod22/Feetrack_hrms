import 'package:get/get.dart';
import 'package:vlr/data/api/api_client.dart';
import 'package:vlr/services/constants.dart';

class TargetRepo {
  final ApiClient apiClient;
  TargetRepo({required this.apiClient});

  Future<Response> getMyTargets() async {
    return await apiClient.getData(AppConstants.myTargets, "getMyTargets");
  }
}
