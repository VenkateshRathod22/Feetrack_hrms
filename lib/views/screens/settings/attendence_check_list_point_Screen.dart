import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/attendance_checklist_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/screens/settings/add_check_list_point.dart';

class AttendenceCheckListPointScreen extends StatefulWidget {
  const AttendenceCheckListPointScreen({super.key});

  @override
  State<AttendenceCheckListPointScreen> createState() => _AttendenceCheckListPointScreenState();
}

class _AttendenceCheckListPointScreenState extends State<AttendenceCheckListPointScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<AttendanceChecklistController>().getChecklist();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: const Text("Attendance Checklist"),
        backgroundColor: white,
        foregroundColor: black,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.find<AttendanceChecklistController>().clearControllers();
          navigate(context: context, page: const AddCheckListPoint());
        },
        backgroundColor: primaryColor,
        child:  Icon(Icons.add, color: white),
      ),
      body: GetBuilder<AttendanceChecklistController>(builder: (controller) {
        return Column(
          children: [
            Padding(
              padding: AppConstants.screenPadding.copyWith(bottom: 0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search questions...",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: grey.withValues(alpha: 0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (val) {
                  controller.getChecklist(search: val);
                },
              ),
            ),
            Expanded(
              child: controller.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : controller.checklist.isEmpty
                      ? const Center(child: CustomText("No questions found"),)
                      : ListView.builder(
                          padding: AppConstants.screenPadding,
                          itemCount: controller.checklist.length,
                          itemBuilder: (context, index) {
                            final item = controller.checklist[index];
                            return Container(
                              margin: EdgeInsets.only(bottom: 16.h),
                              padding: EdgeInsets.all(16.w),
                              decoration: BoxDecoration(
                                color: white,
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(color: grey.withValues(alpha: 0.2)),
                                boxShadow: [
                                  BoxShadow(
                                    color: black.withValues(alpha: 0.05),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CustomText(
                                          item.question ?? "",
                                          style: Helper(context).textTheme.titleMedium?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        sizedBoxHeight(height: 4.h),
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                                          decoration: BoxDecoration(
                                            color: primaryColor.withValues(alpha: 0.1),
                                            borderRadius: BorderRadius.circular(4.r),
                                          ),
                                          child: CustomText(
                                            "Mode: ${capitalize(item.mode?.replaceAll('_', ' '))}",
                                            style: TextStyle(color: primaryColor, fontSize: 10.sp),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Switch(
                                    value: item.isActive ?? false,
                                    onChanged: (val) {
                                      controller.toggleStatus(item.id!);
                                    },
                                    activeColor: primaryColor,
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      _showDeleteDialog(context, controller, item.id!);
                                    },
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
            ),
          ],
        );
      }),
    );
  }

  void _showDeleteDialog(BuildContext context, AttendanceChecklistController controller, int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Question"),
        content: const Text("Are you sure you want to delete this checklist question?"),
        actions: [
          TextButton(
            onPressed: () => pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              controller.deleteChecklist(id).then((res) {
                showToast(message: res.message, typeCheck: res.isSuccess);
                pop(context);
              });
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
