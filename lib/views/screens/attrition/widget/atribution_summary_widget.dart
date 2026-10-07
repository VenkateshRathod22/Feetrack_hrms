import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/attrition_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';

class AtributionSummaryWidget extends StatelessWidget {
  const AtributionSummaryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AttritionController>(builder: (controller) {
      final analytics = controller.attritionAnalytics;
      if (analytics == null) return const SizedBox.shrink();

      return Container(
        padding: EdgeInsets.all(16.r),
        child: Column(
          children: [
            Row(
              children: [
                _buildSummaryCard(
                  context,
                  "Attrition Rate",
                  "${analytics.attritionRate}%",
                  Icons.trending_up,
                  Colors.red,
                ),
                sizedBoxWidth(width: 12),
                _buildSummaryCard(
                  context,
                  "Total Exits",
                  analytics.totalExits.toString(),
                  Icons.exit_to_app,
                  Colors.orange,
                ),
              ],
            ),
            sizedBoxHeight(height: 12),
            Row(
              children: [
                _buildSummaryCard(
                  context,
                  "Total Staff",
                  analytics.totalStaff.toString(),
                  Icons.people,
                  Colors.blue,
                ),
                sizedBoxWidth(width: 12),
                _buildSummaryCard(
                  context,
                  "Avg Headcount",
                  analytics.avgHeadcount.toString(),
                  Icons.analytics,
                  Colors.green,
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildSummaryCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16.r),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20.sp),
            ),
            sizedBoxHeight(height: 12),
            CustomText(value, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: blackText1)),
            sizedBoxHeight(height: 4),
            CustomText(title, style: TextStyle(fontSize: 12.sp, color: greyText)),
          ],
        ),
      ),
    );
  }
}
