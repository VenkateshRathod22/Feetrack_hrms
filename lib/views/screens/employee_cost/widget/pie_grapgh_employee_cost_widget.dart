import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/employee_cost_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';

class PieGrapghEmployeeCostWidget extends StatelessWidget {
  const PieGrapghEmployeeCostWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EmployeeCostController>(builder: (controller) {
      final deptBreakdown = controller.analytics?.deptCostBreakdown;
      if (deptBreakdown == null || deptBreakdown.isEmpty) return const SizedBox.shrink();

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
            CustomText("Dept. Cost Breakdown", style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: blackText1)),
            sizedBoxHeight(height: 16),
            ...deptBreakdown.map((dept) => _buildDeptCostRow(dept.department ?? "N/A", dept.salaryCost ?? 0, dept.percentage ?? 0)),
          ],
        ),
      );
    });
  }

  Widget _buildDeptCostRow(String name, num cost, num percentage) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(name, style: TextStyle(fontSize: 12.sp, color: greyDart2)),
              CustomText(PriceConverter.convertToNumberFormat(cost), style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: primaryColor)),
            ],
          ),
          sizedBoxHeight(height: 6),
          Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: (percentage.toDouble() / 100).clamp(0.0, 1.0),
                  backgroundColor: greyLight1,
                  color: primaryColor,
                  minHeight: 8.h,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              sizedBoxWidth(width: 12),
              CustomText("$percentage%", style: TextStyle(fontSize: 10.sp, color: greyText, fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }
}
