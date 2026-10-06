import 'dart:developer';

import 'package:get/get.dart';
import 'package:vlr/data/models/dashboard_model.dart';
import 'package:vlr/data/models/response/response_model.dart';
import 'package:vlr/data/repositories/dashboard_repo.dart';

class DashBoardController extends GetxController implements GetxService {
  final DashBoardRepo dashBoardRepo;
  DashBoardController({required this.dashBoardRepo});

  int _dashPage = 0;
  bool isLoading = false;
  DashboardModel? dashboardModel;

  int get dashPage => _dashPage;

  set dashPage(int page) {
    _dashPage = page;
    update();
  }

  Future<ResponseModel> getDashboardData() async {
    log('----------- getDashboardData Called ----------');

    ResponseModel responseModel;
    isLoading = true;
    update();

    try {
      Response response = await dashBoardRepo.getDashboardData();

      log("Dashboard Response: ${response.body}");

      if (response.body['status'] == "success") {
        responseModel = ResponseModel(
          true,
          response.body['message'] ?? "Dashboard data fetched successful",
        );
        dashboardModel = DashboardModel.fromJson(response.body['data']);
      } else {
        String errorMessage =
            response.body['message'] ?? "Error while fetching dashboard data";

        if (response.body['errors'] != null) {
          final errors = response.body['errors'] as Map<String, dynamic>;
          if (errors.isNotEmpty) {
            errorMessage = (errors.values.first as List).first.toString();
          }
        }

        responseModel = ResponseModel(false, errorMessage);
      }
    } catch (e) {
      log('ERROR AT getDashboardData(): $e');
      responseModel =
          ResponseModel(false, "Error while fetching dashboard data $e");
    }

    isLoading = false;
    update();
    return responseModel;
  }
}
