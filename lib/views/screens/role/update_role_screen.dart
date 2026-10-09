import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/role_controller.dart';
import 'package:vlr/data/models/role_model.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_button.dart';
import 'package:vlr/views/widget/text_box/app_text_box.dart';

class UpdateRoleScreen extends StatefulWidget {
  final RoleModel role;
  const UpdateRoleScreen({super.key, required this.role});

  @override
  State<UpdateRoleScreen> createState() => _UpdateRoleScreenState();
}

class _UpdateRoleScreenState extends State<UpdateRoleScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<RoleController>().getPermissions();
      Get.find<RoleController>().setEditData(widget.role);
    });
  }

  String formatPermissionName(String name, String module) {
    // Standard format is module_action
    String formatted = name.replaceFirst("${module}_", "");
    
    // Handle cases where name doesn't contain module_ prefix (like manage_bookings in module: manage)
    if (formatted == name && name.contains("_")) {
      formatted = name.split("_").last;
    }

    if (formatted == "viewany") return "AnyView";
    if (formatted == "viewown") return "OurView";
    if (formatted == "viewteam") return "TeamView";
    
    return formatted;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RoleController>(builder: (controller) {
      return Scaffold(
        backgroundColor: backgroundLight,
        appBar: AppBar(
          title: Text("Update Role"),
          centerTitle: true,
          leading: IconButton(
            onPressed: () => pop(context),
            icon: Icon(Icons.arrow_back_ios, size: 20),
          ),
        ),
        body: controller.isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: AppConstants.screenPadding,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextFieldWithHeading(
                        heading: "Role Name",
                        hindText: "Enter Role Name",
                        controller: controller.nameController,
                        isRequired: true,
                        validator: (value) => value == null || value.isEmpty
                            ? "Name is required"
                            : null,
                      ),
                      sizedBoxHeight(height: 24),
                      CustomText(
                        "Permissions",
                        style: Helper(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(color: greyLight8, fontSize: 14.sp),
                      ),
                      sizedBoxHeight(height: 12),
                      Wrap(
                        spacing: 16.w,
                        runSpacing: 16.h,
                        children: controller.availablePermissionModules.map((module) {
                          final isAllSelected = controller.isModuleAllSelected(module);
                          
                          return Container(
                            width: (MediaQuery.of(context).size.width - AppConstants.horizontalPadding * 2 - 16.w) / 2,
                            decoration: BoxDecoration(
                              color: white,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(color: greyLight1),
                              boxShadow: [
                                BoxShadow(
                                  color: black.withValues(alpha: 0.03),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                )
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Header
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12.w, vertical: 12.h),
                                  decoration: BoxDecoration(
                                    color: greyLight7.withValues(alpha: 0.5),
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(12.r)),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.grid_view,
                                          size: 18.sp, color: tertiaryColor),
                                      sizedBoxWidth(width: 8),
                                      Expanded(
                                        child: Text(
                                          module.title?.toUpperCase() ?? "",
                                          style: Helper(context)
                                              .textTheme
                                              .titleSmall
                                              ?.copyWith(
                                                  fontSize: 13.sp,
                                                  fontWeight: FontWeight.w700,
                                                  color: blackText1),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 22.h,
                                        width: 22.w,
                                        child: Checkbox(
                                          value: isAllSelected,
                                          activeColor: tertiaryColor,
                                          onChanged: (val) => controller
                                              .toggleModulePermissions(
                                                  module, val),
                                          side: BorderSide(color: greyLight2),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(6.r)),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                // Permissions list
                                Padding(
                                  padding: EdgeInsets.all(12.r),
                                  child: Column(
                                    children: (module.permissions ?? []).map((permission) {
                                      final isSelected = controller
                                          .selectedPermissions
                                          .contains(permission.name);

                                      return Padding(
                                        padding: EdgeInsets.only(bottom: 12.h),
                                        child: InkWell(
                                          onTap: () =>
                                              controller.togglePermission(
                                                  permission.name!),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                height: 22.h,
                                                width: 22.w,
                                                child: Checkbox(
                                                  value: isSelected,
                                                  activeColor: tertiaryColor,
                                                  onChanged: (val) => controller
                                                      .togglePermission(
                                                          permission.name!),
                                                  side: BorderSide(
                                                      color: greyLight2),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6.r)),
                                                ),
                                              ),
                                              sizedBoxWidth(width: 10),
                                              Expanded(
                                                child: Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Container(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: 10.w,
                                                        vertical: 6.h),
                                                    decoration: BoxDecoration(
                                                      color: greyLight1,
                                                      borderRadius:
                                                          BorderRadius.circular(8.r),
                                                    ),
                                                    child: Text(
                                                      formatPermissionName(
                                                          permission.name ?? "",
                                                          module.module ?? ""),
                                                      style: TextStyle(
                                                          fontSize: 12.sp,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: tertiaryColor),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                )
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      sizedBoxHeight(height: 32),
                      CustomButton(
                        title: "Update Role",
                        isLoading: controller.isLoading,
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            controller
                                .updateRole(widget.role.id!)
                                .then((response) {
                              if (response.isSuccess) {
                                showToast(
                                    message: response.message,
                                    toastType: ToastType.success);
                                pop(context);
                              } else {
                                showToast(
                                    message: response.message,
                                    toastType: ToastType.error);
                              }
                            });
                          }
                        },
                      ),
                      sizedBoxHeight(height: 32),
                    ],
                  ),
                ),
              ),
      );
    });
  }
}
