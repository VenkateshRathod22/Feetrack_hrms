import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/exit_reason_controller.dart';
import 'package:vlr/data/models/reports/exit_reason_report_model.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_button.dart';
import 'package:vlr/views/widget/text_box/app_text_box.dart';

class ExitReasonScreen extends StatefulWidget {
  const ExitReasonScreen({super.key});

  @override
  State<ExitReasonScreen> createState() => _ExitReasonScreenState();
}

class _ExitReasonScreenState extends State<ExitReasonScreen> {
  @override
  void initState() {
    super.initState();
    Get.find<ExitReasonController>().getExitReasons();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: CustomText("Exit Reasons", style: Helper(context).textTheme.titleMedium?.copyWith(fontSize: 18.sp)),
        centerTitle: true,
        backgroundColor: white,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showReasonDialog(context),
        backgroundColor: primaryColor,
        child:  Icon(Icons.add, color: white),
      ),
      body: GetBuilder<ExitReasonController>(builder: (controller) {
        if (controller.isLoading && controller.exitReasonList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.exitReasonList.isEmpty) {
          return const Center(child: Text("No exit reasons found"));
        }

        return ListView.separated(
          padding: EdgeInsets.all(16.r),
          itemCount: controller.exitReasonList.length,
          separatorBuilder: (_, __) => sizedBoxHeight(height: 12),
          itemBuilder: (context, index) {
            final reason = controller.exitReasonList[index];
            return _buildReasonCard(context, reason);
          },
        );
      }),
    );
  }

  Widget _buildReasonCard(BuildContext context, ExitReasonReportModel reason) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(reason.name ?? "N/A", style: const TextStyle(fontWeight: FontWeight.bold)),
                sizedBoxHeight(height: 4),
                _buildTypeBadge(reason.type),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _showReasonDialog(context, reason: reason),
            icon: Icon(Icons.edit_rounded, color: Colors.blue, size: 20),
          ),
          IconButton(
            onPressed: () => _confirmDelete(context, reason),
            icon: Icon(Icons.delete_rounded, color: Colors.red, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeBadge(String? type) {
    Color color = type == 'voluntary' ? Colors.green : Colors.orange;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: CustomText(capitalize(type), style: TextStyle(fontSize: 10.sp, color: color, fontWeight: FontWeight.bold)),
    );
  }

  void _showReasonDialog(BuildContext context, {ExitReasonReportModel? reason}) {
    final TextEditingController nameController = TextEditingController(text: reason?.name);
    String selectedType = reason?.type ?? 'voluntary';
    bool isActive = reason?.isActive ?? true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(reason == null ? "Add Exit Reason" : "Edit Exit Reason"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppTextFieldWithHeading(
                  heading: "Reason Name",
                  hindText: "e.g. Better Career Opportunity",
                  controller: nameController,
                  isRequired: true,
                ),
                sizedBoxHeight(height: 16),
                _buildDialogDropdown(
                  "Type",
                  selectedType,
                  ['voluntary', 'involuntary'].map((e) => DropdownMenuItem(value: e, child: Text(capitalize(e)))).toList(),
                  (val) => setDialogState(() => selectedType = val!),
                ),
                sizedBoxHeight(height: 16),
                SwitchListTile(
                  title: const Text("Is Active"),
                  value: isActive,
                  onChanged: (val) => setDialogState(() => isActive = val),
                  activeColor: primaryColor,
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
            TextButton(
              onPressed: () {
                if (nameController.text.isEmpty) {
                  showToast(message: "Name is required", toastType: ToastType.error);
                  return;
                }
                Navigator.pop(context);
                final body = {
                  "name": nameController.text,
                  "type": selectedType,
                  "is_active": isActive,
                };

                if (reason == null) {
                  Get.find<ExitReasonController>().createExitReason(body).then((res) {
                    showToast(message: res.message, toastType: res.isSuccess ? ToastType.success : ToastType.error);
                  });
                } else {
                  Get.find<ExitReasonController>().updateExitReason(reason.id!, body).then((res) {
                    showToast(message: res.message, toastType: res.isSuccess ? ToastType.success : ToastType.error);
                  });
                }
              },
              child: Text(reason == null ? "Add" : "Update"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogDropdown(String label, String value, List<DropdownMenuItem<String>> items, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        sizedBoxHeight(height: 4),
        DropdownButtonFormField<String>(
          value: value,
          items: items,
          onChanged: onChanged,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
          ),
        ),
      ],
    );
  }

  void _confirmDelete(BuildContext context, ExitReasonReportModel reason) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Reason?"),
        content: Text("Are you sure you want to delete '${reason.name}'?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Get.find<ExitReasonController>().deleteExitReason(reason.id!).then((res) {
                showToast(message: res.message, toastType: res.isSuccess ? ToastType.success : ToastType.error);
              });
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
