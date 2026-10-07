import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';

class LocationAttendanceWidget extends StatelessWidget {
  final String title;
  final String? location;
  final Color color;
  final Function() onTap;
  const LocationAttendanceWidget({
    super.key,
    required this.title,
    required this.location,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundColor: color,
              radius: 4.r,
            ),
            sizedBoxWidth(width: 8.w),
            CustomText(
              title,
              style: Helper(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 10.sp,
                    color: greyLight8,
                  ),
            )
          ],
        ),
        sizedBoxHeight(height: 4.h),
        CustomText(
          location ?? "--",
          style: Helper(context).textTheme.bodyMedium?.copyWith(
                fontSize: 11.sp,
              ),
        ),
        sizedBoxHeight(height: 4.h),
        GestureDetector(
          onTap: onTap,
          child: Row(
            children: [
              CustomText(
                "View on Map",
                style: Helper(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontSize: 10.sp, color: blueLight3),
              ),
              sizedBoxWidth(width: 4.w),
              Icon(
                Icons.open_in_new_outlined,
                color: blueLight3,
                size: 14.sp,
              )
            ],
          ),
        )
      ],
    );
  }
}
