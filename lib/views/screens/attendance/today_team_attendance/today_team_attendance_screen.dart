import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/attendance_controller.dart';
import 'package:vlr/data/models/employee_model.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/views/base/shimmer.dart';
import 'package:vlr/views/screens/attendance/team_attendance_history/team_attendaance_history_screen/widget/appbar_and_searchbar.dart';
import 'package:vlr/views/screens/attendance/today_team_attendance/widget/employee_today_team_attendance_widget.dart';
import 'package:vlr/views/screens/attendance/today_team_attendance/widget/today_team_attendance_summary_section/today_team_attendance_summary_section.dart';

class TodayTeamAttendanceScreen extends StatefulWidget {
  const TodayTeamAttendanceScreen({super.key});

  @override
  State<TodayTeamAttendanceScreen> createState() =>
      _TodayTeamAttendanceScreenState();
}

class _TodayTeamAttendanceScreenState extends State<TodayTeamAttendanceScreen> {
  Timer? _debounce;
  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<AttendanceController>().fetchTodayTeamAttendance();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<AttendanceController>(builder: (attendanceController) {
        return Column(
          children: [
            AppBarAndSearchBar(
              title: "Today Team Attendance",
              onChanged: (value) {
                _debounce?.cancel();

                _debounce = Timer(
                  const Duration(milliseconds: 500),
                  () {
                    final controller = Get.find<AttendanceController>();

                    controller.searchBarController.text = value.trim();

                    controller.fetchTodayTeamAttendance();
                  },
                );
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: AppConstants.screenPadding,
                child: Column(
                  children: [
                    const TodayTeamAttendanceSummarySection(),
                    !attendanceController.isLoading &&
                            attendanceController
                                .employeesModelTodayAttendanceList.isEmpty
                        ? Padding(
                            padding: EdgeInsets.only(top: 30.h),
                            child: Center(
                              child: CustomText(
                                "No Employee Found",
                                style: Helper(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(fontSize: 16),
                              ),
                            ),
                          )
                        : const SizedBox(),
                    ListView.separated(
                      itemBuilder: (context, index) {
                        final model = attendanceController.isLoading
                            ? EmployeesModel()
                            : attendanceController
                                .employeesModelTodayAttendanceList[index];
                        return CustomShimmer(
                            isLoading: attendanceController.isLoading,
                            child: EmployeeTodayTeamAttendanceWidget(
                              employeesModel: model,
                            ));
                      },
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (_, __) => sizedBoxHeight(height: 16.h),
                      itemCount: attendanceController.isLoading
                          ? 4
                          : attendanceController
                              .employeesModelTodayAttendanceList.length,
                      shrinkWrap: true,
                    ),
                  ],
                ),
              ),
            )
          ],
        );
      }),
    );
  }
}
