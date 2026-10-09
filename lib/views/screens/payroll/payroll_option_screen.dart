import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/services/permission_helper.dart';
import 'package:vlr/views/screens/payroll/my_payroll_screen.dart';
import 'package:vlr/views/screens/payroll/payroll_process_screen.dart';
import 'package:vlr/views/screens/payroll/payroll_drafts_screen.dart';
import 'package:vlr/views/screens/payroll/payroll_approval_screen.dart';
import 'package:vlr/views/screens/payroll/advance_payments_screen.dart';
import 'package:vlr/views/screens/payroll/payroll_reports_screen.dart';

class PayrollOptionScreen extends StatelessWidget {
  const PayrollOptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text("Payroll Management"),
        centerTitle: true,
        backgroundColor: white,
        foregroundColor: black,
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        children: [
          PermissionWrapper(
            permission: 'payroll_viewown',
            child: _buildModernOptionCard(
              context: context,
              icon: Icons.account_balance_wallet_outlined,
              title: "My Payroll",
              subtitle: "View your personal salary history",
              color: Colors.blue,
              onTap: () => navigate(context: context, page: const MyPayrollScreen()),
            ),
          ),
          PermissionWrapper(
            permission: 'payroll_create',
            child: _buildModernOptionCard(
              context: context,
              icon: Icons.published_with_changes_outlined,
              title: "Payroll Process",
              subtitle: "Generate new payroll cycles",
              color: Colors.purple,
              onTap: () => navigate(context: context, page: const PayrollProcessScreen()),
            ),
          ),
          PermissionWrapper(
            permission: 'payroll_update',
            child: _buildModernOptionCard(
              context: context,
              icon: Icons.description_outlined,
              title: "Payroll Drafts",
              subtitle: "Manage and adjust pending drafts",
              color: Colors.orange,
              onTap: () => navigate(context: context, page: const PayrollDraftsScreen()),
            ),
          ),
          PermissionWrapper(
            permission: 'payroll_viewany',
            child: _buildModernOptionCard(
              context: context,
              icon: Icons.fact_check_outlined,
              title: "Payroll Approval",
              subtitle: "Review and approve payrolls",
              color: Colors.teal,
              onTap: () => navigate(context: context, page: const PayrollApprovalScreen()),
            ),
          ),
          PermissionWrapper(
            permission: 'payroll_viewany',
            child: _buildModernOptionCard(
              context: context,
              icon: Icons.payments_outlined,
              title: "Advance Payments",
              subtitle: "Manage employee salary advances",
              color: Colors.indigo,
              onTap: () => navigate(context: context, page: const AdvancePaymentsScreen()),
            ),
          ),
          PermissionWrapper(
            permission: 'payroll_viewany',
            child: _buildModernOptionCard(
              context: context,
              icon: Icons.analytics_outlined,
              title: "Payroll Reports",
              subtitle: "View detailed financial insights",
              color: Colors.grey,
              onTap: () => navigate(context: context, page: const PayrollReportsScreen()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernOptionCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20.r),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 28.sp,
                  ),
                ),
                sizedBoxWidth(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1E293B),
                        ),
                      ),
                      sizedBoxHeight(height: 4.h),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: grey.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 14.sp,
                    color: const Color(0xFF64748B),
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
