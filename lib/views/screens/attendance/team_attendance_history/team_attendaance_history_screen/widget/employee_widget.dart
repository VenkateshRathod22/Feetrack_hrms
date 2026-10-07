import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/attendance_controller.dart';
import 'package:vlr/data/models/employee_model.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_image.dart';
import 'package:vlr/views/base/shimmer.dart';
import 'package:vlr/views/screens/attendance/team_attendance_history/employee_attendance_history_screen/employee_attendance_history_screen.dart';

class EmployeeWidget extends StatelessWidget {
  final EmployeesModel? employeesModel;
  final bool isLoading;

  const EmployeeWidget({
    super.key,
    this.employeesModel,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return CustomShimmer(
      isLoading: isLoading,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              width: 1,
              color: greyLight1,
            ),
            color: white,
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 1),
                blurRadius: 2,
                spreadRadius: 0,
                color: black.withValues(alpha: 0.05),
              )
            ]),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 64.h,
              width: 64.w,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 2,
                    color: greyLight6,
                  )),
              child: CustomImage(
                path: employeesModel?.profileImageUrl ?? "",
                radius: 999.r,
                fit: BoxFit.cover,
              ),
            ),
            sizedBoxWidth(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    capitalize(employeesModel?.name ?? ""),
                    maxLines: 2,
                    style: Helper(context).textTheme.titleMedium?.copyWith(
                          fontSize: 18.sp,
                          color: blackText3,
                        ),
                  ),
                  CustomText(
                    employeesModel?.role ?? "",
                    style: Helper(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 14.sp,
                          color: primaryColor,
                        ),
                  ),
                  CustomText(
                    "Employee Id : ${employeesModel?.id ?? ""}",
                    style: Helper(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 14.sp,
                        ),
                  ),
                  sizedBoxHeight(height: 16.h),
                  GetBuilder<AttendanceController>(
                      builder: (attendanceController) {
                    return Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          attendanceController.updateSelectEmployeeModel(
                              employeesModel:
                                  employeesModel ?? EmployeesModel());
                          navigate(
                            context: context,
                            page: const EmployeeAttendanceHistoryScreen(),
                          );
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomText(
                              "View History",
                              style: Helper(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontSize: 14.sp,
                                    color: tertiaryColor,
                                  ),
                            ),
                            SizedBox(width: 4.w),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 16.sp,
                              color: tertiaryColor,
                            ),
                          ],
                        ),
                      ),
                    );
                  })
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
