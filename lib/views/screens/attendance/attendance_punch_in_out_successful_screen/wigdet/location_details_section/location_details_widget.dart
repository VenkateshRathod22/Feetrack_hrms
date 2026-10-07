import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_button.dart';
import 'package:vlr/views/screens/attendance/attendance_punch_in_out_successful_screen/wigdet/location_details_section/location_widget_model.dart';

class LocationDetailsWidget extends StatelessWidget {
  final LocationWidgetModel locationWidgetModel;
  const LocationDetailsWidget({
    super.key,
    required this.locationWidgetModel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.location_on,
          color: locationWidgetModel.color,
        ),
        sizedBoxWidth(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                locationWidgetModel.title ?? "",
                style: Helper(context).textTheme.titleMedium?.copyWith(
                      fontSize: 12.sp,
                      color: blackText1,
                    ),
              ),
              sizedBoxHeight(height: 2.h),
              CustomText(
                "${locationWidgetModel.lat ?? ""}, ${locationWidgetModel.lng ?? ""}",
                style: Helper(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 12.sp,
                      color: blackText1,
                    ),
              ),
            ],
          ),
        ),
        CustomButton(
          type: ButtonType.secondary,
          height: 40.h,
          radius: 8.r,
          borderColor: locationWidgetModel.color,
          color: locationWidgetModel.color.withValues(alpha: 0.10),
          onTap: locationWidgetModel.onTap,
          child: Row(
            children: [
              Icon(
                Icons.map_outlined,
                color: locationWidgetModel.color,
                size: 14.sp,
              ),
              sizedBoxWidth(width: 6.w),
              CustomText(
                "View on Map",
                style: Helper(context).textTheme.titleMedium?.copyWith(
                      fontSize: 10.sp,
                      color: locationWidgetModel.color,
                    ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
