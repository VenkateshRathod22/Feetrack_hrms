import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/leave_controller.dart';
import 'package:vlr/data/models/response/leave_model.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/date_formatters_and_converters.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/services/custom_text.dart';

class LeaveHistoryScreen extends StatefulWidget {
  const LeaveHistoryScreen({super.key});

  @override
  State<LeaveHistoryScreen> createState() => _LeaveHistoryScreenState();
}

class _LeaveHistoryScreenState extends State<LeaveHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<LeaveController>().fetchLeaves();
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
          "Leave History",
          style: Helper(context).textTheme.titleMedium?.copyWith(
                fontSize: 16.sp,
              ),
        ),
      ),
      body: GetBuilder<LeaveController>(builder: (leaveController) {
        if (leaveController.isLoading && leaveController.leaveList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (leaveController.leaveList.isEmpty) {
          return Center(
            child: CustomText(
              "No leave history found",
              style: Helper(context).textTheme.bodyMedium,
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            await leaveController.fetchLeaves();
          },
          child: ListView.separated(
            padding: AppConstants.screenPadding,
            itemCount: leaveController.leaveList.length,
            separatorBuilder: (context, index) => sizedBoxHeight(height: 12.h),
            itemBuilder: (context, index) {
              LeaveModel leave = leaveController.leaveList[index];
              return _LeaveCard(leave: leave);
            },
          ),
        );
      }),
    );
  }
}

class _LeaveCard extends StatelessWidget {
  final LeaveModel leave;
  const _LeaveCard({required this.leave});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    switch (leave.status?.toLowerCase()) {
      case 'approved':
        statusColor = green;
        break;
      case 'rejected':
        statusColor = red;
        break;
      case 'pending':
      default:
        statusColor = yellow;
    }

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(12.r),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: CustomText(
                  capitalize(leave.type ?? ""),
                  style: Helper(context).textTheme.labelSmall?.copyWith(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: CustomText(
                  capitalize(leave.status ?? ""),
                  style: Helper(context).textTheme.labelSmall?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
          sizedBoxHeight(height: 12.h),
          Row(
            children: [
              Expanded(
                child: _DateInfo(
                  label: "Start Date",
                  date: leave.startDate != null ? formatDateTimeSimple(leave.startDate!) : "--",
                ),
              ),
              Icon(Icons.arrow_forward, size: 16.sp, color: grey),
              Expanded(
                child: _DateInfo(
                  label: "End Date",
                  date: leave.endDate != null ? formatDateTimeSimple(leave.endDate!) : "--",
                  crossAxisAlignment: CrossAxisAlignment.end,
                ),
              ),
            ],
          ),
          sizedBoxHeight(height: 12.h),
          const Divider(),
          sizedBoxHeight(height: 8.h),
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
        ],
      ),
    );
  }

  String formatDateTimeSimple(String dateStr) {
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
