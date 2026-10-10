import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/attendance_controller.dart';
import 'package:vlr/controllers/permission_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_button.dart';
import 'package:vlr/views/screens/attendance/attendance_punch_in_out_successful_screen/attendance_punch_in_out_success_screen.dart';
import 'package:vlr/views/screens/dashboard/home_screen/widget/attendance_section/attendance_camera_section.dart';
import 'package:vlr/views/screens/dashboard/home_screen/widget/attendance_section/check_in_out_row_section.dart';
import 'package:vlr/views/screens/dashboard/home_screen/widget/attendance_section/duty_status_widget.dart';
import 'package:vlr/views/screens/dashboard/home_screen/widget/attendance_section/location_row_widget.dart';
import 'package:vlr/views/screens/dashboard/home_screen/widget/attendance_section/working_time_section.dart';

class AttendanceSection extends StatelessWidget {
  const AttendanceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AttendanceController>(builder: (attendanceController) {
      return Container(
        padding: EdgeInsets.all(20.w),
        decoration: containerDecoration,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomText(
                  "Today’s Attendance",
                  style: Helper(context).textTheme.titleMedium?.copyWith(
                        fontSize: 18.sp,
                      ),
                ),
              ],
            ),
            sizedBoxHeight(height: 20.h),
            const AttendanceCameraSection(),
            sizedBoxHeight(height: 16.h),
            const DutyStatusWidget(),
            sizedBoxHeight(height: 8.h),
            const LocationRowWidget(),
            sizedBoxHeight(height: 12.h),
            const WorkingTimeSection(),
            sizedBoxHeight(height: 12.h),
            const CheckInAndOutTImeRowSection(),
            sizedBoxHeight(height: 20.h),
            GetBuilder<PermissionController>(builder: (permissionController) {
              if ((attendanceController.attendanceModel?.isNotPunchIn ??
                      false) ||
                  (attendanceController.attendanceModel?.isPunchIn ?? false)) {
                return Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        isLoading: attendanceController.isLoading,
                        height: 50.h,
                        radius: 12.r,
                        onTap: () {
                          if (attendanceController.isLoading) {
                            return showToast(
                                message: "Please wait...",
                                toastType: ToastType.info);
                          }
                          if (permissionController.selfie == null) {
                            return showToast(
                                message: "Take selfie of you",
                                toastType: ToastType.info);
                          }
                          if ((permissionController.latitude == null) ||
                              (permissionController.longitude == null)) {
                            permissionController
                                .requestLocationPermissionAndFetch(context);
                          }

                          if (attendanceController
                                  .attendanceModel?.isNotPunchIn ??
                              false) {
                            attendanceController
                                .punchInAttendance(
                              lat: permissionController.latitude.toString(),
                              lng: permissionController.longitude.toString(),
                              selfie: permissionController.selfie,
                            )
                                .then((value) {
                              if (value.isSuccess) {
                                attendanceController
                                    .submitCheckListPointForPunchIn()
                                    .then((value) {
                                  if (value.isSuccess) {
                                    permissionController.updateCamera(
                                        value: false);
                                    permissionController.updateCamera(
                                        value: false);

                                    navigate(
                                        context: context,
                                        page:
                                            const AttendancePunchInOutSuccessScreen());
                                  } else {
                                    permissionController.updateCamera(
                                        value: false);

                                    showToast(
                                        message: value.message,
                                        typeCheck: value.isSuccess);
                                  }
                                });
                                permissionController.updateCamera(value: false);

                                showToast(
                                    message: value.message,
                                    typeCheck: value.isSuccess);
                              } else {
                                permissionController.updateCamera(value: false);

                                showToast(
                                    message: value.message,
                                    typeCheck: value.isSuccess);
                              }
                            });
                          }
                        },
                        type: ButtonType.secondary,
                        borderColor: grey1,
                        child: CustomText(
                          "Check in",
                          style: Helper(context).textTheme.bodyLarge?.copyWith(
                                fontSize: 16.sp,
                              ),
                        ),
                      ),
                    ),
                    sizedBoxWidth(width: 12),

                    ///* ----- Check out -------
                    Expanded(
                      child: CustomButton(
                        isLoading: attendanceController.isLoading,
                        height: 50.h,
                        radius: 12.r,
                        onTap: () {
                          if (attendanceController.isLoading) {
                            return showToast(
                                message: "Please wait...",
                                toastType: ToastType.info);
                          }
                          if (attendanceController.attendanceModel?.isPunchIn ??
                              false) {
                            if (permissionController.selfie == null) {
                              return showToast(
                                  message: "Take selfie of you",
                                  toastType: ToastType.info);
                            }

                            attendanceController
                                .fetchCheckListPoint()
                                .then((value1) {
                              if (value1.isSuccess) {
                                attendanceController
                                    .submitCheckListPointForPunchOut()
                                    .then((value) {
                                  if (value.isSuccess) {
                                    attendanceController
                                        .punchOutAttendance(
                                      lat: permissionController.latitude
                                          .toString(),
                                      lng: permissionController.longitude
                                          .toString(),
                                      selfie: permissionController.selfie,
                                    )
                                        .then((value) {
                                      if (value.isSuccess) {
                                        permissionController.updateCamera(
                                            value: false);
                                        navigate(
                                            context: context,
                                            page:
                                                const AttendancePunchInOutSuccessScreen());
                                      } else {
                                        permissionController.updateCamera(
                                            value: false);

                                        showToast(
                                            message: value.message,
                                            typeCheck: value.isSuccess);
                                      }
                                    });
                                  } else {
                                    permissionController.updateCamera(
                                        value: false);

                                    showToast(
                                        message: value.message,
                                        typeCheck: value.isSuccess);
                                  }
                                });
                              } else {
                                showToast(
                                    message: value1.message,
                                    typeCheck: value1.isSuccess);
                              }
                            });

                            if ((permissionController.latitude == null) ||
                                (permissionController.longitude == null)) {
                              permissionController
                                  .requestLocationPermissionAndFetch(context);
                            }
                          } else if (attendanceController
                                  .attendanceModel?.isNotPunchIn ??
                              false) {
                            permissionController.updateCamera(value: false);

                            return showToast(
                                message: "Check in first",
                                toastType: ToastType.warning);
                          }
                        },
                        color: primaryColor,
                        borderColor: primaryColor,
                        child: CustomText(
                          "Check out",
                          style: Helper(context).textTheme.bodyLarge?.copyWith(
                                fontSize: 16.sp,
                                color: Get.isDarkMode ? black : white,
                              ),
                        ),
                      ),
                    ),
                  ],
                );
              }
              return SizedBox();
            })
          ],
        ),
      );
    });
  }
}
