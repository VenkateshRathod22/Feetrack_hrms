import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/task_controller.dart';
import 'package:vlr/data/models/response/task_model.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/screens/task/create_new_task/create_new_task_screen.dart';

class TaskScreen extends StatefulWidget {
  final bool isTab;
  const TaskScreen({super.key, this.isTab = false});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<TaskController>().getTasks();
      Get.find<TaskController>().fetchTaskStatuses();
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = GetBuilder<TaskController>(builder: (taskController) {
      if (taskController.isLoading && taskController.taskList.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      if (taskController.taskList.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.assignment_late_outlined, size: 60.sp, color: grey),
              sizedBoxHeight(height: 16.h),
              CustomText(
                "No tasks found",
                style: Helper(context).textTheme.bodyMedium?.copyWith(color: grey),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () async {
          await taskController.getTasks();
        },
        child: ListView.separated(
          padding: AppConstants.screenPadding,
          itemCount: taskController.taskList.length,
          separatorBuilder: (context, index) => sizedBoxHeight(height: 12.h),
          itemBuilder: (context, index) {
            TaskModel task = taskController.taskList[index];
            return _TaskCard(task: task);
          },
        ),
      );
    });

    if (widget.isTab) {
      return content;
    }

    return Scaffold(
      backgroundColor: backgroundLight,
      appBar: AppBar(
        elevation: 2,
        centerTitle: true,
        backgroundColor: white,
        title: CustomText(
          "Assigned Tasks",
          style: Helper(context).textTheme.titleMedium?.copyWith(
                fontSize: 16.sp,
              ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              navigate(context: context, page: const CreateNewTaskScreen());
            },
            icon: Icon(Icons.add_circle_outline, color: primaryColor),
          ),
        ],
      ),
      body: content,
    );
  }
}

class _TaskCard extends StatelessWidget {
  final TaskModel task;
  const _TaskCard({required this.task});

