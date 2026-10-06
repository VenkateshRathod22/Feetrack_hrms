import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/task_status_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/widget/button/appbar_back_button.dart';
import 'package:vlr/views/widget/text_box/app_text_box.dart';

class CreateTaskStatusScreen extends StatelessWidget {
  const CreateTaskStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TaskStatusController>(builder: (controller) {
      final isEdit = controller.selectedStatus != null;
      
      return Scaffold(
        backgroundColor: backgroundLight,
        appBar: AppBar(
          title: CustomText(
            isEdit ? "Update Task Status" : "Add Task Status",
            style: Helper(context).textTheme.titleMedium?.copyWith(fontSize: 18.sp),
          ),
          centerTitle: true,
          backgroundColor: white,
          elevation: 0,
          leading: const AppBarBackButton(),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(20.r),
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: black.withValues(alpha: 0.04),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    AppTextFieldWithHeading(
                      heading: "STATUS NAME",
                      isRequired: true,
                      controller: controller.nameController,
                      hindText: "e.g. In Review",
                    ),
                    sizedBoxHeight(height: 32),
                    ElevatedButton(
                      onPressed: () {
                        if (controller.isLoading) return;
                        
                        final action = isEdit 
                            ? controller.updateTaskStatus() 
                            : controller.addTaskStatus();
                            
                        action.then((res) {
                          if (res.isSuccess) {
                            showToast(message: res.message, toastType: ToastType.success);
                            Navigator.pop(context);
                          } else {
                            showToast(message: res.message, toastType: ToastType.error);
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        minimumSize: Size(double.infinity, 50.h),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                      ),
                      child: controller.isLoading
                          ? SizedBox(width: 20.w, height: 20.w, child:  CircularProgressIndicator(color: white, strokeWidth: 2))
                          : CustomText(
                              isEdit ? "Update Status" : "Create Status",
                              style: TextStyle(color: white, fontWeight: FontWeight.bold, fontSize: 16.sp),
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
