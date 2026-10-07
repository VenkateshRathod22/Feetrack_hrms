import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/attendance_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_image.dart';
import 'package:vlr/views/screens/attendance/team_attendance_history/employee_attendance_history_screen/widget/appbar_of_employee_section/employee_count_widget.dart';
import 'package:vlr/views/widget/button/appbar_back_button.dart';

class AppBarOfEmployeeSection extends StatelessWidget {
  const AppBarOfEmployeeSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GetBuilder<AttendanceController>(builder: (attendanceController) {
          return Column(
            children: [
              Container(
                padding: AppConstants.screenPadding,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.horizontal(
                    right: Radius.circular(
                      32.r,
                    ),
                    left: Radius.circular(
                      32.r,
                    ),
                  ),
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
                              "Employee History",
                              style: Helper(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontSize: 20.sp,
                                    color: white,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    sizedBoxHeight(height: 32.h),
                    Row(
                      children: [
                        CustomImage(
                          path: attendanceController
                                  .employeesModel?.profileImageUrl ??
                              "",
                          height: 80.h,
                          width: 80.w,
                          radius: 999.r,
                          fit: BoxFit.cover,
                        ),
                        sizedBoxWidth(width: 16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                attendanceController.employeesModel?.name ?? "",
                                style: Helper(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      fontSize: 20.sp,
                                      color: white,
                                    ),
                              ),
                              CustomText(
                                attendanceController.employeesModel?.role ?? "",
                                style: Helper(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontSize: 14.sp,
                                      color: white,
                                    ),
                              ),
                              sizedBoxHeight(height: 4.h),
                              CustomText(
                                "Employee Id: ${attendanceController.employeesModel?.id ?? ""}",
                                maxLines: 1,
                                style: Helper(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      fontSize: 12.sp,
                                      color: white,
                                    ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    sizedBoxHeight(height: 64.h),
                  ],
                ),
              ),
              sizedBoxHeight(height: 40.h)
            ],
          );
        }),
        Positioned(
            bottom: 0,
            right: 20.w,
            left: 20.w,
            child: GetBuilder<AttendanceController>(
                builder: (attendanceController) {
              return Container(
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                    color: white,
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 4),
                        blurRadius: 12,
                        spreadRadius: 0,
                        color: black.withValues(alpha: 0.05),
                      )
                    ]),
                child: Row(
                  children: [
                    Expanded(
                      child: EmployeeCountWidget(
                        title: attendanceController
                                .employeesAttendanceSummaryModel?.punchOut
                                .toString() ??
                            "",
                        subtitle: 'Present',
                        color: green2,
                      ),
                    ),
                    Container(
                      width: 1,
                      color: greyLight3,
                      height: 50,
                    ),
                    Expanded(
                      child: EmployeeCountWidget(
                        title: attendanceController
                                .employeesAttendanceSummaryModel?.absent
                                .toString() ??
                            "",
                        subtitle: 'Absent',
                        color: red1,
                      ),
                    ),
                    Container(
                      width: 1,
                      color: greyLight3,
                      height: 50,
                    ),
                    Expanded(
                      child: EmployeeCountWidget(
                        title: attendanceController
                                .employeesAttendanceSummaryModel?.leave
                                .toString() ??
                            "",
                        subtitle: 'Leave',
                        color: tertiaryColor,
                      ),
                    ),
                    Container(
                      width: 1,
                      color: greyLight3,
                      height: 50,
                    ),
                    Expanded(
                      child: EmployeeCountWidget(
                        title: attendanceController
                                .employeesAttendanceSummaryModel?.halfDay
                                .toString() ??
                            "",
                        subtitle: 'Halfday',
                        color: holiday,
                      ),
                    ),
                    Container(
                      width: 1,
                      color: greyLight3,
                      height: 50,
                    ),
                    Expanded(
                      child: EmployeeCountWidget(
                        title: (attendanceController
                                    .employeesAttendanceSummaryModel?.late ??
                                0)
                            .toString(),
                        subtitle: 'Late',
                        color: shortLeave,
                      ),
                    ),
                  ],
                ),
              );
            }))
      ],
    );
  }
}
