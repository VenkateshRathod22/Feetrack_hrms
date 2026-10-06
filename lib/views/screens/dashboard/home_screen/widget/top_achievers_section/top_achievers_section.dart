import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/dashboard_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_button.dart';
import 'package:vlr/views/screens/dashboard/home_screen/widget/top_achievers_section/top_achievers_widget.dart';

class TopAchieversSection extends StatelessWidget {
  const TopAchieversSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashBoardController>(builder: (dashController) {
      if (dashController.dashboardModel?.topAchievers == null ||
          dashController.dashboardModel!.topAchievers!.isEmpty) {
        return const SizedBox.shrink();
      }
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        padding: EdgeInsets.all(16.w),
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
                  "Top Achievers",
                  style: Helper(context).textTheme.titleMedium?.copyWith(
                        fontSize: 16.sp,
                      ),
                ),
                CustomButton(
                  onTap: () {},
                  type: ButtonType.tertiary,
                  child: CustomText(
                    "View All",
                    style: Helper(context).textTheme.titleMedium?.copyWith(
                          fontSize: 12.sp,
                          color: tertiaryColor,
                        ),
                  ),
                ),
              ],
            ),
            sizedBoxHeight(height: 16.h),
            SizedBox(
              height: 190.h,
              child: ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final achiever =
                        dashController.dashboardModel!.topAchievers![index];
                    return SizedBox(
                        width: 200.w,
                        child: TopAchieversWidget(achiever: achiever));
                  },
                  separatorBuilder: (_, __) => sizedBoxWidth(width: 12.w),
                  itemCount:
                      dashController.dashboardModel!.topAchievers!.length),
            )
          ],
        ),
      );
    });
  }
}
