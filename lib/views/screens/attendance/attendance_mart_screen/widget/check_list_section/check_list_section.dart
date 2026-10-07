import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/state_manager.dart';
import 'package:vlr/controllers/attendance_controller.dart';
import 'package:vlr/controllers/permission_controller.dart';
import 'package:vlr/data/models/check_point_model.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/shimmer.dart';
import 'package:vlr/views/screens/account_screen/widget/daily_attendance_section/punch_out_button.dart';
import 'package:vlr/views/screens/attendance/attendance_mart_screen/widget/check_list_section/check_list_widget.dart';
import 'package:vlr/views/screens/attendance/attendance_punch_in_out_successful_screen/attendance_punch_in_out_success_screen.dart';

class CheckListSection extends StatelessWidget {
  const CheckListSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GetBuilder<AttendanceController>(builder: (attendanceController) {
          String title =
              (attendanceController.attendanceModel?.isNotPunchIn ?? false)
                  ? "Pre-Check-in Checklist"
                  : (attendanceController.attendanceModel?.isPunchIn ?? false)
                      ? "Post check out Checklist"
                      : "";
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
                      Icons.checklist_outlined,
                      color: blueLight3,
                    ),
                    sizedBoxWidth(width: 8.w),
                    CustomText(
                      title,
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
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    final model = attendanceController.isLoading
                        ? CheckPointModel()
                        : attendanceController.checkPointModelList[index];
                    return CustomShimmer(
                      isLoading: attendanceController.isLoading,
                      child: CheckListPointWidget(
                        checkPointModel: model,
                      ),
                    );
                  },
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (_, __) => Divider(
                    color: greyLight6,
                  ),
                  itemCount: attendanceController.isLoading
                      ? 4
                      : attendanceController.checkPointModelList.length,
                ),
              ),
            ],
          );
        }),
        sizedBoxHeight(height: 32.h),
        GetBuilder<AttendanceController>(builder: (attendanceController) {
          return GetBuilder<PermissionController>(
              builder: (permissionController) {
            return PunchButtonWidget(
              onTap: () {
                if (permissionController.selfie == null) {
                  return showToast(
                      message: "Take selfie of you", toastType: ToastType.info);
                }
                if ((permissionController.latitude == null) ||
                    (permissionController.longitude == null)) {
                  permissionController
                      .requestLocationPermissionAndFetch(context);
                }

                if (attendanceController.attendanceModel?.isNotPunchIn ??
                    false) {
                  attendanceController
                      .punchInAttendance(
                    lat: permissionController.latitude.toString(),
                    lng: permissionController.longitude.toString(),
                    selfie: permissionController.selfie,
                  )
                      .then((value) {
                    if (value.isSuccess) {
                      attendanceController.submitCheckListPointForPunchIn().then((value) {
                        if (value.isSuccess) {
                          navigate(
                              context: context,
                              page: const AttendancePunchInOutSuccessScreen());
                        } else {
                          showToast(
                              message: value.message,
                              typeCheck: value.isSuccess);
                        }
                      });
                      showToast(
                          message: value.message, typeCheck: value.isSuccess);
                    } else {
                      showToast(
                          message: value.message, typeCheck: value.isSuccess);
                    }
                  });
                } else if (attendanceController.attendanceModel?.isPunchIn ??
                    false) {
                  attendanceController.submitCheckListPointForPunchOut().then((value) {
                    if (value.isSuccess) {
                      attendanceController
                          .punchOutAttendance(
                        lat: permissionController.latitude.toString(),
                        lng: permissionController.longitude.toString(),
                        selfie: permissionController.selfie,
                      )
                          .then((value) {
                        if (value.isSuccess) {
                          navigate(
                              context: context,
                              page: const AttendancePunchInOutSuccessScreen());
                        } else {
                          showToast(
                              message: value.message,
                              typeCheck: value.isSuccess);
                        }
                      });
                    } else {
                      showToast(
                          message: value.message, typeCheck: value.isSuccess);
                    }
                  });

                  // attendanceController
                  //     .punchOutAttendance(
                  //   lat: permissionController.latitude.toString(),
                  //   lng: permissionController.longitude.toString(),
                  //   selfie: permissionController.selfie,
                  // )
                  //     .then((value) {
                  //   if (value.isSuccess) {
                  //     attendanceController.submitCheckListPoint().then((value) {
                  //       if (value.isSuccess) {
                  //         navigate(
                  //             context: context,
                  //             page: const AttendancePunchInOutSuccessScreen());
                  //       } else {
                  //         showToast(
                  //             message: value.message,
                  //             typeCheck: value.isSuccess);
                  //       }
                  //     });
                  //     showToast(
                  //         message: value.message, typeCheck: value.isSuccess);
                  //   } else {
                  //     showToast(
                  //         message: value.message, typeCheck: value.isSuccess);
                  //   }
                  // });
                }
              },
            );
          });
        })
      ],
    );
  }
}
