import 'package:get/get.dart';
import 'package:vlr/data/models/reports/grievance_discipline_report_model.dart';
import 'package:vlr/data/models/response/response_model.dart';
import 'package:vlr/data/repositories/reports_repo.dart';

class DisciplineController extends GetxController implements GetxService {
  final ReportsRepo reportsRepo;
  DisciplineController({required this.reportsRepo});

  bool isLoading = false;
  List<GrievanceModel> grievanceList = [];
  GrievanceModel? selectedGrievance;

  Future<void> getGrievances({Map<String, dynamic>? query}) async {
    isLoading = true;
    update();
    try {
      Response response = await reportsRepo.getGrievancesList(query ?? {});
      if (response.statusCode == 200 && response.body['status'] == "success") {
        grievanceList = [];
        final data = response.body['data']['data'] as List;
        for (var item in data) {
          grievanceList.add(GrievanceModel.fromJson(item));
        }
      }
    } catch (e) {
      print("Error fetching grievances: $e");
    }
    isLoading = false;
    update();
  }

  Future<void> getGrievanceDetails(int id) async {
    isLoading = true;
    update();
    try {
      Response response = await reportsRepo.getGrievanceDetails(id);
      if (response.statusCode == 200 && response.body['status'] == "success") {
        selectedGrievance = GrievanceModel.fromJson(response.body['data']);
      }
    } catch (e) {
      print("Error fetching grievance details: $e");
    }
    isLoading = false;
    update();
  }

  Future<ResponseModel> createGrievanceRecord(Map<String, dynamic> body) async {
    isLoading = true;
    update();
    try {
      Response response = await reportsRepo.createGrievance(body);
      if (response.isOk && response.body['status'] == "success") {
        await getGrievances();
        return ResponseModel(true, response.body['message'] ?? "Grievance record created successfully");
      } else {
        return ResponseModel(false, response.body?['message'] ?? "Failed to create grievance record");
      }
    } catch (e) {
      return ResponseModel(false, "Error: $e");
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<ResponseModel> updateGrievanceRecord(int id, Map<String, dynamic> body) async {
    isLoading = true;
    update();
    try {
      Response response = await reportsRepo.updateGrievance(id, body);
      if (response.isOk && response.body['status'] == "success") {
        await getGrievances();
        return ResponseModel(true, response.body['message'] ?? "Grievance record updated successfully");
      } else {
        return ResponseModel(false, response.body?['message'] ?? "Failed to update grievance record");
      }
    } catch (e) {
      return ResponseModel(false, "Error: $e");
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<ResponseModel> deleteGrievanceRecord(int id) async {
    isLoading = true;
    update();
    try {
      Response response = await reportsRepo.deleteGrievance(id);
      if (response.isOk && response.body['status'] == "success") {
        grievanceList.removeWhere((element) => element.id == id);
        return ResponseModel(true, response.body['message'] ?? "Grievance record deleted successfully");
      } else {
        return ResponseModel(false, response.body?['message'] ?? "Failed to delete grievance record");
      }
    } catch (e) {
      return ResponseModel(false, "Error: $e");
    } finally {
      isLoading = false;
      update();
    }
  }
}
