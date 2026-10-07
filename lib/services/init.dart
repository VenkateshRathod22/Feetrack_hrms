import 'dart:developer';
import 'package:get/instance_manager.dart';
import 'package:vlr/controllers/attendance_controller.dart';
import 'package:vlr/controllers/basic_controller.dart';
import 'package:vlr/controllers/dashboard_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vlr/controllers/lead_controller.dart';
import 'package:vlr/controllers/leave_controller.dart';
import 'package:vlr/controllers/notice_controller.dart';
import 'package:vlr/controllers/task_controller.dart';
import 'package:vlr/controllers/about_company_controller.dart';
import 'package:vlr/controllers/task_status_controller.dart';
import 'package:vlr/data/repositories/about_company_repo.dart';
import 'package:vlr/data/repositories/attendence_repo.dart';
import 'package:vlr/data/repositories/lead_repo.dart';
import 'package:vlr/controllers/expense_controller.dart';
import 'package:vlr/data/repositories/expense_repo.dart';
import 'package:vlr/data/repositories/leave_repo.dart';
import 'package:vlr/data/repositories/notice_repo.dart';
import 'package:vlr/data/repositories/task_repo.dart';
import 'package:vlr/controllers/braches_controller.dart';
import 'package:vlr/controllers/department_controller.dart';
import 'package:vlr/data/repositories/branch_repo.dart';
import 'package:vlr/data/repositories/department_repo.dart';
import 'package:vlr/controllers/salary_controller.dart';
import 'package:vlr/data/repositories/salary_repo.dart';
import 'package:vlr/controllers/staff_contoller.dart';
import 'package:vlr/data/repositories/staff_repo.dart';
import 'package:vlr/controllers/category_controller.dart';
import 'package:vlr/data/repositories/category_repo.dart';
import 'package:vlr/controllers/product_controller.dart';
import 'package:vlr/data/repositories/product_repo.dart';
import 'package:vlr/controllers/work_shift_controller.dart';
import 'package:vlr/data/repositories/work_shift_repo.dart';
import 'package:vlr/controllers/role_controller.dart';
import 'package:vlr/data/repositories/role_repo.dart';
import 'package:vlr/controllers/hrms_permission_controller.dart';
import 'package:vlr/data/repositories/permission_repo.dart';
import 'package:vlr/controllers/holiday_controller.dart';
import 'package:vlr/data/repositories/holiday_repo.dart';
import 'package:vlr/controllers/commission_level_controller.dart';
import 'package:vlr/data/repositories/commission_level_repo.dart';
import 'package:vlr/controllers/pipeline_stage_controller.dart';
import 'package:vlr/data/repositories/pipeline_stage_repo.dart';
import 'package:vlr/controllers/attendance_checklist_controller.dart';
import 'package:vlr/data/repositories/attendance_checklist_repo.dart';
import 'package:vlr/controllers/leave_category_controller.dart';
import 'package:vlr/data/repositories/leave_category_repo.dart';
import 'package:vlr/controllers/expense_category_controller.dart';
import 'package:vlr/data/repositories/expense_category_repo.dart';
import 'package:vlr/controllers/payslip_config_controller.dart';
import 'package:vlr/data/repositories/payslip_config_repo.dart';
import 'package:vlr/controllers/commission_controller.dart';
import 'package:vlr/data/repositories/commission_repo.dart';
import 'package:vlr/controllers/payroll_controller.dart';
import 'package:vlr/data/repositories/payroll_repo.dart';
import 'package:vlr/controllers/reports_controller.dart';
import 'package:vlr/controllers/pip_controller.dart';
import 'package:vlr/controllers/recruitment_controller.dart';
import 'package:vlr/controllers/probation_controller.dart';
import 'package:vlr/controllers/resignation_exit_controller.dart';
import 'package:vlr/controllers/document_controller.dart';
import 'package:vlr/controllers/discipline_controller.dart';
import 'package:vlr/controllers/attrition_controller.dart';
import 'package:vlr/controllers/exit_reason_controller.dart';
import 'package:vlr/controllers/employee_cost_controller.dart';
import 'package:vlr/controllers/training_report_controller.dart';
import 'package:vlr/controllers/asset_controller.dart';
import 'package:vlr/controllers/daily_report_controller.dart';
import 'package:vlr/controllers/advance_payment_controller.dart';
import 'package:vlr/data/repositories/advance_payment_repo.dart';
import 'package:vlr/controllers/my_target_controller.dart';
import 'package:vlr/data/repositories/target_repo.dart';
import 'package:vlr/data/repositories/daily_report_repo.dart';
import 'package:vlr/data/repositories/dashboard_repo.dart';
import 'package:vlr/data/repositories/reports_repo.dart';
import '../controllers/auth_controller.dart';
import '../controllers/permission_controller.dart';
import '../data/api/api_client.dart';
import '../data/repositories/auth_repo.dart';
import '../data/repositories/basic_repo.dart';
import 'constants.dart';

