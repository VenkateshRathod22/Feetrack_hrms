import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vlr/controllers/auth_controller.dart';
import 'package:vlr/data/repositories/reports_repo.dart';
import 'package:vlr/data/models/reports/staff_report_model.dart';
import 'package:vlr/data/models/reports/attendance_report_model.dart';
import 'package:vlr/data/models/reports/leave_report_model.dart';
import 'package:vlr/data/models/reports/expense_report_model.dart';
import 'package:vlr/data/models/reports/task_report_model.dart';
import 'package:vlr/data/models/reports/lead_report_model.dart';
import 'package:vlr/data/models/reports/order_report_model.dart';
import 'package:vlr/data/models/reports/payroll_report_model.dart';
import 'package:vlr/data/models/reports/recovery_report_model.dart';
import 'package:vlr/data/models/reports/notice_report_model.dart';
import 'package:vlr/data/models/reports/product_category_report_model.dart';
import 'package:vlr/data/models/reports/product_report_model.dart';
import 'package:vlr/data/models/reports/salary_report_model.dart';
import 'package:vlr/data/models/reports/commission_report_model.dart';
import 'package:vlr/data/models/reports/pip_report_model.dart';
import 'package:vlr/data/models/reports/recruitment_report_model.dart';
import 'package:vlr/data/models/reports/probation_report_model.dart';
import 'package:vlr/data/models/reports/resignation_exit_report_model.dart';
import 'package:vlr/data/models/reports/document_report_model.dart';
import 'package:vlr/data/models/reports/grievance_discipline_report_model.dart';
import 'package:vlr/data/models/reports/attrition_report_model.dart';
import 'package:vlr/data/models/reports/exit_reason_report_model.dart';
import 'package:vlr/data/models/reports/employee_cost_report_model.dart';
import 'package:vlr/data/models/reports/training_report_model.dart';
import 'package:vlr/data/models/reports/asset_report_model.dart';
import 'package:vlr/services/constants.dart';

class ReportsController extends GetxController implements GetxService {
  final ReportsRepo reportsRepo;

  ReportsController({required this.reportsRepo});

  bool isLoading = false;

  // Staff Report
  List<StaffReportModel> staffReportList = [];
  StaffReportSummary? staffReportSummary;

  // Attendance Report
  List<AttendanceReportModel> attendanceReportList = [];
  AttendanceReportSummary? attendanceReportSummary;

  // Leave Report
  List<LeaveReportModel> leaveReportList = [];
  LeaveReportSummary? leaveReportSummary;

  // Expense Report
  List<ExpenseReportModel> expenseReportList = [];
  ExpenseReportSummary? expenseReportSummary;

  // Task Report
  List<TaskReportModel> taskReportList = [];
  TaskReportSummary? taskReportSummary;

  // Lead Report
  List<LeadReportModel> leadReportList = [];
  LeadReportSummary? leadReportSummary;

  // Order Report
  List<OrderReportModel> orderReportList = [];
  OrderReportSummary? orderReportSummary;

  // Payroll Report
  List<PayrollReportModel> payrollReportList = [];
  PayrollReportSummary? payrollReportSummary;

  // Recovery Report
  List<RecoveryReportModel> recoveryReportList = [];
  RecoveryReportSummary? recoveryReportSummary;

  // Notice Report
  List<NoticeReportModel> noticeReportList = [];
  NoticeReportSummary? noticeReportSummary;

  // Product Category Report
  List<ProductCategoryReportModel> productCategoryReportList = [];
  ProductCategoryReportSummary? productCategoryReportSummary;

  // Product Report
  List<ProductReportModel> productReportList = [];
  ProductReportSummary? productReportSummary;

  // Salary Report
  List<SalaryReportModel> salaryReportList = [];
  SalaryReportSummary? salaryReportSummary;

  // Commission Report
  List<CommissionReportModel> commissionReportList = [];
  CommissionReportSummary? commissionReportSummary;

  // PIP Report
  List<PipReportModel> pipReportList = [];
  PipReportSummary? pipReportSummary;

  // Recruitment Report
  List<RecruitmentReportModel> recruitmentReportList = [];
  RecruitmentReportSummary? recruitmentReportSummary;

