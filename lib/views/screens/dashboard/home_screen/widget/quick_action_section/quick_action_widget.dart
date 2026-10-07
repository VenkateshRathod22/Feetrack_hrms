import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vlr/generated/assets.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/screens/DailyReport/daily_report_screen.dart';
import 'package:vlr/views/screens/lead/lead_create/lead_section_screen.dart';
import 'package:vlr/views/screens/payroll/payroll_option_screen.dart';
import 'package:vlr/views/screens/process_commissions/process_commions_screen.dart';
import 'package:vlr/views/screens/recruitment/all_job_section_screen.dart';
import 'package:vlr/views/screens/staff/staff_screen.dart';
import 'package:vlr/views/screens/salary_management/salary_screen.dart';
import 'package:vlr/views/screens/branches/branches_screen.dart';
import 'package:vlr/views/screens/department/department_screen.dart';
import 'package:vlr/views/screens/permission/permission_screen.dart';
import 'package:vlr/views/screens/role/role_screen.dart';
import 'package:vlr/views/screens/task/create_new_task/task_tabar_screen.dart';

import 'package:vlr/views/screens/reports/reports_section_screen.dart';
import 'package:vlr/views/screens/pip/pip_screen.dart';
import 'package:vlr/views/screens/recruitment/recruitment_screen.dart';
import 'package:vlr/views/screens/resignation_exit/resignation_exit_screen.dart';
import 'package:vlr/views/screens/discipline/discipline_screen.dart';
import 'package:vlr/views/screens/attendance/attendance_history/attendance_history_screen.dart';
import 'package:vlr/views/screens/performance/performance_screen.dart';

import 'package:vlr/views/screens/employee_cost/employee_cost_report_screen.dart';
import 'package:vlr/views/screens/work_shift/work_shift_screen.dart';
import 'package:vlr/services/permission_helper.dart';

import 'package:vlr/views/screens/performance/my_target_screen.dart';
import 'package:vlr/views/screens/advance_payment/advance_payment_screen.dart';

import '../../../../asset_managment/asset_screen.dart';
import '../../../../attrition/atribution_screen.dart';
import '../../../../document/document_screen.dart';
import '../../../../expence/apply_expence_screen.dart';
import '../../../../probation/probation_screen.dart';
import '../../../../training_management/training_programs_list_screen.dart';

class QuickActionWidget extends StatelessWidget {
  final QuickActionModel quickActionModel;

  const QuickActionWidget({
    super.key,
    required this.quickActionModel,
  });

