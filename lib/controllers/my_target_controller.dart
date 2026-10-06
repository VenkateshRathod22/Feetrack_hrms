import 'dart:developer';
import 'package:get/get.dart';
import 'package:vlr/data/models/my_target_model.dart';
import 'package:vlr/data/repositories/target_repo.dart';
import 'package:vlr/data/models/response/response_model.dart';

class MyTargetController extends GetxController implements GetxService {
  final TargetRepo targetRepo;
  MyTargetController({required this.targetRepo});

  bool isLoading = false;
  MyTargetModel? myTargetModel;

  Future<ResponseModel> fetchMyTargets() async {
    log('----------- fetchMyTargets Called ----------');
    isLoading = true;
    update();

    ResponseModel responseModel;
    try {
      Response response = await targetRepo.getMyTargets();

      if (response.body['status'] == "success") {
        myTargetModel = MyTargetModel.fromJson(response.body['data']);
        responseModel = ResponseModel(true, response.body['message'] ?? "Targets fetched successfully");
      } else {
        responseModel = ResponseModel(false, response.body['message'] ?? "Error fetching targets");
      }
    } catch (e) {
      log('ERROR AT fetchMyTargets(): $e');
      responseModel = ResponseModel(false, "Error fetching targets: $e");
    }

    isLoading = false;
    update();
    return responseModel;
  }
}
