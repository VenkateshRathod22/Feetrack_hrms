import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/attendance_controller.dart';
import 'package:vlr/services/date_formatters_and_converters.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/shimmer.dart';
import 'package:vlr/views/screens/account_screen/widget/daily_attendance_section/punch_in_and_punch_out_widget.dart';

class PunchTimeInOutSection extends StatelessWidget {
  const PunchTimeInOutSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AttendanceController>(builder: (attendanceController) {
      if (attendanceController.attendanceModel?.isLeave ?? false) {
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 20.h,
                bottom: 8.h,
              ),
              child: Divider(
                color: greyLight6,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: CustomShimmer(
                    isLoading: attendanceController.isLoading,
                    child: PunchInAndPunchOutWidget(
                        title: "Punch In",
                        subTitle:
                            (attendanceController.attendanceModel?.checkIn !=
                                        null ||
                                    (attendanceController.attendanceModel
                                            ?.checkIn?.isNotEmpty ??
                                        false))
                                ? convertTo12HourFormat(
                                    time24: attendanceController
                                            .attendanceModel?.checkIn ??
                                        "",
                                    isShowAMPM: true,
                                  )
                                : "-- : --"),
                  ),
                ),
                Container(
                  width: 1,
                  height: 70.h,
                  color: greyLight6,
                ),
                Expanded(
                  child: CustomShimmer(
                    isLoading: attendanceController.isLoading,
                    child: PunchInAndPunchOutWidget(
                        title: "Punch out",
                        subTitle:
                            (attendanceController.attendanceModel?.checkOut !=
                                    null)
                                ? convertTo12HourFormat(
                                    time24: attendanceController
                                            .attendanceModel?.checkOut ??
                                        "",
                                    isShowAMPM: true,
                                  )
                                : "-- : --"),
                  ),
                ),
              ],
            ),
          ],
        );
      }
      return Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: 20.h,
              bottom: 8.h,
            ),
            child: Divider(
              color: greyLight6,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: CustomShimmer(
                  isLoading: attendanceController.isLoading,
                  child: PunchInAndPunchOutWidget(
                      title: "Punch In",
                      subTitle:
                          (attendanceController.attendanceModel?.checkIn !=
                                      null ||
                                  (attendanceController.attendanceModel?.checkIn
                                          ?.isNotEmpty ??
                                      false))
                              ? convertTo12HourFormat(
                                  time24: attendanceController
                                          .attendanceModel?.checkIn ??
                                      "",
                                  isShowAMPM: true,
                                )
                              : "-- : --"),
                ),
              ),
              Container(
                width: 1,
                height: 70.h,
                color: greyLight6,
              ),
              Expanded(
                child: CustomShimmer(
                  isLoading: attendanceController.isLoading,
                  child: PunchInAndPunchOutWidget(
                      title: "Punch out",
                      subTitle:
                          (attendanceController.attendanceModel?.checkOut !=
                                  null)
                              ? convertTo12HourFormat(
                                  time24: attendanceController
                                          .attendanceModel?.checkOut ??
                                      "",
                                  isShowAMPM: true,
                                )
                              : "-- : --"),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 8.h,
              bottom: 8.h,
            ),
            child: Divider(
              color: greyLight6,
            ),
          ),
        ],
      );
    });
  }
}
