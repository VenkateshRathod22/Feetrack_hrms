import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/attrition_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';

class AtribuitonGraphCardWidget extends StatelessWidget {
  const AtribuitonGraphCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AttritionController>(builder: (controller) {
      final analytics = controller.attritionAnalytics;
      if (analytics == null || analytics.monthlyExits == null) return const SizedBox.shrink();

      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
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
            CustomText("Monthly Exits Trend", style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: blackText1)),
            sizedBoxHeight(height: 20),
            SizedBox(
              height: 150.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: analytics.monthlyExits!.map((data) {
                  return _buildBar(data.month ?? "", data.exits ?? 0, analytics.totalExits ?? 1);
                }).toList(),
              ),
            ),
            sizedBoxHeight(height: 24),
            CustomText("Department Attrition Rate", style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: blackText1)),
            sizedBoxHeight(height: 16),
            ...analytics.deptAttrition!.map((dept) => _buildDeptRow(dept.department ?? "N/A", dept.rate ?? 0)),
          ],
        ),
      );
    });
  }

  Widget _buildBar(String label, int value, int total) {
    double percentage = total > 0 ? value / total : 0;
    return Column(
      mainAxisAlignment:MainAxisAlignment.end,
      children: [
        Container(
          width: 20.w,
          height: (percentage * 100.h) + 2.h,
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
        sizedBoxHeight(height: 8),
        CustomText(label, style: TextStyle(fontSize: 10.sp, color: greyText)),
      ],
    );
  }

  Widget _buildDeptRow(String name, num rate) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(name, style: TextStyle(fontSize: 12.sp, color: greyDart2)),
              CustomText("$rate%", style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: primaryColor)),
            ],
          ),
          sizedBoxHeight(height: 4),
          LinearProgressIndicator(
            value: rate / 100,
            backgroundColor: greyLight1,
            color: primaryColor,
            borderRadius: BorderRadius.circular(4.r),
            minHeight: 6.h,
          ),
        ],
      ),
    );
  }
}
