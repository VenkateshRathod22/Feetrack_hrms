import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/auth_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_image.dart';

import 'package:vlr/views/screens/edit_profile/edit_profile_screen.dart';

class ProfileDetailScreen extends StatelessWidget {
  const ProfileDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (authController) {
      final user = authController.userModel;
      return Scaffold(
        appBar: AppBar(
          title: CustomText(
            "Profile Details",
            style: Helper(context).textTheme.titleLarge?.copyWith(
                  fontSize: 18.sp,
                  color: black,
                ),
          ),
          actions: [
            IconButton(
              onPressed: () => navigate(context: context, page: const EditProfileScreen()),
              icon: Icon(Icons.edit_outlined, color: primaryColor, size: 22.sp),
            ),
            sizedBoxWidth(width: 8.w),
          ],
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          iconTheme:  IconThemeData(color: black),
        ),
        body: user == null
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    /// Profile Image Section
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: primaryColor, width: 3.r),
                            ),
                            child: CustomImage(
                              path: user.profileImageUrl ?? user.profileImage ?? Assets.imagesNoProfile,
                              height: 120.h,
                              width: 120.w,
                              isProfile: true,
                              radius: 999,
                            ),
                          ),
                          Positioned(
                            bottom: 5.h,
                            right: 5.w,
                            child: Container(
                              padding: EdgeInsets.all(4.r),
                              decoration:  BoxDecoration(
                                color: green,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.check,
                                color: white,
                                size: 16.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    sizedBoxHeight(height: 12.h),
                    CustomText(
                      user.name ?? "N/A",
                      style: Helper(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 22.sp,
                          ),
                    ),
                    CustomText(
                      capitalize(user.role ?? ""),
                      style: Helper(context).textTheme.bodyMedium?.copyWith(
                            color: grey,
                            fontSize: 14.sp,
                          ),
                    ),
                    sizedBoxHeight(height: 30.h),

                    /// Info Sections
                    _buildInfoSection(
                      context,
                      title: "Personal Information",
                      children: [
                        _buildInfoRow(context, Icons.email_outlined, "Email", user.email ?? "N/A"),
                        _buildInfoRow(context, Icons.phone_android_outlined, "Mobile", user.mobile ?? "N/A"),
                        _buildInfoRow(context, Icons.wallet_outlined, "Wallet Balance", "₹ ${user.walletBalance ?? "0.00"}"),
                      ],
                    ),
                    sizedBoxHeight(height: 20.h),
                    _buildInfoSection(
                      context,
                      title: "Employment Details",
                      children: [
                        _buildInfoRow(context, Icons.badge_outlined, "Employee Code", user.employeeCode ?? "N/A"),
                        _buildInfoRow(context, Icons.work_outline, "Employment Type", capitalize(user.employmentType ?? "N/A")),
                        _buildInfoRow(context, Icons.calendar_today_outlined, "Joining Date", user.joiningDate ?? "N/A"),
                        _buildInfoRow(context, Icons.apartment_outlined, "Working Mode", capitalize(user.workingMode ?? "N/A")),
                        _buildInfoRow(context, Icons.info_outline, "Employment Status", capitalize(user.employmentStatus ?? "N/A")),
                      ],
                    ),
                    sizedBoxHeight(height: 20.h),
                    if (user.roles != null && user.roles!.isNotEmpty)
                      _buildInfoSection(
                        context,
                        title: "Roles",
                        children: [
                          Wrap(
                            spacing: 8.w,
                            runSpacing: 8.h,
                            children: user.roles!.map((role) {
                              String displayRole = role;
                              if (role.contains('_')) {
                                displayRole = role.split('_').last;
                              }
                              return Container(
                                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                                decoration: BoxDecoration(
                                  color: secondaryColor.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(20.r),
                                  border: Border.all(color: secondaryColor.withOpacity(0.2)),
                                ),
                                child: CustomText(
                                  displayRole.toUpperCase(),
                                  style: Helper(context).textTheme.bodySmall?.copyWith(
                                        fontSize: 10.sp,
                                        color: secondaryColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    sizedBoxHeight(height: 20.h),
                    
                    /// Permissions Section
                    if (user.permissions != null && user.permissions!.isNotEmpty)
                      _buildInfoSection(
                        context,
                        title: "Permissions",
                        children: [
                          Wrap(
                            spacing: 8.w,
                            runSpacing: 8.h,
                            children: user.permissions!.map((permission) {
                              return Container(
                                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                                decoration: BoxDecoration(
                                  color: primaryColor.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(20.r),
                                  border: Border.all(color: primaryColor.withOpacity(0.2)),
                                ),
                                child: CustomText(
                                  permission.replaceAll('_', ' ').toUpperCase(),
                                  style: Helper(context).textTheme.bodySmall?.copyWith(
                                        fontSize: 10.sp,
                                        color: primaryColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    sizedBoxHeight(height: 40.h),
                  ],
                ),
              ),
      );
    });
  }

  Widget _buildInfoSection(BuildContext context, {required String title, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            title,
            style: Helper(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                  fontSize: 16.sp,
                ),
          ),
          Divider(height: 24.h, color: grey.withOpacity(0.2)),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: greyLight7,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18.sp, color: greyDart3),
          ),
          sizedBoxWidth(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  label,
                  style: Helper(context).textTheme.bodySmall?.copyWith(
                        color: grey,
                        fontSize: 12.sp,
                      ),
                ),
                CustomText(
                  value,
                  style: Helper(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                        color: black,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
