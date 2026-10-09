import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/task_controller.dart';
import 'package:vlr/data/models/response/task_model.dart';
import 'package:vlr/data/models/response/task_status_model.dart';
import 'package:vlr/data/models/user_model.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/widget/text_box/app_text_box.dart';
import 'package:vlr/views/base/custom_button.dart';
import 'package:vlr/views/base/custom_dropdown.dart';

class CreateNewTaskScreen extends StatefulWidget {
  final bool isTab;
  final TaskModel? task;
  const CreateNewTaskScreen({super.key, this.isTab = false, this.task});

  @override
  State<CreateNewTaskScreen> createState() => _CreateNewTaskScreenState();
}

class _CreateNewTaskScreenState extends State<CreateNewTaskScreen>
{
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final taskController = Get.find<TaskController>();
      
      // Fetch data sequentially to ensure matching works
      await taskController.fetchTaskStatuses();
      await taskController.fetchEmployees();
      
      if (widget.task != null) {
        taskController.setTask(widget.task!);
      } else {
        if (!widget.isTab) {
          taskController.clearControllers();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = GetBuilder<TaskController>(builder: (taskController) {
      return Form(
        key: formKey,
        child: Column(
          children: [
            AppTextFieldWithHeading(
              headingWidget: Row(
                children: [
                  CustomText(
                    "Title",
                    style: Helper(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 14.sp,
                        ),
                  ),
                  CustomText(
                    " *",
                    style: Helper(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontSize: 18.sp, color: redDark),
                  ),
                ],
              ),
              controller: taskController.titleController,
              hindText: "Enter task title",
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Enter a title for Task";
                }
                return null;
              },
            ),
            sizedBoxHeight(height: 24.h),
            CustomDropDownList<UserModel>(
              headingWidget: Row(
                children: [
                  CustomText(
                    "Assign To",
                    style: Helper(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 14.sp,
                        ),
                  ),
                  CustomText(
                    " *",
                    style: Helper(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontSize: 18.sp, color: redDark),
                  ),
                ],
              ),
              value: taskController.assignTo,
              items: taskController.assignToList,
              hintText: "Select Employee",
              onChanged: (value) {
                taskController.assignTo = value;
                taskController.update();
              },
              validator: (value) {
                if (value == null) {
                  return "Select assign employee";
                }
                return null;
              },
            ),
            sizedBoxHeight(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: AppTextFieldWithHeading(
                    headingWidget: Row(
                      children: [
                        CustomText(
                          "Due Date",
                          style: Helper(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                fontSize: 14.sp,
                              ),
                        ),
                      ],
                    ),
                    controller: taskController.dateController,
                    hindText: "dd-mm-yyyy",
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );

                      if (pickedDate != null) {
                        taskController.dateController.text =
                            "${pickedDate.day.toString().padLeft(2, '0')}-"
                            "${pickedDate.month.toString().padLeft(2, '0')}-"
                            "${pickedDate.year}";
                      }
                    },
                    suffix: Icon(Icons.calendar_month),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Select due date";
                      }
                      return null;
                    },
                  ),
                ),
                sizedBoxWidth(width: 16.w),
                Expanded(
                  child: CustomDropDownList<TaskStatusModel>(
                    headingWidget: Row(
                      children: [
                        CustomText(
                          "Status",
                          style: Helper(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                fontSize: 14.sp,
                              ),
                        ),
                      ],
                    ),
                    value: taskController.taskStatus,
                    items: taskController.taskStatusList,
                    hintText: "Select Status",
                    onChanged: (value) {
                      taskController.taskStatus = value;
                      taskController.update();
                    },
                  ),
                ),
              ],
            ),
            sizedBoxHeight(height: 24.h),
            AppTextFieldWithHeading(
              headingWidget: Row(
                children: [
                  CustomText(
                    "Description",
                    style: Helper(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 14.sp,
                        ),
                  ),
                ],
              ),
              controller: taskController.descriController,
              hindText: "Add details about the task...",
              maxLines: 5,
            ),
            if (widget.isTab) ...[
              sizedBoxHeight(height: 24.h),
              CustomButton(
                height: 50,
                isLoading: taskController.isLoading,
                onTap: () {
                  if (formKey.currentState?.validate() ?? false) {
                    if (taskController.selectedTask != null) {
                      taskController.updateTask();
                    } else {
                      taskController.addTask();
                    }
                  }
                },
                child: CustomText(
                  taskController.selectedTask != null ? "Update Task" : "Save Task",
                  style: Helper(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontSize: 16.sp, color: white),
                ),
              ),
            ],
          ],
        ),
      );
    });

    if (widget.isTab) {
      return SingleChildScrollView(
        padding: AppConstants.screenPadding,
        child: content,
      );
    }

    return Scaffold(
      bottomNavigationBar: Padding(
        padding: AppConstants.screenPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GetBuilder<TaskController>(builder: (taskController) {
              return CustomButton(
                height: 50,
                isLoading: taskController.isLoading,
                onTap: () {
                  if (formKey.currentState?.validate() ?? false) {
                    if (taskController.selectedTask != null) {
                      taskController.updateTask();
                    } else {
                      taskController.addTask();
                    }
                  }
                },
                child: CustomText(
                  taskController.selectedTask != null ? "Update Task" : "Save Task",
                  style: Helper(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontSize: 16.sp, color: white),
                ),
              );
            })
          ],
        ),
      ),
      appBar: AppBar(
        elevation: 2,
        centerTitle: true,
        title: GetBuilder<TaskController>(builder: (taskController) {
          return CustomText(
            taskController.selectedTask != null ? "Edit Task" : "New Task",
            style: Helper(context).textTheme.titleMedium?.copyWith(
                  fontSize: 16.sp,
                ),
          );
        }),
      ),
      body: SingleChildScrollView(
        padding: AppConstants.screenPadding,
        child: content,
      ),
    );
  }
}
