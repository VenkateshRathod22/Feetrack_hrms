import 'package:get/get.dart';
import 'package:vlr/data/models/reports/exit_reason_report_model.dart';
import 'package:vlr/data/models/response/response_model.dart';
import 'package:vlr/data/repositories/reports_repo.dart';

class ExitReasonController extends GetxController implements GetxService {
  final ReportsRepo reportsRepo;
  ExitReasonController({required this.reportsRepo});

  bool isLoading = false;
  List<ExitReasonReportModel> exitReasonList = [];

  // Report specific fields
  List<ExitReasonReportModel> exitReasonReportList = [];
  ExitReasonReportSummary? exitReasonReportSummary;

  Future<void> getExitReasonsReport({Map<String, dynamic>? search}) async {
    isLoading = true;
    update();
    try {
      Response response = await reportsRepo.getExitReasonsReport(search ?? {});
      if (response.statusCode == 200 && response.body['status'] == "success") {
        exitReasonReportList = [];
        final List data = response.body['data']['data'];
        for (var v in data) {
          exitReasonReportList.add(ExitReasonReportModel.fromJson(v));
        }
        exitReasonReportSummary = ExitReasonReportSummary.fromJson(response.body['summary']);
      }
    } catch (e) {
      print("Error fetching exit reasons report: $e");
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
        final List data = response.body['data'];
        for (var v in data) {
          exitReasonList.add(ExitReasonReportModel.fromJson(v));
        }
      }
    } catch (e) {
      print("Error fetching exit reasons: $e");
    }
    isLoading = false;
    update();
  }

  Future<ResponseModel> createExitReason(Map<String, dynamic> body) async {
    isLoading = true;
    update();
    try {
      Response response = await reportsRepo.createExitReason(body);
      if (response.isOk && response.body['status'] == "success") {
        await getExitReasons();
        return ResponseModel(true, response.body['message'] ?? "Created successfully");
      } else {
        return ResponseModel(false, response.body?['message'] ?? "Failed to create");
      }
    } catch (e) {
      return ResponseModel(false, "Error: $e");
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<ResponseModel> updateExitReason(int id, Map<String, dynamic> body) async {
    isLoading = true;
    update();
    try {
      Response response = await reportsRepo.updateExitReason(id, body);
      if (response.isOk && response.body['status'] == "success") {
        await getExitReasons();
        return ResponseModel(true, response.body['message'] ?? "Updated successfully");
      } else {
        return ResponseModel(false, response.body?['message'] ?? "Failed to update");
      }
    } catch (e) {
      return ResponseModel(false, "Error: $e");
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<ResponseModel> deleteExitReason(int id) async {
    isLoading = true;
    update();
    try {
      Response response = await reportsRepo.deleteExitReason(id);
      if (response.isOk && response.body['status'] == "success") {
        exitReasonList.removeWhere((element) => element.id == id);
        return ResponseModel(true, response.body['message'] ?? "Deleted successfully");
      } else {
        return ResponseModel(false, response.body?['message'] ?? "Failed to delete");
      }
    } catch (e) {
      return ResponseModel(false, "Error: $e");
    } finally {
      isLoading = false;
      update();
    }
  }
}
