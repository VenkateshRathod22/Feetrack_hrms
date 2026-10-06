import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/date_formatters_and_converters.dart';
import 'package:vlr/services/theme.dart';

class CalenderWidgetTodayStatus extends StatelessWidget {
  const CalenderWidgetTodayStatus({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: greyDart.withValues(alpha: 0.20),
        borderRadius: BorderRadius.circular(16),
        border: const Border(
          left: BorderSide(
            width: 4,
            color: primaryColor,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
                color: tertiaryColor,
                borderRadius: BorderRadius.circular(12.r)),
            child: Icon(
              Icons.calendar_month,
              color: white,
            ),
          ),
          sizedBoxWidth(width: 16.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now()),
                style: Helper(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 18.sp,
                      color: blackText3,
                    ),
              ),
              CustomText(
                DateFormatters().hMA.format(getDateTime()),
                style: Helper(context).textTheme.labelSmall?.copyWith(
                      fontSize: 12.sp,
                      color: greyDart2,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
