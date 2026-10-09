import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/task_status_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/widget/button/appbar_back_button.dart';
import 'package:vlr/views/screens/task/create_task_status_screen.dart';

class TaskStatusScreen extends StatefulWidget {
  const TaskStatusScreen({super.key});

  @override
  State<TaskStatusScreen> createState() => _TaskStatusScreenState();
}

class _TaskStatusScreenState extends State<TaskStatusScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<TaskStatusController>().getTaskStatuses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: CustomText(
          "Task Statuses",
          style: Helper(context).textTheme.titleMedium?.copyWith(fontSize: 18.sp),
        ),
        centerTitle: true,
        backgroundColor: white,
        elevation: 0,
        leading: const AppBarBackButton(),
        actions: [
          IconButton(
            onPressed: () {
              Get.find<TaskStatusController>().clearData();
              navigate(context: context, page: const CreateTaskStatusScreen());
            },
            icon: Icon(Icons.add_circle_outline, color: primaryColor),
          ),
        ],
      ),
      body: GetBuilder<TaskStatusController>(builder: (controller) {
        if (controller.isLoading && controller.taskStatusList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.taskStatusList.isEmpty) {
          return const Center(child: CustomText("No task statuses found"));
        }

        return RefreshIndicator(
          onRefresh: () => controller.getTaskStatuses(),
          child: ListView.separated(
            padding: EdgeInsets.all(16.r),
            itemCount: controller.taskStatusList.length,
            separatorBuilder: (_, __) => sizedBoxHeight(height: 12.h),
            itemBuilder: (context, index) {
              final status = controller.taskStatusList[index];
              return Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 12.w,
                      height: 12.w,
                      decoration: BoxDecoration(
                        color: _getStatusColor(status.color),
                        shape: BoxShape.circle,
                      ),
                    ),
                    sizedBoxWidth(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            status.name ?? "N/A",
                            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                          ),
                          if (status.slug != null)
                            CustomText(
                              "Slug: ${status.slug}",
                              style: TextStyle(fontSize: 11.sp, color: greyText),
                            ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            controller.setEditData(status);
                            navigate(context: context, page: const CreateTaskStatusScreen());
                          },
                          icon: Icon(Icons.edit_outlined, size: 20.sp, color: primaryColor),
                        ),
                        IconButton(
                          onPressed: () => _showDeleteDialog(context, controller, status.id!),
                          icon: Icon(Icons.delete_outline, size: 20.sp, color: red),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }

  Color _getStatusColor(String? color) {
    switch (color?.toLowerCase()) {
      case 'warning': return Colors.orange;
      case 'primary': return primaryColor;
      case 'info': return Colors.blue;
      case 'success': return green2;
      case 'danger': return red;
      case 'purple': return Colors.purple;
      default: return grey;
    }
  }

  void _showDeleteDialog(BuildContext context, TaskStatusController controller, int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Status"),
        content: Text("Are you sure you want to remove this task status?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              controller.deleteTaskStatus(id).then((res) {
                if (res.isSuccess) {
                  showToast(message: res.message, toastType: ToastType.success);
                } else {
                  showToast(message: res.message, toastType: ToastType.error);
                }
              });
            },
            child: Text("Delete", style: TextStyle(color: red)),
          ),
        ],
      ),
    );
  }
}
