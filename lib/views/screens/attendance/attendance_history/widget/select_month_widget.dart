import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/state_manager.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:vlr/controllers/attendance_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_image.dart';

class SelectMonthWidget extends StatelessWidget {
  const SelectMonthWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AttendanceController>(builder: (attendanceController) {
      return GestureDetector(
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

          await attendanceController.fetchAttendanceHistory();
        },
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(25.r),
            border: Border.all(color: greyLight6),
            boxShadow: [
              BoxShadow(
                color: black.withValues(alpha: 0.05),
                blurRadius: 1,
                offset: const Offset(0, 1),
              )
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.calendar_month),
              sizedBoxWidth(width: 12.w),
              Expanded(
                child: CustomText(
                  DateFormat('MMMM yyyy')
                      .format(attendanceController.selectedMonth),
                  style: Helper(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 16,
                      ),
                ),
              ),
              SvgPicture.asset(Assets.svgsIconDown),
            ],
          ),
        ),
      );
    });
  }
}
