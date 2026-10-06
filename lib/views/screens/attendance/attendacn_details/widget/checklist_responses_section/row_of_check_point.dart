import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vlr/data/models/attendance/attendance_model.dart';
import 'package:vlr/generated/assets.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';

class RowOfCheckPoint extends StatelessWidget {
  final CheckchecklistResponse? checkchecklistResponse;
  const RowOfCheckPoint({
    super.key,
    this.checkchecklistResponse,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          Assets.svgsCheckCircle,
          height: 13.h,
          width: 13.w,
          fit: BoxFit.cover,
        ),
        sizedBoxWidth(width: 8.w),
        CustomText(
          checkchecklistResponse?.question ?? "",
          style: Helper(context).textTheme.titleSmall?.copyWith(
                fontSize: 10.sp,
                color: blackText1,
              ),
        ),
      ],
    );
  }
}
