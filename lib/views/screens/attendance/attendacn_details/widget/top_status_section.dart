import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/attendance_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_image.dart';
import 'package:vlr/views/base/shimmer.dart';

class TopStatusSection extends StatefulWidget {
  const TopStatusSection({
    super.key,
  });

  @override
  State<TopStatusSection> createState() => _TopStatusSectionState();
}

class _TopStatusSectionState extends State<TopStatusSection> {
  Timer? _timer;
  bool showUpdateTime = false;

  @override
  void initState() {
    super.initState();

    showUpdateTime =
        Get.find<AttendanceController>().attendanceModel?.isPunchIn ?? false;

    if (showUpdateTime) {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) {
          setState(() {});
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AttendanceController>(builder: (attendanceController) {
      final workingTime =
          attendanceController.attendanceModel?.workingTimeFormat;

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomShimmer(
            isLoading: attendanceController.isLoading,
            child: Container(
              padding: EdgeInsets.all(16.w),
              height: 94.h,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    width: 1,
                    color: green2.withValues(
                      alpha: 0.2,
                    ),
                  ),
                  color: greenDark2.withValues(
                    alpha: 0.1,
                  )),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        (attendanceController.attendanceModel?.isPunchIn ??
                                false)
                            ? Assets.svgsArrowUp
                            : ((attendanceController
                                            .attendanceModel?.isPunchOut ??
                                        false) ||
                                    (attendanceController
                                            .attendanceModel?.isHalfDay ??
                                        false))
                                ? Assets.svgsArrowDownCircle
                                : Assets.svgsArrowUp,
                        height: 24.h,
                        width: 24.w,
                        colorFilter:
                            const ColorFilter.mode(green2, BlendMode.srcIn),
                      ),
                      sizedBoxWidth(width: 8.w),
                      CustomText(
                        (attendanceController.attendanceModel?.isPunchIn ??
                                false)
                            ? "Punch In - Completed"
                            : ((attendanceController
                                            .attendanceModel?.isPunchOut ??
                                        false) ||
                                    (attendanceController
                                            .attendanceModel?.isHalfDay ??
                                        false))
                                ? "Punch Out - Completed"
                                : "",
                        style: Helper(context).textTheme.bodyLarge?.copyWith(
                              fontSize: 14.sp,
                              color: primaryColor,
                            ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  CustomText(
                    (attendanceController.attendanceModel?.isPunchIn ?? false)
                        ? "Work session started"
                        : ((attendanceController.attendanceModel?.isPunchOut ??
                                    false) ||
                                (attendanceController
                                        .attendanceModel?.isHalfDay ??
                                    false))
                            ? "Work session end"
                            : "",
                    style: Helper(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 12.sp,
                          color: greyDart,
                        ),
                  ),
                ],
              ),
            ),
          ),
          sizedBoxWidth(width: 12.w),
          Container(
            height: 94.h,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                width: 1,
                color: tertiaryColor.withValues(alpha: 0.4),
              ),
              color: tertiaryColor.withValues(alpha: 0.2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    CustomText(
                      "WORKING TIME",
                      style: Helper(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 10.sp,
                            color: blueLight3,
                          ),
                    ),
                    sizedBoxWidth(width: 6.w),
                    Icon(
                      Icons.watch_later_outlined,
                      color: blueLight3,
                      size: 14.sp,
                    ),
                  ],
                ),
                sizedBoxHeight(height: 4.h),
                CustomShimmer(
                  isLoading: attendanceController.isLoading,
                  child: CustomText(
                    workingTime ?? "-- : --",
                    style: Helper(context).textTheme.titleMedium?.copyWith(
                          fontSize: 18.sp,
                          color: primaryColor,
                        ),
                  ),
                ),
              ],
            ),
          )
        ],
      );
    });
  }
}
