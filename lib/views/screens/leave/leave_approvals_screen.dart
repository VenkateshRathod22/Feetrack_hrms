import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/leave_controller.dart';
import 'package:vlr/data/models/response/leave_model.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/date_formatters_and_converters.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_image.dart';
import 'package:vlr/generated/assets.dart';

class LeaveApprovalsScreen extends StatefulWidget {
  const LeaveApprovalsScreen({super.key});

  @override
  State<LeaveApprovalsScreen> createState() => _LeaveApprovalsScreenState();
}

class _LeaveApprovalsScreenState extends State<LeaveApprovalsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<LeaveController>().fetchTeamLeaves('pending');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundLight,
      appBar: AppBar(
        elevation: 2,
        centerTitle: true,
        backgroundColor: white,
        title: CustomText(
          "Leave Approvals",
          style: Helper(context).textTheme.titleMedium?.copyWith(
                fontSize: 16.sp,
              ),
        ),
      ),
      body: GetBuilder<LeaveController>(builder: (leaveController) {
        if (leaveController.isLoading && leaveController.teamLeaveList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (leaveController.teamLeaveList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.assignment_turned_in_outlined, size: 60.sp, color: grey),
                sizedBoxHeight(height: 16.h),
                CustomText(
                  "No pending leave requests",
                  style: Helper(context).textTheme.bodyMedium?.copyWith(color: grey),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            await leaveController.fetchTeamLeaves('pending');
          },
          child: ListView.separated(
            padding: AppConstants.screenPadding,
            itemCount: leaveController.teamLeaveList.length,
            separatorBuilder: (context, index) => sizedBoxHeight(height: 16.h),
            itemBuilder: (context, index) {
              LeaveModel leave = leaveController.teamLeaveList[index];
              return _ApprovalCard(leave: leave);
            },
          ),
        );
      }),
    );
  }
}

class _ApprovalCard extends StatelessWidget {
  final LeaveModel leave;
  const _ApprovalCard({required this.leave});

  @override
  Widget build(BuildContext context) {
    final leaveController = Get.find<LeaveController>();
    
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomImage(
                path: leave.employee?.profileImage ?? Assets.imagesNoProfile,
                height: 50.h,
                width: 50.w,
                radius: 999,
                isProfile: true,
              ),
              sizedBoxWidth(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      leave.employee?.name ?? "Unknown",
                      style: Helper(context).textTheme.titleSmall?.copyWith(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    CustomText(
                      "Applied for ${capitalize(leave.type ?? "")}",
                      style: Helper(context).textTheme.bodySmall?.copyWith(
                            color: primaryColor,
                            fontSize: 12.sp,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          sizedBoxHeight(height: 12.h),
          const Divider(),
          sizedBoxHeight(height: 12.h),
          Row(
            children: [
              Expanded(
                child: _DateInfo(
                  label: "Start Date",
                  date: _formatDate(leave.startDate),
                ),
              ),
              Icon(Icons.arrow_forward, size: 16.sp, color: grey),
              Expanded(
                child: _DateInfo(
                  label: "End Date",
                  date: _formatDate(leave.endDate),
                  crossAxisAlignment: CrossAxisAlignment.end,
                ),
              ),
            ],
          ),
          sizedBoxHeight(height: 12.h),
          CustomText(
            "Reason:",
            style: Helper(context).textTheme.titleSmall?.copyWith(fontSize: 12.sp),
          ),
          sizedBoxHeight(height: 4.h),
          CustomText(
            leave.reason ?? "No reason provided",
            style: Helper(context).textTheme.bodySmall?.copyWith(
                  color: greyText,
                  fontSize: 12.sp,
                ),
          ),
          sizedBoxHeight(height: 20.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: leaveController.isLoading ? null : () {
                    _showConfirmationDialog(context, "rejected");
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: red,
                    side:  BorderSide(color: red),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                  ),
                  child: Text("Reject"),
                ),
              ),
              sizedBoxWidth(width: 16.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: leaveController.isLoading ? null : () {
                    _showConfirmationDialog(context, "approved");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: green,
                    foregroundColor: white,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                  ),
                  child: Text("Approve"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context, String status) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("${capitalize(status)} Leave"),
        content: Text("Are you sure you want to ${status.toLowerCase()} this leave request?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Get.find<LeaveController>().updateLeaveStatus(leave.id!, status, currentTabStatus: 'pending');
            },
            child: Text(capitalize(status), style: TextStyle(color: status == 'approved' ? green : red)),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return "--";
    try {
      DateTime dt = DateTime.parse(dateStr);
      return DateFormatters().dMy.format(dt);
    } catch (e) {
      return dateStr;
    }
  }
}

class _DateInfo extends StatelessWidget {
  final String label;
  final String date;
  final CrossAxisAlignment crossAxisAlignment;
  const _DateInfo({
    required this.label,
    required this.date,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        CustomText(
          label,
          style: Helper(context).textTheme.bodySmall?.copyWith(color: grey),
        ),
        sizedBoxHeight(height: 2.h),
        CustomText(
          date,
          style: Helper(context).textTheme.titleSmall?.copyWith(fontSize: 13.sp),
        ),
      ],
    );
  }
}
