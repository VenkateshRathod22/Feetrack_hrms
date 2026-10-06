import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:vlr/controllers/attendance_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/date_formatters_and_converters.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_image.dart';
import 'package:vlr/views/base/shimmer.dart';

class TopSectionAttendancePunchOutSection extends StatelessWidget {
  const TopSectionAttendancePunchOutSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  width: 10.w,
                  color: green2.withValues(
                    alpha: 0.10,
                  ),
                )),
            child: Container(
              height: 80.h,
              width: 80.w,
              decoration: const BoxDecoration(
                color: green2,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check,
                color: white,
                size: 50.sp,
              ),
            ),
          ),
          GetBuilder<AttendanceController>(builder: (attendanceController) {
            final dateText = (attendanceController.attendanceModel?.isPunchIn ??
                    false)
                ? "${DateFormatters().dMy.format(attendanceController.attendanceModel?.date ?? getDateTime())}, ${convertTo12HourFormat(
                    time24: attendanceController.attendanceModel?.checkIn ?? "",
                    isShowAMPM: true,
                  )}"
                : "${DateFormatters().dMy.format(attendanceController.attendanceModel?.date ?? getDateTime())} ,${convertTo12HourFormat(
                    time24:
                        attendanceController.attendanceModel?.checkOut ?? "",
                    isShowAMPM: true,
                  )}";

            final titleText = (attendanceController
                        .attendanceModel?.isPunchIn ??
                    false)
                ? "Punch In Successful"
                : (attendanceController.attendanceModel?.isPunchOut ?? false)
                    ? "Punch Out Successful"
                    : "";
            return Column(
              children: [
                sizedBoxHeight(height: 16.h),
                CustomShimmer(
                  isLoading: attendanceController.isLoading,
                  child: CustomText(
                    titleText,
                    style: Helper(context).textTheme.titleMedium?.copyWith(
                          fontSize: 24,
                          color: green2,
                        ),
                  ),
                ),
                sizedBoxHeight(height: 8.h),
                CustomText(
                  "Great job! Your attendance has been recorded successfully.",
                  maxLines: 3,
                  textAlign: TextAlign.center,
                  style: Helper(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 14,
                        color: greyDart2,
                      ),
                ),
                sizedBoxHeight(height: 24.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 6.h,
                    horizontal: 16.w,
                  ),
                  decoration: BoxDecoration(
                    color: green2.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(999.r),
                    border: Border.all(
                      width: 1,
                      color: green,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.calendar_month_outlined,
                        color: green2,
                        size: 20,
                      ),
                      sizedBoxWidth(width: 16.w),
                      CustomShimmer(
                        isLoading: attendanceController.isLoading,
                        child: CustomText(
                          dateText,
                          style: Helper(context).textTheme.titleSmall?.copyWith(
                                fontSize: 16,
                                color: green2,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
