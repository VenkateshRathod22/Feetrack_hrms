import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/staff_contoller.dart';
import 'package:vlr/controllers/salary_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_image.dart';
import 'package:vlr/views/screens/salary_management/employee_salary_structure.dart';

class StaffDetailScreen extends StatelessWidget {
  const StaffDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: greyLight4,
      appBar: AppBar(
        title: const Text("Staff Details"),
        backgroundColor: white,
        foregroundColor: black,
        elevation: 0,
        actions: [
          GetBuilder<StaffController>(builder: (staffController) {
            final staff = staffController.staffProfile;
            if (staff == null) return const SizedBox();
            return IconButton(
              onPressed: () {
                Get.find<SalaryController>().getSalaryStructure(staff.id!);
                navigate(context: context, page: EmployeeSalaryStructure(staffId: staff.id!, staffName: staff.name ?? ""));
              },
              icon: const Icon(Icons.account_balance_wallet_outlined, color: primaryColor),
              tooltip: "Salary Structure",
            );
          }),
        ],
      ),
      body: GetBuilder<StaffController>(builder: (staffController) {
        if (staffController.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final staff = staffController.staffProfile;
        if (staff == null) {
          return const Center(child: Text("No profile data found"));
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(context, staff),
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  children: [
                    _buildSection(context, "Contact Information", [
                      _buildInfoRow(context, Icons.email_outlined, "Email", staff.email),
                      _buildInfoRow(context, Icons.phone_android_outlined, "Mobile", staff.mobile),
                    ]),
                    sizedBoxHeight(height: 16.h),
                    _buildSection(context, "Work Details", [
                      _buildInfoRow(context, Icons.badge_outlined, "Employee Code", staff.employeeCode),
                      _buildInfoRow(context, Icons.calendar_today_outlined, "Joining Date", staff.joiningDate),
                      _buildInfoRow(context, Icons.work_outline, "Working Mode", capitalize(staff.workingMode ?? "")),
                      _buildInfoRow(context, Icons.info_outline, "Status", capitalize(staff.employmentStatus ?? "")),
                    ]),
                    sizedBoxHeight(height: 16.h),
                    _buildSection(context, "Organization", [
                      _buildInfoRow(context, Icons.account_tree_outlined, "Department", staff.department?.name),
                      _buildInfoRow(context, Icons.business_outlined, "Branch", staff.branch?.name),
                      _buildInfoRow(context, Icons.access_time_outlined, "Shift", staff.shift?.name),
                      _buildInfoRow(context, Icons.person_search_outlined, "Manager", staff.manager?.name),
                    ]),
                    sizedBoxHeight(height: 16.h),
                    _buildSection(context, "Financial", [
                      _buildInfoRow(context, Icons.payments_outlined, "Basic Salary", PriceConverter.convertToNumberFormat(double.tryParse(staff.basicSalary ?? "0") ?? 0)),
                    ]),
                    sizedBoxHeight(height: 40.h),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildHeader(BuildContext context, dynamic staff) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 32.h),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32.r),
          bottomRight: Radius.circular(32.r),
        ),
        boxShadow: [
          BoxShadow(
            color: black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 120.h,
            width: 120.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(width: 4, color: greyLight4),
            ),
            child: CustomImage(
              path: staff.profileImageUrl ?? "",
              radius: 999.r,
              fit: BoxFit.cover,
            ),
          ),
          sizedBoxHeight(height: 16.h),
          CustomText(
            staff.name ?? "N/A",
            style: Helper(context).textTheme.titleLarge?.copyWith(fontSize: 24.sp, color: blackText3),
          ),
          CustomText(
            capitalize(staff.role ?? "Employee"),
            style: Helper(context).textTheme.bodyLarge?.copyWith(color: primaryColor, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            title,
            style: Helper(context).textTheme.titleMedium?.copyWith(color: primaryColor, fontSize: 16.sp),
          ),
          const Divider(height: 24),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String label, String? value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: greyLight4,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, size: 20.sp, color: greyDart3),
          ),
          sizedBoxWidth(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  label,
                  style: Helper(context).textTheme.bodySmall?.copyWith(color: grey),
                ),
                CustomText(
                  value ?? "N/A",
                  style: Helper(context).textTheme.titleSmall?.copyWith(color: blackText3, fontSize: 14.sp),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
