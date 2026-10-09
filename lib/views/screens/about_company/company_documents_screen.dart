import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/about_company_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/widget/button/appbar_back_button.dart';
import 'package:url_launcher/url_launcher.dart';

class CompanyDocumentsScreen extends StatefulWidget {
  const CompanyDocumentsScreen({super.key});

  @override
  State<CompanyDocumentsScreen> createState() => _CompanyDocumentsScreenState();
}

class _CompanyDocumentsScreenState extends State<CompanyDocumentsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<AboutCompanyController>().getCompanyDocuments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: CustomText(
          "Company Documents",
          style: Helper(context).textTheme.titleMedium?.copyWith(fontSize: 18.sp),
        ),
        centerTitle: true,
        backgroundColor: white,
        elevation: 0,
        leading: const AppBarBackButton(),
      ),
      body: GetBuilder<AboutCompanyController>(builder: (controller) {
        if (controller.isLoading && controller.documents.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.documents.isEmpty) {
          return const Center(child: CustomText("No documents found"));
        }

        return RefreshIndicator(
          onRefresh: () => controller.getCompanyDocuments(),
          child: ListView.separated(
            padding: EdgeInsets.all(16.r),
            itemCount: controller.documents.length,
            separatorBuilder: (_, __) => sizedBoxHeight(height: 12.h),
            itemBuilder: (context, index) {
              final doc = controller.documents[index];
              return Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.r),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(
                        _getFileIcon(doc.files?.first.type),
                        color: primaryColor,
                        size: 24.sp,
                      ),
                    ),
                    sizedBoxWidth(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            doc.title ?? "Untitled Document",
                            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: blackText1),
                          ),
                          CustomText(
                            "Type: ${doc.files?.first.type?.toUpperCase() ?? "Unknown"}",
                            style: TextStyle(fontSize: 11.sp, color: greyText),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => _openDocument(doc.files?.first.url),
                      icon: Icon(Icons.download_for_offline_outlined, color: primaryColor, size: 24.sp),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }

  IconData _getFileIcon(String? type) {
    switch (type?.toLowerCase()) {
      case 'pdf': return Icons.picture_as_pdf_outlined;
      case 'png':
      case 'jpg':
      case 'jpeg': return Icons.image_outlined;
      default: return Icons.insert_drive_file_outlined;
    }
  }

  Future<void> _openDocument(String? url) async {
    if (url == null) return;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      showToast(message: "Could not open document", toastType: ToastType.error);
    }
  }
}
