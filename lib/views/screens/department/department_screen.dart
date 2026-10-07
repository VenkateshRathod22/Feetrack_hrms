import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/auth_controller.dart';
import 'package:vlr/controllers/department_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/shimmer.dart';
import 'package:vlr/views/screens/attendance/team_attendance_history/team_attendaance_history_screen/widget/appbar_and_searchbar.dart';
import 'package:vlr/views/screens/department/create_department_screen.dart';

class DepartmentScreen extends StatefulWidget {
  const DepartmentScreen({super.key});

  @override
  State<DepartmentScreen> createState() => _DepartmentScreenState();
}

class _DepartmentScreenState extends State<DepartmentScreen> {
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<DepartmentController>().getDepartmentList();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (authController) {
      return Scaffold(
        backgroundColor: white,
        floatingActionButton: authController.hasPermission("department_create")
            ? FloatingActionButton(
                onPressed: () {
                  Get.find<DepartmentController>().clearControllers();
                  navigate(
                      context: context, page: const CreateDepartmentScreen());
                },
                backgroundColor: primaryColor,
                child: Icon(Icons.add, color: white),
              )
            : null,
        body: GetBuilder<DepartmentController>(builder: (departmentController) {
          return Column(
            children: [
              AppBarAndSearchBar(
                title: "Department Management",
                onChanged: (value) {
                  _debounce?.cancel();
                  _debounce = Timer(const Duration(milliseconds: 500), () {
                    departmentController.getDepartmentList(
                        search: value.trim());
                  });
                },
              ),
              Expanded(
                child: departmentController.isLoading
                    ? ListView.separated(
                        padding: AppConstants.screenPadding,
                        itemBuilder: (context, index) => const CustomShimmer(
                          isLoading: true,
                          child: SizedBox(height: 100, width: double.infinity),
                        ),
                        separatorBuilder: (_, __) =>
                            sizedBoxHeight(height: 16.h),
                        itemCount: 5,
                      )
                    : departmentController.departmentList.isEmpty
                        ? Center(
                            child: CustomText(
                              "No departments found",
                              style: Helper(context).textTheme.titleMedium,
                            ),
                          )
                        : ListView.separated(
                            padding: AppConstants.screenPadding,
                            itemBuilder: (context, index) {
                              final dept =
                                  departmentController.departmentList[index];
                              return Container(
                                padding: EdgeInsets.all(16.w),
                                decoration: BoxDecoration(
                                  color: white,
                                  borderRadius: BorderRadius.circular(20.r),
                                  border: Border.all(color: blueLight3),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CustomText(
                                            dept.name ?? "",
                                            style: Helper(context)
                                                .textTheme
                                                .titleMedium,
                                          ),
                                          CustomText(
                                            dept.description ??
                                                "No description",
                                            style: Helper(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(color: grey),
                                            maxLines: 2,
                                          ),
                                          if (dept.parentId != null)
                                            CustomText(
                                              "Parent ID: ${dept.parentId}",
                                              style: Helper(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.copyWith(
                                                      color: primaryColor),
                                            ),
                                        ],
                                      ),
                                    ),
                                    if (authController
                                        .hasPermission("department_update"))
                                      IconButton(
                                        onPressed: () {
                                          departmentController.setEditData(dept);
                                          navigate(
                                              context: context,
                                              page: CreateDepartmentScreen(
                                                  isEdit: true,
                                                  departmentId: dept.id));
                                        },
                                        icon: const Icon(Icons.edit,
                                            color: primaryColor),
                                      ),
                                    if (authController
                                        .hasPermission("department_delete"))
                                      IconButton(
                                        onPressed: () => _showDeleteDialog(
                                            context, dept.id!),
                                        icon: const Icon(Icons.delete,
                                            color: red1),
                                      ),
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (_, __) =>
                                sizedBoxHeight(height: 16.h),
                            itemCount:
                                departmentController.departmentList.length,
                          ),
              ),
            ],
          );
        }),
      );
    });
  }

  void _showDeleteDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Department"),
        content: const Text("Are you sure you want to delete this department?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              Get.find<DepartmentController>().deleteDepartment(id).then((value) {
                showToast(message: value.message, typeCheck: value.isSuccess);
                Navigator.pop(context);
              });
            },
            child: const Text("Delete", style: TextStyle(color: red1)),
          ),
        ],
      ),
    );
  }
}
