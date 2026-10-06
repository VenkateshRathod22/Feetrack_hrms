import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/employee_cost_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';

class BranchCostBreakdownWidget extends StatelessWidget {
  const BranchCostBreakdownWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EmployeeCostController>(builder: (controller) {
      final branchBreakdown = controller.analytics?.branchCostBreakdown;
      if (branchBreakdown == null || branchBreakdown.isEmpty) return const SizedBox.shrink();

      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
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
            CustomText("Branch Cost Breakdown", style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: blackText1)),
            sizedBoxHeight(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: branchBreakdown.length,
              separatorBuilder: (_, __) => const Divider(height: 24),
              itemBuilder: (context, index) {
                final branch = branchBreakdown[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CustomText(branch.branch ?? "N/A", style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: blackText1)),
                        ),
                        CustomText(PriceConverter.convertToNumberFormat(branch.totalCost ?? 0), 
                          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: primaryColor)),
                      ],
                    ),
                    sizedBoxHeight(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _smallDetail("Employees", branch.employees.toString()),
                        _smallDetail("Salary", PriceConverter.convertToNumberFormat(branch.salaryCost ?? 0)),
                        _smallDetail("Incentives", PriceConverter.convertToNumberFormat(branch.incentiveCost ?? 0)),
                      ],
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      );
    });
  }

  Widget _smallDetail(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(label, style: TextStyle(fontSize: 10.sp, color: greyText)),
        CustomText(value, style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w600, color: blackText1)),
      ],
    );
  }
}
