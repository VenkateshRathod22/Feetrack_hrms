import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/state_manager.dart';
import 'package:vlr/controllers/attendance_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/date_formatters_and_converters.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_image.dart';

class VerificationSection extends StatelessWidget {
  const VerificationSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AttendanceController>(builder: (attendanceController) {
      return Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            color: white,
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 1),
                blurRadius: 2,
                spreadRadius: 0,
                color: black.withValues(alpha: 0.05),
              )
            ]),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.security_outlined,
                  color: blueLight3,
                  size: 18.sp,
                ),
                sizedBoxWidth(width: 8.w),
                Expanded(
                  child: CustomText(
                    "Verification",
                    style: Helper(context).textTheme.titleMedium?.copyWith(
                          fontSize: 14.sp,
                          color: blackText4,
                        ),
                  ),
                )
              ],
            ),
            sizedBoxHeight(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      color: greyLight4.withValues(alpha: 0.50),
                      border: Border.all(width: 1, color: greyLight4),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          "Check In Selfie",
                          style:
                              Helper(context).textTheme.titleMedium?.copyWith(
                                    fontSize: 10.sp,
                                    color: blackText4,
                                  ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                          child: CustomText(
                            convertTo12HourFormat(
                                time24: attendanceController
                                        .attendanceModel?.checkIn ??
                                    "-- : --",
                                isShowAMPM: true),
                            style:
                                Helper(context).textTheme.bodySmall?.copyWith(
                                      fontSize: 9.sp,
                                      color: greyLight5,
                                    ),
                          ),
                        ),
                        CustomImage(
                          radius: 20.r,
                          path: attendanceController
                                  .attendanceModel?.checkInSelfieUrl ??
                              "",
                          height: 250.h,
                          width: double.infinity,
                          fit: BoxFit.fill,
                        )
                      ],
                    ),
                  ),
                ),
                sizedBoxWidth(width: 12.w),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      color: greyLight4.withValues(alpha: 0.50),
                      border: Border.all(width: 1, color: greyLight4),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          "Check Out Selfie",
                          style:
                              Helper(context).textTheme.titleMedium?.copyWith(
                                    fontSize: 10.sp,
                                    color: blackText4,
                                  ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                          child: CustomText(
                            convertTo12HourFormat(
                                time24: attendanceController
                                        .attendanceModel?.checkOut ??
                                    "-- : --",
                                isShowAMPM: true),
                            style:
                                Helper(context).textTheme.bodySmall?.copyWith(
                                      fontSize: 9.sp,
                                      color: greyLight5,
                                    ),
                          ),
                        ),
                        CustomImage(
                          radius: 20.r,
                          path: attendanceController
                                  .attendanceModel?.checkOutSelfieUrl ??
                              "",
                          height: 250.h,
                          width: double.infinity,
                          fit: BoxFit.fill,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
