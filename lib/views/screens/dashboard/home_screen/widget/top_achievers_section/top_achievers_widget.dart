import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_image.dart';

import 'package:vlr/data/models/dashboard_model.dart';

class TopAchieversWidget extends StatelessWidget {
  final TopAchiever? achiever;
  const TopAchieversWidget({super.key, this.achiever});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: pinkLight2,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomImage(
            path: achiever?.user?.profileImage ?? Assets.imagesProfile,
            height: 46.h,
            width: 46.w,
            fit: BoxFit.cover,
            radius: 100.r,
          ),
          sizedBoxHeight(height: 8.h),
          CustomText(
            achiever?.user?.name ?? "N/A",
            maxLines: 1,
            style: Helper(context).textTheme.titleMedium?.copyWith(
                  fontSize: 14.sp,
                ),
          ),
          CustomText(
            "Target: ${achiever?.target ?? 0}",
            maxLines: 1,
            style: Helper(context).textTheme.titleSmall?.copyWith(
                  fontSize: 12.sp,
                ),
          ),
          CustomText(
            "Business: ${achiever?.business ?? 0}",
            maxLines: 1,
            style: Helper(context).textTheme.titleSmall?.copyWith(
                  fontSize: 12.sp,
                ),
          ),
          sizedBoxHeight(height: 4.h),
          CustomText(
            "${achiever?.pct ?? 0}% Achieved",
            maxLines: 1,
            style: Helper(context).textTheme.bodySmall?.copyWith(
                  fontSize: 10.sp,
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}
