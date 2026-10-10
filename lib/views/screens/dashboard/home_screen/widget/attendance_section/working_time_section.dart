import 'dart:async'; // 1. Import dart:async for the Timer
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/attendance_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';

class WorkingTimeSection extends StatefulWidget {
  const WorkingTimeSection({
    super.key,
  });

  @override
  State<WorkingTimeSection> createState() => _WorkingTimeSectionState();
}

class _WorkingTimeSectionState extends State<WorkingTimeSection> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // 2. Start a timer that ticks every 1 second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // Only rebuild if the user is actually punched in to save performance
      final controller = Get.find<AttendanceController>();
      if (controller.attendanceModel?.isPunchIn == true) {
        setState(
            () {}); // This forces the widget to rebuild and fetch the latest time
      }
    });
  }

  @override
  void dispose() {
    // 3. IMPORTANT: Cancel the timer when the widget is destroyed to prevent memory leaks
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AttendanceController>(builder: (attendanceController) {
      return Column(
        children: [
          CustomText(
            attendanceController.attendanceModel?.workingTiming ?? "00 : 00",
            style: Helper(context).textTheme.titleMedium?.copyWith(
                  fontSize: 34.sp,
                ),
          ),
          CustomText(
            "Working time",
            style: Helper(context).textTheme.titleMedium?.copyWith(
                  fontSize: 12.sp,
                  color: greyLight5,
                ),
          ),
        ],
      );
    });
  }
}
