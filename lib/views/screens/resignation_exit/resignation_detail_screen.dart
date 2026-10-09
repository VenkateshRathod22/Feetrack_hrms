import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:vlr/controllers/resignation_exit_controller.dart';
import 'package:vlr/data/models/exit_model.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';

class ResignationDetailScreen extends StatefulWidget {
  final String exitId;
  const ResignationDetailScreen({super.key, required this.exitId});

  @override
  State<ResignationDetailScreen> createState() => _ResignationDetailScreenState();
}

class _ResignationDetailScreenState extends State<ResignationDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<ResignationExitController>().getExitDetails(widget.exitId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: CustomText("Exit Details", style: Helper(context).textTheme.titleMedium?.copyWith(fontSize: 18.sp)),
        centerTitle: true,
        backgroundColor: white,
        elevation: 0,
      ),
      body: GetBuilder<ResignationExitController>(builder: (controller) {
        if (controller.isDetailLoading || controller.currentExitDetail == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final exit = controller.currentExitDetail!;

        return SingleChildScrollView(
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileCard(exit),
              sizedBoxHeight(height: 20),
              _buildInfoSection("Separation Timeline", [
                _detailTile("Resignation Date", _formatDate(exit.resignationDate), Icons.event_note_rounded),
                _detailTile("Notice Period", "${exit.noticePeriodDays} Days", Icons.timer_rounded),
                _detailTile("Last Working Day", _formatDate(exit.lastWorkingDate), Icons.event_available_rounded),
              ]),
              sizedBoxHeight(height: 20),
              _buildInfoSection("Financial & Clearance", [
                _detailTile("Clearance Status", capitalize(exit.clearanceStatus?.replaceAll("_", " ")), Icons.check_circle_outline_rounded),
                _detailTile("F&F Status", capitalize(exit.fnfStatus), Icons.payments_outlined),
                _detailTile("F&F Amount", PriceConverter.convertToNumberFormat(num.tryParse(exit.fnfAmount ?? "0") ?? 0), Icons.money_rounded),
                if (exit.fnfSettlementDate != null)
                  _detailTile("Settlement Date", _formatDate(exit.fnfSettlementDate), Icons.calendar_today_rounded),
              ]),
              sizedBoxHeight(height: 20),
              _buildInfoSection("Reasons & Feedback", [
                _detailTile("Exit Reason", exit.exitReason ?? "N/A", Icons.help_outline_rounded),
                if (exit.remarks != null)
                  _detailTile("Internal Remarks", exit.remarks!, Icons.notes_rounded),
              ]),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildProfileCard(ExitModel exit) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 35.r,
            backgroundColor: primaryColor.withValues(alpha: 0.1),
            child: Icon(Icons.person_remove_rounded, size: 40.r, color: primaryColor),
          ),
          sizedBoxHeight(height: 12),
          CustomText(exit.employee?.name ?? "N/A", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: blackText1)),
          CustomText(exit.employee?.employeeCode ?? "EMP-XXXX", style: TextStyle(fontSize: 12.sp, color: greyText)),
          sizedBoxHeight(height: 16),
          _buildStatusBadge(exit.status),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
          child: CustomText(title, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: blackText1)),
        ),
        Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(color: white, borderRadius: BorderRadius.circular(16.r)),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _detailTile(String label, String value, IconData icon) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(color: backgroundLight, borderRadius: BorderRadius.circular(8.r)),
        child: Icon(icon, size: 18.sp, color: primaryColor),
      ),
      title: CustomText(label, style: TextStyle(fontSize: 10.sp, color: greyText)),
      subtitle: CustomText(value, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: blackText1)),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return "N/A";
    try {
      DateTime dt = DateTime.parse(dateStr);
      return DateFormat('dd MMMM yyyy').format(dt);
    } catch (e) {
      return dateStr.split("T")[0];
    }
  }

  Widget _buildStatusBadge(String? status) {
    Color color = Colors.blue;
    if (status == 'completed') color = Colors.green;
    if (status == 'in_notice_period') color = Colors.orange;
    if (status == 'resigned') color = Colors.deepPurple;
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20.r)),
      child: CustomText(capitalize(status?.replaceAll("_", " ")), style: TextStyle(fontSize: 12.sp, color: color, fontWeight: FontWeight.bold)),
    );
  }
}
