import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/work_shift_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/shimmer.dart';
import 'package:vlr/views/screens/attendance/team_attendance_history/team_attendaance_history'
    '_screen/widget/appbar_and_searchbar.dart';
import 'package:vlr/views/screens/work_shift/create_work_shift_screen.dart';
import 'package:vlr/views/screens/work_shift/widget/work_shift_widget.dart';

class WorkShiftScreen extends StatefulWidget {
  const WorkShiftScreen({super.key});

  @override
  State<WorkShiftScreen> createState() => _WorkShiftScreenState();
}

class _WorkShiftScreenState extends State<WorkShiftScreen> {
  Timer? _debounce;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<WorkShiftController>().getWorkShifts();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.find<WorkShiftController>().clearControllers();

          navigate(
            context: context,
            page: const CreateWorkShiftScreen(),
          );
        },
        backgroundColor: primaryColor,
        child: Icon(
          Icons.add,
          color: white,
        ),
      ),

      body: GetBuilder<WorkShiftController>(
        builder: (workShiftController) {
          return Column(
            children: [
              /// App Bar + Search
              AppBarAndSearchBar(
                title: "Work Shift Management",
                onChanged: (value) {
                  _debounce?.cancel();

                  _debounce = Timer(
                    const Duration(milliseconds: 500),
                        () {
                      workShiftController.getWorkShifts(
                        search: value.trim(),
                      );
                    },
                  );
                },
              ),

              sizedBoxHeight(height: 16.h),

              /// Work Shift List
              Expanded(
                child: workShiftController.isLoading
                    ? ListView.separated(
                  padding: AppConstants.screenPadding,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return const CustomShimmer(
                      isLoading: true,
                      child: SizedBox(
                        height: 170,
                        width: double.infinity,
                      ),
                    );
                  },
                  separatorBuilder: (_, __) =>
                      sizedBoxHeight(height: 16.h),
                )
                    : workShiftController.workShiftList.isEmpty
                    ? Center(
                  child: CustomText(
                    "No work shifts found",
                    style: Helper(context)
                        .textTheme
                        .titleMedium,
                  ),
                )
                    : ListView.separated(
                  padding: AppConstants.screenPadding,
                  itemCount:
                  workShiftController.workShiftList.length,
                  itemBuilder: (context, index) {
                    final shift =
                    workShiftController.workShiftList[index];

                    return Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: white,
                        borderRadius:
                        BorderRadius.circular(20.r),
                        border: Border.all(
                          color: blueLight3,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          /// Shift Name
                          _buildShiftDetail(
                            context: context,
                            icon: Icons.access_time,
                            title: "Shift Name",
                            value: shift.name ?? "",
                            valueColor: primaryColor,
                          ),

                          sizedBoxHeight(height: 10.h),

                          /// Branch
                          _buildShiftDetail(
                            context: context,
                            icon: Icons.business,
                            title: "Branch",
                            value: shift.branchId.toString() ?? "",
                          ),

                          sizedBoxHeight(height: 10.h),

                          /// Shift Time
                          _buildShiftDetail(
                            context: context,
                            icon: Icons.schedule,
                            title: "Time",
                            value:
                            "${shift.startTime ?? ""} - ${shift.endTime ?? ""}",
                          ),

                          sizedBoxHeight(height: 10.h),

                          /// Late Tolerance
                          _buildShiftDetail(
                            context: context,
                            icon: Icons.timer_outlined,
                            title: "Late Tolerance",
                            value:
                            "${shift.lateToleranceMinutes ?? 0} Minutes",
                          ),

                          sizedBoxHeight(height: 10.h),

                          /// Auto Mark Attendance
                          _buildShiftDetail(
                            context: context,
                            icon: Icons.fact_check_outlined,
                            title: "Auto-Mark Attendance",
                            value:
                            shift.autoMarkAttendance == true
                                ? "Enabled"
                                : "Disabled",
                            valueColor:
                            shift.autoMarkAttendance == true
                                ? green2
                                : red1,
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (_, __) =>
                      sizedBoxHeight(height: 16.h),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildShiftDetail({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18.sp,
          color: primaryColor,
        ),

        SizedBox(width: 10.w),

        Expanded(
          child: RichText(
            text: TextSpan(
              style: Helper(context).textTheme.bodySmall,
              children: [
                TextSpan(
                  text: "$title: ",
                  style: Helper(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: black,
                  ),
                ),
                TextSpan(
                  text: value,
                  style: Helper(context).textTheme.bodySmall?.copyWith(
                    color: valueColor ?? grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

