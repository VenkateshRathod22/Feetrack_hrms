import 'package:get/get.dart';
import 'package:vlr/data/models/exit_model.dart';
import 'package:vlr/data/models/response/response_model.dart';
import 'package:vlr/data/repositories/reports_repo.dart';

class ResignationExitController extends GetxController implements GetxService {
  final ReportsRepo reportsRepo;
  ResignationExitController({required this.reportsRepo});

  bool isLoading = false;
  bool isDetailLoading = false;
  bool isActionLoading = false;

  List<ExitModel> exitList = [];
  ExitModel? currentExitDetail;

  Future<void> getExits({Map<String, dynamic>? query}) async {
    isLoading = true;
    update();
    try {
      Response response = await reportsRepo.getExitsList(query ?? {});
      if (response.statusCode == 200 && response.body['status'] == "success") {
        exitList = [];
        final data = response.body['data']['data'] as List;
        for (var item in data) {
          exitList.add(ExitModel.fromJson(item));
        }
      }
    } catch (e) {
      print("Error fetching Exits: $e");
    }
    isLoading = false;
    update();
  }

  Future<void> getExitDetails(String id) async {
    isDetailLoading = true;
    update();
    try {
      Response response = await reportsRepo.getExitDetails(id);
      if (response.statusCode == 200 && response.body['status'] == "success") {
        currentExitDetail = ExitModel.fromJson(response.body['data']);
      }
    } catch (e) {
      print("Error fetching Exit Details: $e");
    }
    isDetailLoading = false;
    update();
  }

  Future<ResponseModel> createExitRecord(Map<String, dynamic> body) async {
    isActionLoading = true;
    update();
    try {
      Response response = await reportsRepo.createExit(body);
      if (response.isOk && response.body['status'] == "success") {
        await getExits();
        return ResponseModel(true, response.body['message'] ?? "Exit record created successfully");
      } else {
        return ResponseModel(false, response.body?['message'] ?? "Failed to create Exit record");
      }
    } catch (e) {
      return ResponseModel(false, "Error: $e");
    } finally {
      isActionLoading = false;
      update();
    }
  }

  Future<ResponseModel> updateExitRecord(String id, Map<String, dynamic> body) async {
    isActionLoading = true;
    update();
    try {
      Response response = await reportsRepo.updateExit(id, body);
      if (response.isOk && response.body['status'] == "success") {
        await getExits();
        return ResponseModel(true, response.body['message'] ?? "Exit record updated successfully");
      } else {
        return ResponseModel(false, response.body?['message'] ?? "Failed to update Exit record");
      }
    } catch (e) {
      return ResponseModel(false, "Error: $e");
    } finally {
      isActionLoading = false;
      update();
    }
  }

  Future<ResponseModel> deleteExitRecord(String id) async {
    isActionLoading = true;
    update();
    try {
      Response response = await reportsRepo.deleteExit(id);
      if (response.isOk && response.body['status'] == "success") {
        exitList.removeWhere((element) => element.id == id);
        return ResponseModel(true, response.body['message'] ?? "Exit record deleted successfully");
      } else {
        return ResponseModel(false, response.body?['message'] ?? "Failed to delete Exit record");
      }
    } catch (e) {
      return ResponseModel(false, "Error: $e");
    } finally {
      isActionLoading = false;
      update();
    }
  }
}
