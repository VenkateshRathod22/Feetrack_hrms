import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/commission_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/screens/process_commissions/generate_process_commions_screen.dart';

class ProcessCommionsScreen extends StatefulWidget {
  const ProcessCommionsScreen({super.key});

  @override
  State<ProcessCommionsScreen> createState() => _ProcessCommionsScreenState();
}

class _ProcessCommionsScreenState extends State<ProcessCommionsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<CommissionController>().getCommissionHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: Text("Process Commissions"),
        backgroundColor: white,
        foregroundColor: black,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          navigate(context: context, page: const GenerateProcessCommionsScreen());
        },
        backgroundColor: primaryColor,
        icon: Icon(Icons.add, color: Colors.white),
        label: Text("Process New", style: TextStyle(color: Colors.white)),
      ),
      body: GetBuilder<CommissionController>(builder: (controller) {
        return Column(
          children: [
            Padding(
              padding: AppConstants.screenPadding.copyWith(bottom: 0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search history...",
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: grey.withValues(alpha: 0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (val) {
                  controller.getCommissionHistory(search: val);
                },
              ),
            ),
            Expanded(
              child: controller.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : controller.commissionHistoryList.isEmpty
                      ? const Center(child: CustomText("No commission history found"))
                      : ListView.builder(
                          padding: AppConstants.screenPadding,
                          itemCount: controller.commissionHistoryList.length,
                          itemBuilder: (context, index) {
                            final item = controller.commissionHistoryList[index];
                            // Assuming typical fields for commission history
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomText(
                                        "Period: ${item['month']}/${item['year']}",
                                        style: Helper(context).textTheme.titleMedium?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                                        decoration: BoxDecoration(
                                          color: primaryColor.withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(4.r),
                                        ),
                                        child: CustomText(
                                          "Processed",
                                          style: TextStyle(
                                            color: primaryColor,
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  sizedBoxHeight(height: 8.h),
                                  CustomText(
                                    "Count: ${item['processed_count'] ?? 0}",
                                    style: Helper(context).textTheme.bodySmall?.copyWith(color: grey),
                                  ),
                                  if (item['created_at'] != null) ...[
                                    sizedBoxHeight(height: 4.h),
                                    CustomText(
                                      "Date: ${item['created_at'].toString().split('T')[0]}",
                                      style: Helper(context).textTheme.bodySmall?.copyWith(color: grey),
                                    ),
                                  ],
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
}
