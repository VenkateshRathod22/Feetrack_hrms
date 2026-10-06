import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vlr/data/models/notice_model.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_image.dart';
import 'package:vlr/views/screens/notification_screen/notification_details/notification_details_screen.dart';

class NotificationWidget extends StatelessWidget {
  final NoticeModel? noticeModel;
  const NotificationWidget({
    super.key,
    this.noticeModel,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        navigate(
            context: context,
            page: NotificationDetailsScreen(
                notificationId: noticeModel?.id ?? 0));
      },
      child: Container(
        margin: EdgeInsets.only(
          left: 16.w,
          right: 16.w,
          top: 16.h,
        ),
        padding: EdgeInsets.all(
          16.w,
        ),
        decoration: BoxDecoration(
            color: greyLight7.withValues(alpha: 0.2),
            border: Border.all(
              width: 1,
              color: greyLight7,
            ),
            borderRadius: BorderRadius.circular(16.r)),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: deepPurple.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset(
                      Assets.svgsMegaphone,
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        deepPurple,
                        BlendMode.srcIn,
                      ),
                    )),
                sizedBoxWidth(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 2.r, horizontal: 8.w),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(99),
                            color: tertiaryColor.withValues(alpha: 0.1)),
                        child: CustomText(
                          capitalize(noticeModel?.type ?? ""),
                          style: Helper(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontSize: 10.sp, color: tertiaryColor),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.h),
                        child: CustomText(
                          capitalize(noticeModel?.title ?? ""),
                          style:
                              Helper(context).textTheme.titleMedium?.copyWith(
                                    fontSize: 16.sp,
                                  ),
                        ),
                      ),
                      CustomText(
                        noticeModel?.content ?? "",
                        maxLines: 2,
                        style: Helper(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(fontSize: 10.sp, color: greyDart2),
                      ),
                      sizedBoxHeight(height: 4.h),
                    ],
                  ),
                )
              ],
            ),
            sizedBoxHeight(height: 12.h),
            Container(
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                color: grey.withValues(alpha: 0.5),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        color: white),
                    child: Icon(
                      Icons.calendar_month,
                      color: tertiaryColor,
                    ),
                  ),
                  sizedBoxWidth(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          "Active Period",
                          style: Helper(context).textTheme.bodyMedium?.copyWith(
                                fontSize: 10.sp,
                                color: weekOff,
                              ),
                        ),
                        sizedBoxHeight(height: 2.h),
                        CustomText(
                          "${noticeModel?.startDateFormat ?? ""} - ${noticeModel?.endDateFormat ?? ""}",
                          style:
                              Helper(context).textTheme.titleMedium?.copyWith(
                                    fontSize: 14.sp,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
