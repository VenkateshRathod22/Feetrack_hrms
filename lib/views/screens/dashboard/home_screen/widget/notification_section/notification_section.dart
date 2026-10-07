import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:vlr/controllers/dashboard_controller.dart';
import 'package:vlr/data/models/notice_model.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_button.dart';
import 'package:vlr/views/base/shimmer.dart';
import 'package:vlr/views/screens/dashboard/home_screen/widget/notification_section/notification_widget.dart';

class NotificationSection extends StatelessWidget {
  const NotificationSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashBoardController>(builder: (dashController) {
      final notices = dashController.dashboardModel?.recentNotices ?? [];
      
      if (!dashController.isLoading && notices.isEmpty) {
        return const SizedBox();
      }
      return Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 8.w),
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 4),
                blurRadius: 12,
                spreadRadius: 0,
                color: black.withValues(alpha: 0.05),
              )
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    "Notifications",
                    style: Helper(context).textTheme.titleMedium?.copyWith(
                          fontSize: 16.sp,
                        ),
                  ),
                  CustomButton(
                    onTap: () {},
                    type: ButtonType.tertiary,
                    child: CustomText(
                      "View All",
                      style: Helper(context).textTheme.titleMedium?.copyWith(
                            fontSize: 12.sp,
                            color: tertiaryColor,
                          ),
                    ),
                  ),
                ],
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final noticeModel = dashController.isLoading
                      ? NoticeModel()
                      : notices[index];
                  return CustomShimmer(
                    isLoading: dashController.isLoading,
                    child: NotificationWidget(
                      noticeModel: noticeModel,
                    ),
                  );
                },
                itemCount: dashController.isLoading
                    ? 4
                    : notices.length,
              )
            ],
          ));
    });
  }
}