  // Probation Report
  List<ProbationReportModel> probationReportList = [];
  ProbationReportSummary? probationReportSummary;

  // Resignation & Exit Report
  List<ResignationExitReportModel> resignationExitReportList = [];
  ResignationExitReportSummary? resignationExitReportSummary;

  // Documents & KYC Report
  List<DocumentReportModel> documentReportList = [];
  DocumentReportSummary? documentReportSummary;

  // Grievance & Discipline Report
  List<GrievanceDisciplineReportModel> grievanceDisciplineReportList = [];
  GrievanceDisciplineReportSummary? grievanceDisciplineReportSummary;

  // Attrition Analytics
  List<AttritionReportModel> attritionReportList = [];
  AttritionReportSummary? attritionReportSummary;

  // Exit Reasons
  List<ExitReasonReportModel> exitReasonReportList = [];
  ExitReasonReportSummary? exitReasonReportSummary;

  // Employee Cost
  List<EmployeeCostReportModel> employeeCostReportList = [];
  EmployeeCostReportSummary? employeeCostReportSummary;

  // Training Report
  List<TrainingReportModel> trainingReportList = [];
  TrainingReportSummary? trainingReportSummary;

  // Asset Report
  List<AssetReportModel> assetReportList = [];
  AssetReportSummary? assetReportSummary;

  Future<void> getStaffReport({Map<String, dynamic>? search}) async {
    isLoading = true;
    update();
    Response response = await reportsRepo.getStaffReport(search ?? {});
    if (response.statusCode == 200 && response.body['status'] == "success") {
      staffReportList = [];
      response.body['data']['data'].forEach((v) {
        staffReportList.add(StaffReportModel.fromJson(v));
      });
      staffReportSummary = StaffReportSummary.fromJson(response.body['summary']);
    }
    isLoading = false;
    update();
  }

  Future<void> getAttendanceReport({Map<String, dynamic>? search}) async {
    isLoading = true;
    update();
    Response response = await reportsRepo.getAttendanceReport(search ?? {});
    if (response.statusCode == 200 && response.body['status'] == "success") {
      attendanceReportList = [];
      response.body['data']['data'].forEach((v) {
        attendanceReportList.add(AttendanceReportModel.fromJson(v));
      });
      attendanceReportSummary = AttendanceReportSummary.fromJson(response.body['summary']);
    }
    isLoading = false;
    update();
  }

  Future<void> getLeaveReport({Map<String, dynamic>? search}) async {
    isLoading = true;
    update();
    Response response = await reportsRepo.getLeaveReport(search ?? {});
    if (response.statusCode == 200 && response.body['status'] == "success") {
      leaveReportList = [];
      response.body['data']['data'].forEach((v) {
        leaveReportList.add(LeaveReportModel.fromJson(v));
      });
      leaveReportSummary = LeaveReportSummary.fromJson(response.body['summary']);
    }
    isLoading = false;
    update();
  }

  Future<void> getExpenseReport({Map<String, dynamic>? search}) async {
    isLoading = true;
    update();
    Response response = await reportsRepo.getExpenseReport(search ?? {});
    if (response.statusCode == 200 && response.body['status'] == "success") {
      expenseReportList = [];
      response.body['data']['data'].forEach((v) {
        expenseReportList.add(ExpenseReportModel.fromJson(v));
      });
      expenseReportSummary = ExpenseReportSummary.fromJson(response.body['summary']);
    }
    isLoading = false;
    update();
  }

  Future<void> getTaskReport({Map<String, dynamic>? search}) async {
    isLoading = true;
    update();
    Response response = await reportsRepo.getTaskReport(search ?? {});
    if (response.statusCode == 200 && response.body['status'] == "success") {
      taskReportList = [];
      response.body['data']['data'].forEach((v) {
        taskReportList.add(TaskReportModel.fromJson(v));
      });
      taskReportSummary = TaskReportSummary.fromJson(response.body['summary']);
    }
    isLoading = false;
    update();
  }

