import 'package:get/get.dart';
import 'package:vlr/data/models/reports/probation_report_model.dart';
import 'package:vlr/data/models/response/response_model.dart';
import 'package:vlr/data/repositories/reports_repo.dart';

class ProbationController extends GetxController implements GetxService {
  final ReportsRepo reportsRepo;
  ProbationController({required this.reportsRepo});

  bool isLoading = false;
  List<ProbationModel> probationList = [];
  ProbationModel? selectedProbation;

  Future<void> getProbations({Map<String, dynamic>? query}) async {
    isLoading = true;
    update();
    try {
      Response response = await reportsRepo.getProbationsList(query ?? {});
      if (response.statusCode == 200 && response.body['status'] == "success") {
        probationList = [];
        final data = response.body['data']['data'] as List;
        for (var item in data) {
          probationList.add(ProbationModel.fromJson(item));
        }
      }
    } catch (e) {
      print("Error fetching probations: $e");
    }
    isLoading = false;
    update();
  }

  Future<void> getProbationDetails(int id) async {
    isLoading = true;
    update();
    try {
      Response response = await reportsRepo.getProbationDetails(id);
      if (response.statusCode == 200 && response.body['status'] == "success") {
        selectedProbation = ProbationModel.fromJson(response.body['data']);
      }
    } catch (e) {
      print("Error fetching probation details: $e");
    }
    isLoading = false;
    update();
  }

  Future<ResponseModel> createProbationRecord(Map<String, dynamic> body) async {
    isLoading = true;
    update();
    try {
      Response response = await reportsRepo.createProbation(body);
      if (response.isOk && response.body['status'] == "success") {
        await getProbations();
        return ResponseModel(true, response.body['message'] ?? "Probation record created successfully");
      } else {
        return ResponseModel(false, response.body?['message'] ?? "Failed to create probation record");
      }
    } catch (e) {
      return ResponseModel(false, "Error: $e");
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<ResponseModel> updateProbationRecord(int id, Map<String, dynamic> body) async {
    isLoading = true;
    update();
    try {
      Response response = await reportsRepo.updateProbation(id, body);
      if (response.isOk && response.body['status'] == "success") {
        await getProbations();
        return ResponseModel(true, response.body['message'] ?? "Probation record updated successfully");
      } else {
        return ResponseModel(false, response.body?['message'] ?? "Failed to update probation record");
      }
    } catch (e) {
      return ResponseModel(false, "Error: $e");
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<ResponseModel> deleteProbationRecord(int id) async {
    isLoading = true;
    update();
    try {
      Response response = await reportsRepo.deleteProbation(id);
      if (response.isOk && response.body['status'] == "success") {
        probationList.removeWhere((element) => element.id == id);
        return ResponseModel(true, response.body['message'] ?? "Probation record deleted successfully");
      } else {
        return ResponseModel(false, response.body?['message'] ?? "Failed to delete probation record");
      }
    } catch (e) {
      return ResponseModel(false, "Error: $e");
    } finally {
      isLoading = false;
      update();
    }
  }
}
