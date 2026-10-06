import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/attendance_controller.dart';
import 'package:vlr/data/models/response/attendance_override_model.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/widget/button/appbar_back_button.dart';
import 'add_attendence_orveride_screen.dart';

class AttendenceOverrideScreen extends StatefulWidget {
  const AttendenceOverrideScreen({super.key});

  @override
  State<AttendenceOverrideScreen> createState() => _AttendenceOverrideScreenState();
}

class _AttendenceOverrideScreenState extends State<AttendenceOverrideScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<AttendanceController>().fetchAttendanceOverrides();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundLight,
      appBar: AppBar(
        title: CustomText(
          "Attendance Overrides",
          style: Helper(context).textTheme.titleMedium?.copyWith(fontSize: 18.sp),
        ),
        centerTitle: true,
        backgroundColor: white,
        elevation: 0,
        leading: const AppBarBackButton(),
        actions: [
          IconButton(
            onPressed: () => navigate(context: context, page: const AddAttendenceOrverideScreen()),
            icon: const Icon(Icons.add_circle_outline, color: primaryColor),
          ),
        ],
      ),
      body: GetBuilder<AttendanceController>(builder: (controller) {
        if (controller.isLoading && controller.overrideList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.overrideList.isEmpty) {
          return const Center(child: CustomText("No override records found"));
        }

        return RefreshIndicator(
          onRefresh: () => controller.fetchAttendanceOverrides(),
          child: ListView.separated(
            padding: EdgeInsets.all(16.r),
            itemCount: controller.overrideList.length,
            separatorBuilder: (_, __) => sizedBoxHeight(height: 16.h),
            itemBuilder: (context, index) {
              final item = controller.overrideList[index];
              return _buildOverrideCard(item);
            },
          ),
        );
      }),
    );
  }

  Widget _buildOverrideCard(AttendanceOverrideModel item) {
    return Container(
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      item.dateDisplay ?? "",
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: primaryColor),
                    ),
                    _statusBadge(item.newStatus),
                  ],
                ),
                sizedBoxHeight(height: 12),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20.r,
                      backgroundColor: secondaryColor.withValues(alpha: 0.1),
                      child: CustomText(item.employee?.name?[0].toUpperCase() ?? "E", style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    sizedBoxWidth(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            item.employee?.name ?? "N/A",
                            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: blackText1),
                          ),
                          CustomText(
                            "${item.employee?.department ?? ''} | ${item.shift?.name ?? ''}",
                            style: TextStyle(fontSize: 11.sp, color: greyText),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                sizedBoxHeight(height: 16),
                Row(
                  children: [
                    _timeItem("New Check-In", item.newCheckInTime, Icons.login_rounded),
                    const Spacer(),
                    _timeItem("New Check-Out", item.newCheckOutTime, Icons.logout_rounded),
                  ],
                ),
                if (item.notes != null && item.notes!.isNotEmpty) ...[
                  sizedBoxHeight(height: 12),
                  Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: backgroundLight,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.notes_rounded, size: 14.sp, color: grey),
                        sizedBoxWidth(width: 8),
                        Expanded(
                          child: CustomText(
                            item.notes ?? "",
                            style: TextStyle(fontSize: 11.sp, color: greyDart2),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: greyLight4.withValues(alpha: 0.5),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(16.r)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  "By: ${item.overriddenBy?.name ?? 'N/A'}",
                  style: TextStyle(fontSize: 10.sp, color: greyText, fontWeight: FontWeight.bold),
                ),
                CustomText(
                  item.loggedAt ?? "",
                  style: TextStyle(fontSize: 10.sp, color: greyText),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _timeItem(String label, String? time, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 14.sp, color: grey),
        sizedBoxWidth(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(label, style: TextStyle(fontSize: 10.sp, color: greyText)),
            CustomText(time ?? "--:--", style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: blackText2)),
          ],
        ),
      ],
    );
  }

  Widget _statusBadge(String? status) {
    Color color = Colors.grey;
    if (status?.toLowerCase().contains('punch') ?? false) color = Colors.green;
    if (status?.toLowerCase() == 'present') color = Colors.blue;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: CustomText(
        capitalize(status?.replaceAll('_', ' ')),
        style: TextStyle(fontSize: 10.sp, color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}