  Future<void> getLeadReport({Map<String, dynamic>? search}) async {
    isLoading = true;
    update();
    Response response = await reportsRepo.getLeadReport(search ?? {});
    if (response.statusCode == 200 && response.body['status'] == "success") {
      leadReportList = [];
      response.body['data']['data'].forEach((v) {
        leadReportList.add(LeadReportModel.fromJson(v));
      });
      leadReportSummary = LeadReportSummary.fromJson(response.body['summary']);
    }
    isLoading = false;
    update();
  }

  Future<void> getOrderReport({Map<String, dynamic>? search}) async {
    isLoading = true;
    update();
    Response response = await reportsRepo.getOrderReport(search ?? {});
    if (response.statusCode == 200 && response.body['status'] == "success") {
      orderReportList = [];
      response.body['data']['data'].forEach((v) {
        orderReportList.add(OrderReportModel.fromJson(v));
      });
      orderReportSummary = OrderReportSummary.fromJson(response.body['summary']);
    }
    isLoading = false;
    update();
  }

  Future<void> getPayrollReport({Map<String, dynamic>? search}) async {
    isLoading = true;
    update();
    Response response = await reportsRepo.getPayrollReport(search ?? {});
    if (response.statusCode == 200 && response.body['status'] == "success") {
      payrollReportList = [];
      response.body['data']['data'].forEach((v) {
        payrollReportList.add(PayrollReportModel.fromJson(v));
      });
      payrollReportSummary = PayrollReportSummary.fromJson(response.body['summary']);
    }
    isLoading = false;
    update();
  }

  Future<void> getRecoveryReport({Map<String, dynamic>? search}) async {
    isLoading = true;
    update();
    Response response = await reportsRepo.getRecoveryReport(search ?? {});
    if (response.statusCode == 200 && response.body['status'] == "success") {
      recoveryReportList = [];
      response.body['data']['data'].forEach((v) {
        recoveryReportList.add(RecoveryReportModel.fromJson(v));
      });
      recoveryReportSummary = RecoveryReportSummary.fromJson(response.body['summary']);
    }
    isLoading = false;
    update();
  }

  Future<void> getNoticeReport({Map<String, dynamic>? search}) async {
    isLoading = true;
    update();
    Response response = await reportsRepo.getNoticeReport(search ?? {});
    if (response.statusCode == 200 && response.body['status'] == "success") {
      noticeReportList = [];
      response.body['data']['data'].forEach((v) {
        noticeReportList.add(NoticeReportModel.fromJson(v));
      });
      noticeReportSummary = NoticeReportSummary.fromJson(response.body['summary']);
    }
    isLoading = false;
    update();
  }

  Future<void> getProductCategoryReport({Map<String, dynamic>? search}) async {
    isLoading = true;
    update();
    Response response = await reportsRepo.getProductCategoryReport(search ?? {});
    if (response.statusCode == 200 && response.body['status'] == "success") {
      productCategoryReportList = [];
      response.body['data']['data'].forEach((v) {
        productCategoryReportList.add(ProductCategoryReportModel.fromJson(v));
      });
      productCategoryReportSummary = ProductCategoryReportSummary.fromJson(response.body['summary']);
    }
    isLoading = false;
    update();
  }

  Future<void> getProductReport({Map<String, dynamic>? search}) async {
    isLoading = true;
    update();
    Response response = await reportsRepo.getProductReport(search ?? {});
    if (response.statusCode == 200 && response.body['status'] == "success") {
      productReportList = [];
      response.body['data']['data'].forEach((v) {
        productReportList.add(ProductReportModel.fromJson(v));
      });
      productReportSummary = ProductReportSummary.fromJson(response.body['summary']);
    }
    isLoading = false;
    update();
  }

  Future<void> getSalaryReport({Map<String, dynamic>? search}) async {
    isLoading = true;
    update();
    Response response = await reportsRepo.getSalaryReport(search ?? {});
    if (response.statusCode == 200 && response.body['status'] == "success") {
      salaryReportList = [];
      response.body['data']['data'].forEach((v) {
        salaryReportList.add(SalaryReportModel.fromJson(v));
      });
      salaryReportSummary = SalaryReportSummary.fromJson(response.body['summary']);
    }
    isLoading = false;
    update();
  }

