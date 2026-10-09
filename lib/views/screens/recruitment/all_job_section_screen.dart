import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/screens/recruitment/add_requirement_screen.dart';
import 'package:vlr/views/screens/recruitment/applied_job_list_screen.dart';
import 'package:vlr/views/screens/recruitment/billing_history_screen.dart';
import 'package:vlr/views/screens/recruitment/create_job_template_screen.dart';
import 'package:vlr/views/screens/recruitment/job_templates_screen.dart';
import 'package:vlr/views/screens/recruitment/recruitment_screen.dart';
import 'package:vlr/views/screens/reports/recruitment_report_screen.dart';

import 'job_list_screen.dart';

class AllJobSectionScreen extends StatelessWidget {
  final int initialIndex;
  const AllJobSectionScreen({super.key, this.initialIndex = 0});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: CustomText(
          "Recruitment & Jobs",
          style: Helper(context).textTheme.titleMedium?.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: blackText1,
              ),
        ),
        centerTitle: true,
        backgroundColor: white,
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: black),
          onPressed: () => pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.r),
        child: Column(
          children: [
            _buildNavigationCard(
              context,
              title: "Add Requirement",
              subtitle: "Add new candidate or job vacancy requirement",
              icon: Icons.person_add_rounded,
              color: Colors.blue,
              onTap: () => navigate(context: context, page: const AddRequirementScreen()),
            ),
            sizedBoxHeight(height: 16),
            _buildNavigationCard(
              context,
              title: "Applied Jobs",
              subtitle: "View and manage candidate job applications",
              icon: Icons.work_history_outlined,
              color: Colors.orange,
              onTap: () => navigate(context: context, page: const AppliedJobListScreen()),
            ),
            sizedBoxHeight(height: 16),
            _buildNavigationCard(
              context,
              title: "Recruitment Management",
              subtitle: "Track recruitment status and candidate pipeline",
              icon: Icons.people_alt_rounded,
              color: Colors.purple,
              onTap: () => navigate(context: context, page: const RecruitmentScreen()),
            ),
            sizedBoxHeight(height: 16),
            _buildNavigationCard(
              context,
              title: "Post Job Opening",
              subtitle: "Create and publish new job openings",
              icon: Icons.post_add_rounded,
              color: Colors.teal,
              onTap: () => navigate(context: context, page: const CreateJobTemplateScreen()),
            ),
            sizedBoxHeight(height: 16),
            _buildNavigationCard(
              context,
              title: "Job Templates",
              subtitle: "Browse predefined job templates and screening questions",
              icon: Icons.description_outlined,
              color: Colors.deepOrange,
              onTap: () => navigate(context: context, page: const JobTemplatesScreen()),
            ),
            sizedBoxHeight(height: 16),
            _buildNavigationCard(
              context,
              title: "Billing & Job History",
              subtitle: "View job post history, payment and wallet transactions",
              icon: Icons.receipt_long_rounded,
              color: Colors.brown,
              onTap: () => navigate(context: context, page: const BillingHistoryScreen()),
            ),
            _buildNavigationCard(
              context,
              title: "JobListScreen",
              subtitle: "View job post history, payment and wallet transactions",
              icon: Icons.receipt_long_rounded,
              color: Colors.brown,
              onTap: () => navigate(context: context, page: const JobListScreen()),
            ),
            sizedBoxHeight(height: 16),
            _buildNavigationCard(
              context,
              title: "Recruitment Report",
              subtitle: "View recruitment analytics and reports",
              icon: Icons.analytics_outlined,
              color: Colors.indigo,
              onTap: () => navigate(context: context, page: const RecruitmentReportScreen()),
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
