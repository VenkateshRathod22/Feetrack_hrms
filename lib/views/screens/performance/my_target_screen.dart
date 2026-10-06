import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/my_target_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_button.dart';

class MyTargetScreen extends StatefulWidget {
  const MyTargetScreen({super.key});

  @override
  State<MyTargetScreen> createState() => _MyTargetScreenState();
}

class _MyTargetScreenState extends State<MyTargetScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<MyTargetController>().fetchMyTargets();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundLight,
      appBar: AppBar(
        title: CustomText(
          "My Targets",
          style: Helper(context).textTheme.titleMedium?.copyWith(
                fontSize: 18.sp,
                color: white,
              ),
        ),
        backgroundColor: primaryColor,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: white),
        ),
      ),
      body: GetBuilder<MyTargetController>(builder: (controller) {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.myTargetModel == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("No target data available"),
                sizedBoxHeight(height: 16),
                SizedBox(
                  width: 150.w,
                  child: CustomButton(
                    onTap: () => controller.fetchMyTargets(),
                    child: const Text("Retry"),
                  ),
                )
              ],
            ),
          );
        }

        final metrics = controller.myTargetModel!.metrics!;

        return SingleChildScrollView(
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMetricCard(
                context,
                "Target Status",
                [
                  _MetricItem("Required", PriceConverter.convertToNumberFormat(num.tryParse(metrics.targetRequired.toString()) ?? 0), Colors.blue),
                  _MetricItem("Achieved", PriceConverter.convertToNumberFormat(num.tryParse(metrics.targetAchieved.toString()) ?? 0), Colors.green),
                ],
              ),
              sizedBoxHeight(height: 16),
              _buildMetricCard(
                context,
                "Business Overview",
                [
                  _MetricItem("New Business", PriceConverter.convertToNumberFormat(num.tryParse(metrics.newBusiness.toString()) ?? 0), Colors.orange),
                  _MetricItem("Recovery Business", PriceConverter.convertToNumberFormat(num.tryParse(metrics.recoveryBusiness.toString()) ?? 0), Colors.purple),
                ],
              ),
              sizedBoxHeight(height: 16),
              _buildMetricCard(
                context,
                "Commissions",
                [
                  _MetricItem("Base", PriceConverter.convertToNumberFormat(num.tryParse(metrics.baseCommission.toString()) ?? 0), Colors.teal),
                  _MetricItem("Recovery", PriceConverter.convertToNumberFormat(num.tryParse(metrics.recoveryCommission.toString()) ?? 0), Colors.indigo),
                  _MetricItem("Hierarchy", PriceConverter.convertToNumberFormat(num.tryParse(metrics.hierarchyCommission.toString()) ?? 0), Colors.cyan),
                  _MetricItem("Total", PriceConverter.convertToNumberFormat(num.tryParse(metrics.totalCommission.toString()) ?? 0), Colors.green, isBold: true),
                ],
              ),
              sizedBoxHeight(height: 16),
              _buildMetricCard(
                context,
                "Earnings",
                [
                  _MetricItem("Basic Salary", PriceConverter.convertToNumberFormat(num.tryParse(metrics.basicSalary.toString()) ?? 0), Colors.blueGrey),
                  _MetricItem("Est. Total Earning", PriceConverter.convertToNumberFormat(num.tryParse(metrics.estTotalEarning.toString()) ?? 0), Colors.deepOrange, isBold: true),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildMetricCard(BuildContext context, String title, List<_MetricItem> items) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: black.withValues(alpha: 0.05),
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
            style: Helper(context).textTheme.titleSmall?.copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
          ),
          const Divider(),
          sizedBoxHeight(height: 8),
          ...items.map((item) => Padding(
                padding: EdgeInsets.symmetric(vertical: 4.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      item.label,
                      style: Helper(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 14.sp,
                            color: greyDart2,
                          ),
                    ),
                    CustomText(
                      item.value,
                      style: Helper(context).textTheme.titleSmall?.copyWith(
                            fontSize: 15.sp,
                            fontWeight: item.isBold ? FontWeight.bold : FontWeight.w600,
                            color: item.color,
                          ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class _MetricItem {
  final String label;
  final String value;
  final Color color;
  final bool isBold;

  _MetricItem(this.label, this.value, this.color, {this.isBold = false});
}