  @override
  Widget build(BuildContext context) {
    Color statusColor = _getStatusColor(task.status);

    return Container(
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: greyLight4.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Status and Actions
          Padding(
            padding: EdgeInsets.fromLTRB(16.r, 16.r, 8.r, 8.r),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatusDropdown(context, statusColor),
                Row(
                  children: [
                    _buildActionButton(
                      icon: Icons.add_comment_rounded,
                      color: primaryColor,
                      onTap: () => _showRemarksBottomSheet(context, task.id!),
                    ),
                    _buildActionButton(
                      icon: Icons.edit_note_rounded,
                      color: Colors.blue,
                      onTap: () => navigate(context: context, page: CreateNewTaskScreen(task: task)),
                    ),
                    _buildActionButton(
                      icon: Icons.delete_outline_rounded,
                      color: Colors.redAccent,
                      onTap: () => _showDeleteConfirmation(context),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                CustomText(
                  task.title ?? "Untitled Task",
                  style: Helper(context).textTheme.titleMedium?.copyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: blackText1,
                      ),
                ),

                sizedBoxHeight(height: 8.h),

                // Description
                if (task.description != null && task.description!.isNotEmpty) ...[
                  CustomText(
                    task.description!,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: Helper(context).textTheme.bodySmall?.copyWith(
                          fontSize: 13.sp,
                          color: greyDart,
                          height: 1.4,
                        ),
                  ),
                  sizedBoxHeight(height: 16.h),
                ],

                // Metadata: Dates and Assigner
                Row(
                  children: [
                    _buildInfoChip(
                      context,
                      icon: Icons.calendar_today_rounded,
                      label: task.dueDate ?? task.endDate ?? "--",
                      color: task.isOverdue == true ? Colors.red : Colors.blueGrey,
                    ),
                    sizedBoxWidth(width: 8.w),
                    _buildInfoChip(
                      context,
                      icon: Icons.person_outline_rounded,
                      label: task.assigner?.name ?? "N/A",
                      color: Colors.teal,
                    ),
                  ],
                ),

                if (task.isOverdue == true) ...[
                  sizedBoxHeight(height: 8.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.warning_amber_rounded, color: Colors.red, size: 14.sp),
                        sizedBoxWidth(width: 6.w),
                        CustomText(
                          "Overdue by ${task.overdueDays} days",
                          style: TextStyle(color: Colors.red, fontSize: 11.sp, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusDropdown(BuildContext context, Color statusColor) {
    final taskController = Get.find<TaskController>();
    return PopupMenuButton<String>(
      onSelected: (String status) {
        taskController.updateTaskProgressStatus(task.id!, status);
      },
      offset: const Offset(0, 45),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
      elevation: 8,
      itemBuilder: (BuildContext context) {
        // Prepare status options (use API list if available, otherwise use defaults)
        final List<Map<String, dynamic>> options = taskController.taskStatusList.isEmpty
            ? [
                {'name': 'Pending', 'slug': 'pending', 'color': Colors.amber},
                {'name': 'In Progress', 'slug': 'in_progress', 'color': Colors.blue},
                {'name': 'Under Review', 'slug': 'under_review', 'color': Colors.purple},
                {'name': 'Completed', 'slug': 'completed', 'color': Colors.green},
                {'name': 'Cancelled', 'slug': 'cancelled', 'color': Colors.red},
              ]
            : taskController.taskStatusList.map((e) => {
                'name': e.name ?? "N/A",
                'slug': e.slug ?? e.name?.toLowerCase().replaceAll(" ", "_") ?? "",
                'color': _getStatusColor(e.color ?? e.name),
              }).toList();

        return options.map((option) {
          return PopupMenuItem<String>(
            value: option['slug'],
            child: Row(
              children: [
                Container(
                  width: 10.w,
                  height: 10.w,
                  decoration: BoxDecoration(
                    color: option['color'] is Color ? option['color'] : _getStatusColor(option['color']),
                    shape: BoxShape.circle,
                  ),
                ),
                sizedBoxWidth(width: 10.w),
                CustomText(option['name'], style: TextStyle(fontSize: 13.sp)),
              ],
            ),
          );
        }).toList();
      },
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: statusColor.withValues(alpha: 0.3), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: statusColor.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle),
              ),
              sizedBoxWidth(width: 8.w),
              CustomText(
                capitalize(task.status?.replaceAll("_", " ") ?? "Pending"),
                style: TextStyle(
                  color: const Color(0xFF1E293B),
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp,
                ),
              ),
              sizedBoxWidth(width: 4.w),
              Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey, size: 18.sp),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String? key) {
    if (key == null) return Colors.grey;
    String k = key.toLowerCase();
    if (k == 'pending' || k == 'warning') return Colors.amber;
    if (k == 'in progress' || k == 'in_progress' || k == 'primary') return Colors.blue;
    if (k == 'completed' || k == 'success') return Colors.green;
    if (k == 'under review' || k == 'under_review' || k == 'info') return Colors.purple;
    if (k == 'cancelled' || k == 'danger') return Colors.red;
    if (k == 'purple') return Colors.purple;
    return Colors.grey;
  }

  Widget _buildActionButton({required IconData icon, required Color color, required VoidCallback onTap}) {
    return IconButton(
      onPressed: onTap,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      icon: Container(
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 20.sp),
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context, {required IconData icon, required String label, required Color color}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13.sp, color: color),
          sizedBoxWidth(width: 6.w),
          CustomText(
            label,
            style: TextStyle(fontSize: 11.sp, color: color, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        title: const CustomText("Delete Task", style: TextStyle(fontWeight: FontWeight.bold)),
        content: const CustomText("This action cannot be undone. Are you sure?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: CustomText("Cancel", style: TextStyle(color: grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Get.find<TaskController>().deleteTask(task.id!);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
            ),
            child: const CustomText("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showRemarksBottomSheet(BuildContext context, int taskId) {
    final TextEditingController remarkController = TextEditingController();
    Get.find<TaskController>().getTaskRemarks(taskId);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: EdgeInsets.all(20.r),
            height: 550.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          "Task Remarks",
                          style: Helper(context).textTheme.titleLarge?.copyWith(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        CustomText(
                          "Track progress and updates",
                          style: Helper(context).textTheme.bodySmall?.copyWith(color: grey),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Container(
                        padding: EdgeInsets.all(4.r),
                        decoration: BoxDecoration(
                          color: greyLight4,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.close, size: 20),
                      ),
                    ),
                  ],
                ),
                const Divider(),
                sizedBoxHeight(height: 12.h),
                Expanded(
                  child: GetBuilder<TaskController>(builder: (taskController) {
                    if (taskController.isRemarkLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (taskController.taskRemarks.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.speaker_notes_off_outlined, size: 48.sp, color: greyLight2),
                            sizedBoxHeight(height: 8.h),
                            CustomText(
                              "No remarks yet",
                              style: TextStyle(color: grey, fontSize: 14.sp),
                            ),
                          ],
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: taskController.taskRemarks.length,
                      itemBuilder: (context, index) {
                        final remark = taskController.taskRemarks[index];
                        return Container(
                          margin: EdgeInsets.only(bottom: 16.h),
                          padding: EdgeInsets.all(12.r),
                          decoration: BoxDecoration(
                            color: greyLight4.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 14.r,
                                    backgroundColor: primaryColor.withValues(alpha: 0.1),
                                    child: CustomText(
                                      remark.user?.name?[0].toUpperCase() ?? "U",
                                      style: TextStyle(fontSize: 10.sp, color: primaryColor, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  sizedBoxWidth(width: 8.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CustomText(
                                          remark.user?.name ?? "Unknown User",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13.sp,
                                            color: blackText3,
                                          ),
                                        ),
                                        CustomText(
                                          remark.createdAt?.split('T').first ?? "",
                                          style: TextStyle(
                                            fontSize: 10.sp,
                                            color: grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              sizedBoxHeight(height: 8.h),
                              CustomText(
                                remark.remark ?? "",
                                style: TextStyle(fontSize: 12.sp, color: blackText1),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }),
                ),
                sizedBoxHeight(height: 16.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(30.r),
                    boxShadow: [
                      BoxShadow(
                        color: black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: remarkController,
                          decoration: InputDecoration(
                            hintText: "Write a message...",
                            hintStyle: TextStyle(fontSize: 13.sp, color: grey),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 12.h,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (remarkController.text.isNotEmpty) {
                            Get.find<TaskController>().addTaskRemark(
                              taskId,
                              remarkController.text,
                            );
                            remarkController.clear();
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.all(4.r),
                          padding: EdgeInsets.all(10.r),
                          decoration:  BoxDecoration(
                            color: primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.send_rounded, color: white, size: 18.sp),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
