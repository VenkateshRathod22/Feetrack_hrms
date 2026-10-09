import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/hrms_permission_controller.dart';
import 'package:vlr/data/models/role_model.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key});

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<HrmsPermissionController>().getPermissionList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: Text("Permissions"),
        backgroundColor: white,
        foregroundColor: black,
        elevation: 0,
      ),
      body: GetBuilder<HrmsPermissionController>(builder: (permissionController) {
        if (permissionController.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (permissionController.permissionList.isEmpty) {
          return const Center(child: Text("No permissions found"));
        }

        return RefreshIndicator(
          onRefresh: () => permissionController.getPermissionList(),
          child: ListView.separated(
            padding: AppConstants.screenPadding,
            itemCount: permissionController.permissionList.length,
            separatorBuilder: (context, index) => sizedBoxHeight(height: 12.h),
            itemBuilder: (context, index) {
              final permission = permissionController.permissionList[index];
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: grey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: grey.withValues(alpha: 0.3), width: 0.5),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: primaryColor.withValues(alpha: 0.1),
                      child: CustomText(
                        (index + 1).toString(),
                        style: Helper(context).textTheme.bodyMedium?.copyWith(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    sizedBoxWidth(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            permission.name ?? "N/A",
                            style: Helper(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          CustomText(
                            "Guard: ${permission.guardName ?? "N/A"}",
                            style: Helper(context).textTheme.bodySmall?.copyWith(
                                  color: grey,
                                ),
                          ),
                        ],
                      ),
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
}
