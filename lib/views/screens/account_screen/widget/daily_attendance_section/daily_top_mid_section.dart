import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/attendance_controller.dart';
import 'package:vlr/generated/assets.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';

class DailyTopMidSection extends StatelessWidget {
  const DailyTopMidSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AttendanceController>(builder: (attendanceController) {
      final color = attendanceController.attendanceModel?.statusColor;
      final icon = (attendanceController.attendanceModel?.isWeekOff ?? false)
          ? Assets.svgsCalender
          : (attendanceController.attendanceModel?.isHoliday ?? false)
              ? Assets.svgsCalender
              : (attendanceController.attendanceModel?.isShortLeave ?? false)
                  ? Assets.svgsShortLeave
                  : "";
      final title = (attendanceController.attendanceModel?.isWeekOff ?? false)
          ? "WEEKOFF"
          : (attendanceController.attendanceModel?.isHoliday ?? false)
              ? "ON HOLIDAY TODAY"
              : (attendanceController.attendanceModel?.isShortLeave ?? false)
                  ? "Short Leave"
                  : "";
      final subTitle = (attendanceController.attendanceModel?.isWeekOff ??
              false)
          ? "Today is your weekly off"
          : (attendanceController.attendanceModel?.isHoliday ?? false)
              ? "Today is a company Holiday."
              : (attendanceController.attendanceModel?.isShortLeave ?? false)
                  ? "You have applied for Short Leave today."
                  : "";
      if (attendanceController.attendanceModel?.isNotPunchIn ?? false) {
        return Center(
          child: Column(
            children: [
              sizedBoxHeight(height: 24.h),
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: greenDark2.withValues(alpha: 0.1),
                ),
                child: SvgPicture.asset(
                  Assets.svgsAleamWatch,
                  height: 32.h,
                  width: 32.w,
                  fit: BoxFit.cover,
                ),
              ),
              sizedBoxHeight(height: 12.h),
              CustomText(
                "Good Morning!",
                style: Helper(context).textTheme.labelMedium?.copyWith(
                      fontSize: 20,
                      color: blackText4,
                    ),
              ),
              sizedBoxHeight(height: 4.h),
              CustomText(
                "You haven't punched in yet. Your working day has not started.",
                maxLines: 3,
                textAlign: TextAlign.center,
                style: Helper(context).textTheme.bodySmall?.copyWith(
                      fontSize: 14.sp,
                      color: greyLight8,
                    ),
              ),
            ],
          ),
        );
      }
      if (attendanceController.attendanceModel?.isPunchIn ?? false) {
        return Center(
          child: Column(
            children: [
              sizedBoxHeight(height: 16.h),
              Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: greenDark2.withValues(alpha: 0.1),
                  ),
                  child: Icon(
                    Icons.watch_later_outlined,
                    size: 32.sp,
                    color: greenDark2,
                  )),
            ],
          ),
        );
      }
      if (attendanceController.attendanceModel?.isPunchOut ?? false) {
        return Container(
          margin: EdgeInsets.only(
            top: 16.h,
            left: 24.w,
            right: 24.w,
          ),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            color: greenDark2.withValues(
              alpha: 0.2,
            ),
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                Assets.svgsCheckCircle,
              ),
              sizedBoxWidth(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      "Punch Out Successful!",
                      textAlign: TextAlign.center,
                      style: Helper(context).textTheme.titleMedium?.copyWith(
                            fontSize: 14.sp,
                            color: greenDark2,
                          ),
                    ),
                    CustomText(
                      "Have a great day!",
                      textAlign: TextAlign.center,
                      style: Helper(context).textTheme.bodySmall?.copyWith(
                            fontSize: 12.sp,
                            color: greenDark2,
                          ),
                    ),
                  ],
                ),
              ),
              SvgPicture.asset(
                Assets.svgsParty,
                height: 40.h,
                width: 40.w,
                fit: BoxFit.cover,
                colorFilter: const ColorFilter.mode(
                  greenDark2,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
        );
      }
      if (attendanceController.attendanceModel?.isLeave ?? false) {
        return Padding(
          padding: EdgeInsets.only(top: 16.h),
          child: Center(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                      color: color?.withValues(alpha: 0.1),
                      shape: BoxShape.circle),
                  child: Icon(
                    Icons.calendar_month_outlined,
                    size: 40.sp,
                    color: color,
                  ),
                ),
                sizedBoxHeight(height: 12.h),
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 4.h, horizontal: 24.w),
                  decoration: BoxDecoration(
                    color: color?.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(99.r),
                  ),
                  child: CustomText(
                    "ON LEAVE TODAY",
                    style: Helper(context).textTheme.titleMedium?.copyWith(
                          fontSize: 12.sp,
                          color: color,
                        ),
                  ),
                ),
                sizedBoxHeight(height: 12.h),
                CustomText(
                  "Enjoy your day off!",
                  style: Helper(context).textTheme.titleMedium?.copyWith(
                        fontSize: 20.sp,
                      ),
                ),
                sizedBoxHeight(height: 12.h),
                CustomText(
                  attendanceController.attendanceModel?.statusReason ?? "",
                  style: Helper(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(fontSize: 14.sp, color: weekOff),
                )
              ],
            ),
          ),
        );
      }
      if (attendanceController.attendanceModel?.isAbsent ?? false) {
        return Padding(
          padding: EdgeInsets.only(top: 16.h),
          child: Center(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                      color: color?.withValues(alpha: 0.1),
                      shape: BoxShape.circle),
                  child: SvgPicture.asset(
                    Assets.svgsCrossBord,
                    fit: BoxFit.cover,
                  ),
                ),
                sizedBoxHeight(height: 12.h),
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 4.h, horizontal: 24.w),
                  decoration: BoxDecoration(
                    color: color?.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(99.r),
                  ),
                  child: CustomText(
                    "ON ABSENT TODAY",
                    style: Helper(context).textTheme.titleMedium?.copyWith(
                          fontSize: 12.sp,
                          color: color,
                        ),
                  ),
                ),
                sizedBoxHeight(height: 12.h),
                CustomText(
                  "You were marked Absent for today.!",
                  style: Helper(context).textTheme.titleMedium?.copyWith(
                        fontSize: 16.sp,
                      ),
                ),
                sizedBoxHeight(height: 12.h),
                CustomText(
                  attendanceController.attendanceModel?.statusReason ?? "",
                  style: Helper(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(fontSize: 14.sp, color: weekOff),
                )
              ],
            ),
          ),
        );
      }
      if (attendanceController.attendanceModel?.isHalfDay ?? false) {
        return Padding(
          padding: EdgeInsets.only(top: 16.h),
          child: Center(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                      color: color?.withValues(alpha: 0.1),
                      shape: BoxShape.circle),
                  child: SvgPicture.asset(
                    Assets.svgsCalender,
                    fit: BoxFit.cover,
                    height: 30.h,
                    width: 30.w,
                    colorFilter: ColorFilter.mode(
                        attendanceController.attendanceModel?.statusColor ??
                            defaultColor,
                        BlendMode.srcIn),
                  ),
                ),
                sizedBoxHeight(height: 12.h),
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 4.h, horizontal: 24.w),
                  decoration: BoxDecoration(
                    color: color?.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(99.r),
                  ),
                  child: CustomText(
                    "ON HAlFDAY TODAY",
                    style: Helper(context).textTheme.titleMedium?.copyWith(
                          fontSize: 12.sp,
                          color: color,
                        ),
                  ),
                ),
                sizedBoxHeight(height: 12.h),
                CustomText(
                  "Half day attendance recorded for today.",
                  maxLines: 2,
                  style: Helper(context).textTheme.titleMedium?.copyWith(
                        fontSize: 16.sp,
                      ),
                ),
                sizedBoxHeight(height: 12.h),
                CustomText(
                  attendanceController.attendanceModel?.statusReason ?? "",
                  style: Helper(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(fontSize: 14.sp, color: weekOff),
                )
              ],
            ),
          ),
        );
      }
      if ((attendanceController.attendanceModel?.isHoliday ?? false) ||
          (attendanceController.attendanceModel?.isWeekOff ?? false) ||
          (attendanceController.attendanceModel?.isShortLeave ?? false)) {
        return Padding(
          padding: EdgeInsets.only(top: 16.h),
          child: Center(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                      color: color?.withValues(alpha: 0.1),
                      shape: BoxShape.circle),
                  child: SvgPicture.asset(
                    icon,
                    fit: BoxFit.cover,
                    height: 30.h,
                    width: 30.w,
                    colorFilter: ColorFilter.mode(
                        color ?? defaultColor, BlendMode.srcIn),
                  ),
                ),
                sizedBoxHeight(height: 12.h),
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 4.h, horizontal: 24.w),
                  decoration: BoxDecoration(
                    color: color?.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(99.r),
                  ),
                  child: CustomText(
                    title,
                    style: Helper(context).textTheme.titleMedium?.copyWith(
                          fontSize: 12.sp,
                          color: color,
                        ),
                  ),
                ),
                sizedBoxHeight(height: 12.h),
                CustomText(
                  subTitle,
                  maxLines: 2,
                  style: Helper(context).textTheme.titleMedium?.copyWith(
                        fontSize: 16.sp,
                      ),
                ),
                sizedBoxHeight(height: 12.h),
                CustomText(
                  attendanceController.attendanceModel?.statusReason ?? "",
                  style: Helper(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(fontSize: 14.sp, color: weekOff),
                )
              ],
            ),
          ),
        );
      }
      return SizedBox();
    });
  }
}
