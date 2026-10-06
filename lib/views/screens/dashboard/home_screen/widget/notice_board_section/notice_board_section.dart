import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:vlr/controllers/notice_controller.dart';
import 'package:vlr/data/models/notice_model.dart';
import 'package:vlr/generated/assets.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/shimmer.dart';
import 'package:vlr/views/screens/dashboard/home_screen/widget/notification_section/notification_widget.dart';

class NoticeBoardWidget extends StatelessWidget {
  const NoticeBoardWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.only(bottom: 20.h),
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
                decoration: BoxDecoration(
                  color: tertiaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.r),
                    topRight: Radius.circular(20.r),
                  ),
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      Assets.svgsMegaphoneOutline,
                      width: 24.w,
                      height: 24.h,
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(white, BlendMode.srcIn),
                    ),
                    sizedBoxWidth(width: 12.w),
                    Expanded(
                      child: CustomText(
                        "Notice Board",
                        style: Helper(context).textTheme.titleMedium?.copyWith(
                              fontSize: 18.sp,
                              color: white,
                            ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        pop(context);
                      },
                      icon: Icon(
                        Icons.close,
                        color: white,
                      ),
                    ),
                  ],
                ),
              ),
              GetBuilder<NoticeController>(builder: (noticeController) {
                return ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final noticeModel = noticeController.isLoading
                          ? NoticeModel()
                          : noticeController.noticeModelList[index];
                      return CustomShimmer(
                          isLoading: noticeController.isLoading,
                          child: NotificationWidget(
                            noticeModel: noticeModel,
                          ));
                    },
                    itemCount: noticeController.isLoading
                        ? 4
                        : noticeController.noticeModelList.length);
              })
            ],
          ),
        ),
      ],
    );
  }
}
