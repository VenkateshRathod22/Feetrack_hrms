import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/reports_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/screens/reports/widget/report_summary_widget.dart';
import 'package:vlr/views/screens/reports/widget/report_staff_filter_widget.dart';

class StaffReportScreen extends StatefulWidget {
  const StaffReportScreen({super.key});

  @override
  State<StaffReportScreen> createState() => _StaffReportScreenState();
}

class _StaffReportScreenState extends State<StaffReportScreen> {
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
    Get.find<ReportsController>().getStaffReport(search: {
      if (search.isNotEmpty) "search": search,
      if (departmentId != null) "department_id": departmentId,
      if (roleId != null) "role_id": roleId,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundLight,
      appBar: AppBar(
        title: CustomText(
          "Staff Report",
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
                uri: AppConstants.staffExport,
                search: {
                  if (search.isNotEmpty) "search": search,
                  if (departmentId != null) "department_id": departmentId,
                  if (roleId != null) "role_id": roleId,
                },
              );
            },
            icon: Icon(Icons.download_rounded, color: primaryColor),
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
              if (reportsController.isLoading && reportsController.staffReportList.isEmpty)
                Padding(
                  padding: EdgeInsets.only(top: 100.h),
                  child: const Center(child: CircularProgressIndicator()),
                )
              else ...[
                if (reportsController.staffReportSummary != null)
                  ReportSummaryWidget(
                    items: [
                      ReportSummaryItemModel(
                        label: "Total Staff",
                        value: reportsController.staffReportSummary!.totalStaff.toString(),
                        icon: Icons.group_rounded,
                      ),
                      ReportSummaryItemModel(
                        label: "Active Staff",
                        value: reportsController.staffReportSummary!.activeStaff.toString(),
                        icon: Icons.person_add_rounded,
                      ),
                      ReportSummaryItemModel(
                        label: "Inactive Staff",
                        value: ((reportsController.staffReportSummary!.totalStaff ?? 0) -
                                (reportsController.staffReportSummary!.activeStaff ?? 0))
                            .toString(),
                        icon: Icons.person_off_rounded,
                      ),
                      ReportSummaryItemModel(
                        label: "Total Salary",
                        value: PriceConverter.convertToNumberFormat(reportsController.staffReportSummary!.totalBasicSalary ?? 0),
                        icon: Icons.payments_rounded,
                      ),
                      ReportSummaryItemModel(
                        label: "Total Wallet",
                        value: PriceConverter.convertToNumberFormat(reportsController.staffReportSummary!.totalWallet ?? 0),
                        icon: Icons.account_balance_wallet_rounded,
                      ),
                    ],
                  ),
                if (reportsController.staffReportList.isEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 100.h),
                    child: const Center(child: Text("No data found")),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                    itemCount: reportsController.staffReportList.length,
                    separatorBuilder: (_, __) => sizedBoxHeight(height: 12.h),
                    itemBuilder: (context, index) {
                      final staff = reportsController.staffReportList[index];
                      return _buildStaffCard(context, staff);
                    },
                  ),
              ],
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStaffCard(BuildContext context, staff) {
    return Container(
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.r),
              child: Row(
                children: [
                  Container(
                    height: 50.h,
                    width: 50.w,
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: CustomText(
                        staff.name?[0] ?? "U",
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.sp,
                        ),
                      ),
                    ),
                  ),
                  sizedBoxWidth(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: CustomText(
                                staff.name ?? "N/A",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.sp,
                                  color: blackText1,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            _buildStatusBadge(staff.status),
                          ],
                        ),
                        sizedBoxHeight(height: 4),
                        CustomText(
                          "${staff.role} • ${staff.department}",
                          style: TextStyle(fontSize: 12.sp, color: grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: greyLight4.withValues(alpha: 0.5),
                border: Border(top: BorderSide(color: greyLight1)),
              ),
              child: Column(
                children: [
                  _infoRow(Icons.badge_outlined, "Code", staff.employeeCode ?? "N/A"),
                  sizedBoxHeight(height: 8),
                  _infoRow(Icons.location_on_outlined, "Branch", staff.branch ?? "N/A"),
                  sizedBoxHeight(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _amountInfo("Basic Salary", staff.basicSalary ?? 0),
                      _amountInfo("Wallet", staff.walletBalance ?? 0),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 14.sp, color: greyText),
        sizedBoxWidth(width: 8),
        CustomText("$label: ", style: TextStyle(fontSize: 11.sp, color: grey)),
        Expanded(
          child: CustomText(
            value,
            style: TextStyle(fontSize: 11.sp, color: blackText1, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  Widget _amountInfo(String label, num amount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(label, style: TextStyle(fontSize: 10.sp, color: grey)),
        CustomText(
          PriceConverter.convertToNumberFormat(amount),
          style: TextStyle(fontSize: 12.sp, color: primaryColor, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String? status) {
    bool isActive = status?.toLowerCase() == 'active';
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: (isActive ? Colors.green : Colors.red).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: CustomText(
        capitalize(status),
        style: TextStyle(
          fontSize: 10.sp,
          color: isActive ? Colors.green : Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
