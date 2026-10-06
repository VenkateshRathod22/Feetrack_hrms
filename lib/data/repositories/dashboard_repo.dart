import 'package:get/get.dart';
import '../../services/constants.dart';
import '../api/api_client.dart';

class DashBoardRepo {
  final ApiClient apiClient;
  DashBoardRepo({required this.apiClient});

  Future<Response> getDashboardData() async => await apiClient.getData(
        AppConstants.dashboard,
        "getDashboardData",
      );
}
