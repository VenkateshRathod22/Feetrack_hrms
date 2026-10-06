import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/screens/lead/lead_create/CustomerVisitsScreen.dart';
import 'package:vlr/views/screens/lead/lead_create/OrdersPipelineScreen.dart';
import 'package:vlr/views/screens/lead/lead_create/RecoveryHistoryScreen.dart';
import 'package:vlr/views/screens/lead/lead_create/lead_create_screen.dart';
import 'package:vlr/views/screens/lead/lead_create/lead_recovery_amount_screen.dart';
import 'package:vlr/views/screens/lead/lead_create/lead_tabar_screen.dart';

class LeadSectionScreen extends StatelessWidget {
  const LeadSectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundLight,
      appBar: AppBar(
        title: CustomText(
          "Lead Management",
          style: Helper(context).textTheme.titleMedium?.copyWith(fontSize: 18.sp),
        ),
        centerTitle: true,
        backgroundColor: white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.r),
        child: Column(
          children: [
            _buildNavigationCard(
              context,
              title: "Create New Lead",
              subtitle: "Add a new potential customer",
              icon: Icons.person_add_alt_1_rounded,
              color: Colors.blue,
              onTap: () => navigate(context: context, page: const LeadTabarScreen()),
            ),
            sizedBoxHeight(height: 16),
            _buildNavigationCard(
              context,
              title: "Customer Visits",
              subtitle: "Manage and track field visits",
              icon: Icons.location_on_rounded,
              color: Colors.orange,
              onTap: () => navigate(context: context, page: const Customervisitsscreen()),
            ),
            sizedBoxHeight(height: 16),
            _buildNavigationCard(
              context,
              title: "Orders Pipeline",
              subtitle: "Track order status and stages",
              icon: Icons.account_tree_rounded,
              color: Colors.purple,
              onTap: () => navigate(context: context, page: const Orderspipelinescreen()),
            ),
            _buildNavigationCard(
              context,
              title: "Lead Recovery Amount",
              subtitle: "Manage and collect pending recovery payments",
              icon: Icons.payments_rounded,
              color: Colors.redAccent,
              onTap: () => navigate(
                context: context,
                page: const LeadRecoveryAmountScreen(),
              ),
            ),
            sizedBoxHeight(height: 16),
            _buildNavigationCard(
              context,
              title: "Recovery History",
              subtitle: "View payment recovery records",
              icon: Icons.history_rounded,
              color: Colors.green,
              onTap: () => navigate(context: context, page: const Recoveryhistoryscreen()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28.sp),
            ),
            sizedBoxWidth(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: blackText1,
                    ),
                  ),
                  sizedBoxHeight(height: 4),
                  CustomText(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: greyText,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, size: 16.sp, color: greyLight5),
          ],
        ),
      ),
    );
  }
}