  Future<void> getCommissionReport({Map<String, dynamic>? search}) async {
    isLoading = true;
    update();
    Response response = await reportsRepo.getCommissionReport(search ?? {});
    if (response.statusCode == 200 && response.body['status'] == "success") {
      commissionReportList = [];
      if (response.body['data']['data'] != null) {
        response.body['data']['data'].forEach((v) {
          commissionReportList.add(CommissionReportModel.fromJson(v));
        });
      }
      commissionReportSummary = CommissionReportSummary.fromJson(response.body['summary']);
    }
    isLoading = false;
    update();
  }

  Future<void> getPipReport({Map<String, dynamic>? search}) async {
    isLoading = true;
    update();
    Response response = await reportsRepo.getPipReport(search ?? {});
    if (response.statusCode == 200 && response.body['status'] == "success") {
      pipReportList = [];
      response.body['data']['data'].forEach((v) {
        pipReportList.add(PipReportModel.fromJson(v));
      });
      pipReportSummary = PipReportSummary.fromJson(response.body['summary']);
    }
    isLoading = false;
    update();
  }

  Future<void> getRecruitmentReport({Map<String, dynamic>? search}) async {
    isLoading = true;
    update();
    Response response = await reportsRepo.getRecruitmentReport(search ?? {});
    if (response.statusCode == 200 && response.body['status'] == "success") {
      recruitmentReportList = [];
      response.body['data']['data'].forEach((v) {
        recruitmentReportList.add(RecruitmentReportModel.fromJson(v));
      });
      recruitmentReportSummary = RecruitmentReportSummary.fromJson(response.body['summary']);
    }
    isLoading = false;
    update();
  }

  Future<void> getProbationReport({Map<String, dynamic>? search}) async {
    isLoading = true;
    update();
    Response response = await reportsRepo.getProbationReport(search ?? {});
    if (response.statusCode == 200 && response.body['status'] == "success") {
      probationReportList = [];
      response.body['data']['data'].forEach((v) {
        probationReportList.add(ProbationReportModel.fromJson(v));
      });
      probationReportSummary = ProbationReportSummary.fromJson(response.body['summary']);
    }
    isLoading = false;
    update();
  }

  Future<void> getResignationExitReport({Map<String, dynamic>? search}) async {
    isLoading = true;
    update();
    Response response = await reportsRepo.getResignationExitReport(search ?? {});
    if (response.statusCode == 200 && response.body['status'] == "success") {
      resignationExitReportList = [];
      response.body['data']['data'].forEach((v) {
        resignationExitReportList.add(ResignationExitReportModel.fromJson(v));
      });
      resignationExitReportSummary = ResignationExitReportSummary.fromJson(response.body['summary']);
    }
    isLoading = false;
    update();
  }

  Future<void> getDocumentReport({Map<String, dynamic>? search}) async {
    isLoading = true;
    update();
    Response response = await reportsRepo.getDocumentReport(search ?? {});
    if (response.statusCode == 200 && response.body['status'] == "success") {
      documentReportList = [];
      response.body['data']['data'].forEach((v) {
        documentReportList.add(DocumentReportModel.fromJson(v));
      });
      documentReportSummary = DocumentReportSummary.fromJson(response.body['summary']);
    }
    isLoading = false;
    update();
  }

  Future<void> getGrievanceDisciplineReport({Map<String, dynamic>? search}) async {
    isLoading = true;
    update();
    Response response = await reportsRepo.getGrievanceDisciplineReport(search ?? {});
    if (response.statusCode == 200 && response.body['status'] == "success") {
      grievanceDisciplineReportList = [];
      response.body['data']['data'].forEach((v) {
        grievanceDisciplineReportList.add(GrievanceDisciplineReportModel.fromJson(v));
      });
      grievanceDisciplineReportSummary = GrievanceDisciplineReportSummary.fromJson(response.body['summary']);
    }
    isLoading = false;
    update();
  }

