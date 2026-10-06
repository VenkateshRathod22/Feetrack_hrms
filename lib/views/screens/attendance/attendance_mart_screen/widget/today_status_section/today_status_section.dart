import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/screens/attendance/attendance_mart_screen/widget/today_status_section/calender_widged_today_status.dart';
import 'package:vlr/views/screens/attendance/attendance_mart_screen/widget/today_status_section/check_in_and_check_out_widget_today_status.dart';

class TodayStatus extends StatelessWidget {
  const TodayStatus({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w),
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: greyLight6),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(
                24.r,
              ),
              topRight: Radius.circular(
                24.r,
              ),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.watch_later_outlined,
                color: blueLight3,
              ),
              sizedBoxWidth(width: 8.w),
              CustomText(
                "TODAY'S STATUS",
                style: Helper(context).textTheme.labelMedium?.copyWith(
                      fontSize: 14,
                      color: greyDart2,
                    ),
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1, color: greyLight6),
              left: BorderSide(width: 1, color: greyLight6),
              right: BorderSide(width: 1, color: greyLight6),
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(
                24.r,
              ),
              bottomRight: Radius.circular(
                24.r,
              ),
            ),
          ),
          child: Column(
            children: [
              const CalenderWidgetTodayStatus(),
              sizedBoxHeight(height: 16),
              const CheckInandCheckOutWidgetTodayStatus()
            ],
          ),
        )
      ],
    );
  }
}
