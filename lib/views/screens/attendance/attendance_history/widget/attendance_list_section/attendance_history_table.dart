import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vlr/data/models/attendance/attendance_model.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_image.dart';

class AttendanceHistoryTable extends StatelessWidget {
  final List<AttendanceModel> attendanceList;
  const AttendanceHistoryTable({super.key, required this.attendanceList});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(vertical: 8.h),
      itemCount: attendanceList.length,
      separatorBuilder: (context, index) => sizedBoxHeight(height: 16.h),
      itemBuilder: (context, index) {
        final model = attendanceList[index];
        return _buildAttendanceCard(context, model);
      },
    );
  }

  Widget _buildAttendanceCard(BuildContext context, AttendanceModel model) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: greyLight7.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// --- Header: Profile & Status ---
          Row(
            children: [
              CustomImage(
                path: model.employee?.profileImageUrl?.toString() ?? model.employee?.avatarUrl ?? "",
                height: 48.h,
                width: 48.w,
                radius: 12.r,
              ),
              sizedBoxWidth(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      model.employee?.name ?? "N/A",
                      style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w800, color: blackText1),
                    ),
                    CustomText(
                      model.employee?.employeeCode ?? "EMP-ID",
                      style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w500, color: greyDart2),
                    ),
                  ],
                ),
              ),
              _buildStatusBadge(model),
            ],
          ),
          
          sizedBoxHeight(height: 16.h),
          Divider(color: greyLight7.withValues(alpha: 0.5), thickness: 1),
          sizedBoxHeight(height: 16.h),

          /// --- Main Stats: Check-In, Check-Out, Working Hrs ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem("Check In", model.checkInTimeFormat ?? "-- : --", Icons.login_rounded, Colors.green),
              _buildStatItem("Check Out", model.checkOutTimeFormat ?? "-- : --", Icons.logout_rounded, Colors.red),
              _buildStatItem("Total Time", model.workingHours ?? "0h 0m", Icons.timer_outlined, primaryColor),
            ],
          ),

          sizedBoxHeight(height: 16.h),

          /// --- Secondary Info: Date, Mode, Late ---
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: greyLight8,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoRow(Icons.calendar_today_rounded, model.dataFormat ?? "--"),
                _buildInfoRow(Icons.work_outline_rounded, capitalize(model.workingMode ?? "Office")),
                _buildInfoRow(
                  Icons.history_toggle_off_rounded, 
                  "${model.lateMinutes ?? 0}m Late", 
                  color: (int.tryParse(model.lateMinutes ?? "0") ?? 0) > 0 ? red1 : greyDart2
                ),
              ],
            ),
          ),

          if (model.statusReason != null && model.statusReason!.isNotEmpty) ...[
            sizedBoxHeight(height: 12.h),
            Row(
              children: [
                Icon(Icons.info_outline_rounded, size: 14.sp, color: greyDart2),
                sizedBoxWidth(width: 6.w),
                Expanded(
                  child: CustomText(
                    model.statusReason!,
                    style: TextStyle(fontSize: 11.sp, color: greyDart2, fontStyle: FontStyle.italic),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color.withValues(alpha: 0.8), size: 18.sp),
        sizedBoxHeight(height: 6.h),
        CustomText(
          value,
          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w800, color: blackText1),
        ),
        CustomText(
          label,
          style: TextStyle(fontSize: 10.sp, color: greyDart2, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text, {Color? color}) {
    return Row(
      children: [
        Icon(icon, size: 12.sp, color: color ?? greyDart2),
        sizedBoxWidth(width: 4.w),
        CustomText(
          text,
          style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w700, color: color ?? greyDart2),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(AttendanceModel model) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: model.statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Text(
        model.statusName,
        style: TextStyle(color: model.statusColor, fontWeight: FontWeight.w800, fontSize: 10.sp),
      ),
    );
  }
}
