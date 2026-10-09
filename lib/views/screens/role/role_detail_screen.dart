import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/role_controller.dart';
import 'package:vlr/data/models/role_model.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:intl/intl.dart';

class RoleDetailScreen extends StatelessWidget {
  final RoleModel role;
  const RoleDetailScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    String displayName = role.name ?? "Role Details";
    if (displayName.contains("_")) {
      displayName = displayName.split("_").last;
    }

    return Scaffold(

      body: GetBuilder<RoleController>(builder: (controller) {
        if (controller.isLoading && controller.roleDetails == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final details = controller.roleDetails;
        if (details == null) {
          return Scaffold(
            appBar: AppBar(title: Text(displayName)),
            body: const Center(child: Text("Unable to load details")),
          );
        }

        return CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 180.h,
              pinned: true,
              stretch: true,
              backgroundColor: primaryColor,
              foregroundColor: white,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  displayName,
                  style: Helper(context).textTheme.titleLarge?.copyWith(
                        color: white,
                        fontSize: 18.sp,
                      ),
                ),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            primaryColor,
                            primaryColor.withValues(alpha: 0.8),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      right: -20,
                      top: -20,
                      child: Icon(
                        Icons.security,
                        size: 150.sp,
                        color: white.withValues(alpha: 0.1),
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.shield, color: white, size: 48.sp),
                          sizedBoxHeight(height: 8),
                          CustomText(
                            "Role Permissions",
                            style: Helper(context).textTheme.bodyMedium?.copyWith(
                                  color: white.withValues(alpha: 0.7),
                                  letterSpacing: 1.2,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMainInfoCard(context, details),
                    sizedBoxHeight(height: 24),
                    Row(
                      children: [
                        Icon(Icons.key, color: primaryColor, size: 20.sp),
                        sizedBoxWidth(width: 8),
                        CustomText(
                          "Assigned Permissions",
                          style: Helper(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: blackText3,
                              ),
                        ),
                        const Spacer(),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: CustomText(
                            "${details.permissions?.length ?? 0}",
                            style: Helper(context).textTheme.bodySmall?.copyWith(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ],
                    ),
                    sizedBoxHeight(height: 16),
                    if (details.permissions == null || details.permissions!.isEmpty)
                      _buildEmptyPermissions(context)
                    else
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 10.h,
                        children: details.permissions!.map((p) => _buildPermissionChip(context, p)).toList(),
                      ),
                    sizedBoxHeight(height: 40),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildMainInfoCard(BuildContext context, RoleModel details) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildDetailRow(
            context,
            Icons.badge_outlined,
            "Role Name",
            details.name ?? "N/A",
          ),
          const Divider(height: 32, color: Color(0xFFF1F5F9)),
          _buildDetailRow(
            context,
            Icons.gpp_good_outlined,
            "Guard Name",
            details.guardName ?? "N/A",
          ),
          const Divider(height: 32, color: Color(0xFFF1F5F9)),
          _buildDetailRow(
            context,
            Icons.calendar_today_outlined,
            "Created At",
            details.createdAt != null 
              ? DateFormat('MMM dd, yyyy').format(details.createdAt!)
              : "N/A",
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: greyLight4,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(icon, color: greyLight8, size: 20.sp),
        ),
        sizedBoxWidth(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                label,
                style: Helper(context).textTheme.bodySmall?.copyWith(color: greyText, fontSize: 12.sp),
              ),
              sizedBoxHeight(height: 2),
              CustomText(
                value,
                style: Helper(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: blackText3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPermissionChip(BuildContext context, PermissionModel permission) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: greyLight1, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, color: green2, size: 14.sp),
          sizedBoxWidth(width: 6),
          Flexible(
            child: CustomText(
              permission.name ?? "",
              style: Helper(context).textTheme.bodySmall?.copyWith(
                    color: blackText4,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyPermissions(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(32.w),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: greyLight1, style: BorderStyle.none),
      ),
      child: Column(
        children: [
          Icon(Icons.info_outline, color: greyLight2, size: 48.sp),
          sizedBoxHeight(height: 16),
          CustomText(
            "No permissions assigned to this role.",
            style: Helper(context).textTheme.bodyMedium?.copyWith(color: greyText),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