  Future<void> getAttritionReport({Map<String, dynamic>? search}) async {
    isLoading = true;
    update();
    Response response = await reportsRepo.getAttritionReport(search ?? {});
    if (response.statusCode == 200 && response.body['status'] == "success") {
      attritionReportList = [];
      response.body['data']['data'].forEach((v) {
        attritionReportList.add(AttritionReportModel.fromJson(v));
      });
      if (response.body['summary'] != null) {
        attritionReportSummary = AttritionReportSummary.fromJson(response.body['summary']);
      }
    }
    isLoading = false;
    update();
  }

  Future<void> getExitReasonsReport({Map<String, dynamic>? search}) async {
    isLoading = true;
    update();
    Response response = await reportsRepo.getExitReasonsReport(search ?? {});
    if (response.statusCode == 200 && response.body['status'] == "success") {
      exitReasonReportList = [];
      response.body['data']['data'].forEach((v) {
        exitReasonReportList.add(ExitReasonReportModel.fromJson(v));
      });
      exitReasonReportSummary = ExitReasonReportSummary.fromJson(response.body['summary']);
    }
    isLoading = false;
    update();
  }

  Future<void> getEmployeeCostReport({Map<String, dynamic>? search}) async {
    isLoading = true;
    update();
    Response response = await reportsRepo.getEmployeeCostReport(search ?? {});
    if (response.statusCode == 200 && response.body['status'] == "success") {
      employeeCostReportList = [];
      response.body['data']['data'].forEach((v) {
        employeeCostReportList.add(EmployeeCostReportModel.fromJson(v));
      });
      employeeCostReportSummary = EmployeeCostReportSummary.fromJson(response.body['summary']);
    }
    isLoading = false;
    update();
  }

  Future<void> getTrainingReport({Map<String, dynamic>? search}) async {
    isLoading = true;
    update();
    Response response = await reportsRepo.getTrainingReport(search ?? {});
    if (response.statusCode == 200 && response.body['status'] == "success") {
      trainingReportList = [];
      response.body['data']['data'].forEach((v) {
        trainingReportList.add(TrainingReportModel.fromJson(v));
      });
      trainingReportSummary = TrainingReportSummary.fromJson(response.body['summary']);
    }
    isLoading = false;
    update();
  }

  Future<void> getAssetReport({Map<String, dynamic>? search}) async {
    isLoading = true;
    update();
    Response response = await reportsRepo.getAssetReport(search ?? {});
    if (response.statusCode == 200 && response.body['status'] == "success") {
      assetReportList = [];
      response.body['data']['data'].forEach((v) {
        assetReportList.add(AssetReportModel.fromJson(v));
      });
      assetReportSummary = AssetReportSummary.fromJson(response.body['summary']);
    }
    isLoading = false;
    update();
  }

  Future<void> exportReport({required String uri, Map<String, dynamic>? search}) async {
    isLoading = true;
    update();
    try {
      final token = Get.find<AuthController>().getUserToken();

      // Ensure the search map is mutable
      final Map<String, dynamic> queryParams = search != null ? Map.from(search) : {};
      queryParams['token'] = token;

      // Construct the full URL using Uri constructor for proper encoding
      final String baseUrl = AppConstants.baseUrl;
      final Uri baseUri = Uri.parse(baseUrl);
      
      final Uri url = Uri(
        scheme: baseUri.scheme,
        host: baseUri.host,
        port: baseUri.port,
        path: "${baseUri.path}$uri",
        queryParameters: queryParams.map((k, v) => MapEntry(k, v.toString())),
      );

      print("Launching Export URL: $url");

      // launchUrl returns true if successful, false otherwise.
      // We skip canLaunchUrl check because it often fails on Android 11+ without specific manifest entries,
      // while launchUrl itself might still succeed by delegating to the system.
      bool launched = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        // Try fallback to platform default if external application fails
        launched = await launchUrl(url, mode: LaunchMode.platformDefault);
      }

      if (!launched) {
        showToast(message: "Could not launch export URL. Please ensure a browser is installed.", toastType: ToastType.error);
      }
    } catch (e) {
      print("Export error: $e");
      showToast(message: "Export failed: $e", toastType: ToastType.error);
    }
    isLoading = false;
    update();
  }
}
