// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:vlr/main.dart';
import 'package:vlr/services/route_helper.dart';
import 'package:vlr/services/theme.dart';
import 'package:page_transition/page_transition.dart';
import 'package:toastification/toastification.dart';

class PriceConverter {
  static String convert(dynamic price) {
    if (price == null) return '₹ 0.00';
    String cleanPrice = price.toString().replaceAll(',', '');
    double val = double.tryParse(cleanPrice) ?? 0.0;
    return '₹ ${val.toStringAsFixed(2)}';
  }

  static String convertRound(dynamic price) {
    if (price == null) return '₹ 0';
    String cleanPrice = price.toString().replaceAll(',', '');
    double val = double.tryParse(cleanPrice) ?? 0.0;
    return '₹ ${val.toInt()}';
  }

  static String convertToNumberFormat(dynamic price) {
    if (price == null) return '₹ 0.00';
    num val = num.tryParse(price.toString().replaceAll(',', '')) ?? 0;
    final format = NumberFormat("#,##,##,##0.00", "en_IN");
    return '₹ ${format.format(val)}';
  }
}

Widget sizedBoxHeight({required double height}) {
  return SizedBox(
    height: height.h,
  );
}

Widget sizedBoxWidth({required double width}) {
  return SizedBox(
    width: width.w,
  );
}

class Helper {
  final BuildContext context;
  Helper(this.context);

  Size get size => MediaQuery.sizeOf(context);
  TextTheme get textTheme => Theme.of(context).textTheme;
}

String capitalize(String? s) {
  if (s == null || s.isEmpty) return "";
  return s[0].toUpperCase() + s.substring(1);
}

void navigate({
  PageTransitionType type = PageTransitionType.fade,
  required BuildContext context,
  required Widget page,
  bool isReplace = false,
  bool isRemoveUntil = false,
  Duration duration = const Duration(milliseconds: 300),
}) {
  if (isReplace) {
    Navigator.of(context).pushReplacement(
      getCustomRoute(
        child: page,
        type: type,
        duration: duration,
      ),
    );
  } else if (isRemoveUntil) {
    Navigator.of(context).pushAndRemoveUntil(
      getCustomRoute(
        child: page,
        type: type,
        duration: duration,
      ),
      (route) => false,
    );
  } else {
    Navigator.of(context).push(
      getCustomRoute(
        child: page,
        type: type,
        duration: duration,
      ),
    );
  }
}

void pop(BuildContext context, {dynamic data}) {
  Navigator.pop(context, data);
}

enum ToastType {
  info(ToastificationType.info),
  warning(ToastificationType.warning),
  error(ToastificationType.error),
  success(ToastificationType.success);

  const ToastType(this.value);
  final ToastificationType value;
}

