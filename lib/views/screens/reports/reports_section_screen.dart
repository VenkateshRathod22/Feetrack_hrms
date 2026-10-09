import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/auth_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/screens/reports/staff_report_screen.dart';
import 'package:vlr/views/screens/reports/attendance_report_screen.dart';
import 'package:vlr/views/screens/reports/leave_report_screen.dart';
import 'package:vlr/views/screens/reports/expense_report_screen.dart';
import 'package:vlr/views/screens/reports/task_report_screen.dart';
import 'package:vlr/views/screens/reports/lead_report_screen.dart';
import 'package:vlr/views/screens/reports/order_report_screen.dart';
import 'package:vlr/views/screens/reports/recovery_report_screen.dart';
import 'package:vlr/views/screens/reports/notice_report_screen.dart';
import 'package:vlr/views/screens/reports/product_category_report_screen.dart';
import 'package:vlr/views/screens/reports/product_report_screen.dart';
import 'package:vlr/views/screens/reports/salary_report_screen.dart';
import 'package:vlr/views/screens/reports/commission_report_screen.dart';
import 'package:vlr/views/screens/reports/payroll_report_screen.dart';
import 'package:vlr/views/screens/reports/pip_report_screen.dart';
import 'package:vlr/views/screens/reports/recruitment_report_screen.dart';
import 'package:vlr/views/screens/reports/probation_report_screen.dart';
import 'package:vlr/views/screens/reports/resignation_exit_report_screen.dart';
import 'package:vlr/views/screens/reports/document_report_screen.dart';
import 'package:vlr/views/screens/reports/grievance_discipline_report_screen.dart';
import 'package:vlr/views/screens/reports/attrition_report_screen.dart';
import 'package:vlr/views/screens/reports/exit_reasons_report_screen.dart';
import 'package:vlr/views/screens/reports/employee_cost_report_screen.dart';
import 'package:vlr/views/screens/reports/training_report_screen.dart';
import 'package:vlr/views/screens/reports/asset_report_screen.dart';

