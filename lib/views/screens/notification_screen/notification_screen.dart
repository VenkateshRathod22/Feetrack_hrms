import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/notice_controller.dart';
import 'package:vlr/data/models/notice_model.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/shimmer.dart';
import 'package:vlr/views/screens/dashboard/home_screen/widget/notification_section/notification_widget.dart';
import 'package:vlr/views/screens/notification_screen/create_notice_screen.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: CustomText(
          "Notifications",
          style: Helper(context).textTheme.titleMedium?.copyWith(
                fontSize: 20.sp,
              ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigate(context: context, page: const CreateNoticeScreen());
        },
        backgroundColor: primaryColor,
        child: Icon(Icons.add, color: white),
      ),
      body: GetBuilder<NoticeController>(builder: (noticeController) {
        return ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final noticeModel = noticeController.isLoading
                ? NoticeModel()
                : noticeController.noticeModelList[index];
            return CustomShimmer(
              isLoading: noticeController.isLoading,
              child: Stack(
                children: [
                  NotificationWidget(
                    noticeModel: noticeModel,
                  ),
                  if (!noticeController.isLoading)
                    Positioned(
                      right: 20.w,
                      top: 10.h,
                      child: PopupMenuButton<String>(
                        icon: Icon(Icons.more_vert),
                        onSelected: (val) {
                          if (val == 'edit') {
                            navigate(context: context, page: CreateNoticeScreen(isEdit: true, noticeModel: noticeModel));
                          } else if (val == 'delete') {
                            _showDeleteDialog(context, noticeController, noticeModel.id!);
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(value: 'edit', child: Text("Update")),
                          const PopupMenuItem(value: 'delete', child: Text("Delete")),
                        ],
                      ),
                    ),
                ],
              ),
            );
          },
          itemCount: noticeController.isLoading
              ? 4
              : noticeController.noticeModelList.length,
        );
      }),
    );
  }

  void _showDeleteDialog(BuildContext context, NoticeController controller, int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Notice"),
        content: Text("Are you sure you want to delete this notice?"),
        actions: [
          TextButton(onPressed: () => pop(context), child: Text("Cancel")),
          TextButton(
            onPressed: () {
              controller.deleteNotice(id).then((res) {
                showToast(message: res.message, typeCheck: res.isSuccess);
                pop(context);
              });
            },
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
