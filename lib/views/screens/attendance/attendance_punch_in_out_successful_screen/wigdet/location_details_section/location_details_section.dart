import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:vlr/controllers/attendance_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_image.dart';
import 'package:vlr/views/base/shimmer.dart';
import 'package:vlr/views/screens/attendance/attendance_punch_in_out_successful_screen/wigdet/location_details_section/location_details_widget.dart';
import 'package:vlr/views/screens/attendance/attendance_punch_in_out_successful_screen/wigdet/location_details_section/location_widget_model.dart';

class LocationDetailSection extends StatelessWidget {
  const LocationDetailSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
              SvgPicture.asset(
                Assets.svgsLocationOutline,
                height: 20.h,
                width: 20.w,
                fit: BoxFit.cover,
              ),
              sizedBoxWidth(width: 8.w),
              Expanded(
                child: CustomText(
                  "Location Details",
                  style: Helper(context).textTheme.titleMedium?.copyWith(
                        fontSize: 14,
                        color: blackText1,
                      ),
                ),
              ),
            ],
          ),
          sizedBoxHeight(height: 16.h),
          GetBuilder<AttendanceController>(builder: (attendanceController) {
            final list = locationWidgetModelList(
                attendanceController: attendanceController);
            return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final locationWidgetModel = list[index];
                  return CustomShimmer(
                    isLoading: attendanceController.isLoading,
                    child: LocationDetailsWidget(
                        locationWidgetModel: locationWidgetModel),
                  );
                },
                separatorBuilder: (_, __) => Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      child: Divider(
                        color: greyLight6,
                      ),
                    ),
                itemCount: list.length);
          })
        ],
      ),
    );
  }
}
