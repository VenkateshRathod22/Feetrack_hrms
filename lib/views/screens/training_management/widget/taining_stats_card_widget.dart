import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/training_report_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';

class TrainingStatsCardWidget extends StatelessWidget {
  const TrainingStatsCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TrainingReportController>(builder: (controller) {
      final summary = controller.trainingAnalytics?.summary;
      if (summary == null) return const SizedBox.shrink();

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          children: [
            _buildStatCard("Training Assigned", summary.totalAssigned.toString(), Icons.assignment_outlined, Colors.blue),
            sizedBoxWidth(width: 12),
            _buildStatCard("Training Completed", summary.totalCompleted.toString(), Icons.check_circle_outline, Colors.green),
            sizedBoxWidth(width: 12),
            _buildStatCard("Average Attendance", "${summary.avgAttendancePct}%", Icons.person_outline, Colors.cyan),
            sizedBoxWidth(width: 12),
            _buildStatCard("Avg Assessment Score", "${summary.avgAssessmentScorePct}%", Icons.emoji_events_outlined, Colors.deepPurple),
            sizedBoxWidth(width: 12),
            _buildStatCard("Pending Training", summary.pendingTraining.toString(), Icons.hourglass_empty, Colors.orange),
          ],
        ),
      );
    });
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      width: 160.w,
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border(left: BorderSide(color: color, width: 4.w)),
        boxShadow: [
          BoxShadow(color: black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CustomText(label, style: TextStyle(fontSize: 10.sp, color: greyText, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
              Icon(icon, size: 16.sp, color: color.withValues(alpha: 0.7)),
            ],
          ),
          sizedBoxHeight(height: 8),
          CustomText(value, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: blackText1)),
        ],
      ),
    );
  }
}
