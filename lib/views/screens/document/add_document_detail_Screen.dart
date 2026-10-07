import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:vlr/controllers/document_controller.dart';
import 'package:vlr/data/models/reports/document_report_model.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';

class AddDocumentDetailScreen extends StatefulWidget {
  final int documentId;
  const AddDocumentDetailScreen({super.key, required this.documentId});

  @override
  State<AddDocumentDetailScreen> createState() => _AddDocumentDetailScreenState();
}

class _AddDocumentDetailScreenState extends State<AddDocumentDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<DocumentController>().getDocumentDetails(widget.documentId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundLight,
      appBar: AppBar(
        title: CustomText("Document Details", style: Helper(context).textTheme.titleMedium?.copyWith(fontSize: 18.sp)),
        centerTitle: true,
        backgroundColor: white,
        elevation: 0,
      ),
      body: GetBuilder<DocumentController>(builder: (controller) {
        if (controller.isLoading || controller.selectedDocument == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final doc = controller.selectedDocument!;

        return SingleChildScrollView(
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderCard(doc),
              sizedBoxHeight(height: 20),
              _buildInfoSection("Document Information", [
                _detailTile("Document Type", capitalize(doc.documentType), Icons.description_rounded),
                _detailTile("Document Number", doc.documentNumber ?? "N/A", Icons.numbers_rounded),
                _detailTile("Category", capitalize(doc.documentCategory), Icons.category_rounded),
              ]),
              sizedBoxHeight(height: 20),
              _buildInfoSection("Validity Dates", [
                _detailTile("Issue Date", _formatDate(doc.issueDate), Icons.calendar_today_rounded),
                _detailTile("Expiry Date", _formatDate(doc.expiryDate), Icons.event_busy_rounded),
              ]),
              if (doc.remarks != null && doc.remarks!.isNotEmpty) ...[
                sizedBoxHeight(height: 20),
                _buildInfoSection("Status & Remarks", [
                  _detailTile("Status", capitalize(doc.status), Icons.verified_user_rounded),
                  _detailTile("HR Remarks", doc.remarks!, Icons.notes_rounded),
                ]),
              ],
              if (doc.fileUrl != null) ...[
                sizedBoxHeight(height: 24),
                CustomText("Document File", style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: blackText1)),
                sizedBoxHeight(height: 12),
                Container(
                  width: double.infinity,
                  height: 200.h,
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: greyLight1),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.insert_drive_file_rounded, size: 50.r, color: greyText),
                        sizedBoxHeight(height: 12),
                        TextButton.icon(
                          onPressed: () {
                             // Implement view file logic
                          },
                          icon: const Icon(Icons.visibility_rounded),
                          label: const Text("View Attachment"),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      }),
    );
  }

  Widget _buildHeaderCard(DocumentModel doc) {
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
            child: Icon(Icons.file_copy_rounded, size: 40.r, color: primaryColor),
          ),
          sizedBoxHeight(height: 12),
          CustomText(doc.title ?? "N/A", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: blackText1)),
          CustomText(doc.employeeName ?? "Unknown Employee", style: TextStyle(fontSize: 12.sp, color: greyText)),
          sizedBoxHeight(height: 16),
          _buildStatusBadge(doc.status),
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
    if (status == 'verified') color = Colors.green;
    if (status == 'pending') color = Colors.orange;
    if (status == 'rejected') color = Colors.red;
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20.r)),
      child: CustomText(capitalize(status), style: TextStyle(fontSize: 12.sp, color: color, fontWeight: FontWeight.bold)),
    );
  }
}
