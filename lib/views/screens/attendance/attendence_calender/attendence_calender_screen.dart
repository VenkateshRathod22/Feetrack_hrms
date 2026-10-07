import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/attendance_controller.dart';
import 'package:vlr/data/models/attendance/attendance_calendar_model.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/widget/button/appbar_back_button.dart';

class AttendenceCalenderScreen extends StatefulWidget {
  const AttendenceCalenderScreen({super.key});

  @override
  State<AttendenceCalenderScreen> createState() => _AttendenceCalenderScreenState();
}

class _AttendenceCalenderScreenState extends State<AttendenceCalenderScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<AttendanceController>().fetchAttendanceCalendar();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundLight,
      body: GetBuilder<AttendanceController>(builder: (controller) {
        return Column(
          children: [
            _buildHeader(context, controller),
            Expanded(
              child: controller.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : controller.attendanceCalendar == null
                      ? const Center(child: Text("No data found"))
                      : RefreshIndicator(
                          onRefresh: () async {
                            await controller.fetchAttendanceCalendar(
                              employeeId: controller.selectedCalendarEmployee?.id,
                              month: controller.attendanceCalendar?.month,
                              year: controller.attendanceCalendar?.year,
                            );
                          },
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: EdgeInsets.all(16.w),
                            child: Column(
                              children: [
                                if (controller.attendanceCalendar?.employees != null &&
                                    controller.attendanceCalendar!.employees!.length > 1)
                                  _buildEmployeeSelector(controller),
                                sizedBoxHeight(height: 16),
                                _buildCalendar(context, controller),
                                sizedBoxHeight(height: 16),
                                _buildSummary(context, controller),
                                sizedBoxHeight(height: 24),
                                _buildLegend(context),
                                sizedBoxHeight(height: 40),
                              ],
                            ),
                          ),
                        ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildHeader(BuildContext context, AttendanceController controller) {
    String monthYear = "";
    if (controller.attendanceCalendar != null) {
      monthYear = "${controller.attendanceCalendar!.monthName} ${controller.attendanceCalendar!.year}";
    }

    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 10.h, bottom: 20.h, left: 16.w, right: 16.w),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const AppBarBackButton(),
              sizedBoxWidth(width: 10),
              Expanded(
                child: CustomText(
                  "Attendance Calendar",
                  style: Helper(context).textTheme.titleLarge?.copyWith(color: white, fontSize: 18.sp),
                ),
              ),
            ],
          ),
          sizedBoxHeight(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => controller.changeCalendarMonth(false),
                icon: Icon(Icons.arrow_back_ios, color: white, size: 20.sp),
              ),
              CustomText(
                monthYear,
                style: TextStyle(color: white, fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () => controller.changeCalendarMonth(true),
                icon: Icon(Icons.arrow_forward_ios, color: white, size: 20.sp),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeSelector(AttendanceController controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: greyLight2),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<CalendarEmployee>(
          isExpanded: true,
          value: controller.selectedCalendarEmployee,
          items: controller.attendanceCalendar!.employees!.map((e) {
            return DropdownMenuItem(
              value: e,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 12.r,
                    backgroundColor: primaryColor.withValues(alpha: 0.1),
                    child: CustomText(
                      e.name?[0].toUpperCase() ?? "",
                      style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold),
                    ),
                  ),
                  sizedBoxWidth(width: 8),
                  CustomText(e.name ?? "", style: TextStyle(fontSize: 14.sp)),
                ],
              ),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) controller.updateSelectedCalendarEmployee(val);
          },
        ),
      ),
    );
  }

  Widget _buildCalendar(BuildContext context, AttendanceController controller) {
    final calendar = controller.attendanceCalendar!;
    final days = calendar.days ?? [];
    final startDay = calendar.startDayOfWeek ?? 0; // 0=Sun, 1=Mon... as per response (usually)
    // Wait, the response sample says "start_day_of_week": 2 for Sep 2026. 
    // Sep 1, 2026 is Tuesday. So 0=Sun, 1=Mon, 2=Tue. Correct.

    List<Widget> gridItems = [];
    
    // Day headers
    const weekDays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
    for (var day in weekDays) {
      gridItems.add(
        Center(
          child: CustomText(
            day,
            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: greyText),
          ),
        ),
      );
    }

    // Empty spaces before first day
    for (int i = 0; i < startDay; i++) {
      gridItems.add(const SizedBox.shrink());
    }

    // Actual days
    for (var day in days) {
      gridItems.add(_buildDayCell(context, day));
    }

    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: GridView.count(
        crossAxisCount: 7,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 8.h,
        crossAxisSpacing: 8.w,
        children: gridItems,
      ),
    );
  }

  Widget _buildDayCell(BuildContext context, CalendarDay day) {
    Color bgColor = Colors.transparent;
    Color textColor = black;
    
    String status = day.status?.toLowerCase() ?? "";
    
    if (status == "punch in" || status == "punch_in" || status == "present") {
      bgColor = punchOut.withValues(alpha: 0.1);
      textColor = punchOut;
    } else if (status == "absent") {
      bgColor = absent.withValues(alpha: 0.1);
      textColor = absent;
    } else if (status == "week off" || status == "week_off") {
      bgColor = weekOff.withValues(alpha: 0.1);
      textColor = weekOff;
    } else if (status == "holiday") {
      bgColor = holiday.withValues(alpha: 0.1);
      textColor = holiday;
    } else if (status == "leave") {
      bgColor = leave.withValues(alpha: 0.1);
      textColor = leave;
    } else if (status == "half day" || status == "half_day") {
      bgColor = halfDay.withValues(alpha: 0.1);
      textColor = halfDay;
    }

    if (day.isToday == true) {
      bgColor = primaryColor;
      textColor = white;
    }

    return GestureDetector(
      onTap: day.clickable == true ? () {
        // Show details dialog or navigate
        if (day.attendance != null) {
           _showAttendanceDetails(context, day);
        }
      } : null,
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
          border: day.isToday == true ? null : Border.all(color: greyLight4, width: 0.5),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                day.day.toString(),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: day.isToday == true || status.isNotEmpty ? FontWeight.bold : FontWeight.normal,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummary(BuildContext context, AttendanceController controller) {
    final summary = controller.attendanceCalendar?.summary;
    if (summary == null) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            "Monthly Summary",
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: blackText1),
          ),
          sizedBoxHeight(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _summaryItem("Present", summary.punchIn ?? 0, punchOut),
              _summaryItem("Absent", summary.absent ?? 0, absent),
              _summaryItem("Week Off", summary.weekOff ?? 0, weekOff),
              _summaryItem("Holiday", summary.holiday ?? 0, holiday),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryItem(String label, int count, Color color) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: CustomText(
            count.toString(),
            style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16.sp),
          ),
        ),
        sizedBoxHeight(height: 4),
        CustomText(label, style: TextStyle(fontSize: 10.sp, color: greyText)),
      ],
    );
  }

  Widget _buildLegend(BuildContext context) {
    return Wrap(
      spacing: 16.w,
      runSpacing: 8.h,
      alignment: WrapAlignment.center,
      children: [
        _legendItem("Present", punchOut),
        _legendItem("Absent", absent),
        _legendItem("Week Off", weekOff),
        _legendItem("Holiday", holiday),
        _legendItem("Leave", leave),
        _legendItem("Half Day", halfDay),
        _legendItem("Today", primaryColor),
      ],
    );
  }

  Widget _legendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        sizedBoxWidth(width: 4),
        CustomText(label, style: TextStyle(fontSize: 12.sp, color: greyDart3)),
      ],
    );
  }

  void _showAttendanceDetails(BuildContext context, CalendarDay day) {
    final att = day.attendance!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Attendance Details - ${day.date}"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _detailRow("Punch In", att.checkInTimeFormat ?? "-- : --"),
            _detailRow("Punch Out", att.checkOutTimeFormat ?? "-- : --"),
            _detailRow("Status", capitalize(att.status)),
            if (att.workingMinutes != null)
               _detailRow("Working Time", "${att.workingMinutes} mins"),
            if (att.lateMinutes != null && att.lateMinutes != "0" && att.lateMinutes != "")
               _detailRow("Late", "${att.lateMinutes} mins", color: red),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Close")),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value, {Color? color}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          CustomText(value, style: TextStyle(color: color)),
        ],
      ),
    );
  }
}
