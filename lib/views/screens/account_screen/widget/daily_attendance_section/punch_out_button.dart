import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:vlr/controllers/attendance_controller.dart';
import 'package:vlr/generated/assets.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_button.dart';

class PunchButtonWidget extends StatelessWidget {
  final Function() onTap;
  const PunchButtonWidget({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AttendanceController>(builder: (attendanceController) {
      String? title;
      IconData? icon;
      Color? buttonBgColor;
      Color color =
          attendanceController.attendanceModel?.statusColor ?? defaultColor;
      if (attendanceController.attendanceModel?.isNotPunchIn ?? false) {
        title = "Punch In";
        icon = Icons.login;
        buttonBgColor = green;
      } else if (attendanceController.attendanceModel?.isPunchOut ?? false) {
        title = "Punch out Done";
        icon = Icons.logout;
        buttonBgColor = primaryColor;
      } else if (attendanceController.attendanceModel?.isPunchIn ?? false) {
        title = "Punch Out";
        icon = Icons.logout;
        buttonBgColor = redDark;
      }

      if ((attendanceController.attendanceModel?.isNotPunchIn ?? false) ||
          (attendanceController.attendanceModel?.isPunchIn ?? false)) {
        return Column(
          children: [
            CustomButton(
              height: 48.h,
              onTap: onTap,
              color: buttonBgColor,
              borderColor: buttonBgColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    color: white,
                  ),
                  sizedBoxWidth(width: 12.w),
                  CustomText(
                    title ?? "",
                    style: Helper(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 16.sp,
                          color: white,
                        ),
                  ),
                ],
              ),
            ),
            (attendanceController.attendanceModel?.isNotPunchIn ?? false)
                ? Container(
                    margin: EdgeInsets.only(top: 16.h),
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        color: greenDark2.withValues(
                          alpha: 0.1,
                        ),
                        border: Border.all(
                          width: 1,
                          color: greenDark2.withValues(
                            alpha: 0.2,
                          ),
                        )),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: green2,
                        ),
                        sizedBoxWidth(width: 12.w),
                        Expanded(
                          child: CustomText(
                            "Please punch in when you start working.",
                            style:
                                Helper(context).textTheme.bodySmall?.copyWith(
                                      fontSize: 12.sp,
                                      color: greyDart3,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  )
                : (attendanceController.attendanceModel?.isPunchIn ?? false)
                    ? Container(
                        margin: EdgeInsets.only(top: 16.h),
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.r),
                            color: blueLight3.withValues(
                              alpha: 0.1,
                            ),
                            border: Border.all(
                              width: 1,
                              color: blueLight3.withValues(
                                alpha: 0.2,
                              ),
                            )),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              Assets.svgsInfo,
                            ),
                            sizedBoxWidth(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    "You are currently punched in.",
                                    style: Helper(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(
                                          fontSize: 12.sp,
                                          color: blueDark1,
                                        ),
                                  ),
                                  CustomText(
                                    "Don't forget to punch out.",
                                    style: Helper(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          fontSize: 11.sp,
                                          color: blueDark1,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox()
          ],
        );
      }
      if (attendanceController.attendanceModel?.isPunchOut ?? false) {
        return Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            color: blueLight3.withValues(alpha: 0.1),
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                Assets.svgsInfo,
                colorFilter: ColorFilter.mode(blueDark2, BlendMode.srcIn),
              ),
              sizedBoxWidth(width: 12.w),
              Expanded(
                child: CustomText(
                  "You have completed your work session. Thank you!",
                  maxLines: 2,
                  style: Helper(context).textTheme.bodySmall?.copyWith(
                        fontSize: 12.sp,
                        color: greyDart3,
                      ),
                ),
              ),
            ],
          ),
        );
      }
      if (attendanceController.attendanceModel?.isLeave ?? false) {
        return Container(
          padding: EdgeInsets.all(12.w),
          margin: EdgeInsets.only(top: 12.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            color: color.withValues(alpha: 0.1),
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                Assets.svgsInfo,
                colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
              ),
              sizedBoxWidth(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      "You are on leave for today",
                      maxLines: 2,
                      style: Helper(context).textTheme.bodyLarge?.copyWith(
                            fontSize: 12.sp,
                            color: color,
                          ),
                    ),
                    sizedBoxHeight(height: 2.h),
                    CustomText(
                      "No punch in/out required.",
                      maxLines: 2,
                      style: Helper(context).textTheme.bodySmall?.copyWith(
                            fontSize: 10.sp,
                            color: color,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }
      if (attendanceController.attendanceModel?.isAbsent ?? false) {
        return Container(
          padding: EdgeInsets.all(12.w),
          margin: EdgeInsets.only(top: 12.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            color: color.withValues(alpha: 0.1),
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                Assets.svgsInfo,
                colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
              ),
              sizedBoxWidth(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      "You are on absent for today.",
                      maxLines: 2,
                      style: Helper(context).textTheme.bodyLarge?.copyWith(
                            fontSize: 12.sp,
                            color: color,
                          ),
                    ),
                    sizedBoxHeight(height: 2.h),
                    CustomText(
                      "No punch in/out required.",
                      maxLines: 2,
                      style: Helper(context).textTheme.bodySmall?.copyWith(
                            fontSize: 10.sp,
                            color: color,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }
      if (attendanceController.attendanceModel?.isHalfDay ?? false) {
        return Container(
          padding: EdgeInsets.all(12.w),
          margin: EdgeInsets.only(top: 12.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            color: color.withValues(alpha: 0.1),
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                Assets.svgsInfo,
                colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
              ),
              sizedBoxWidth(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      "You are on halfday for today.",
                      maxLines: 2,
                      style: Helper(context).textTheme.bodyLarge?.copyWith(
                            fontSize: 12.sp,
                            color: color,
                          ),
                    ),
                    sizedBoxHeight(height: 2.h),
                    CustomText(
                      "Half day recorded.Thank you!",
                      maxLines: 2,
                      style: Helper(context).textTheme.bodySmall?.copyWith(
                            fontSize: 10.sp,
                            color: color,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }
      if ((attendanceController.attendanceModel?.isHoliday ?? false) ||
          (attendanceController.attendanceModel?.isWeekOff ?? false)) {
        return Container(
          padding: EdgeInsets.all(12.w),
          margin: EdgeInsets.only(top: 12.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            color: color.withValues(alpha: 0.1),
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                Assets.svgsInfo,
                colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
              ),
              sizedBoxWidth(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      "Enjoy your holiday!",
                      maxLines: 2,
                      style: Helper(context).textTheme.bodyLarge?.copyWith(
                            fontSize: 12.sp,
                            color: color,
                          ),
                    ),
                    sizedBoxHeight(height: 2.h),
                    CustomText(
                      "Have a great day.",
                      maxLines: 2,
                      style: Helper(context).textTheme.bodySmall?.copyWith(
                            fontSize: 10.sp,
                            color: color,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }
      if (attendanceController.attendanceModel?.isShortLeave ?? false) {
        return Container(
          padding: EdgeInsets.all(12.w),
          margin: EdgeInsets.only(top: 12.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            color: color.withValues(alpha: 0.1),
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                Assets.svgsInfo,
                colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
              ),
              sizedBoxWidth(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      "Short leave recorded for the day.",
                      maxLines: 2,
                      style: Helper(context).textTheme.bodyLarge?.copyWith(
                            fontSize: 12.sp,
                            color: color,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }

      return const SizedBox();
    });
  }
}
