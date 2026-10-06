import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:vlr/controllers/attendance_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/widget/button/appbar_back_button.dart';
import 'package:vlr/views/widget/text_box/app_text_box.dart';

class AppBarAndSearchBar extends StatelessWidget {
  final String title;
  final Function(String)? onChanged;
  const AppBarAndSearchBar({
    super.key,
    required this.title,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppConstants.screenPadding,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryColor,
            tertiaryColor,
          ],
        ),
      ),
      child: Column(
        children: [
          sizedBoxHeight(height: 36.h),
          Row(
            children: [
              const AppBarBackButton(),
              sizedBoxWidth(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    title,
                    style: Helper(context).textTheme.titleLarge?.copyWith(
                          fontSize: 20.sp,
                          color: white,
                        ),
                  ),
                  sizedBoxHeight(height: 6.h),
                  CustomText(
                    "Track and manage your team's attendance.",
                    style: Helper(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 12.sp,
                          color: white,
                        ),
                  ),
                ],
              ),
            ],
          ),
          sizedBoxHeight(height: 30.h),
          GetBuilder<AttendanceController>(builder: (attendanceController) {
            return Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 4),
                  blurRadius: 6,
                  spreadRadius: -4,
                  color: black.withValues(alpha: 0.10),
                ),
                BoxShadow(
                  offset: const Offset(0, 10),
                  blurRadius: 15,
                  spreadRadius: -3,
                  color: black.withValues(alpha: 0.10),
                )
              ]),
              child: AppTextFieldWithHeading(
                controller: attendanceController.searchBarController,
                bgColor: white,
                hindText: "Search employee by name, position, employee id...",
                onChanged: onChanged,
              ),
            );
          })
        ],
      ),
    );
  }
}
