import 'package:get/get.dart';
import 'package:vlr/data/models/reports/pip_report_model.dart';
import 'package:vlr/data/models/response/response_model.dart';
import 'package:vlr/data/repositories/reports_repo.dart';

class PipController extends GetxController implements GetxService {
  final ReportsRepo reportsRepo;
  PipController({required this.reportsRepo});

  bool isLoading = false;
  List<PipModel> pipList = [];

  Future<void> getPips({Map<String, dynamic>? query}) async {
    isLoading = true;
    update();
    try {
      Response response = await reportsRepo.getPipsList(query ?? {});
      if (response.statusCode == 200 && response.body['status'] == "success") {
        pipList = [];
        final data = response.body['data']['data'] as List;
        for (var item in data) {
          pipList.add(PipModel.fromJson(item));
        }
      }
    } catch (e) {
      print("Error fetching PIPs: $e");
    }
    isLoading = false;
    update();
  }

  Future<ResponseModel> createPipRecord(Map<String, dynamic> body) async {
    isLoading = true;
    update();
    try {
      Response response = await reportsRepo.createPip(body);
      if (response.isOk && response.body['status'] == "success") {
        await getPips();
        return ResponseModel(true, response.body['message'] ?? "PIP record created successfully");
      } else {
        return ResponseModel(false, response.body?['message'] ?? "Failed to create PIP record");
      }
    } catch (e) {
      return ResponseModel(false, "Error: $e");
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<ResponseModel> updatePipRecord(int id, Map<String, dynamic> body) async {
    isLoading = true;
    update();
    try {
      Response response = await reportsRepo.updatePip(id, body);
      if (response.isOk && response.body['status'] == "success") {
        await getPips();
        return ResponseModel(true, response.body['message'] ?? "PIP record updated successfully");
      } else {
        return ResponseModel(false, response.body?['message'] ?? "Failed to update PIP record");
      }
    } catch (e) {
      return ResponseModel(false, "Error: $e");
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<ResponseModel> deletePipRecord(int id) async {
    isLoading = true;
    update();
    try {
      Response response = await reportsRepo.deletePip(id);
      if (response.isOk && response.body['status'] == "success") {
        pipList.removeWhere((element) => element.id == id);
        return ResponseModel(true, response.body['message'] ?? "PIP record deleted successfully");
      } else {
        return ResponseModel(false, response.body?['message'] ?? "Failed to delete PIP record");
      }
    } catch (e) {
      return ResponseModel(false, "Error: $e");
    } finally {
      isLoading = false;
      update();
    }
  }
}
