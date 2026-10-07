import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/attendance_controller.dart';
import 'package:vlr/data/models/check_point_model.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';

class CheckListPointWidget extends StatelessWidget {
  final CheckPointModel? checkPointModel;
  const CheckListPointWidget({
    super.key,
    required this.checkPointModel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomText(
            checkPointModel?.question ?? "",
            maxLines: 3,
            style: Helper(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 12.sp,
                ),
          ),
        ),
        GetBuilder<AttendanceController>(builder: (attendanceController) {
          return Checkbox(
            activeColor: blueLight3,
            value: checkPointModel?.isChecked ?? false,
            onChanged: (value) {
              attendanceController.updateCheckListPoint(
                  id: checkPointModel?.id ?? 0, value: value);
            },
          );
        })
      ],
    );
  }
}
