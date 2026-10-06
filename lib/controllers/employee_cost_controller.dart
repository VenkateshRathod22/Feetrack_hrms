import 'package:get/get.dart';
import 'package:vlr/data/models/reports/employee_cost_report_model.dart';
import 'package:vlr/data/repositories/reports_repo.dart';

class EmployeeCostController extends GetxController implements GetxService {
  final ReportsRepo reportsRepo;
  EmployeeCostController({required this.reportsRepo});

  bool isLoading = false;
  List<EmployeeCostReportModel> employeeCostList = [];
  EmployeeCostAnalytics? analytics;

  Future<void> getEmployeeCostReport({Map<String, dynamic>? search}) async {
    isLoading = true;
    update();
    try {
      Response response = await reportsRepo.getEmployeeCostReport(search ?? {});
      if (response.statusCode == 200 && response.body['status'] == "success") {
        employeeCostList = [];
        if (response.body['data'] != null && response.body['data']['data'] != null) {
          final List data = response.body['data']['data'];
          for (var v in data) {
            employeeCostList.add(EmployeeCostReportModel.fromJson(v));
          }
        }
        analytics = EmployeeCostAnalytics.fromJson(response.body);
      }
    } catch (e) {
      print("Error fetching employee cost report: $e");
    }
    isLoading = false;
    update();
  }
}

