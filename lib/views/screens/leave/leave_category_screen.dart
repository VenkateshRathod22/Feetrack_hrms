import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/leave_category_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';

class LeaveCategoryScreen extends StatefulWidget {
  const LeaveCategoryScreen({super.key});

  @override
  State<LeaveCategoryScreen> createState() => _LeaveCategoryScreenState();
}

class _LeaveCategoryScreenState extends State<LeaveCategoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<LeaveCategoryController>().getLeaveCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        title: CustomText(
          "Leave Management",
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
      body: GetBuilder<LeaveCategoryController>(builder: (leaveCategoryController) {
        if (leaveCategoryController.isLoading && leaveCategoryController.leaveCategoryList.isEmpty) {
          return const Center(child: CircularProgressIndicator(color: primaryColor));
        }

        if (leaveCategoryController.leaveCategoryList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(20.r),
                  decoration: BoxDecoration(
                    color: greyLight1.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.event_note_rounded, size: 64.sp, color: greyDart2),
                ),
                sizedBoxHeight(height: 16),
                CustomText(
                  "No Leave Categories Available",
                  style: Helper(context).textTheme.titleSmall?.copyWith(color: greyDart2, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => leaveCategoryController.getLeaveCategories(),
          child: ListView.builder(
            padding: EdgeInsets.all(20.r),
            itemCount: leaveCategoryController.leaveCategoryList.length,
            itemBuilder: (context, index) {
              final category = leaveCategoryController.leaveCategoryList[index];
              return Container(
                margin: EdgeInsets.only(bottom: 16.h),
                padding: EdgeInsets.all(20.r),
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(24.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                  border: Border.all(color: const Color(0xFFF1F5F9)),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 54.h,
                      width: 54.w,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [primaryColor.withValues(alpha: 0.1), primaryColor.withValues(alpha: 0.05)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Icon(Icons.calendar_month_rounded, color: primaryColor, size: 24.sp),
                    ),
                    sizedBoxWidth(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            category.name ?? "N/A",
                            style: Helper(context).textTheme.titleMedium?.copyWith(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF1E293B),
                                ),
                          ),
                          sizedBoxHeight(height: 4),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.info_outline_rounded, size: 12.sp, color: greyDart2),
                                sizedBoxWidth(width: 4),
                                CustomText(
                                  (category.isUnlimited ?? false) ? "Unlimited Quota" : "${category.days} Days Per Year",
                                  style: Helper(context).textTheme.bodySmall?.copyWith(
                                        color: const Color(0xFF475569),
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildStatusIndicator(category.status ?? false),
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }

  Widget _buildStatusIndicator(bool isActive) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: isActive ? Colors.green.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: isActive ? Colors.green.withValues(alpha: 0.2) : Colors.red.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Text(
        isActive ? "Active" : "Inactive",
        style: TextStyle(
          color: isActive ? Colors.green : Colors.red,
          fontSize: 10.sp,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