  @override
  Widget build(BuildContext context) {
    final color = quickActionModel.color;

    return PermissionWrapper(
      permission: quickActionModel.requiredPermission,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: quickActionModel.onTap,
          borderRadius: BorderRadius.circular(18.r),
          splashColor: color.withValues(alpha: 0.12),
          highlightColor: color.withValues(alpha: 0.05),
          child: Container(
            width: 80.w,
            padding: EdgeInsets.symmetric(
              horizontal: 6.w,
              vertical: 8.h,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(18.r),
              border: Border.all(
                color: color.withValues(alpha: 0.10),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// Icon Background
                Container(
                  height: 40.h,
                  width: 40.w,
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14.r),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        color.withValues(alpha: 0.20),
                        color.withValues(alpha: 0.08),
                      ],
                    ),
                    border: Border.all(
                      color: color.withValues(alpha: 0.12),
                    ),
                  ),
                  child: quickActionModel.icon.endsWith('.svg')
                      ? SvgPicture.asset(
                    quickActionModel.icon,
                    colorFilter: ColorFilter.mode(
                      color,
                      BlendMode.srcIn,
                    ),
                  )
                      : Image.asset(
                    quickActionModel.icon,
                    color: color,
                  ),
                ),

                SizedBox(height: 4.h),

                /// Title
                CustomText(
                  quickActionModel.title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Helper(context).textTheme.titleMedium?.copyWith(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class QuickActionModel {
  final String icon;
  final String title;
  final Color color;
  final Function()? onTap;
  final dynamic requiredPermission; // Can be String or List<String>

  QuickActionModel({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
    this.requiredPermission,
  });
}

List<QuickActionModel> quickActionModelList({required BuildContext context}) =>
    [
      QuickActionModel(
          icon: Assets.svgsCalender,
          title: "Daily Report",
          color: Colors.blue,
          requiredPermission: ["dailyreport_viewown", "dailyreport_viewany", "dailyreport_viewteam", "report_viewown", "report_viewany"],
          onTap: () {
            navigate(context: context, page: const DailyReportScreen());
          }),
      QuickActionModel(
          icon: Assets.svgsCalender,
          title: "Attendance",
          color: Colors.blue,
          requiredPermission: ["attendance_viewown", "attendance_viewany", "attendance_viewteam"],
          onTap: () {
            navigate(context: context, page: const AttendanceHistoryScreen());
          }),
      QuickActionModel(
          icon: Assets.svgsGraph,
          title: "Performance",
          color: Colors.orange,
          requiredPermission: ["performance_viewown", "performance_viewany", "performance_viewteam", "target_viewown", "target_viewany"],
          onTap: () {
            navigate(context: context, page: const PerformanceScreen());
          }),
      QuickActionModel(
          icon: Assets.svgsLocation,
          title: "Commissions",
          color: Colors.greenAccent,
          requiredPermission: ["commission_viewown", "commission_viewany", "commission_viewteam", "processcommission_viewown", "processcommission_viewany"],
          onTap: () {
            navigate(context: context, page: const ProcessCommionsScreen());
          }),
      QuickActionModel(
        icon: Assets.svgsPerson2,
        title: "Lead Create",
        color: tertiaryColor,
        requiredPermission: ["lead_create", "lead_viewown", "lead_viewany", "lead_viewteam"],
        onTap: () {
          navigate(context: context, page: const LeadSectionScreen());
        },
      ),
      QuickActionModel(
        icon: Assets.svgsPerson2,
        title: "Payroll",
        color: tertiaryColor,
        requiredPermission: ["payroll_viewown", "payroll_viewany", "payroll_viewteam", "salary_viewown", "salary_viewany", "salary_viewteam"],
        onTap: () {
          navigate(context: context, page: const PayrollOptionScreen());
        },
      ),
      QuickActionModel(
        icon: Assets.svgsDocument,
        title: "Order Create",
        color: Colors.orange.shade400,
        requiredPermission: ["leadorder_create", "leadorder_viewany", "leadorder_viewown", "leadorder_viewteam"],
        onTap: () {},
      ),
      QuickActionModel(
        icon: Assets.expence,
        title: "Advance Pay",
        color: Colors.amber.shade700,
        requiredPermission: ["advancepayment_viewown", "advancepayment_viewany", "advancepayment_viewteam", "payroll_viewown", "payroll_viewany", "salary_viewown"],
        onTap: () {
          navigate(context: context, page: const AdvancePaymentScreen());
        },
      ),
      QuickActionModel(
        icon: Assets.svgsList,
        title: "My Target",
        color: Colors.purple.shade500,
        requiredPermission: ["target_viewown", "target_viewany", "target_viewteam"],
        onTap: () {
          navigate(context: context, page: const MyTargetScreen());
        },
      ),
      QuickActionModel(
        icon: Assets.svgsGraph,
        title: "Reports",
        color: greenDark,
        requiredPermission: ["view-own-reports", "viewany-reports", "report_viewown", "report_viewany", "report_viewteam", "reports_viewany", "reports_viewown"],
        onTap: () {
          navigate(context: context, page: const ReportsSectionScreen());
        },
      ),
      QuickActionModel(
        icon: Assets.expence,
        title: "Expense",
        color: greenDark,
        requiredPermission: ["expense_viewown", "expense_viewany", "expense_viewteam"],
        onTap: () {
          navigate(context: context, page: const ApplyExpenceScreen());
        },
      ),
      QuickActionModel(
        icon: Assets.svgsTask,
        title: "Task",
        color: tertiaryColor,
        requiredPermission: ["task_viewown", "task_viewany", "task_viewteam"],
        onTap: () {
          navigate(context: context, page: const TaskTabarScreen());
        },
      ),
      QuickActionModel(
        icon: Assets.svgsPerson,
        title: "Staff",
        color: primaryColor,
        requiredPermission: ["staff_viewany", "staff_viewown", "staff_viewteam"],
        onTap: () {
          navigate(context: context, page: const StaffScreen());
        },
      ),
      QuickActionModel(
        icon: Assets.svgsCheckList,
        title: "Salary",
        color: Colors.green,
        requiredPermission: ["salary_viewown", "salary_viewany", "salary_viewteam", "salary_viewbranch", "payroll_viewown", "payroll_viewany"],
        onTap: () {
          navigate(context: context, page: const SalaryScreen());
        },
      ),
      QuickActionModel(
        icon: Assets.svgsCheckCircle,
        title: "Permission",
        color: Colors.green,
        requiredPermission: ["role_viewany", "role_viewown", "role_viewteam", "permission_viewany", "permission_viewown"],
        onTap: () {
          navigate(context: context, page: const PermissionScreen());
        },
      ),
      QuickActionModel(
        icon: Assets.svgsMegaphone,
        title: "Role",
        color: Colors.green,
        requiredPermission: ["role_viewany", "role_viewown", "role_viewteam"],
        onTap: () {
          navigate(context: context, page: const RoleScreen());
        },
      ),
      QuickActionModel(
        icon: Assets.svgsLocationOutline,
        title: "Branches",
        color: Colors.blue,
        requiredPermission: ["branch_viewany", "branch_viewown", "branch_viewteam"],
        onTap: () {
          navigate(context: context, page: const BranchesScreen());
        },
      ),
      QuickActionModel(
        icon: Assets.svgsSession,
        title: "Departments",
        color: Colors.orange,
        requiredPermission: ["department_viewany", "department_viewown", "department_viewteam"],
        onTap: () {
          navigate(context: context, page: const DepartmentScreen());
        },
      )
    ];

List<QuickActionModel> managementActions1({required BuildContext context}) => [
      QuickActionModel(
        icon: Assets.svgsGraph,
        title: "Attrition Analytics",
        color: Colors.blueAccent,
        requiredPermission: ["attrition_viewany", "attrition_viewown", "attrition_viewteam", "atribution_viewany", "atribution_viewown"],
        onTap: () => navigate(context: context, page: const AttritionScreen()),
      ),
      QuickActionModel(
        icon: Assets.svgsCheckList,
        title: "Employee Cost",
        color: Colors.greenAccent,
        requiredPermission: ["employeecost_viewany", "employeecost_viewown", "employeecost_viewteam"],
        onTap: () => navigate(context: context, page: const EmployeeCostReportScreen()),
      ),
      QuickActionModel(
        icon: Assets.svgsSession,
        title: "Training Mgmt",
        color: Colors.amberAccent,
        requiredPermission: ["training_viewany", "training_viewown", "training_viewteam", "trainingprogram_viewany", "trainingprogram_viewown"],
        onTap: () => navigate(context: context, page: const TrainingProgramsListScreen()),
      ),
      QuickActionModel(
        icon: Assets.svgsDocument,
        title: "Asset Mgmt",
        color: Colors.lime,
        requiredPermission: ["asset_viewany", "asset_viewown", "asset_viewteam", "assetmanagement_viewany"],
        onTap: () => navigate(context: context, page: const AssetScreen()),
      ),
      QuickActionModel(
        icon: Assets.svgsDocument,
        title: "Work Shift",
        color: Colors.lime,
        requiredPermission: ["shift_viewany", "shift_viewown", "shift_viewteam", "workshift_viewany", "workshift_viewown", "work_shift_viewany"],
        onTap: () => navigate(context: context, page: const WorkShiftScreen()),
      ),
      QuickActionModel(
        icon: Assets.svgsGraph,
        title: "PIP Plan",
        color: Colors.redAccent,
        requiredPermission: ["pip_viewany", "pip_viewown", "pip_viewteam"],
        onTap: () => navigate(context: context, page: const PipScreen()),
      ),
    ];

List<QuickActionModel> managementActions2({required BuildContext context}) => [
      QuickActionModel(
        icon: Assets.svgsPerson,
        title: "Recruitment",
        color: Colors.indigoAccent,
        requiredPermission: [
          "recruitment_viewany", "recruitment_viewown", "recruitment_viewteam",
          "jobpost_viewany", "jobpost_viewown", "jobpost_viewteam", "jobpost_viewbranch",
          "appliedjobpost_viewany", "appliedjobpost_viewown", "appliedjobpost_viewteam", "appliedjobpost_viewbranch"
        ],
        onTap: () => navigate(context: context, page: const AllJobSectionScreen()),
      ),
      QuickActionModel(
        icon: Assets.svgsClock,
        title: "Probation & Assets",
        color: Colors.deepPurpleAccent,
        requiredPermission: ["probation_viewany", "probation_viewown", "probation_viewteam"],
        onTap: () => navigate(context: context, page: const ProbationtScreen()),
      ),
      QuickActionModel(
        icon: Assets.svgsLogout,
        title: "Resignation & Exit",
        color: Colors.red,
        requiredPermission: ["resignationexit_viewany", "resignationexit_viewown", "resignationexit_viewteam", "resignation_viewany", "resignation_viewown", "exit_viewany", "exit_viewown"],
        onTap: () => navigate(context: context, page: const ResignationExitScreen()),
      ),
      QuickActionModel(
        icon: Assets.svgsDocument,
        title: "Documents & KYC",
        color: Colors.blueGrey,
        requiredPermission: ["document_viewany", "document_viewown", "document_viewteam", "documentreport_viewany"],
        onTap: () => navigate(context: context, page: const DocumentScreen()),
      ),
      QuickActionModel(
        icon: Assets.svgsInfo,
        title: "Grievance & Disc.",
        color: Colors.orangeAccent,
        requiredPermission: ["grievance_viewany", "grievance_viewown", "grievance_viewteam", "discipline_viewany", "discipline_viewown"],
        onTap: () => navigate(context: context, page: const DisciplineScreen()),
      ),
    ];
