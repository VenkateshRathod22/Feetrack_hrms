import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/staff_contoller.dart';
import 'package:vlr/data/models/performance_staff_model.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_image.dart';
import 'package:vlr/views/screens/performance/performance_detail_screen.dart';

class PerformanceScreen extends StatefulWidget {
  const PerformanceScreen({super.key});

  @override
  State<PerformanceScreen> createState() => _PerformanceScreenState();
}

class _PerformanceScreenState extends State<PerformanceScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<StaffController>().getPerformanceStaffList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        title: CustomText(
          "Employee Performance",
          style: Helper(context).textTheme.titleMedium?.copyWith(
                color: white,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon:  Icon(Icons.arrow_back_ios_new_rounded, color: white),
        ),
      ),
      body: GetBuilder<StaffController>(builder: (staffController) {
        if (staffController.isLoading && staffController.performanceStaffList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (staffController.performanceStaffList.isEmpty) {
          return Center(
            child: CustomText(
              "No employees found",
              style: Helper(context).textTheme.bodyLarge,
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => staffController.getPerformanceStaffList(),
          child: ListView.builder(
            padding: EdgeInsets.all(16.r),
            itemCount: staffController.performanceStaffList.length,
            itemBuilder: (context, index) {
              return _buildEmployeePerformanceCard(
                  context, staffController.performanceStaffList[index]);
            },
          ),
        );
      }),
    );
  }

  Widget _buildEmployeePerformanceCard(BuildContext context, PerformanceStaffModel staff) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 60.h,
                width: 60.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: primaryColor.withValues(alpha: 0.2), width: 2),
                ),
                child: CustomImage(
                  path: staff.avatarUrl ?? "",
                  radius: 30.r,
                  fit: BoxFit.cover,
                ),
              ),
              sizedBoxWidth(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      staff.name ?? "N/A",
                      style: Helper(context).textTheme.titleMedium?.copyWith(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    CustomText(
                      staff.designation ?? "Employee",
                      style: Helper(context).textTheme.bodySmall?.copyWith(
                            color: greyDart2,
                            fontSize: 13.sp,
                          ),
                    ),
                    sizedBoxHeight(height: 4),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: secondaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: CustomText(
                        "ID: ${staff.employeeCode ?? "N/A"}",
                        style: Helper(context).textTheme.labelSmall?.copyWith(
                              color: secondaryColor,
                              fontSize: 11.sp,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: Colors.amber, size: 20),
                      sizedBoxWidth(width: 4),
                      CustomText(
                        "4.5", // Dummy rating
                        style: Helper(context).textTheme.titleMedium?.copyWith(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  CustomText(
                    "Excellent",
                    style: Helper(context).textTheme.labelSmall?.copyWith(
                          color: Colors.green,
                          fontSize: 12.sp,
                        ),
                  ),
                ],
              ),
            ],
          ),
          Divider(height: 24.h, color: greyLight1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem(context, "Attendance", "${staff.weights?.attendance ?? 0}%"),
              _buildStatItem(context, "Tasks", "${staff.weights?.tasks ?? 0}%"),
              _buildStatItem(context, "Target", "${staff.weights?.monthlyTarget ?? 0}%"),
            ],
          ),
          sizedBoxHeight(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                navigate(
                  context: context,
                  page: PerformanceDetailScreen(employeeId: staff.id ?? ""),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                elevation: 0,
              ),
              child: CustomText(
                "View Details",
                style: Helper(context).textTheme.labelMedium?.copyWith(
                      color: white,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value) {
    return Column(
      children: [
        CustomText(
          value,
          style: Helper(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
              ),
        ),
        CustomText(
          label,
          style: Helper(context).textTheme.bodySmall?.copyWith(
                color: greyDart2,
                fontSize: 12.sp,
              ),
        ),
      ],
    );
  }
}
