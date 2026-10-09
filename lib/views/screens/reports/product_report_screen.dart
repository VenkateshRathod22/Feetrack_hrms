import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/reports_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/screens/reports/widget/report_summary_widget.dart';
import 'package:vlr/views/screens/reports/widget/report_staff_filter_widget.dart';

class ProductReportScreen extends StatefulWidget {
  const ProductReportScreen({super.key});

  @override
  State<ProductReportScreen> createState() => _ProductReportScreenState();
}

class _ProductReportScreenState extends State<ProductReportScreen> {
  String search = "";
  String? departmentId;
  String? roleId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchReport();
    });
  }

  void _fetchReport() {
    Get.find<ReportsController>().getProductReport(search: _getSearchMap());
  }

  Map<String, dynamic> _getSearchMap() {
    return {
      if (search.isNotEmpty) "search": search,
      if (departmentId != null) "department_id": departmentId,
      if (roleId != null) "role_id": roleId,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: CustomText(
          "Product Report",
          style: Helper(context).textTheme.titleMedium?.copyWith(fontSize: 18.sp),
        ),
        centerTitle: true,
        backgroundColor: white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () {
              Get.find<ReportsController>().exportReport(
                uri: AppConstants.productExport,
                search: _getSearchMap(),
              );
            },
            icon:  Icon(Icons.download_rounded, color: primaryColor),
          ),
        ],
      ),
      body: GetBuilder<ReportsController>(builder: (reportsController) {
        return SingleChildScrollView(
          child: Column(
            children: [
              ReportStaffFilterWidget(
                onFilterChanged: (s, d, r) {
                  setState(() {
                    search = s;
                    departmentId = d;
                    roleId = r;
                  });
                  _fetchReport();
                },
              ),
              if (reportsController.isLoading && reportsController.productReportList.isEmpty)
                Padding(
                  padding: EdgeInsets.only(top: 100.h),
                  child: const Center(child: CircularProgressIndicator()),
                )
              else ...[
                if (reportsController.productReportSummary != null)
                  ReportSummaryWidget(
                    items: [
                      ReportSummaryItemModel(
                        label: "Total Products",
                        value: reportsController.productReportSummary!.totalProducts.toString(),
                        icon: Icons.inventory_2_rounded,
                      ),
                      ReportSummaryItemModel(
                        label: "Active",
                        value: reportsController.productReportSummary!.active.toString(),
                        icon: Icons.check_circle_rounded,
                      ),
                      ReportSummaryItemModel(
                        label: "Inactive",
                        value: reportsController.productReportSummary!.inactive.toString(),
                        icon: Icons.cancel_rounded,
                      ),
                      ReportSummaryItemModel(
                        label: "Total Amount",
                        value: PriceConverter.convertToNumberFormat(reportsController.productReportSummary!.totalAmount ?? 0),
                        icon: Icons.payments_rounded,
                      ),
                    ],
                  ),
                if (reportsController.productReportList.isEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 100.h),
                    child: const Center(child: Text("No data found")),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                    itemCount: reportsController.productReportList.length,
                    separatorBuilder: (_, __) => sizedBoxHeight(height: 12.h),
                    itemBuilder: (context, index) {
                      final product = reportsController.productReportList[index];
                      return _buildProductCard(context, product);
                    },
                  ),
              ],
            ],
          ),
        );
      }),
    );
  }

  Widget _buildProductCard(BuildContext context, product) {
    return Container(
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomText(
                    product.name ?? "N/A",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp, color: blackText1),
                  ),
                ),
                _buildStatusBadge(product.status),
              ],
            ),
            sizedBoxHeight(height: 8),
            Row(
              children: [
                Icon(Icons.category_outlined, size: 14.sp, color: grey),
                sizedBoxWidth(width: 8),
                CustomText(
                  product.category ?? "N/A",
                  style: TextStyle(fontSize: 12.sp, color: primaryColor, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                CustomText(
                  PriceConverter.convertToNumberFormat(product.amount ?? 0),
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: blackText1),
                ),
              ],
            ),
            sizedBoxHeight(height: 12),
            const Divider(),
            sizedBoxHeight(height: 4),
            Row(
              children: [
                Icon(Icons.calendar_today_rounded, size: 12.sp, color: grey),
                sizedBoxWidth(width: 4),
                CustomText(
                  "Created: ${product.createdAt?.split(" ")[0] ?? "N/A"}",
                  style: TextStyle(fontSize: 11.sp, color: greyText),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String? status) {
    bool isActive = status?.toLowerCase() == 'active';
    Color color = isActive ? Colors.green : Colors.red;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: CustomText(
        capitalize(status),
        style: TextStyle(fontSize: 10.sp, color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}
