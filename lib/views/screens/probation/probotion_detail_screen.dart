import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:vlr/controllers/probation_controller.dart';
import 'package:vlr/data/models/reports/probation_report_model.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';

class ProbotionDetailScreen extends StatefulWidget {
  final int probationId;
  const ProbotionDetailScreen({super.key, required this.probationId});

  @override
  State<ProbotionDetailScreen> createState() => _ProbotionDetailScreenState();
}

class _ProbotionDetailScreenState extends State<ProbotionDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<ProbationController>().getProbationDetails(widget.probationId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundLight,
      appBar: AppBar(
        title: CustomText("Probation Details", style: Helper(context).textTheme.titleMedium?.copyWith(fontSize: 18.sp)),
        centerTitle: true,
        backgroundColor: white,
        elevation: 0,
      ),
      body: GetBuilder<ProbationController>(builder: (controller) {
        if (controller.isLoading || controller.selectedProbation == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final item = controller.selectedProbation!;

        return SingleChildScrollView(
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderCard(item),
              sizedBoxHeight(height: 20),
              _buildInfoSection("Probation Timeline", [
                _detailTile("Start Date", _formatDate(item.startDate), Icons.calendar_today_rounded),
                _detailTile("Due Date", _formatDate(item.confirmationDueDate), Icons.event_available_rounded),
                if (item.isExtended == true)
                  _detailTile("Extended Date", _formatDate(item.extendedDueDate), Icons.update_rounded),
                if (item.confirmationDate != null)
                  _detailTile("Actual Confirmation", _formatDate(item.confirmationDate), Icons.verified_user_rounded),
              ]),
              sizedBoxHeight(height: 20),
              _buildInfoSection("Asset & Resources", [
                _detailTile("Assets Allocated", item.assetAllocation ?? "None", Icons.inventory_2_rounded),
              ]),
              if (item.evaluationNotes != null && item.evaluationNotes!.isNotEmpty) ...[
                sizedBoxHeight(height: 20),
                _buildInfoSection("Evaluation & Notes", [
                  _detailTile("Review Summary", item.evaluationNotes!, Icons.notes_rounded),
                ]),
              ],
            ],
          ),
        );
      }),
    );
  }

  Widget _buildHeaderCard(ProbationModel item) {
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
            child: Icon(Icons.person_rounded, size: 40.r, color: primaryColor),
          ),
          sizedBoxHeight(height: 12),
          CustomText(item.employeeName ?? "N/A", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: blackText1)),
          CustomText(item.employeeCode ?? "EMP-XXXX", style: TextStyle(fontSize: 12.sp, color: greyText)),
          sizedBoxHeight(height: 16),
          _buildStatusBadge(item.status),
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
    if (status == 'confirmed') color = Colors.green;
    if (status == 'extended') color = Colors.orange;
    if (status == 'terminated') color = Colors.red;
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20.r)),
      child: CustomText(capitalize(status?.replaceAll("_", " ")), style: TextStyle(fontSize: 12.sp, color: color, fontWeight: FontWeight.bold)),
    );
  }
}
