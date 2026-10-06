import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vlr/data/models/attendance/attendance_model.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/views/base/shimmer.dart';
import 'package:vlr/views/screens/attendance/attendacn_details/widget/checklist_responses_section/row_of_check_point.dart';

class CheckListWidget extends StatelessWidget {
  final String title;
  final Color color;
  final List<CheckchecklistResponse> checkList;
  bool isLoading;
  CheckListWidget({
    super.key,
    required this.title,
    required this.color,
    required this.checkList,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          title,
          style: Helper(context).textTheme.titleMedium?.copyWith(
                fontSize: 12.sp,
                color: color,
              ),
        ),
        sizedBoxHeight(height: 12.h),
        ListView.separated(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final model =
                isLoading ? CheckchecklistResponse() : checkList[index];
            return CustomShimmer(
                isLoading: isLoading,
                child: RowOfCheckPoint(
                  checkchecklistResponse: model,
                ));
          },
          separatorBuilder: (_, __) => sizedBoxHeight(height: 9.h),
          itemCount: isLoading ? 4 : checkList.length,
        )
      ],
    );
  }
}
