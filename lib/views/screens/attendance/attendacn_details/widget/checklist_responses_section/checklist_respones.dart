import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/attendance_controller.dart';
import 'package:vlr/data/models/attendance/attendance_model.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_image.dart';
import 'package:vlr/views/screens/attendance/attendacn_details/widget/checklist_responses_section/checklist_widget.dart';

class ChecklistResponsesSection extends StatelessWidget {
  const ChecklistResponsesSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AttendanceController>(builder: (attendanceController) {
      return Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            color: white,
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 1),
                blurRadius: 2,
                spreadRadius: 0,
                color: black.withValues(alpha: 0.05),
              )
            ]),
        child: Column(
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  Assets.svgsCheckList,
                ),
                sizedBoxWidth(width: 8.w),
                Expanded(
                  child: CustomText(
                    "Checklist Responses",
                    style: Helper(context).textTheme.titleMedium?.copyWith(
                          fontSize: 14.sp,
                          color: blackText4,
                        ),
                  ),
                )
              ],
            ),
            sizedBoxHeight(height: 16.h),
            CheckListWidget(
                title: "Check In Checklist",
                color: green2,
                checkList:
                    attendanceController.attendanceModel?.checklistResponses ??
                        <CheckchecklistResponse>[],
                isLoading: attendanceController.isLoading),
            (attendanceController.attendanceModel?.isPunchOut ?? false)
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        child: Divider(
                          color: greyLight2,
                        ),
                      ),
                      CheckListWidget(
                          title: "Check Out Checklist",
                          color: red1,
                          checkList: attendanceController.attendanceModel
                                  ?.checkOutChecklistResponses ??
                              <CheckchecklistResponse>[],
                          isLoading: attendanceController.isLoading),
                    ],
                  )
                : const SizedBox(),
          ],
        ),
      );
    });
  }
}
