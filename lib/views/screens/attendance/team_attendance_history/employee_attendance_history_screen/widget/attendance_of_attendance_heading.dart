import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:vlr/controllers/attendance_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/date_formatters_and_converters.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_button.dart';
import 'package:vlr/views/base/custom_image.dart';

class RowOfAttendanceHeading extends StatelessWidget {
  const RowOfAttendanceHeading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    DateTime data = DateTime.now();
    return Padding(
      padding: AppConstants.screenPadding,
      child: Row(
        children: [
          Expanded(
            child: CustomText(
              "Attendance History",
              style: Helper(context).textTheme.titleLarge?.copyWith(
                    fontSize: 18.sp,
                    color: blackText2,
                  ),
            ),
          ),
          GetBuilder<AttendanceController>(builder: (attendanceController) {
            return CustomButton(
              type: ButtonType.tertiary,
              onTap: () async {
                final month = await showMonthPicker(
                  context: context,
                  initialDate: attendanceController.selectedMonth,
                  firstDate: DateTime(2024),
                  lastDate: DateTime(2035),
                );

                // User pressed Cancel
                if (month == null) return;

                // Don't call API if same month is selected
                if (month.month == attendanceController.selectedMonth.month &&
                    month.year == attendanceController.selectedMonth.year) {
                  return;
                }

                attendanceController.selectedMonth = month;

                await attendanceController.fetchTeamEmployeeAttendanceList();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    attendanceController.selectedMonth.month == data.month
                        ? "This Month"
                        : DateFormatters()
                            .month
                            .format(attendanceController.selectedMonth),
                    style: Helper(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 14.sp,
                          color: tertiaryColor,
                        ),
                  ),
                  sizedBoxWidth(width: 8.w),
                  SvgPicture.asset(
                    Assets.svgsIconDown,
                    colorFilter:
                        ColorFilter.mode(tertiaryColor, BlendMode.srcIn),
                  )
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
