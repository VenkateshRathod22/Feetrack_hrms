import 'package:get/get.dart';
import 'package:vlr/data/models/reports/training_report_model.dart';
import 'package:vlr/data/models/response/response_model.dart';
import 'package:vlr/data/repositories/reports_repo.dart';

class TrainingReportController extends GetxController implements GetxService {
  final ReportsRepo reportsRepo;
  TrainingReportController({required this.reportsRepo});

  bool isLoading = false;
  
  // Dashboard Analytics
  TrainingAnalytics? trainingAnalytics;
  
  // Assignments (Data list)
  List<TrainingAssignmentModel> trainingAssignments = [];
  
  // Programs
  List<TrainingProgramModel> trainingPrograms = [];

  Future<void> getTrainingDashboard({Map<String, dynamic>? search}) async {
    isLoading = true;
    update();
    try {
      Response response = await reportsRepo.getTrainingDashboard(search ?? {});
      if (response.statusCode == 200 && response.body['status'] == "success") {
        trainingAnalytics = TrainingAnalytics.fromJson(response.body);
        
        // Populate assignments list from the 'data' field
        trainingAssignments = [];
        if (response.body['data'] != null && response.body['data']['data'] != null) {
          final List dataList = response.body['data']['data'];
          for (var item in dataList) {
            trainingAssignments.add(TrainingAssignmentModel.fromJson(item));
          }
        }
      }
    } catch (e) {
      print("Error fetching training dashboard: $e");
    }
    isLoading = false;
    update();
  }

  Future<void> getTrainingPrograms({Map<String, dynamic>? search}) async {
    isLoading = true;
    update();
    try {
      Response response = await reportsRepo.getTrainingPrograms(search ?? {});
      if (response.statusCode == 200 && response.body['status'] == "success") {
        trainingPrograms = [];
        final List data = response.body['data'];
        for (var item in data) {
          trainingPrograms.add(TrainingProgramModel.fromJson(item));
        }
      }
    } catch (e) {
      print("Error fetching training programs: $e");
    }
    isLoading = false;
    update();
  }

  Future<ResponseModel> createTrainingProgram(Map<String, dynamic> body) async {
    isLoading = true;
    update();
    try {
      Response response = await reportsRepo.createTrainingProgram(body);
      if (response.isOk && response.body['status'] == "success") {
        await getTrainingPrograms();
        return ResponseModel(true, response.body['message'] ?? "Program created successfully");
      } else {
        return ResponseModel(false, response.body?['message'] ?? "Failed to create program");
      }
    } catch (e) {
      return ResponseModel(false, "Error: $e");
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<ResponseModel> updateTrainingProgram(int id, Map<String, dynamic> body) async {
    isLoading = true;
    update();
    try {
      Response response = await reportsRepo.updateTrainingProgram(id, body);
      if (response.isOk && response.body['status'] == "success") {
        await getTrainingPrograms();
        return ResponseModel(true, response.body['message'] ?? "Program updated successfully");
      } else {
        return ResponseModel(false, response.body?['message'] ?? "Failed to update program");
      }
    } catch (e) {
      return ResponseModel(false, "Error: $e");
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<ResponseModel> deleteTrainingProgram(int id) async {
    isLoading = true;
    update();
    try {
      Response response = await reportsRepo.deleteTrainingProgram(id);
      if (response.isOk && response.body['status'] == "success") {
        trainingPrograms.removeWhere((element) => element.id == id);
        return ResponseModel(true, response.body['message'] ?? "Program deleted successfully");
      } else {
        return ResponseModel(false, response.body?['message'] ?? "Failed to delete program");
      }
    } catch (e) {
      return ResponseModel(false, "Error: $e");
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<ResponseModel> assignTraining(Map<String, dynamic> body) async {
    isLoading = true;
    update();
    try {
      Response response = await reportsRepo.assignTraining(body);
      if (response.isOk && response.body['status'] == "success") {
        await getTrainingDashboard();
        return ResponseModel(true, response.body['message'] ?? "Training assigned successfully");
      } else {
        return ResponseModel(false, response.body?['message'] ?? "Failed to assign training");
      }
    } catch (e) {
      return ResponseModel(false, "Error: $e");
    } finally {
      isLoading = false;
      update();
    }
  }
}
