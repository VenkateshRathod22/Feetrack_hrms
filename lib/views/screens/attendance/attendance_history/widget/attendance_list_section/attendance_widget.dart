import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/attendance_controller.dart';
import 'package:vlr/data/models/attendance/attendance_model.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';

class AttendanceWidget extends StatefulWidget {
  final AttendanceModel attendanceModel;
  final Function()? onTap;
  const AttendanceWidget({
    super.key,
    required this.attendanceModel,
    required this.onTap,
  });

  @override
  State<AttendanceWidget> createState() => _AttendanceWidgetState();
}

class _AttendanceWidgetState extends State<AttendanceWidget> {
  Timer? _timer;
  bool showUpdateTime = false;

  @override
  void initState() {
    super.initState();

    showUpdateTime =
        Get.find<AttendanceController>().attendanceModel?.isPunchIn ?? false;

    if (showUpdateTime) {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) {
          setState(() {});
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  bool isNotPresent = false;

  @override
  Widget build(BuildContext context) {
    isNotPresent = widget.attendanceModel.isLeave ||
        widget.attendanceModel.isAbsent ||
        widget.attendanceModel.isWeekOff ||
        widget.attendanceModel.isHalfDay;
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: greyLight7),
        borderRadius: BorderRadius.circular(16.r),
        color: white,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 1),
            blurRadius: 2,
            spreadRadius: 0,
            color: black.withValues(alpha: 0.05),
          )
        ],
      ),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(16.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(99.r),
                              color: widget.attendanceModel.statusColor
                                  .withValues(alpha: 0.10),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 4.r,
                                  backgroundColor:
                                      widget.attendanceModel.statusColor,
                                ),
                                sizedBoxWidth(width: 4.w),
                                CustomText(
                                  widget.attendanceModel.statusName,
                                  style: Helper(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontSize: 10.sp,
                                        color:
                                            widget.attendanceModel.statusColor,
                                      ),
                                )
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: widget.onTap,
                                child: CustomText(
                                  widget.attendanceModel.dataFormat ?? "",
                                  style: Helper(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontSize: 12.sp,
                                        color: greyDart2,
                                      ),
                                ),
                              ),
                              sizedBoxWidth(width: 4.w),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: greyDart2,
                                size: 16.sp,
                              ),
                              sizedBoxWidth(width: 4.w),
                            ],
                          )
                        ],
                      ),
                      isNotPresent
                          ? Padding(
                              padding: EdgeInsets.only(top: 8.h, left: 38.w),
                              child: CustomText(
                                widget.attendanceModel.statusReason ?? "",
                                style: Helper(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontSize: 14.sp,
                                      color: weekOff,
                                    ),
                              ),
                            )
                          : Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 8.h,
                                  ),
                                  child: Divider(
                                    color: greyLight6,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(8.w),
                                            decoration: BoxDecoration(
                                              color:
                                                  green2.withValues(alpha: 0.1),
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                            ),
                                            child: const Icon(
                                              Icons.login,
                                              color: green2,
                                            ),
                                          ),
                                          sizedBoxWidth(width: 8.w),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CustomText(
                                                "Punch In",
                                                style: Helper(context)
                                                    .textTheme
                                                    .titleMedium
                                                    ?.copyWith(
                                                      fontSize: 10,
                                                    ),
                                              ),
                                              CustomText(
                                                widget.attendanceModel
                                                        .checkInTimeFormat ??
                                                    "-- : --",
                                                style: Helper(context)
                                                    .textTheme
                                                    .titleMedium
                                                    ?.copyWith(
                                                      fontSize: 10,
                                                    ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      color: greyLight6,
                                      width: 1,
                                      height: 50.h,
                                    ),
                                    sizedBoxWidth(width: 16.w),
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(8.w),
                                            decoration: BoxDecoration(
                                              color:
                                                  red1.withValues(alpha: 0.1),
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                            ),
                                            child: const Icon(
                                              Icons.logout,
                                              color: red1,
                                            ),
                                          ),
                                          sizedBoxWidth(width: 8.w),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CustomText(
                                                "Punch out",
                                                style: Helper(context)
                                                    .textTheme
                                                    .titleMedium
                                                    ?.copyWith(
                                                      fontSize: 10,
                                                    ),
                                              ),
                                              CustomText(
                                                widget.attendanceModel
                                                        .checkOutTimeFormat ??
                                                    "-- : --",
                                                style: Helper(context)
                                                    .textTheme
                                                    .titleMedium
                                                    ?.copyWith(
                                                      fontSize: 10,
                                                    ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.h),
                                  child: Divider(
                                    color: greyLight6,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(8.w),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                        color: greyDart2.withValues(
                                          alpha: 0.10,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.watch_later_outlined,
                                        color: greyDart2,
                                        size: 20.sp,
                                      ),
                                    ),
                                    sizedBoxWidth(width: 8.w),
                                    Expanded(
                                      child: CustomText(
                                        "Working Hours",
                                        style: Helper(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                                fontSize: 10, color: greyDart2),
                                      ),
                                    ),
                                    CustomText(
                                      widget.attendanceModel
                                              .workingTimeFormat ??
                                          "",
                                      style: Helper(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                              fontSize: 11, color: blackText3),
                                    ),
                                    sizedBoxWidth(width: 10.w)
                                  ],
                                ),
                              ],
                            )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: 6.w,
                color: widget.attendanceModel.statusColor,
              )),
        ],
      ),
    );
  }
}
