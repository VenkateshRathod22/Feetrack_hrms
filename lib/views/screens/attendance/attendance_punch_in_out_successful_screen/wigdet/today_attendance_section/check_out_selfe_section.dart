import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:vlr/controllers/attendance_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_image.dart';
import 'package:vlr/views/base/shimmer.dart';

class CheckOutSelfeSection extends StatelessWidget {
  const CheckOutSelfeSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AttendanceController>(builder: (attendanceController) {
      final String titleText =
          (attendanceController.attendanceModel?.isPunchIn ?? false)
              ? "Punch in Selfie"
              : (attendanceController.attendanceModel?.isPunchOut ?? false)
                  ? "Punch out Selfie"
                  : "";

      final String imageUri = (attendanceController
                  .attendanceModel?.isPunchIn ??
              false)
          ? attendanceController.attendanceModel?.checkInSelfieUrl ?? ""
          : (attendanceController.attendanceModel?.isPunchOut ?? false)
              ? attendanceController.attendanceModel?.checkOutSelfieUrl ?? ""
              : "";
      return Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 2),
              blurRadius: 4,
              spreadRadius: -2,
              color: black.withValues(
                alpha: 0.05,
              ),
            ),
            BoxShadow(
              offset: const Offset(0, 4),
              blurRadius: 6,
              spreadRadius: -1,
              color: black.withValues(
                alpha: 0.05,
              ),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.camera_alt_outlined,
                  size: 18.sp,
                  color: green2,
                ),
                sizedBoxWidth(width: 8.w),
                CustomText(
                  titleText,
                  style: Helper(context).textTheme.titleMedium?.copyWith(
                        fontSize: 14,
                        color: blackText1,
                      ),
                ),
              ],
            ),
            sizedBoxHeight(height: 16.h),
            CustomShimmer(
              isLoading: attendanceController.isLoading,
              child: Center(
                child: CustomImage(
                  path: imageUri,
                  height: 300.h,
                  width: 200.w,
                  radius: 16.r,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