class Init {
  initialize() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    Get.lazyPut<SharedPreferences>(() => sharedPreferences);

    try {
      // ApiClient
      Get.lazyPut(() => ApiClient(
          appBaseUrl: AppConstants.baseUrl,
          sharedPreferences: sharedPreferences));

      Get.lazyPut(() => PermissionController());

      // Get Repo's...
      Get.lazyPut(
          () => AuthRepo(sharedPreferences: Get.find(), apiClient: Get.find()));
      Get.lazyPut(() => BasicRepo(dioClient: Get.find()));
      Get.lazyPut(() => AttendanceRepo(apiClient: Get.find()));
      Get.lazyPut(() => TaskRepo(apiClient: Get.find()));
      Get.lazyPut(() => LeadRepo(apiClient: Get.find()));
      Get.lazyPut(() => LeaveRepo(apiClient: Get.find()));
      Get.lazyPut(() => NoticeRepo(apiClient: Get.find()));
      Get.lazyPut(() => ExpenseRepo(apiClient: Get.find()));
      Get.lazyPut(() => StaffRepo(apiClient: Get.find()));
      Get.lazyPut(() => SalaryRepo(apiClient: Get.find()));
      Get.lazyPut(() => BranchRepo(apiClient: Get.find()));
      Get.lazyPut(() => DepartmentRepo(apiClient: Get.find()));
      Get.lazyPut(() => CategoryRepo(apiClient: Get.find()));
      Get.lazyPut(() => ProductRepo(apiClient: Get.find()));
      Get.lazyPut(() => WorkShiftRepo(apiClient: Get.find()));
      Get.lazyPut(() => RoleRepo(apiClient: Get.find()));
      Get.lazyPut(() => PermissionRepo(apiClient: Get.find()));
      Get.lazyPut(() => HolidayRepo(apiClient: Get.find()));
      Get.lazyPut(() => CommissionLevelRepo(apiClient: Get.find()));
      Get.lazyPut(() => PipelineStageRepo(apiClient: Get.find()));
      Get.lazyPut(() => AttendanceChecklistRepo(apiClient: Get.find()));
      Get.lazyPut(() => LeaveCategoryRepo(apiClient: Get.find()));
      Get.lazyPut(() => ExpenseCategoryRepo(apiClient: Get.find()));
      Get.lazyPut(() => PayslipConfigRepo(apiClient: Get.find()));
      Get.lazyPut(() => CommissionRepo(apiClient: Get.find()));
      Get.lazyPut(() => PayrollRepo(apiClient: Get.find()));
      Get.lazyPut(() => DashBoardRepo(apiClient: Get.find()));
      Get.lazyPut(() => ReportsRepo(apiClient: Get.find()));
      Get.lazyPut(() => AboutCompanyRepo(apiClient: Get.find()));
      Get.lazyPut(() => DailyReportRepo(apiClient: Get.find()));
      Get.lazyPut(() => TargetRepo(apiClient: Get.find()));
      Get.lazyPut(() => AdvancePaymentRepo(apiClient: Get.find()));

      // Get Controller's...
      Get.lazyPut(() => DashBoardController(dashBoardRepo: Get.find()), fenix: true);
      Get.lazyPut(() => BasicController(basicRepo: Get.find()), fenix: true);
      Get.lazyPut(() => AuthController(authRepo: Get.find()), fenix: true);
      Get.lazyPut(() => AttendanceController(attendanceRepo: Get.find()), fenix: true);
      Get.lazyPut(() => TaskController(taskRepo: Get.find()), fenix: true);
      Get.lazyPut(() => LeadController(leadRepo: Get.find()), fenix: true);
      Get.lazyPut(() => LeaveController(leaveRepo: Get.find()), fenix: true);
      Get.lazyPut(() => NoticeController(noticeRepo: Get.find()), fenix: true);
      Get.lazyPut(() => ExpenseController(expenseRepo: Get.find()), fenix: true);
      Get.lazyPut(() => StaffController(staffRepo: Get.find()), fenix: true);
      Get.lazyPut(() => SalaryController(salaryRepo: Get.find()), fenix: true);
      Get.lazyPut(() => BrachesController(branchRepo: Get.find()), fenix: true);
      Get.lazyPut(() => DepartmentController(departmentRepo: Get.find()), fenix: true);
      Get.lazyPut(() => CategoryController(categoryRepo: Get.find()), fenix: true);
      Get.lazyPut(() => ProductController(productRepo: Get.find()), fenix: true);
      Get.lazyPut(() => WorkShiftController(workShiftRepo: Get.find()), fenix: true);
      Get.lazyPut(() => RoleController(roleRepo: Get.find(), permissionRepo: Get.find()), fenix: true);
      Get.lazyPut(() => HrmsPermissionController(permissionRepo: Get.find()), fenix: true);
      Get.lazyPut(() => HolidayController(holidayRepo: Get.find()), fenix: true);
      Get.lazyPut(() => CommissionLevelController(commissionLevelRepo: Get.find()), fenix: true);
      Get.lazyPut(() => PayrollController(payrollRepo: Get.find()), fenix: true);
      Get.lazyPut(() => PipelineStageController(pipelineStageRepo: Get.find()), fenix: true);
      Get.lazyPut(() => AttendanceChecklistController(attendanceChecklistRepo: Get.find()), fenix: true);
      Get.lazyPut(() => LeaveCategoryController(leaveCategoryRepo: Get.find()), fenix: true);
      Get.lazyPut(() => ExpenseCategoryController(expenseCategoryRepo: Get.find()), fenix: true);
      Get.lazyPut(() => PayslipConfigController(payslipConfigRepo: Get.find()), fenix: true);
      Get.lazyPut(() => CommissionController(commissionRepo: Get.find()), fenix: true);
      Get.lazyPut(() => ReportsController(reportsRepo: Get.find()), fenix: true);
      Get.lazyPut(() => AboutCompanyController(aboutCompanyRepo: Get.find()), fenix: true);
      Get.lazyPut(() => TaskStatusController(taskRepo: Get.find()), fenix: true);
      Get.lazyPut(() => PipController(reportsRepo: Get.find()), fenix: true);
      Get.lazyPut(() => RecruitmentController(reportsRepo: Get.find()), fenix: true);
      Get.lazyPut(() => ProbationController(reportsRepo: Get.find()), fenix: true);
      Get.lazyPut(() => ResignationExitController(reportsRepo: Get.find()), fenix: true);
      Get.lazyPut(() => DocumentController(reportsRepo: Get.find()), fenix: true);
      Get.lazyPut(() => DisciplineController(reportsRepo: Get.find()), fenix: true);
      Get.lazyPut(() => AttritionController(reportsRepo: Get.find()), fenix: true);
      Get.lazyPut(() => ExitReasonController(reportsRepo: Get.find()), fenix: true);
      Get.lazyPut(() => EmployeeCostController(reportsRepo: Get.find()), fenix: true);
      Get.lazyPut(() => TrainingReportController(reportsRepo: Get.find()), fenix: true);
      Get.lazyPut(() => AssetController(reportsRepo: Get.find()), fenix: true);
      Get.lazyPut(() => DailyReportController(dailyReportRepo: Get.find()), fenix: true);
      Get.lazyPut(() => MyTargetController(targetRepo: Get.find()), fenix: true);
      Get.lazyPut(() => AdvancePaymentController(advancePaymentRepo: Get.find()));
    } catch (e) {
      log('---- ${e.toString()} ----', name: "ERROR AT initialize()");
    }
  }
}