class ReportsSectionScreen extends StatelessWidget {
  const ReportsSectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: CustomText(
          "Reports Dashboard",
          style: Helper(context).textTheme.titleMedium?.copyWith(fontSize: 18.sp),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: white,
        surfaceTintColor: Colors.transparent,
        leading: Navigator.canPop(context) ? IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back),
        ) : null,
      ),
      body: GetBuilder<AuthController>(builder: (authController) {
        final List<_ReportOption> reports = [
          _ReportOption(
            title: "Staff",
            icon: Icons.people_rounded,
            permission: "staff_viewany",
            page: const StaffReportScreen(),
            color: Colors.blue,
          ),
          _ReportOption(
            title: "Attendance",
            icon: Icons.calendar_month_rounded,
            permission: "attendance_viewany",
            page: const AttendanceReportScreen(),
            color: Colors.orange,
          ),
          _ReportOption(
            title: "Leaves",
            icon: Icons.time_to_leave_rounded,
            permission: "leave_viewany",
            page: const LeaveReportScreen(),
            color: Colors.purple,
          ),
          _ReportOption(
            title: "Expenses",
            icon: Icons.account_balance_wallet_rounded,
            permission: "expense_viewany",
            page: const ExpenseReportScreen(),
            color: Colors.red,
          ),
          _ReportOption(
            title: "Tasks",
            icon: Icons.task_alt_rounded,
            permission: "task_viewany",
            page: const TaskReportScreen(),
            color: Colors.teal,
          ),
          _ReportOption(
            title: "Leads",
            icon: Icons.leaderboard_rounded,
            permission: "lead_viewany",
            page: const LeadReportScreen(),
            color: Colors.indigo,
          ),
          _ReportOption(
            title: "Orders",
            icon: Icons.shopping_bag_rounded,
            permission: "leadorder_viewany",
            page: const OrderReportScreen(),
            color: Colors.green,
          ),
          _ReportOption(
            title: "Payroll",
            icon: Icons.payments_rounded,
            permission: "payroll_viewany",
            page: const PayrollReportScreen(),
            color: Colors.cyan,
          ),
          _ReportOption(
            title: "Recovery",
            icon: Icons.assignment_return_rounded,
            permission: "recovery_viewany",
            page: const RecoveryReportScreen(),
            color: Colors.deepOrange,
          ),
          _ReportOption(
            title: "Notices",
            icon: Icons.campaign_rounded,
            permission: "notice_viewany",
            page: const NoticeReportScreen(),
            color: Colors.amber,
          ),
          _ReportOption(
            title: "Category",
            icon: Icons.category_rounded,
            permission: "category_viewany",
            page: const ProductCategoryReportScreen(),
            color: Colors.brown,
          ),
          _ReportOption(
            title: "Products",
            icon: Icons.inventory_2_rounded,
            permission: "product_viewany",
            page: const ProductReportScreen(),
            color: Colors.blueGrey,
          ),
          _ReportOption(
            title: "Salary",
            icon: Icons.money_rounded,
            permission: "salary_viewany",
            page: const SalaryReportScreen(),
            color: Colors.lightGreen,
          ),
          _ReportOption(
            title: "Commission",
            icon: Icons.percent_rounded,
            permission: "commission_viewany",
            page: const CommissionReportScreen(),
            color: Colors.pink,
          ),
          _ReportOption(
            title: "PIP",
            icon: Icons.trending_down_rounded,
            permission: "pip_viewany",
            page: const PipReportScreen(),
            color: Colors.redAccent,
          ),
          _ReportOption(
            title: "Recruitment",
            icon: Icons.person_search_rounded,
            permission: "recruitment_viewany",
            page: const RecruitmentReportScreen(),
            color: Colors.indigoAccent,
          ),
          _ReportOption(
            title: "Probation",
            icon: Icons.timer_outlined,
            permission: "probation_viewany",
            page: const ProbationReportScreen(),
            color: Colors.deepPurpleAccent,
          ),
          _ReportOption(
            title: "Resignation",
            icon: Icons.exit_to_app_rounded,
            permission: "resignationexit_viewany",
            page: const ResignationExitReportScreen(),
            color: Colors.red,
          ),
          _ReportOption(
            title: "Documents",
            icon: Icons.folder_shared_rounded,
            permission: "document_viewany",
            page: const DocumentReportScreen(),
            color: Colors.blueGrey,
          ),
          _ReportOption(
            title: "Grievance",
            icon: Icons.gavel_rounded,
            permission: "grievance_viewany",
            page: const GrievanceDisciplineReportScreen(),
            color: Colors.orangeAccent,
          ),
          _ReportOption(
            title: "Attrition",
            icon: Icons.analytics_rounded,
            permission: "attrition_viewany",
            page: const AttritionReportScreen(),
            color: Colors.blueAccent,
          ),
          _ReportOption(
            title: "Exit Reasons",
            icon: Icons.list_alt_rounded,
            permission: "exitreason_viewany",
            page: const ExitReasonsReportScreen(),
            color: Colors.tealAccent,
          ),
          _ReportOption(
            title: "Employee Cost",
            icon: Icons.price_check_rounded,
            permission: "employeecost_viewany",
            page: const EmployeeCostReportScreen(),
            color: Colors.greenAccent,
          ),
          _ReportOption(
            title: "Training",
            icon: Icons.school_rounded,
            permission: "training_viewany",
            page: const TrainingReportScreen(),
            color: Colors.amberAccent,
          ),
          _ReportOption(
            title: "Assets",
            icon: Icons.inventory_2_rounded,
            permission: "asset_viewany",
            page: const AssetReportScreen(),
            color: Colors.lime,
          ),
        ];

        final visibleReports = reports.where((report) {
          if (report.permission == null) return true;
          return authController.hasPermission(report.permission!);
        }).toList();

        return GridView.builder(
          padding: EdgeInsets.all(20.r),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.r,
            mainAxisSpacing: 16.r,
            childAspectRatio: 1.1,
          ),
          itemCount: visibleReports.length,
          itemBuilder: (context, index) {
            final report = visibleReports[index];
            return _buildReportGridTile(context, report);
          },
        );
      }),
    );
  }

  Widget _buildReportGridTile(BuildContext context, _ReportOption report) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => navigate(context: context, page: report.page),
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: report.color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(report.icon, color: report.color, size: 28.sp),
              ),
              sizedBoxHeight(height: 12),
              CustomText(
                report.title,
                style: Helper(context).textTheme.titleSmall?.copyWith(
                      fontSize: 14.sp,
                      color: blackText1,
                    ),
                textAlign: TextAlign.center,
              ),
              sizedBoxHeight(height: 4),
              CustomText(
                "View Details",
                style: Helper(context).textTheme.bodySmall?.copyWith(
                      fontSize: 10.sp,
                      color: grey,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReportOption {
  final String title;
  final IconData icon;
  final String? permission;
  final Widget page;
  final Color color;

  _ReportOption({
    required this.title,
    required this.icon,
    this.permission,
    required this.page,
    required this.color,
  });
}
