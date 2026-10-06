import 'package:get/get.dart';
import 'package:vlr/data/models/reports/attrition_report_model.dart';
import 'package:vlr/data/models/attrition/exit_reason_model.dart';
import 'package:vlr/data/models/response/response_model.dart';
import 'package:vlr/data/repositories/reports_repo.dart';

class AttritionController extends GetxController implements GetxService {
  final ReportsRepo reportsRepo;
  AttritionController({required this.reportsRepo});

  bool isLoading = false;
  List<AttritionReportModel> attritionReportList = [];
  AttritionReportSummary? attritionAnalytics;
  List<ExitReasonModel> exitReasonList = [];

  Future<void> getAttritionReport({Map<String, dynamic>? search}) async {
    isLoading = true;
    update();
    try {
      Response response = await reportsRepo.getAttritionList(search ?? {});
      if (response.statusCode == 200 && response.body['status'] == "success") {
        attritionReportList = [];
        if (response.body['data'] != null && response.body['data']['data'] != null) {
          response.body['data']['data'].forEach((v) {
            attritionReportList.add(AttritionReportModel.fromJson(v));
          });
        }

        if (response.body['analytics'] != null) {
          attritionAnalytics = AttritionReportSummary.fromJson(response.body['analytics']);
        }
      }
    } catch (e) {
      print("Error fetching attrition report: $e");
    }
    isLoading = false;
    update();
  }

  Future<void> getExitReasons() async {
    isLoading = true;
    update();
    try {
      Response response = await reportsRepo.getExitReasons();
      if (response.statusCode == 200 && response.body['status'] == "success") {
        exitReasonList = [];
        if (response.body['data'] != null) {
          response.body['data'].forEach((v) {
            exitReasonList.add(ExitReasonModel.fromJson(v));
          });
        }
      }
    } catch (e) {
      print("Error fetching exit reasons: $e");
    }
    isLoading = false;
    update();
  }

  Future<ResponseModel> createAttritionRecord(Map<String, dynamic> body) async {
    isLoading = true;
    update();
    try {
      Response response = await reportsRepo.createAttrition(body);
      if (response.isOk && response.body['status'] == "success") {
        getAttritionReport();
        isLoading = false;
        update();
        return ResponseModel(true, response.body['message'] ?? "Exit recorded successfully");
      } else {
        isLoading = false;
        update();
        return ResponseModel(false, response.body?['message'] ?? "Failed to record exit");
      }
    } catch (e) {
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  Future<ResponseModel> updateAttritionRecord(String id, Map<String, dynamic> body) async {
    isLoading = true;
    update();
    try {
      Response response = await reportsRepo.updateAttrition(id, body);
      if (response.isOk && response.body['status'] == "success") {
        getAttritionReport();
        isLoading = false;
        update();
        return ResponseModel(true, response.body['message'] ?? "Exit record updated successfully");
      } else {
        isLoading = false;
        update();
        return ResponseModel(false, response.body?['message'] ?? "Failed to update record");
      }
    } catch (e) {
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }

  Future<ResponseModel> deleteAttritionRecord(String id) async {
    isLoading = true;
    update();
    try {
      Response response = await reportsRepo.deleteAttrition(id);
      if (response.isOk && response.body['status'] == "success") {
        getAttritionReport();
        isLoading = false;
        update();
        return ResponseModel(true, response.body['message'] ?? "Exit record deleted successfully");
      } else {
        isLoading = false;
        update();
        return ResponseModel(false, response.body?['message'] ?? "Failed to delete record");
      }
    } catch (e) {
      isLoading = false;
      update();
      return ResponseModel(false, "Error: $e");
    }
  }
}
