import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:vlr/controllers/reports_controller.dart';
import 'package:vlr/controllers/attrition_controller.dart';
import 'package:vlr/controllers/department_controller.dart';
import 'package:vlr/data/models/reports/attrition_report_model.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/screens/attrition/widget/atribution_summary_widget.dart';
import 'package:vlr/views/screens/attrition/widget/attribuiton_graph_card_widget.dart';
import 'package:vlr/views/screens/attrition/record_exit_screen.dart';
import 'package:vlr/views/screens/attrition/exit_reason_screen.dart';

class AttritionReportScreen extends StatefulWidget {
  const AttritionReportScreen({super.key});

  @override
  State<AttritionReportScreen> createState() => _AttritionReportScreenState();
}

class _AttritionReportScreenState extends State<AttritionReportScreen> {
  @override
  void initState() {
    super.initState();
    _fetchReport();
  }

  void _fetchReport() {
    Get.find<AttritionController>().getAttritionReport();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: CustomText(
          "Attrition Report",
          style: Helper(context).textTheme.titleMedium?.copyWith(fontSize: 18.sp),
        ),
        centerTitle: true,
        backgroundColor: white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => navigate(context: context, page: const ExitReasonScreen()),
            icon:  Icon(Icons.list_alt_rounded, color: primaryColor),
            tooltip: "Exit Reasons",
          ),
          IconButton(
            onPressed: () => Get.find<ReportsController>().exportReport(
              uri: AppConstants.attritionExport,
              search: {},
            ),
            icon:  Icon(Icons.download_rounded, color: primaryColor),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
      onPressed: (){
        navigate(context: context, page: RecordExitScreen());
      },
        backgroundColor: primaryColor,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        icon:  Icon(Icons.add_rounded, color: white, size: 24),
        label: CustomText(
          "Record Exit",
          style: TextStyle(color: white, fontWeight: FontWeight.bold, fontSize: 14.sp),
        ),
      ),
      body: GetBuilder<AttritionController>(builder: (controller) {
        return SingleChildScrollView(
          child: Column(
            children: [
              const AtributionSummaryWidget(),
              const AtribuitonGraphCardWidget(),
              sizedBoxHeight(height: 24),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [
                    CustomText("Exit Records", style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: blackText1)),
                  ],
                ),
              ),
              sizedBoxHeight(height: 12),
              if (controller.isLoading && controller.attritionReportList.isEmpty)
                const Center(child: CircularProgressIndicator())
              else if (controller.attritionReportList.isEmpty)
                const Center(child: Text("No data found"))
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                  itemCount: controller.attritionReportList.length,
                  separatorBuilder: (_, __) => sizedBoxHeight(height: 12.h),
                  itemBuilder: (context, index) {
                    final record = controller.attritionReportList[index];
                    return _buildRecordCard(record);
                  },
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildRecordCard(AttritionReportModel record) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(record.employeeName ?? "N/A", style: const TextStyle(fontWeight: FontWeight.bold)),
                    CustomText("${record.department} • ${record.branch}", style: TextStyle(fontSize: 11.sp, color: greyText)),
                  ],
                ),
              ),
              Row(
                children: [
                  _buildBadge(record.exitType),
                  sizedBoxWidth(width: 8),
                  _buildActionMenu(record),
                ],
              ),
            ],
          ),
          sizedBoxHeight(height: 12),
          _infoRow(Icons.calendar_today, "Exit Date: ${record.exitDate != null ? DateFormat('dd MMM yyyy').format(DateTime.parse(record.exitDate!)) : "N/A"}"),
          _infoRow(Icons.help_outline, "Reason: ${record.exitReason ?? "N/A"}"),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Row(
        children: [
          Icon(icon, size: 14, color: grey),
          sizedBoxWidth(width: 8),
          Text(text, style: TextStyle(fontSize: 11.sp, color: greyDart2)),
        ],
      ),
    );
  }

  Widget _buildBadge(String? text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: CustomText(capitalize(text), style: TextStyle(fontSize: 10.sp, color: Colors.red, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildActionMenu(AttritionReportModel record) {
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      icon: Icon(Icons.more_vert_rounded, size: 20, color: greyDart2),
      onSelected: (val) {
        if (val == 'edit') {
          navigate(context: context, page: RecordExitScreen(attritionModel: record));
        } else if (val == 'delete') {
          _confirmDelete(context, record);
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'edit', child: Row(children: [Icon(Icons.edit_rounded, size: 18, color: Colors.blue), SizedBox(width: 8), Text("Edit")])),
        const PopupMenuItem(value: 'delete', child: Row(children: [Icon(Icons.delete_rounded, size: 18, color: Colors.red), SizedBox(width: 8), Text("Delete")])),
      ],
    );
  }

  void _confirmDelete(BuildContext context, AttritionReportModel record) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Record?"),
        content: Text("Are you sure you want to delete the exit record for ${record.employeeName}?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Get.find<AttritionController>().deleteAttritionRecord(record.id!).then((response) {
                if (response.isSuccess) {
                  showToast(message: response.message, toastType: ToastType.success);
                } else {
                  showToast(message: response.message, toastType: ToastType.error);
                }
              });
            },
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