void showToast({
  ToastType? toastType,
  required String message,
  String? description,
  ToastificationStyle? toastificationStyle,
  bool? typeCheck,
}) {
  final context = navigatorKey.currentContext;

  if (context == null) return;

  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;
  final isDark = theme.brightness == Brightness.dark;

  final resolvedType = toastType?.value ??
      ((typeCheck ?? false)
          ? ToastificationType.success
          : ToastificationType.error);

  // Select the accent color and icon according to toast type.
  late final Color accentColor;
  late final IconData iconData;

  if (resolvedType == ToastificationType.success) {
    accentColor = isDark
        ? const Color(0xFF4ADE80)
        : const Color(0xFF16A34A);
    iconData = Icons.check_circle_outline_rounded;
  } else if (resolvedType == ToastificationType.error) {
    accentColor = colorScheme.error;
    iconData = Icons.error_outline_rounded;
  } else if (resolvedType == ToastificationType.warning) {
    accentColor = isDark
        ? const Color(0xFFFBBF24)
        : const Color(0xFFF59E0B);
    iconData = Icons.warning_amber_rounded;
  } else {
    accentColor = colorScheme.primary;
    iconData = Icons.info_outline_rounded;
  }

  toastification.show(
    context: context,
    alignment: Alignment.topLeft,
    type: resolvedType,

    // Adapt the toast to the active theme.
    style: toastificationStyle ?? ToastificationStyle.minimal,
    backgroundColor: colorScheme.surface,
    foregroundColor: colorScheme.onSurface,
    primaryColor: accentColor,

    borderSide: BorderSide(
      color: colorScheme.outlineVariant,
    ),
    borderRadius: BorderRadius.circular(12),

    boxShadow: [
      BoxShadow(
        color: theme.shadowColor.withValues(
          alpha: isDark ? 0.25 : 0.08,
        ),
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
    ],

    title: Text(
      message,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: colorScheme.onSurface,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    ),

    description: description != null
        ? Text(
            description,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          )
        : null,

    icon: Icon(
      iconData,
      color: accentColor,
    ),

    autoCloseDuration: const Duration(seconds: 2),
  );
}

String getStringFromList(List<dynamic>? data) {
  String str = data.toString();
  return data.toString().substring(1, str.length - 1);
}



class AppConstants {
  String get getBaseUrl => baseUrl;
  set setBaseUrl(String url) => baseUrl = url;

  //TODO: Change Base Url
  // static String baseUrl = 'https://feetrackhrms.bestitcompanylucknow.com/api';
  static String baseUrl = 'https://app.feetrack.in/api';
  // static String baseUrl = 'https://test.feetrack.in/api';
  // static String baseUrl = 'http://192.168.1.5:9000/'; ///USE FOR LOCAL
  //TODO: Change Base Url
  static String appName = 'Feetrack Hrms';

  static const String agoraAppId = 'c87b710048c049f59570bd1895b7e561';

  static const String dashboard = '/hrms/dashboard';

  // Auth
  static const String registrationPost = '/partner/register';
  static const String loginPost = '/hrms/login';
  static const String logOutPost = '/hrms/logout';
  static const String updateFCMTokenPost = '/partner/fcm-token';
  static const String deleteAccountPost = ' /hrms/account/destroy';

  //* profile
  static const String getProfile = '/hrms/profile';
  static const String updateProfile = '/hrms/profile';

  //* Attendance
  static const String punchInAttendancePost = '/hrms/attendance/punch-in';
  static const String punchOutAttendancePost = '/hrms/attendance/punch-out';
  static const String todayAttendanceGet = '/hrms/attendance/today';
  static const String attendanceHistoryGet = '/hrms/attendance/history';
  static const String attendanceCalendarGet = '/hrms/attendance/calendar';
  static const String attendanceOverride = '/hrms/attendance/override';

  //* Attendance Team
  static const String todayTeamAttendanceGet = '/hrms/team-attendance/today';
  static const String teamEmployeesListGet = '/hrms/team-attendance/employees';
  static const String attendanceDetailsGet = '/hrms/attendance';
  static const String employeeAttendanceDetailsGet =
      '/hrms/team-attendance/history';

  //* Check list point
  static const String checkListPointGet = '/hrms/attendance/checklists';
  static const String submitCheckListPointGet = '/hrms/attendance/submit-checklist';

  //* Notice Board

  static const String getNoticeBoard = '/hrms/notices';
  static const String getNoticeBoardById = '/hrms/notices';

  //* Leave
  static const String applyLeavePost = '/hrms/leaves/apply';
  static const String getLeaves = '/hrms/leaves';
  static const String getTeamLeaves = '/hrms/team-leaves';

  //* Expense
  static const String applyExpensePost = '/hrms/expenses';
  static const String getExpenses = '/hrms/expenses';
  static const String getTeamExpenses = '/hrms/team-expenses';

  //
  static const double horizontalPadding = 16;
  static const double verticalPadding = 20;
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(
      horizontal: AppConstants.horizontalPadding,
      vertical: AppConstants.verticalPadding);

  // Shared Key
  static const String token = 'user_app_token';
  static const String userId = 'user_app_id';
  static const String razorpayKey = 'razorpay_key';
  static const String recentOrders = 'recent_orders';
  static const String isUser = 'is_user';
  static const String fcmToken = 'fcmToken';

  //Lead Management
  static const String addLead = '/hrms/leads';
  static const String customerVisits = '/hrms/customer-visits';
  static const String leadOrders = '/hrms/lead-orders';
  static const String leadOrderCalculate = '/hrms/lead-orders/calculate';
  static const String leadOrderTabs = '/hrms/lead-orders/tabs';
  static const String wonLeads = '/hrms/new-lead-order';
  static const String leadOrderRecovery = '/hrms/lead-orders-recovery';
  static const String leadOrderRecoveryHistory = '/hrms/lead-orders-recovery-history';

  //Task Management
  static const String taskStatuses = '/hrms/settings/task-statuses';
  static const String tasks = '/hrms/tasks';
  static const String assignableUsers = '/hrms/tasks/assignable-users';
  static const String teamTasks = '/hrms/team-tasks';
  static const String employeesListing = '/hrms/employees';

  // Staff Management
  static const String staff = '/hrms/staff';
  static const String staffProfile = '/hrms/staff/';
  static const String staffEmployeesListing = '/hrms/employees-listing';

  // Salary Management
  static const String salaryStructure = '/hrms/employees/';
  static const String salaryStructuresList = '/hrms/payroll/salary-structures';

  // Branch & Department Management
  static const String branches = '/hrms/branches';
  static const String departments = '/hrms/departments';
  static const String departmentsListing = '/hrms/departments-listing';

  // Holiday Management
  static const String holidays = '/hrms/settings/holidays';
  
  // Commission Management
  static const String commissionLevels = '/hrms/settings/commission-levels';
  static const String commissionHistory = '/hrms/commissions/history';
  static const String processCommission = '/hrms/commissions/process';
  
  // Pipeline Management
  static const String pipelineStages = '/hrms/settings/pipeline-stages';

  // Attendance Checklist Management
  static const String attendanceChecklists = '/hrms/settings/attendance-checklists';

  // Product & Category Management
  static const String productCategories = '/hrms/product-categories';
  static const String products = '/hrms/products';

  // Work Shift Management
  static const String workShifts = '/hrms/work-shifts';

  // Role Management
  static const String roles = '/hrms/roles';
  static const String permissions = '/hrms/permissions';

  // Performance Management
  static const String performanceStaff = '/hrms/settings/performance/staff';
  static const String performanceStaffDetail = '/hrms/settings/performance/staff/';

  // Settings
  static const String leaveCategories = '/hrms/settings/leave-categories';
  static const String expenseCategories = '/hrms/settings/expense-categories';
  static const String payslipConfig = '/hrms/settings/payslip-config';
  // Payroll Management
  static const String myPayroll = '/hrms/payroll/my';
  static const String myTargets = '/hrms/my-targets';
  static const String processPayroll = '/hrms/payroll/process';
  static const String payrollDrafts = '/hrms/payroll/drafts';
  static const String payrollApproval = '/hrms/payroll/approvals'; // Assuming based on standard
  static const String advancePayments = '/hrms/payroll/advance-payments';
  static const String payrollReports = '/hrms/payroll/reports';
  static const String advancePaymentsList = '/hrms/advance-payments';
  static const String advanceReports = '/hrms/advance-reports';

  // Attrition Management
  static const String attrition = '/hrms/attrition';
  static const String attritionExitReasons = '/hrms/attrition/exit-reasons';

  // Reports
  static const String staffReport = '/hrms/reports/staff';
  static const String attendanceReport = '/hrms/reports/attendence';
  static const String leaveReport = '/hrms/reports/leaves';
  static const String expenseReport = '/hrms/reports/expenses';
  static const String taskReport = '/hrms/reports/tasks';
  static const String leadReport = '/hrms/reports/leads';
  static const String orderReport = '/hrms/reports/orders';
  static const String payrollReport = '/hrms/reports/payroll';
  static const String recoveryReport = '/hrms/reports/recovery';
  static const String noticeReport = '/hrms/reports/notice';
  static const String productCategoryReport = '/hrms/reports/product-category';
  static const String productReport = '/hrms/reports/product';
  static const String salaryReport = '/hrms/reports/salary-management';
  static const String commissionReport = '/hrms/reports/commissions';
  static const String pipReport = '/hrms/reports/pip';
  static const String recruitmentReport = '/hrms/reports/recruitment';
  static const String probationReport = '/hrms/reports/probation';
  static const String resignationExitReport = '/hrms/reports/resignation-exit';
  static const String documentReport = '/hrms/reports/document';
  static const String grievanceDisciplineReport = '/hrms/reports/grievance-discipline';
  static const String attritionReport = '/hrms/reports/attrition';
  static const String dailyWorkReports = '/hrms/daily-work-reports';
  static const String pendingTasksForReport = '/hrms/daily-work-reports/pending-tasks';
  static const String companyDocuments = '/hrms/company-documents';
  static const String processNotes = '/hrms/process-notes';
  static const String exitReasonsReport = '/hrms/reports/exit-reasons';
  static const String employeeCostReport = '/hrms/reports/employee-cost';
  static const String trainingReport = '/hrms/reports/training';
  static const String assetReport = '/hrms/reports/assets';

  static const String trainingDashboard = '/hrms/training/dashboard';
  static const String trainingPrograms = '/hrms/training/programs';
  static const String trainingAssignments = '/hrms/training/assignments';
  static const String assets = '/hrms/assets';
  static const String assetGenerateCode = '/hrms/assets/generate-code';
  static const String pips = '/hrms/pips';
  static const String recruitments = '/hrms/recruitments';
  static const String jobPosts = '/hrms/job-posts';
  static const String jobPostsHistory = '/hrms/job-posts-history';
  static const String jobPlans = '/hrms/job-plans';
  static const String jobTemplates = '/hrms/job-templates';
  static const String appliedJobs = '/hrms/applied-jobs';
  static const String probations = '/hrms/probations';
  static const String exits = '/hrms/exits';
  static const String documents = '/hrms/documents';
  static const String grievances = '/hrms/grievances';

  // Export Reports
  static const String staffExport = '/hrms/reports/staff/export';
  static const String attendanceExport = '/hrms/reports/attendance/export';
  static const String leaveExport = '/hrms/reports/leaves/export';
  static const String expenseExport = '/hrms/reports/expenses/export';
  static const String taskExport = '/hrms/reports/tasks/export';
  static const String leadExport = '/hrms/reports/leads/export';
  static const String orderExport = '/hrms/reports/orders/export';
  static const String payrollExport = '/hrms/reports/payroll/export';
  static const String recoveryExport = '/hrms/reports/recovery/export';
  static const String noticeExport = '/hrms/reports/notice/export';
  static const String productCategoryExport = '/hrms/reports/product-category/export';
  static const String productExport = '/hrms/reports/product/export';
  static const String salaryExport = '/hrms/reports/salary-management/export';
  static const String commissionExport = '/hrms/reports/commissions/export';
  static const String pipExport = '/hrms/reports/pip/export';
  static const String recruitmentExport = '/hrms/reports/recruitment/export';
  static const String probationExport = '/hrms/reports/probation/export';
  static const String resignationExitExport = '/hrms/reports/resignation-exit/export';
  static const String documentExport = '/hrms/reports/document/export';
  static const String grievanceDisciplineExport = '/hrms/reports/grievance-discipline/export';
  static const String attritionExport = '/hrms/reports/attrition/export';
  static const String exitReasonsExport = '/hrms/reports/exit-reasons/export';
  static const String employeeCostExport = '/hrms/reports/employee-cost/export';
  static const String trainingExport = '/hrms/reports/training/export';
  static const String assetExport = '/hrms/reports/assets/export';
}
