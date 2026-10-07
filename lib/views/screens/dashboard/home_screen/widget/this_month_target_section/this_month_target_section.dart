import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/dashboard_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/date_formatters_and_converters.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/screens/dashboard/home_screen/widget/this_month_target_section/monthly_target_model.dart';
import 'package:vlr/views/screens/dashboard/home_screen/widget/this_month_target_section/target_card.dart';

class ThisMonthTargetSection extends StatelessWidget {
  const ThisMonthTargetSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashBoardController>(builder: (dashController) {
      final model = dashController.dashboardModel;

      // Define dynamic targets based on API data if available, otherwise fallback
      final dynamicTargets = [
        MonthlyTargetModel(
          title: "Attendance (Days)",
          target: "30",
          percent: (model?.myAttendanceThisMonth?.toDouble() ?? 0) / 30,
          icon: Icons.calendar_today,
          color: tertiaryColor,
          achived: "${model?.myAttendanceThisMonth ?? 0}",
          pending: "${30 - (model?.myAttendanceThisMonth?.toInt() ?? 0)}",
        ),
        MonthlyTargetModel(
          title: model?.expenseLabel ?? "Expenses (Month)",
          target: "Goal",
          percent: 0.5, // Arbitrary since no goal in API
          icon: Icons.currency_rupee,
          color: deepPurple,
          achived: "${model?.myExpensesAmount ?? 0}",
          pending: "-",
        ),
      ];

      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 4),
              blurRadius: 12,
              spreadRadius: 0,
              color: black.withValues(alpha: 0.05),
            )
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  "This Month Status",
                  style: Helper(context).textTheme.titleMedium?.copyWith(
                        fontSize: 16.sp,
                      ),
                ),
                CustomText(
                  DateFormatters().My.format(getDateTime()),
                  style: Helper(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontSize: 14.sp, color: greyDart2),
                ),
              ],
            ),
            sizedBoxHeight(height: 12.h),
            Row(
              children: [
                Expanded(child: TargetCard(target: dynamicTargets[0])),
                SizedBox(width: 6.w),
                Expanded(child: TargetCard(target: dynamicTargets[1]))
              ],
            )
          ],
        ),
      );
    });
  }
}
