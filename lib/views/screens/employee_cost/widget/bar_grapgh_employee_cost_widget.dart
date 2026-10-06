import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/employee_cost_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';

class BarGrapghEmployeeCostWidget extends StatelessWidget {
  const BarGrapghEmployeeCostWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EmployeeCostController>(builder: (controller) {
      final trends = controller.analytics?.monthlyTrends;
      if (trends == null || trends.isEmpty) return const SizedBox.shrink();

      num maxCost = 1;
      for (var trend in trends) {
        if ((trend.totalCost ?? 0) > maxCost) {
          maxCost = trend.totalCost!;
        }
      }

      return Container(
        margin: EdgeInsets.all(16.r),
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
            CustomText("Monthly Cost Trends", style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: blackText1)),
            sizedBoxHeight(height: 20),
            SizedBox(
              height: 180.h,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: trends.map((trend) {
                    double heightFactor = (trend.totalCost ?? 0) / maxCost;
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 6.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CustomText(
                            trend.totalCost! > 1000 ? "${(trend.totalCost! / 1000).toStringAsFixed(1)}k" : trend.totalCost!.toStringAsFixed(0),
                            style: TextStyle(fontSize: 8.sp, color: greyText),
                          ),
                          sizedBoxHeight(height: 4),
                          Container(
                            width: 24.w,
                            height: (heightFactor * 120.h).clamp(2.0, 120.h),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [primaryColor, primaryColor.withValues(alpha: 0.7)],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                          ),
                          sizedBoxHeight(height: 8),
                          CustomText(trend.month ?? "", style: TextStyle(fontSize: 10.sp, color: greyText)),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
